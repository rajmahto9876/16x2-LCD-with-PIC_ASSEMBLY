; TODO INSERT CONFIG CODE HERE USING CONFIG BITS GENERATOR
#include "p16f887.inc"
; CONFIG1
; __config 0x20F4
 __CONFIG _CONFIG1, _FOSC_INTRC_NOCLKOUT & _WDTE_OFF & _PWRTE_OFF & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOREN_OFF & _IESO_OFF & _FCMEN_OFF & _LVP_OFF
; CONFIG2
; __config 0xFFFF
 __CONFIG _CONFIG2, _BOR4V_BOR40V & _WRT_OFF
 ;Defining the Macros or variables
    COUNT_1		EQU 0x70
    COUNT_2		EQU 0x71
    RS_BIT		EQU RC5
    EN_BIT		EQU RC6
    RW_BIT		EQU RC7
    LCD_DATA_PORT	EQU PORTB
    LCD_CTRL_PORT	EQU PORTC
    FIRST_LINE		EQU 0x80    ;SELECT THE FIRST LINE OF LCD
    CLEAR_LCD		EQU 0x01    ;CLEAR LCD
    CURSOR_SHOW		EQU 0x0E    ;SELECT CURSOR OF LCD
    SECOND_LINE		EQU 0xC0    ;SELECT SECOND LINE OF LCD
    LCD_SELECT		EQU 0x38    ;SELECT 16X2 LCD
    COUNT_CTRL		EQU 0x72
  ;******************************************************************************
  ;DEFINING MACROS 
 ; processor reset vector	    
RES_VECT  CODE    0x0000            
    GOTO    START                   ; go to beginning of program

; TODO ADD INTERRUPTS HERE IF USED

MAIN_PROG CODE                      ; let linker place main program

START
 
 ;Switching to Bank1
 ERRORLEVEL -302    ;Remove "not in bank 0" messageERRORLEVEL -302    ;Remove "not in bank 0" message   
 BSF STATUS,RP0  ;Moving to Bank 1 for the Initilisation of PORTA,PORTB,PORTC
 BCF STATUS,RP1 ; 
 CLRF TRISB	 ;Setting PORTB as Output
 CLRF TRISC	 ;Setting PORTC as Output
 MOVLW 0x60
 MOVWF OSCCON	 ;Setting INTRENAL Oscillator to 4MHz
 ;Switching back to Bank0
 BCF STATUS,RP1  ;Moving to Bank 0 for the Initilisation of PORTA,PORTB,PORTC
 BCF STATUS,RP0  ; 
 CLRF PORTB	 ;Clearing PORTB 
 CLRF PORTC	 ;Clearing PORTC
 MOVLW 0x00
 MOVWF COUNT_CTRL
 LOOP_CMD	MOVF  COUNT_CTRL,0
		CALL  LCD_INIT
		MOVWF LCD_DATA_PORT
		CALL  LCD_COMMAND
		INCF  COUNT_CTRL,1
		MOVLW 0x03
		SUBWF COUNT_CTRL,F  ; Test if count reached to 4
		BNZ  LOOP_CMD
	        MOVLW 0x05
		MOVWF COUNT_CTRL
 LOOP_DATA	MOVF  COUNT_CTRL,0
		CALL  LCD_INIT
		MOVWF LCD_DATA_PORT
		CALL  LCD_DATA
		INCF  COUNT_CTRL,1
		SUBWF COUNT_CTRL,F  ; Test if count reached to 4
		BNZ   LOOP_CMD
FOREVER_LOOP    MOVLW 0x00
		GOTO  FOREVER_LOOP  
 
 

;Delay sub-routine  
          
  Delay 
	  MOVLW D'20'
	  MOVWF COUNT_2
    LOOP1 MOVLW D'20'
	  MOVWF COUNT_1
    LOOP2 NOP
	  NOP
	  DECF  COUNT_1,F
	  BNZ   LOOP2
	  DECF  COUNT_2,F
	  BNZ   LOOP1
  RETURN  
  
  LCD_COMMAND
	      BCF   LCD_CTRL_PORT,RW_BIT
	      BCF   LCD_CTRL_PORT,RS_BIT
	      BSF   LCD_CTRL_PORT,EN_BIT
	      CALL  Delay
	      BCF   LCD_CTRL_PORT,EN_BIT
	      CALL  Delay
    RETURN
    
  LCD_DATA    
	      BCF   LCD_CTRL_PORT,RW_BIT
	      BSF   LCD_CTRL_PORT,RS_BIT
	      BSF   LCD_CTRL_PORT,EN_BIT
	      CALL  Delay
	      BCF   LCD_CTRL_PORT,EN_BIT
	      CALL  Delay
    RETURN
  LCD_INIT    ADDWF PCL
	      RETLW LCD_SELECT
	      RETLW CLEAR_LCD
	      RETLW CURSOR_SHOW
	      RETLW FIRST_LINE
	      RETLW SECOND_LINE
	      RETLW 'R'
	      RETLW 'A'
	      RETLW 'J'
    END
