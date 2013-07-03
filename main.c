/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.3 Standard
Automatic Program Generator
© Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 6/30/2013
Author  : Ardika
Company : CrowjaEmbedder
Comments: 


Chip type               : ATmega32
Program type            : Application
AVR Core Clock frequency: 16.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 512
*****************************************************/

#include <mega32.h>
#include <alcd.h>
#include <delay.h>

#define ADC_VREF_TYPE 0x60

// definisi tombol-tombol
#define CMD_UP      PINC.4
#define CMD_DOWN    PINC.5
#define CMD_OK      PINC.6
#define CMD_CANCEL  PINC.7

// Detektor persimpangan jalan
#define RIGHT_WING  PIND.0
#define LEFT_WING   PIND.1

// definisi kendali motor
#define RIGHT_PWM   OCR1AL
#define LEFT_PWM    OCR1BL
#define RIGHT_DR1   PORTD.6
#define RIGHT_DR2   PORTD.7
#define LEFT_DR1    PORTD.2
#define LEFT_DR2    PORTD.3 

// definisi custom character LCD
#define FULL_BLOCK  0
#define EMPTY_BLOCK 1

// definisi untuk melakukan kalibrasi
#define CALIBRATING_COUNT   100


flash unsigned char fullBlock[8] = {0b11111,
                                    0b11111,
                                    0b11111,
                                    0b11111,
                                    0b11111,
                                    0b11111,
                                    0b11111,
                                    0b11111};   
                                    
flash unsigned char emptyBlock[8] = {0b11111,
                                     0b10001,
                                     0b10001,
                                     0b10001,
                                     0b10001,
                                     0b10001,
                                     0b10001,
                                     0b11111};

// Variabel-variabel kontrol yang tersimpan di memory non-volatile
eeprom unsigned char eeMaxSpeed = 255;
eeprom unsigned char eeKp = 0;
eeprom unsigned char eeKd = 0;
eeprom unsigned char eeKi = 0;

// Varibel kepekaan sensor dalam memory non-volaitile
eeprom unsigned char eeWhiteMin[8] = {0};   // Nilai pembacaan minimal untuk putih
eeprom unsigned char eeBlackMax[8] = {0};  // Nilai pembacaan maksimal untuk hitam
eeprom unsigned char eeMiddleVal[8] = {0};   // Nilai tengah antara white min dan black max

// Varibael-varibel kontrol yang disimpan di memory volatile untuk perhitungan kontrol
unsigned char maxSpeed;     // nilai kecepatan maksimal
unsigned char kp;           // konstanta proposional
unsigned char kd;           // konstanta derivatif
unsigned char ki;           // konstanta integral
unsigned char error;        // nilai error pembacaan sensor
unsigned char sp;           // nilai set point sensor 

// Variabel kepekaan sensor dalam memory volatile untuk perhitungan
unsigned char whiteMin[8] = {0};   // Nilai pembacaan minimal untuk putih
unsigned char blackMax[8] = {0};  // Nilai pembacaan maksimal untuk hitam
unsigned char middleVal[8] = {0};   // Nilai tengah antara white min dan black max

// Varibel penyimpan nilai sensor biner, dimana tiap satu sensor nilainya diwakili oleh 1-bit
// yang merupakan hasil perbandingan pembacaan nilai analog sensor dengan nilai kepekaan sensor
unsigned char sensor = 0;

//prototype fungsi
void define_char(unsigned char flash *pc,unsigned char char_code);
unsigned char read_adc(unsigned char adc_input);
void scanLine();
void loadVariables();
void saveVariables();
void lcdOn(unsigned char on);
void lcdOnWing();
void go();
void back();
void left();
void right();
void stop(unsigned char usingPowerBrake);
void lcdPrintByte(unsigned char value);
void printADCSensor();
void printBinarySensor();
void whiteCalibrating();
void blackCalibrating();
void applyCalibratedValue();
void pid();


void main(void)
{

    PORTA=0x00;
    DDRA=0x00;

    PORTB=0xFF;
    DDRB=0xFF;
     
    PORTC=0x00;
    DDRC=0x00;

    PORTD=0x00;
    DDRD=0xFC;

    // Timer/Counter 0 initialization
    // Clock source: System Clock
    // Clock value: 2000.000 kHz
    // Mode: Fast PWM top=0xFF
    // OC0 output: Disconnected
    TCCR0=0x4A;
    TCNT0=0x00;
    OCR0=0x0F;

    // Timer/Counter 1 initialization
    // Clock source: System Clock
    // Clock value: 250.000 kHz
    // Mode: Fast PWM top=0x00FF
    // OC1A output: Non-Inv.
    // OC1B output: Non-Inv.
    // Noise Canceler: Off
    // Input Capture on Falling Edge
    // Timer1 Overflow Interrupt: Off
    // Input Capture Interrupt: Off
    // Compare A Match Interrupt: Off                `
    // Compare B Match Interrupt: Off
    TCCR1A=0xA1;
    TCCR1B=0x0B;
    TCNT1H=0x00;
    TCNT1L=0x00;
    ICR1H=0x00;
    ICR1L=0x00;
    OCR1AH=0x00;
    OCR1AL=0x00;
    OCR1BH=0x00;
    OCR1BL=0x00;

    // Timer/Counter 2 initialization
    // Clock source: System Clock
    // Clock value: Timer2 Stopped
    // Mode: Normal top=0xFF
    // OC2 output: Disconnected
    ASSR=0x00;
    TCCR2=0x00;
    TCNT2=0x00;
    OCR2=0x00;

    // External Interrupt(s) initialization
    // INT0: Off
    // INT1: Off
    // INT2: Off
    MCUCR=0x00;
    MCUCSR=0x00;

    // Timer(s)/Counter(s) Interrupt(s) initialization
    TIMSK=0x00;

    // USART initialization
    // USART disabled
    UCSRB=0x00;

    // Analog Comparator initialization
    // Analog Comparator: Off
    // Analog Comparator Input Capture by Timer/Counter 1: Off
    ACSR=0x80;
    SFIOR=0x00;

    // ADC initialization
    // ADC Clock frequency: 125.000 kHz
    // ADC Voltage Reference: AVCC pin
    // Only the 8 most significant bits of
    // the AD conversion result are used
    ADMUX=ADC_VREF_TYPE & 0xff;
    ADCSRA=0x87;

    // SPI initialization
    // SPI disabled
    SPCR=0x00;

    // TWI initialization
    // TWI disabled
    TWCR=0x00;


    // Alphanumeric LCD initialization
    // Connections are specified in the
    // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
    // RS - PORTB Bit 0
    // RD - PORTB Bit 1
    // EN - PORTB Bit 2
    // D4 - PORTB Bit 4
    // D5 - PORTB Bit 5
    // D6 - PORTB Bit 6
    // D7 - PORTB Bit 7
    // Characters/line: 16
    lcd_init(16);   
    lcd_clear();
    define_char(fullBlock,FULL_BLOCK);
    define_char(emptyBlock,EMPTY_BLOCK);
    lcdOn(1);       
    lcd_clear();
    
    loadVariables();

    while (1) {     
        lcd_gotoxy(0,0);
        printADCSensor();
        //scanLine();
        //printBinarySensor(); 
              
    }
}


/* function used to define user characters */
void define_char(unsigned char flash *pc,unsigned char char_code)
{
    unsigned char i,a;
    a=(char_code<<3) | 0x40;
    for (i=0; i<8; i++) lcd_write_byte(a++,*pc++);
}


// Read the 8 most significant bits
// of the AD conversion result
unsigned char read_adc(unsigned char adc_input)
{
    ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
    // Delay needed for the stabilization of the ADC input voltage
    //delay_us(10);
    // Start the AD conversion
    ADCSRA|=0x40;
    // Wait for the AD conversion to complete
    while (!(ADCSRA & 0x10));
        ADCSRA |= 0x10;
    return ADCH;
}


void scanLine()
{
    unsigned char i = 0;      
    unsigned char adcRead[i];  // Variabel pembacaan nilai ADC          
    // JUmlah warna putih dan hitam yang terdeteksi oleh sensor
    unsigned char blackCount = 0; 
    
    sensor = 0x00;   // Hapus nilai sensor sebelumnya
    
    for (; i<8; i++) {     
        adcRead[i] = read_adc(i);  // Baca nilai ADC ada bit ke-i
        if (adcRead[i] > middleVal[i]) {
            blackCount++;       // Increment jumlah blok hitam yang terbaca
            sensor |= (1<<i);
        }
    }                   
    if ((8 - blackCount) > 4)   // Jika blok hitam yg terdeteksi banyak, maka garisnya adalah putih
        sensor ~= sensor;       // Lakukan negasi nilai sensor
    lcdPrintByte(blackCount);   
}

void loadVariables()
{
    unsigned char i = 0;
    
    maxSpeed = eeMaxSpeed;
    kp = eeKp;
    kd = eeKd;
    ki = eeKi;
    
    for (; i<8; i++) {  
        whiteMin[i] = eeWhiteMin[i];
        blackMax[i] = eeBlackMax[i];    
    }    
}

void saveVariables()
{
    unsigned char i = 0;
    
    eeMaxSpeed = maxSpeed;
    eeKp = kp;
    eeKd = kd;
    eeKi = ki;
    
    for (; i<8; i++) {
        eeWhiteMin[i] = whiteMin[i];
        eeBlackMax[i] = blackMax[i];
    }
}


void lcdOn(unsigned char on)
{
    PORTB.3 = on;
}

void lcdOnWing()
{
    PORTB.3 = !((LEFT_WING) | (RIGHT_WING));
}

void go()
{
    RIGHT_DR1 = 0; RIGHT_DR2 = 1;
    LEFT_DR1 = 0; LEFT_DR2 = 1; 
}

void back()
{
    RIGHT_DR1 = 1; RIGHT_DR2 = 0;
    LEFT_DR1 = 1; LEFT_DR2 = 0;        
}

void left()
{
    RIGHT_DR1 = 0; RIGHT_DR2 = 1;
    LEFT_DR1 = 0; LEFT_DR2 = 0;
}

void right()
{
    RIGHT_DR1 = 0; RIGHT_DR2 = 0;
    LEFT_DR1 = 0; LEFT_DR2 = 1;
}

void stop(unsigned char usingPowerBrake)
{
    RIGHT_DR1 = RIGHT_DR2 = LEFT_DR1 = LEFT_DR2 = 0;
    if (usingPowerBrake) {
        back();
        LEFT_PWM = RIGHT_PWM = 255;
        delay_ms(100);
        LEFT_PWM = RIGHT_PWM = 0;
    }     
    
}



void lcdPrintByte(unsigned char value)
{
    unsigned char ten = (value % 100) / 10;
    lcd_putchar('0' + (value / 100));  
    lcd_putchar('0' + ten);
    lcd_putchar('0' + (value % 10));
}

void printADCSensor()
{
    lcd_gotoxy(0,0); lcdPrintByte(read_adc(0));
    lcd_gotoxy(4,0); lcdPrintByte(read_adc(1));
    lcd_gotoxy(8,0); lcdPrintByte(read_adc(2));
    lcd_gotoxy(12,0); lcdPrintByte(read_adc(3));
    lcd_gotoxy(0,1); lcdPrintByte(read_adc(4));
    lcd_gotoxy(4,1); lcdPrintByte(read_adc(5));
    lcd_gotoxy(8,1); lcdPrintByte(read_adc(6));
    lcd_gotoxy(12,1); lcdPrintByte(read_adc(7)); 
}

void printBinarySensor()
{
    unsigned char i = 0;
    
    for (; i<8; i++) {
        if (sensor & (1<<i))
            lcd_putchar(FULL_BLOCK);
        else
            lcd_putchar(EMPTY_BLOCK);
    }
}  


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//// REGION CALIBRATING FUNCTIONS //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*
    PROSEDUR MELAKUKAN KALIBRASI:
        Panggil kedua fungsi blackCalibrating() dan whiteCalibrating()
        Panggil fungsi applyCalibratedValue()
*/

void blackCalibrating()
{
    unsigned char i;
    unsigned char calibratingCount;   // Jumlah kalkulasi kalibrasi untuk tiap sensor    
    unsigned char calibratedBlackMax;  // Nilai hitam maksimal hasil kalibrasi hitam, untuk tiap sensor     
    unsigned char readADC;  // nilai pembacaan ADC 
                         
    // Kalibrasi HItam
    for (i=0; i<8; i++) {    
        calibratingCount = CALIBRATING_COUNT;
        calibratedBlackMax = 0;     // Atur nilainya menjadi nilai minimal tipedata unsigned byte, karena kita akan mencari nilai maksimum
        while (calibratingCount--) {
            readADC = read_adc(i);
            if (readADC > calibratedBlackMax)
                calibratedBlackMax = readADC;        
        }                   
        blackMax[i] = eeBlackMax[i] = calibratedBlackMax;  // simpan nilai kalibarasi di ram sekaligus di eeprom
    } 
    
}

void whiteCalibrating()
{
    unsigned char i;
    unsigned char calibratingCount;   // Jumlah kalkulasi kalibrasi untuk tiap sensor    
    unsigned char calibratedWhiteMin;  // Nilai hitam minimum hasil kalibrasi putih, untuk tiap sensor     
    unsigned char readADC;  // nilai pembacaan ADC  
                         
    // Kalibrasi HItam
    for (i=0; i<8; i++) {
        calibratingCount = CALIBRATING_COUNT;     
        calibratedWhiteMin = 255;     // Atur nilainya menjadi nilai maksimal tipedata unsigned byte, karena kita akan mencari nilai minimum
        while (calibratingCount--) {
            readADC = read_adc(i);
            if (readADC < calibratedWhiteMin)
                calibratedWhiteMin = readADC;        
        }                   
        whiteMin[i] = eeWhiteMin[i] = calibratedWhiteMin;  // simpan nilai kalibarasi di ram sekaligus di eeprom
    } 
}

void applyCalibratedValue()
{
    unsigned char i = 0;
    
    for (; i<8; i++) 
        middleVal[i] = eeMiddleVal[i] = ((blackMax[i] - whiteMin[i]) / 2);
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//// END OF REGION CALIBRATING FUNCTIONS ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void pid()
{
    
}