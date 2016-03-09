#include <REGX51.H>

	MOV DPTR,#0200H
	MOV R0,#32
	MOV R2,#04H
	ACALL GETDATA
	ACALL COMPDATA
	MOV R3,#02H
	MOV R4,#02
	
	
	
	
	
	
	
	  
GETDATA:	CLR A
AGAIN:	MOVC A,@A+DPTR
	MOV @R0,A
	INC DPTR
	INC R0
	DJNZ R2,AGAIN
	RET
	

COMPDATA: MOV A,32h
		CJNE 	



	


	ORG 0200H
	
	DB "GATE"	 ; TYPE
	DB "14"	  ; TOTAL  PINS
	DB "02"	  ; INPUT PINS
	DB "A B O"
	DB "0 0 0"
	DB	"0 1 0"
	DB	"1 0 0"
	DB	"1 1 1"
	DB "END"
	END