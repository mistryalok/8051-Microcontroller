#include <REGX51.H>
SBIT EN=P2.7
SBIT RS=P2.6
SBIT RW=P2.5
	ORG 0000H


	MOV TMOD,#20H
	MOV SCON,#50H
	MOV TH1,#0FDH
	SETB TR1

	/////////////////////// KEYPAD COMMANDS ///////////////////////////////////////////////////////////
MOV A,#38H                           ; initialization LCD 2lines, 5×7 matrix.
ACALL COMM                   ; call command subroutine.
ACALL DELAY                          ; call delay subroutine.
MOV A,#0EH                           ; display on, cursor on
ACALL COMM
ACALL DELAY
MOV A,#01H                           ; Clear LCD
ACALL COMM
ACALL DELAY
MOV A,#06H                           ; shift cursor right
ACALL COMM
ACALL DELAY
MOV A,#80H                           ; cursor at beginning of 1st line
ACALL COMM
ACALL DELAY


	MOV P1,#00H
	MOV P0,#00H
	MOV P2,#00H
AGAIN:	MOV P1,#01110000B
		MOV A,P1
		ANL A,#01110000B
		CJNE A,#01110000B,CHECK
		ACALL DELAY
		AJMP AGAIN

CHECK:	MOV P1,#01111110B
		MOV A,P1
		ANL A,#01110000B
		CJNE A,#01110000B,SW1

		MOV P1,#01111101B
		MOV A,P1
		ANL A,#01110000B
		CJNE A,#01110000B,SW2
		
		
		MOV P1,#01111011B
		MOV A,P1
		ANL A,#01110000B
		CJNE A,#01110000B,SW3
		
		MOV P1,#01110111B
		MOV A,P1
		ANL A,#01110000B
		CJNE A,#01110000B,SW4

/* SW CHECK\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\*/		
SW1:  MOV DPTR,#0200H
			SWAP A
	RT1:	RRC A
		JNC L1
		INC DPTR
		AJMP RT1

SW2:   MOV DPTR,#021FH

  
NEXT2:	SWAP A
	RT2:	RRC A
		JNC L1
		INC DPTR
		AJMP RT2



SW3:  	 MOV DPTR,#022FH
NEXT3:		SWAP A
	RT3:	RRC A
		JNC L1
		INC DPTR
		AJMP RT3


SW4:  	MOV DPTR,#023FH

NEXT4:		SWAP A
	RT4:	RRC A
		JNC L1
		INC DPTR
		AJMP RT4
/* SEND SUB\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\*/
SEND:	CLR A
		
		MOVC A,@A+DPTR
		CJNE A,#"#",GETDATA
		ACALL DISP
	
		RET
/* DELAY SUB\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\*/
DELAY:	
		MOV R1,#0FFh
	H2:	MOV R0,#0FFH
	H1:	DJNZ R0,H1
		DJNZ R1,H2
		RET

/* SEND KEYWORD\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\*/
L1: 
		ACALL SEND	
		ACALL CHECKIF
		LJMP AGAIN


	CHECKIF: 	/*MOV P1,#0FFH					  */
	CH:	MOV P1,#01110000B
		MOV A,P1
		ACALL DELAY
	
		CJNE A,#01110000B,CH	  ; IF PRESSED FOR LONG TIME

		RET	



////////////////////////// COMMAND FOR KEYPAD SUB///////////////////////////////////////
COMM: MOV P0,A
	CLR RS		   ;DE DATA
	CLR RW		   ;R/W					aa
	SETB EN		   ;ENA

	CLR EN
	RET

/////////////////////////////// DATA FOR DISPLAY SUB/////////////////////////////////////
 DISP: MOV P0,A
 		SETB RS
		CLR RW
		SETB EN
	
		CLR EN
		RET
	
	ORG 0200H
	DB "123"
	ORG 021FH
	DB "456"
	ORG 022FH
	DB "789"
	ORG 023FH
	DB "*0#"

	END