#include <REGX51.H>
		ORG 0000H
		MOV SCON,#50H
		MOV TMOD,#20H
		MOV TH1,#0FDH
		MOV P1,#00H
		SETB TR1
		CLR A

	/*	MOV A,#"A"
		ACALL SEND
		MOV A,#"T"
		ACALL SEND */
		
NEXT:		ACALL REC
		CJNE A,#"Y",NEXT
		LJMP PORTON


/*SEND:	CLR TI
		MOV SBUF,A
		JNB TI,$
		CLR TI
		RET	   */

REC:	CLR RI
		JNB RI,$
		CLR RI
		MOV A,SBUF
		RET			 

PORTON:	
		MOV P1,#0AH

ENDE:	NOP
		END