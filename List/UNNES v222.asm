
;CodeVisionAVR C Compiler V2.05.3 Standard
;(C) Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega32
;Program type             : Application
;Clock frequency          : 16.000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 512 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;Global 'const' stored in FLASH     : No
;Enhanced function parameter passing: Yes
;Enhanced core instructions         : On
;Smart register allocation          : On
;Automatic register allocation      : On

	#pragma AVRPART ADMIN PART_NAME ATmega32
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2143
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x085F
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _maxSpeed=R5
	.DEF _kp=R4
	.DEF _kd=R7
	.DEF _ki=R6
	.DEF _error=R9
	.DEF _sp=R8
	.DEF _sensor=R11
	.DEF __lcd_x=R10
	.DEF __lcd_y=R13
	.DEF __lcd_maxx=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_fullBlock:
	.DB  0x1F,0x1F,0x1F,0x1F,0x1F,0x1F,0x1F,0x1F
_emptyBlock:
	.DB  0x1F,0x11,0x11,0x11,0x11,0x11,0x11,0x1F

_0x60:
	.DB  0x0
_0x2000003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x0B
	.DW  _0x60*2

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x260

	.CSEG
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.05.3 Standard
;Automatic Program Generator
;© Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 6/30/2013
;Author  : Ardika
;Company : CrowjaEmbedder
;Comments:
;
;
;Chip type               : ATmega32
;Program type            : Application
;AVR Core Clock frequency: 16.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 512
;*****************************************************/
;
;#include <mega32.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <alcd.h>
;#include <delay.h>
;
;#define ADC_VREF_TYPE 0x60
;
;// definisi tombol-tombol
;#define CMD_UP      PINC.4
;#define CMD_DOWN    PINC.5
;#define CMD_OK      PINC.6
;#define CMD_CANCEL  PINC.7
;
;// Detektor persimpangan jalan
;#define RIGHT_WING  PIND.0
;#define LEFT_WING   PIND.1
;
;// definisi kendali motor
;#define RIGHT_PWM   OCR1AL
;#define LEFT_PWM    OCR1BL
;#define RIGHT_DR1   PORTD.6
;#define RIGHT_DR2   PORTD.7
;#define LEFT_DR1    PORTD.2
;#define LEFT_DR2    PORTD.3
;
;// definisi custom character LCD
;#define FULL_BLOCK  0
;#define EMPTY_BLOCK 1
;
;// definisi untuk melakukan kalibrasi
;#define CALIBRATING_COUNT   100
;
;
;flash unsigned char fullBlock[8] = {0b11111,
;                                    0b11111,
;                                    0b11111,
;                                    0b11111,
;                                    0b11111,
;                                    0b11111,
;                                    0b11111,
;                                    0b11111};
;
;flash unsigned char emptyBlock[8] = {0b11111,
;                                     0b10001,
;                                     0b10001,
;                                     0b10001,
;                                     0b10001,
;                                     0b10001,
;                                     0b10001,
;                                     0b11111};
;
;// Variabel-variabel kontrol yang tersimpan di memory non-volatile
;eeprom unsigned char eeMaxSpeed = 255;
;eeprom unsigned char eeKp = 0;
;eeprom unsigned char eeKd = 0;
;eeprom unsigned char eeKi = 0;
;
;// Varibel kepekaan sensor dalam memory non-volaitile
;eeprom unsigned char eeWhiteMin[8] = {10};   // Nilai pembacaan minimal untuk putih
;eeprom unsigned char eeBlackMax[8] = {220};  // Nilai pembacaan maksimal untuk hitam
;eeprom unsigned char eeMiddleVal[8] = {105};   // Nilai tengah antara white min dan black max
;
;// Varibael-varibel kontrol yang disimpan di memory volatile untuk perhitungan kontrol
;unsigned char maxSpeed;     // nilai kecepatan maksimal
;unsigned char kp;           // konstanta proposional
;unsigned char kd;           // konstanta derivatif
;unsigned char ki;           // konstanta integral
;unsigned char error;        // nilai error pembacaan sensor
;unsigned char sp;           // nilai set point sensor
;
;// Variabel kepekaan sensor dalam memory volatile untuk perhitungan
;unsigned char whiteMin[8] = {0};   // Nilai pembacaan minimal untuk putih
;unsigned char blackMax[8] = {0};  // Nilai pembacaan maksimal untuk hitam
;unsigned char middleVal[8] = {0};   // Nilai tengah antara white min dan black max
;
;// Varibel penyimpan nilai sensor biner, dimana tiap satu sensor nilainya diwakili oleh 1-bit
;// yang merupakan hasil perbandingan pembacaan nilai analog sensor dengan nilai kepekaan sensor
;unsigned char sensor = 0;
;
;//prototype fungsi
;void define_char(unsigned char flash *pc,unsigned char char_code);
;unsigned char read_adc(unsigned char adc_input);
;void scanLine();
;void loadVariables();
;void saveVariables();
;void lcdOn(unsigned char on);
;void lcdOnWing();
;void go();
;void back();
;void left();
;void right();
;void stop(unsigned char usingPowerBrake);
;void lcdPrintByte(unsigned char value);
;void printADCSensor();
;void printBinarySensor();
;void whiteCalibrating();
;void blackCalibrating();
;void applyCalibratedValue();
;void pid();
;void scanLineActual();
;
;
;void main(void)
; 0000 007E {

	.CSEG
_main:
; 0000 007F 
; 0000 0080     PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 0081     DDRA=0x00;
	OUT  0x1A,R30
; 0000 0082 
; 0000 0083     PORTB=0xFF;
	LDI  R30,LOW(255)
	OUT  0x18,R30
; 0000 0084     DDRB=0xFF;
	OUT  0x17,R30
; 0000 0085 
; 0000 0086     PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 0087     DDRC=0x00;
	OUT  0x14,R30
; 0000 0088 
; 0000 0089     PORTD=0x00;
	OUT  0x12,R30
; 0000 008A     DDRD=0xFC;
	LDI  R30,LOW(252)
	OUT  0x11,R30
; 0000 008B 
; 0000 008C     // Timer/Counter 0 initialization
; 0000 008D     // Clock source: System Clock
; 0000 008E     // Clock value: 2000.000 kHz
; 0000 008F     // Mode: Fast PWM top=0xFF
; 0000 0090     // OC0 output: Disconnected
; 0000 0091     TCCR0=0x4A;
	LDI  R30,LOW(74)
	OUT  0x33,R30
; 0000 0092     TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 0093     OCR0=0x0F;
	LDI  R30,LOW(15)
	OUT  0x3C,R30
; 0000 0094 
; 0000 0095     // Timer/Counter 1 initialization
; 0000 0096     // Clock source: System Clock
; 0000 0097     // Clock value: 250.000 kHz
; 0000 0098     // Mode: Fast PWM top=0x00FF
; 0000 0099     // OC1A output: Non-Inv.
; 0000 009A     // OC1B output: Non-Inv.
; 0000 009B     // Noise Canceler: Off
; 0000 009C     // Input Capture on Falling Edge
; 0000 009D     // Timer1 Overflow Interrupt: Off
; 0000 009E     // Input Capture Interrupt: Off
; 0000 009F     // Compare A Match Interrupt: Off                `
; 0000 00A0     // Compare B Match Interrupt: Off
; 0000 00A1     TCCR1A=0xA1;
	LDI  R30,LOW(161)
	OUT  0x2F,R30
; 0000 00A2     TCCR1B=0x0B;
	LDI  R30,LOW(11)
	OUT  0x2E,R30
; 0000 00A3     TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 00A4     TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 00A5     ICR1H=0x00;
	OUT  0x27,R30
; 0000 00A6     ICR1L=0x00;
	OUT  0x26,R30
; 0000 00A7     OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 00A8     OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 00A9     OCR1BH=0x00;
	OUT  0x29,R30
; 0000 00AA     OCR1BL=0x00;
	OUT  0x28,R30
; 0000 00AB 
; 0000 00AC     // Timer/Counter 2 initialization
; 0000 00AD     // Clock source: System Clock
; 0000 00AE     // Clock value: Timer2 Stopped
; 0000 00AF     // Mode: Normal top=0xFF
; 0000 00B0     // OC2 output: Disconnected
; 0000 00B1     ASSR=0x00;
	OUT  0x22,R30
; 0000 00B2     TCCR2=0x00;
	OUT  0x25,R30
; 0000 00B3     TCNT2=0x00;
	OUT  0x24,R30
; 0000 00B4     OCR2=0x00;
	OUT  0x23,R30
; 0000 00B5 
; 0000 00B6     // External Interrupt(s) initialization
; 0000 00B7     // INT0: Off
; 0000 00B8     // INT1: Off
; 0000 00B9     // INT2: Off
; 0000 00BA     MCUCR=0x00;
	OUT  0x35,R30
; 0000 00BB     MCUCSR=0x00;
	OUT  0x34,R30
; 0000 00BC 
; 0000 00BD     // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 00BE     TIMSK=0x00;
	OUT  0x39,R30
; 0000 00BF 
; 0000 00C0     // USART initialization
; 0000 00C1     // USART disabled
; 0000 00C2     UCSRB=0x00;
	OUT  0xA,R30
; 0000 00C3 
; 0000 00C4     // Analog Comparator initialization
; 0000 00C5     // Analog Comparator: Off
; 0000 00C6     // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 00C7     ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 00C8     SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 00C9 
; 0000 00CA     // ADC initialization
; 0000 00CB     // ADC Clock frequency: 125.000 kHz
; 0000 00CC     // ADC Voltage Reference: AVCC pin
; 0000 00CD     // Only the 8 most significant bits of
; 0000 00CE     // the AD conversion result are used
; 0000 00CF     ADMUX=ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(96)
	OUT  0x7,R30
; 0000 00D0     ADCSRA=0x87;
	LDI  R30,LOW(135)
	OUT  0x6,R30
; 0000 00D1 
; 0000 00D2     // SPI initialization
; 0000 00D3     // SPI disabled
; 0000 00D4     SPCR=0x00;
	LDI  R30,LOW(0)
	OUT  0xD,R30
; 0000 00D5 
; 0000 00D6     // TWI initialization
; 0000 00D7     // TWI disabled
; 0000 00D8     TWCR=0x00;
	OUT  0x36,R30
; 0000 00D9 
; 0000 00DA 
; 0000 00DB     // Alphanumeric LCD initialization
; 0000 00DC     // Connections are specified in the
; 0000 00DD     // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 00DE     // RS - PORTB Bit 0
; 0000 00DF     // RD - PORTB Bit 1
; 0000 00E0     // EN - PORTB Bit 2
; 0000 00E1     // D4 - PORTB Bit 4
; 0000 00E2     // D5 - PORTB Bit 5
; 0000 00E3     // D6 - PORTB Bit 6
; 0000 00E4     // D7 - PORTB Bit 7
; 0000 00E5     // Characters/line: 16
; 0000 00E6     lcd_init(16);
	LDI  R26,LOW(16)
	RCALL _lcd_init
; 0000 00E7     lcd_clear();
	RCALL _lcd_clear
; 0000 00E8     define_char(fullBlock,FULL_BLOCK);
	LDI  R30,LOW(_fullBlock*2)
	LDI  R31,HIGH(_fullBlock*2)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _define_char
; 0000 00E9     define_char(emptyBlock,EMPTY_BLOCK);
	LDI  R30,LOW(_emptyBlock*2)
	LDI  R31,HIGH(_emptyBlock*2)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _define_char
; 0000 00EA     lcdOn(1);
	LDI  R26,LOW(1)
	RCALL _lcdOn
; 0000 00EB     lcd_clear();
	RCALL _lcd_clear
; 0000 00EC 
; 0000 00ED     loadVariables();
	RCALL _loadVariables
; 0000 00EE 
; 0000 00EF     while (1) {
_0x3:
; 0000 00F0         lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x0
; 0000 00F1         printADCSensor();
	RCALL _printADCSensor
; 0000 00F2         //scanLine();
; 0000 00F3         //printBinarySensor();
; 0000 00F4 
; 0000 00F5     }
	RJMP _0x3
; 0000 00F6 }
_0x6:
	RJMP _0x6
;
;
;/* function used to define user characters */
;void define_char(unsigned char flash *pc,unsigned char char_code)
; 0000 00FB {
_define_char:
; 0000 00FC     unsigned char i,a;
; 0000 00FD     a=(char_code<<3) | 0x40;
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	*pc -> Y+3
;	char_code -> Y+2
;	i -> R17
;	a -> R16
	LDD  R30,Y+2
	LSL  R30
	LSL  R30
	LSL  R30
	ORI  R30,0x40
	MOV  R16,R30
; 0000 00FE     for (i=0; i<8; i++) lcd_write_byte(a++,*pc++);
	LDI  R17,LOW(0)
_0x8:
	CPI  R17,8
	BRSH _0x9
	ST   -Y,R16
	INC  R16
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	ADIW R30,1
	STD  Y+4,R30
	STD  Y+4+1,R31
	SBIW R30,1
	LPM  R26,Z
	RCALL _lcd_write_byte
	SUBI R17,-1
	RJMP _0x8
_0x9:
; 0000 00FF }
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
;
;
;// Read the 8 most significant bits
;// of the AD conversion result
;unsigned char read_adc(unsigned char adc_input)
; 0000 0105 {
_read_adc:
; 0000 0106     ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
	ST   -Y,R26
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,LOW(0x60)
	OUT  0x7,R30
; 0000 0107     // Delay needed for the stabilization of the ADC input voltage
; 0000 0108     //delay_us(10);
; 0000 0109     // Start the AD conversion
; 0000 010A     ADCSRA|=0x40;
	SBI  0x6,6
; 0000 010B     // Wait for the AD conversion to complete
; 0000 010C     while (!(ADCSRA & 0x10));
_0xA:
	SBIS 0x6,4
	RJMP _0xA
; 0000 010D         ADCSRA |= 0x10;
	SBI  0x6,4
; 0000 010E     return ADCH;
	IN   R30,0x5
	RJMP _0x2020001
; 0000 010F }
;
;// Fungsi scan garis aktual dimana nilai pembacaan hitam adalah 1 dan nilai pembacaan putih adalah 0
;void scanLineActual()
; 0000 0113 {
; 0000 0114     unsigned char i = 0;
; 0000 0115     unsigned char adcRead;
; 0000 0116 
; 0000 0117     sensor = 0;   // reset nilai sensor
;	i -> R17
;	adcRead -> R16
; 0000 0118     for (; i<8; i++) {
; 0000 0119         adcRead = read_adc(i);  // Baca nilai ADC ada bit ke-i
; 0000 011A         if (adcRead > middleVal[i])
; 0000 011B             sensor |= (1<<i);
; 0000 011C     }
; 0000 011D }
;
;
;// Fungsi scan garis relatif dimana garis dibaca secara relatif terhadap perbandingan antara blok hitam dan putih yang terbaca
;// jika blok putih > blok hitam maka garis adalah hitam, sebaihnya garis adalah putih. Garis tetap dibaca sebagai bit set/1
;void scanLineRelative()
; 0000 0123 {
; 0000 0124     unsigned char i = 0;
; 0000 0125     unsigned char adcRead;  // Variabel pembacaan nilai ADC
; 0000 0126     // JUmlah warna putih dan hitam yang terdeteksi oleh sensor
; 0000 0127     unsigned char blackCount = 0;
; 0000 0128 
; 0000 0129     sensor = 0x00;   // Hapus nilai sensor sebelumnya
;	i -> R17
;	adcRead -> R16
;	blackCount -> R19
; 0000 012A 
; 0000 012B     for (; i<8; i++) {
; 0000 012C         adcRead = read_adc(i);  // Baca nilai ADC ada bit ke-i
; 0000 012D         if (adcRead > middleVal[i]) {
; 0000 012E             blackCount++;       // Increment jumlah blok hitam yang terbaca
; 0000 012F             sensor |= (1<<i);
; 0000 0130         }
; 0000 0131     }
; 0000 0132     if ((8 - blackCount) > 4)   // Jika blok hitam yg terdeteksi banyak, maka garisnya adalah putih
; 0000 0133         sensor = ~sensor;       // Lakukan negasi nilai sensor
; 0000 0134 }
;
;void loadVariables()
; 0000 0137 {
_loadVariables:
; 0000 0138     unsigned char i = 0;
; 0000 0139 
; 0000 013A     maxSpeed = eeMaxSpeed;
	ST   -Y,R17
;	i -> R17
	LDI  R17,0
	LDI  R26,LOW(_eeMaxSpeed)
	LDI  R27,HIGH(_eeMaxSpeed)
	CALL __EEPROMRDB
	MOV  R5,R30
; 0000 013B     kp = eeKp;
	LDI  R26,LOW(_eeKp)
	LDI  R27,HIGH(_eeKp)
	CALL __EEPROMRDB
	MOV  R4,R30
; 0000 013C     kd = eeKd;
	LDI  R26,LOW(_eeKd)
	LDI  R27,HIGH(_eeKd)
	CALL __EEPROMRDB
	MOV  R7,R30
; 0000 013D     ki = eeKi;
	LDI  R26,LOW(_eeKi)
	LDI  R27,HIGH(_eeKi)
	CALL __EEPROMRDB
	MOV  R6,R30
; 0000 013E 
; 0000 013F     for (; i<8; i++) {
_0x17:
	CPI  R17,8
	BRSH _0x18
; 0000 0140         whiteMin[i] = eeWhiteMin[i];
	RCALL SUBOPT_0x1
	SUBI R30,LOW(-_whiteMin)
	SBCI R31,HIGH(-_whiteMin)
	RCALL SUBOPT_0x2
	SUBI R26,LOW(-_eeWhiteMin)
	SBCI R27,HIGH(-_eeWhiteMin)
	RCALL SUBOPT_0x3
; 0000 0141         blackMax[i] = eeBlackMax[i];
	SUBI R30,LOW(-_blackMax)
	SBCI R31,HIGH(-_blackMax)
	RCALL SUBOPT_0x2
	SUBI R26,LOW(-_eeBlackMax)
	SBCI R27,HIGH(-_eeBlackMax)
	RCALL SUBOPT_0x3
; 0000 0142         middleVal[i] = eeMiddleVal[i];
	SUBI R30,LOW(-_middleVal)
	SBCI R31,HIGH(-_middleVal)
	RCALL SUBOPT_0x2
	SUBI R26,LOW(-_eeMiddleVal)
	SBCI R27,HIGH(-_eeMiddleVal)
	CALL __EEPROMRDB
	MOVW R26,R0
	ST   X,R30
; 0000 0143     }
	SUBI R17,-1
	RJMP _0x17
_0x18:
; 0000 0144 }
	LD   R17,Y+
	RET
;
;void saveVariables()
; 0000 0147 {
; 0000 0148     unsigned char i = 0;
; 0000 0149 
; 0000 014A     eeMaxSpeed = maxSpeed;
;	i -> R17
; 0000 014B     eeKp = kp;
; 0000 014C     eeKd = kd;
; 0000 014D     eeKi = ki;
; 0000 014E 
; 0000 014F     for (; i<8; i++) {
; 0000 0150         eeWhiteMin[i] = whiteMin[i];
; 0000 0151         eeBlackMax[i] = blackMax[i];
; 0000 0152         eeMiddleVal[i] = middleVal[i];
; 0000 0153     }
; 0000 0154 }
;
;
;void lcdOn(unsigned char on)
; 0000 0158 {
_lcdOn:
; 0000 0159     PORTB.3 = on;
	ST   -Y,R26
;	on -> Y+0
	LD   R30,Y
	CPI  R30,0
	BRNE _0x1C
	CBI  0x18,3
	RJMP _0x1D
_0x1C:
	SBI  0x18,3
_0x1D:
; 0000 015A }
	RJMP _0x2020001
;
;void lcdOnWing()
; 0000 015D {
; 0000 015E     PORTB.3 = !((LEFT_WING) | (RIGHT_WING));
; 0000 015F }
;
;void go()
; 0000 0162 {
; 0000 0163     RIGHT_DR1 = 0; RIGHT_DR2 = 1;
; 0000 0164     LEFT_DR1 = 0; LEFT_DR2 = 1;
; 0000 0165 }
;
;void back()
; 0000 0168 {
; 0000 0169     RIGHT_DR1 = 1; RIGHT_DR2 = 0;
; 0000 016A     LEFT_DR1 = 1; LEFT_DR2 = 0;
; 0000 016B }
;
;void left()
; 0000 016E {
; 0000 016F     RIGHT_DR1 = 0; RIGHT_DR2 = 1;
; 0000 0170     LEFT_DR1 = 0; LEFT_DR2 = 0;
; 0000 0171 }
;
;void right()
; 0000 0174 {
; 0000 0175     RIGHT_DR1 = 0; RIGHT_DR2 = 0;
; 0000 0176     LEFT_DR1 = 0; LEFT_DR2 = 1;
; 0000 0177 }
;
;void stop(unsigned char usingPowerBrake)
; 0000 017A {
; 0000 017B     RIGHT_DR1 = RIGHT_DR2 = LEFT_DR1 = LEFT_DR2 = 0;
;	usingPowerBrake -> Y+0
; 0000 017C     if (usingPowerBrake) {
; 0000 017D         back();
; 0000 017E         LEFT_PWM = RIGHT_PWM = 255;
; 0000 017F         delay_ms(100);
; 0000 0180         LEFT_PWM = RIGHT_PWM = 0;
; 0000 0181     }
; 0000 0182 
; 0000 0183 }
;
;
;
;void lcdPrintByte(unsigned char value)
; 0000 0188 {
_lcdPrintByte:
; 0000 0189     unsigned char ten = (value % 100) / 10;
; 0000 018A     lcd_putchar('0' + (value / 100));
	ST   -Y,R26
	ST   -Y,R17
;	value -> Y+1
;	ten -> R17
	LDD  R26,Y+1
	CLR  R27
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __MODW21
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	MOV  R17,R30
	LDD  R26,Y+1
	LDI  R27,0
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	RCALL _lcd_putchar
; 0000 018B     lcd_putchar('0' + ten);
	MOV  R26,R17
	SUBI R26,-LOW(48)
	RCALL _lcd_putchar
; 0000 018C     lcd_putchar('0' + (value % 10));
	LDD  R26,Y+1
	CLR  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	RCALL _lcd_putchar
; 0000 018D }
	LDD  R17,Y+0
	RJMP _0x2020002
;
;void printADCSensor()
; 0000 0190 {
_printADCSensor:
; 0000 0191     lcd_gotoxy(0,0); lcdPrintByte(read_adc(0));
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x0
	LDI  R26,LOW(0)
	RCALL SUBOPT_0x4
; 0000 0192     lcd_gotoxy(4,0); lcdPrintByte(read_adc(1));
	LDI  R30,LOW(4)
	RCALL SUBOPT_0x0
	LDI  R26,LOW(1)
	RCALL SUBOPT_0x4
; 0000 0193     lcd_gotoxy(8,0); lcdPrintByte(read_adc(2));
	LDI  R30,LOW(8)
	RCALL SUBOPT_0x0
	LDI  R26,LOW(2)
	RCALL SUBOPT_0x4
; 0000 0194     lcd_gotoxy(12,0); lcdPrintByte(read_adc(3));
	LDI  R30,LOW(12)
	RCALL SUBOPT_0x0
	LDI  R26,LOW(3)
	RCALL SUBOPT_0x4
; 0000 0195     lcd_gotoxy(0,1); lcdPrintByte(read_adc(4));
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x5
	LDI  R26,LOW(4)
	RCALL SUBOPT_0x4
; 0000 0196     lcd_gotoxy(4,1); lcdPrintByte(read_adc(5));
	LDI  R30,LOW(4)
	RCALL SUBOPT_0x5
	LDI  R26,LOW(5)
	RCALL SUBOPT_0x4
; 0000 0197     lcd_gotoxy(8,1); lcdPrintByte(read_adc(6));
	LDI  R30,LOW(8)
	RCALL SUBOPT_0x5
	LDI  R26,LOW(6)
	RCALL SUBOPT_0x4
; 0000 0198     lcd_gotoxy(12,1); lcdPrintByte(read_adc(7));
	LDI  R30,LOW(12)
	RCALL SUBOPT_0x5
	LDI  R26,LOW(7)
	RCALL SUBOPT_0x4
; 0000 0199 }
	RET
;
;void printBinarySensor()
; 0000 019C {
; 0000 019D     unsigned char i = 0;
; 0000 019E 
; 0000 019F     for (; i<8; i++) {
;	i -> R17
; 0000 01A0         if (sensor & (1<<i))
; 0000 01A1             lcd_putchar(FULL_BLOCK);
; 0000 01A2         else
; 0000 01A3             lcd_putchar(EMPTY_BLOCK);
; 0000 01A4     }
; 0000 01A5 }
;
;
;////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
;//// REGION CALIBRATING FUNCTIONS //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
;////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
;/*
;    PROSEDUR MELAKUKAN KALIBRASI:
;        Panggil kedua fungsi blackCalibrating() dan whiteCalibrating()
;        Panggil fungsi applyCalibratedValue()
;*/
;
;void blackCalibrating()
; 0000 01B2 {
; 0000 01B3     unsigned char i;
; 0000 01B4     unsigned char calibratingCount;   // Jumlah kalkulasi kalibrasi untuk tiap sensor
; 0000 01B5     unsigned char calibratedBlackMax;  // Nilai hitam maksimal hasil kalibrasi hitam, untuk tiap sensor
; 0000 01B6     unsigned char readADC;  // nilai pembacaan ADC
; 0000 01B7 
; 0000 01B8     // Kalibrasi HItam
; 0000 01B9     for (i=0; i<8; i++) {
;	i -> R17
;	calibratingCount -> R16
;	calibratedBlackMax -> R19
;	readADC -> R18
; 0000 01BA         calibratingCount = CALIBRATING_COUNT;
; 0000 01BB         calibratedBlackMax = 0;     // Atur nilainya menjadi nilai minimal tipedata unsigned byte, karena kita akan mencari nilai maksimum
; 0000 01BC         while (calibratingCount--) {
; 0000 01BD             readADC = read_adc(i);
; 0000 01BE             if (readADC > calibratedBlackMax)
; 0000 01BF                 calibratedBlackMax = readADC;
; 0000 01C0         }
; 0000 01C1         blackMax[i] = eeBlackMax[i] = calibratedBlackMax;  // simpan nilai kalibarasi di ram sekaligus di eeprom
; 0000 01C2     }
; 0000 01C3 
; 0000 01C4 }
;
;void whiteCalibrating()
; 0000 01C7 {
; 0000 01C8     unsigned char i;
; 0000 01C9     unsigned char calibratingCount;   // Jumlah kalkulasi kalibrasi untuk tiap sensor
; 0000 01CA     unsigned char calibratedWhiteMin;  // Nilai hitam minimum hasil kalibrasi putih, untuk tiap sensor
; 0000 01CB     unsigned char readADC;  // nilai pembacaan ADC
; 0000 01CC 
; 0000 01CD     // Kalibrasi HItam
; 0000 01CE     for (i=0; i<8; i++) {
;	i -> R17
;	calibratingCount -> R16
;	calibratedWhiteMin -> R19
;	readADC -> R18
; 0000 01CF         calibratingCount = CALIBRATING_COUNT;
; 0000 01D0         calibratedWhiteMin = 255;     // Atur nilainya menjadi nilai maksimal tipedata unsigned byte, karena kita akan mencari nilai minimum
; 0000 01D1         while (calibratingCount--) {
; 0000 01D2             readADC = read_adc(i);
; 0000 01D3             if (readADC < calibratedWhiteMin)
; 0000 01D4                 calibratedWhiteMin = readADC;
; 0000 01D5         }
; 0000 01D6         whiteMin[i] = eeWhiteMin[i] = calibratedWhiteMin;  // simpan nilai kalibarasi di ram sekaligus di eeprom
; 0000 01D7     }
; 0000 01D8 }
;
;void applyCalibratedValue()
; 0000 01DB {
; 0000 01DC     unsigned char i = 0;
; 0000 01DD 
; 0000 01DE     for (; i<8; i++)
;	i -> R17
; 0000 01DF         middleVal[i] = eeMiddleVal[i] = ((blackMax[i] - whiteMin[i]) / 2);
; 0000 01E0 }
;////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
;//// END OF REGION CALIBRATING FUNCTIONS ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
;////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
;
;void pid()
; 0000 01E6 {
; 0000 01E7 
; 0000 01E8 }
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G100:
	ST   -Y,R26
	IN   R30,0x18
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x18,R30
	__DELAY_USB 11
	SBI  0x18,2
	__DELAY_USB 27
	CBI  0x18,2
	__DELAY_USB 27
	RJMP _0x2020001
__lcd_write_data:
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 200
	RJMP _0x2020001
_lcd_write_byte:
	ST   -Y,R26
	LDD  R26,Y+1
	RCALL __lcd_write_data
	SBI  0x18,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x18,0
	RJMP _0x2020002
_lcd_gotoxy:
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R10,Y+1
	LDD  R13,Y+0
_0x2020002:
	ADIW R28,2
	RET
_lcd_clear:
	LDI  R26,LOW(2)
	RCALL SUBOPT_0x6
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	RCALL SUBOPT_0x6
	LDI  R30,LOW(0)
	MOV  R13,R30
	MOV  R10,R30
	RET
_lcd_putchar:
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2000005
	CP   R10,R12
	BRLO _0x2000004
_0x2000005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	INC  R13
	MOV  R26,R13
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2020001
_0x2000004:
	INC  R10
	SBI  0x18,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x18,0
	RJMP _0x2020001
_lcd_init:
	ST   -Y,R26
	IN   R30,0x17
	ORI  R30,LOW(0xF0)
	OUT  0x17,R30
	SBI  0x17,2
	SBI  0x17,0
	SBI  0x17,1
	CBI  0x18,2
	CBI  0x18,0
	CBI  0x18,1
	LDD  R12,Y+0
	LD   R30,Y
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x7
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 400
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x2020001:
	ADIW R28,1
	RET

	.ESEG
_eeMaxSpeed:
	.DB  0xFF
_eeKp:
	.DB  0x0
_eeKd:
	.DB  0x0
_eeKi:
	.DB  0x0
_eeWhiteMin:
	.DB  0xA,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
_eeBlackMax:
	.DB  0xDC,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
_eeMiddleVal:
	.DB  0x69,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0

	.DSEG
_whiteMin:
	.BYTE 0x8
_blackMax:
	.BYTE 0x8
_middleVal:
	.BYTE 0x8
__base_y_G100:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x0:
	ST   -Y,R30
	LDI  R26,LOW(0)
	RJMP _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	MOV  R30,R17
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2:
	MOVW R0,R30
	MOV  R26,R17
	LDI  R27,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	CALL __EEPROMRDB
	MOVW R26,R0
	ST   X,R30
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x4:
	RCALL _read_adc
	MOV  R26,R30
	RJMP _lcdPrintByte

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5:
	ST   -Y,R30
	LDI  R26,LOW(1)
	RJMP _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6:
	RCALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x7:
	LDI  R26,LOW(48)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 400
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xFA0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

;END OF CODE MARKER
__END_OF_CODE:
