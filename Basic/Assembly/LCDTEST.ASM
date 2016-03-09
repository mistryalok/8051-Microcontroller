#include <REGX51.H>
SBIT EN=P2.7
SBIT RS=P2.6
SBIT RW=P2.5
	ORG 0000H
		MOV P0,#00H
	MOV P2,#00H
	MOV A,#01H                           ; Clear LCD
	ACALL COMM
	SJMP $

DELAY: MOV R3,#50
A1:		MOV R4,#255
		DJNZ R4,$
		DJNZ R3,A1
		RET

		COMM: MOV P0,A
	CLR RS		   ;DE DATA
	CLR RW		   ;R/W					aa
	SETB EN		   ;ENA
//	ACALL DELAY
	CLR EN
	RET

	END