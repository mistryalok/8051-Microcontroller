#include <REGX51.H>
	ORG 0000H
	MOV TMOD,#20H
	MOV SCON,#50H
	MOV TH1,#0FDH
	SETB TR1


	MOV P1,#00H
	MOV P1,#0FFH
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
 ////SEND SUB\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\*/
SEND:	CLR A
		CLR TI
		MOVC A,@A+DPTR
		MOV SBUF,A
		JNB TI,$
	
		CONT:CLR TI
		RET			*/
/* DELAY SUB\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\*/
DELAY:	
		MOV R1,#0FFh
	H2:	MOV R0,#0FFH
	H1:	DJNZ R0,H1
		DJNZ R1,H2
		RET

/* SEND KEYWORD\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\*/
L1: 	ACALL DISP	
		ACALL CHECKIF
		LJMP AGAIN


	CHECKIF: 	/*MOV P1,#0FFH					  */
	CH:	MOV P1,#01110000B
		MOV A,P1
		ACALL DELAY
	
		CJNE A,#01110000B,CH
								   ; NOT PRESSED FOR LONG TIME

		RET	

	
	ORG 0200H
	DB "123"
	ORG 021FH
	DB "456"
	ORG 022FH
	DB "789"
	ORG 023FH
	DB "*0#"


 /////////////////////////////////////////////////////////LCD....///////////////////////


SBIT EN=P2.7
SBIT RS=P2.6
SBIT RW=P2.5
/*SBIT EN P2.7
P2.6  RS	 */
	
	MOV P0,#00H
	MOV P2,#00H
	MOV A,#01H
	ACALL COMM
	
	
	MOV A,#0EH
	ACALL COMM
//	ACALL DELAYL

	MOV A,#80H						  ;80
	ACALL COMM
//	ACALL DELAYL

	MOV A,#38H					;38
	ACALL COMM
//	ACALL DELAYL

AG:	MOV A,#"A"
	
	ACALL DISP
	ACALL DE

	MOV A,#"L"
	
	ACALL DISP
	ACALL DE

	MOV A,#"O"
	
	ACALL DISP
	ACALL DE

	MOV A,#"K"
	
	ACALL DISP
	ACALL DE


	
 

	MOV A,#01H
	ACALL COMM
	ACALL DE
AJMP AG	 



DE:	MOV R0,#0FFH
		DJNZ R0,$
		RET

DELAYL: MOV R1,#05H
		DJNZ R1,$
		RET

COMM: MOV P0,A
	CLR RW		   ;DE DATA
	CLR RS		   ;R/W					aa
	SETB EN		   ;ENA
	ACALL DELAYL
	CLR EN
	RET

 DISP: MOV P0,A
 		SETB RS
		CLR RW
		SETB EN
		ACALL DELAYL
		CLR EN
		RET


	END





	END