#include <REGX51.H>
	ORG 0000H
/*	DW ALOK0200H

	FST EQU 0200H
	SND EQU 021FH
	THD EQU 022FH
	FRTH EQU 023FH
					  */
	MOV TMOD,#20H
	MOV SCON,#50H
	MOV TH1,#0FDH
	SETB TR1

	MOV R2,#00H
	MOV R4,#00H


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
SW1: MOV C,00H
	 JNC GET1
	 MOV C,01H
	 JNC GET2
	
GET1: MOV DPTR,#0200H
	  SJMP NEXT1
GET2: MOV DPTR,#0400H

	NEXT1:	SWAP A
	RT1:	RRC A
		JNC L1
		INC DPTR
		AJMP RT1

SW2:   MOV C,00H
	 JNC GET11
	 MOV C,01H
	 JNC GET22
	
GET11: MOV DPTR,#021FH
	  SJMP NEXT2
GET22: MOV DPTR,#041FH

  
NEXT2:	SWAP A
	RT2:	RRC A
		JNC L1
		INC DPTR
		AJMP RT2



SW3:   	 MOV C,00H
	 JNC GET12
	 MOV C,01H
	 JNC GET23
	
GET12: MOV DPTR,#022FH
	  SJMP NEXT3
GET23: MOV DPTR,#042FH
NEXT3:		SWAP A
	RT3:	RRC A
		JNC L1
		INC DPTR
		AJMP RT3


SW4:  	 MOV C,00H
	 JNC GET14
	 MOV C,01H
	 JNC GET24
	
GET14: MOV DPTR,#023FH
	  SJMP NEXT1
GET24: MOV DPTR,#043FH

NEXT4:		SWAP A
	RT4:	RRC A
		JNC L1
		INC DPTR
		AJMP RT4
/* SEND SUB\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\*/
SEND:	CLR A
		CLR TI
		MOVC A,@A+DPTR
		MOV SBUF,A
		JNB TI,$
	/*	CJNE A,#"*",CONT
		ACALL WATCH		*/
	CONT:CLR TI
		RET
/* DELAY SUB\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\*/
DELAY:
		MOV R1,#0FFh
	H2:	MOV R0,#0FFH
	H1:	DJNZ R0,H1
		DJNZ R1,H2
		RET

/* SEND KEYWORD\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\*/
L1: 	ACALL SEND	
		ACALL CHECKIF
		LJMP AGAIN		

/*WATCH:	INC R2
		CJNE P1,#01110000B,$
		CJNE R2			   */
/* CHECK IF\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\*/
CHECKIF: 	/*MOV P1,#0FFH					  */
	CH:	MOV P1,#01110000B
		MOV A,P1
		ACALL DELAY
		INC R4
		CJNE A,#01110000B,CH
		CJNE R4,#05H,NTPRS							   ; NOT PRESSED FOR LONG TIME
		MOV R4,#00H
		JNC CHANGE
NTPRS:	RET


/*///////////////////////////TO CHANGE MODE////////////////////////////////////*/
CHANGE: 

			MOV DPTR,#06FFH
			 MOV R6,#37
			CLR A
			CLR TI
SENDNEXT:	ACALL SEND
			CLR A
			INC DPTR
			DJNZ R6,SENDNEXT
			




			AGAIN1:	MOV P1,#01110000B
					MOV A,P1
					ANL A,#01110000B
					CJNE A,#01110000B,CHECK1
					ACALL DELAY
					AJMP AGAIN1
			
			CHECK1:	MOV P1,#01111110B
					MOV A,P1
					ANL A,#01110000B
					CJNE A,#01110000B,SW
					AJMP CHECK1
			 SW:	CJNE A,#00110000B,NEXTCHECK
					SETB 00H
		NEXTCHECK:	CJNE A,#01010000B,CHECK1
					SETB 01H
					LJMP AGAIN
					 




						

	ORG 0200H
	DB "123"
	ORG 021FH
	DB "456"
	ORG 022FH
	DB "789"
	ORG 023FH
	DB "*0#"	
	
	
	ORG 06FFH
	DB "For abcd.. Press 1, For 123.. Press 2"	
	
	ORG 0400H
	DB "ABC"
	ORG 041FH
	DB "DEF"
	ORG 042FH
	DB "GHI"
	ORG 043FH
	DB "JKL"
		
		
		end