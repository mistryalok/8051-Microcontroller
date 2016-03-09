#include <REGX51.H>
ORG 0000H
SBIT RS= P2.6
SBIT RW= P2.5
SBIT EN= P2.7

MOV P1,#00H
MOV P2,#00H

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
MOV A,#0CH
ACALL COMM
ACALL DELAY

MOV DPTR,#0200H
CLR A
MOV R7,#31
DISPAG:MOVC A,@A+DPTR
ACALL DISP
ACALL DELAY
INC DPTR
CLR A
CJNE R7,#15,NEXT
MOV A,#0C0H
ACALL COMM
CLR A
NEXT: DJNZ R7,DISPAG
 AJMP $


COMM: MOV P0,A
	CLR RW		   ;DE DATA
	CLR RS		   ;R/W					aa
	SETB EN		   ;ENA
acall DE
	CLR EN
	RET
////////////////////////////////////DATA SEND///////////////////////////////////////////
 DISP: MOV P0,A
 		SETB RS
		CLR RW
		SETB EN
	Acall DE
		CLR EN
		RET


DELAY:     MOV R2,#0FFH
A1:			MOV R3,#0FFH
       DJNZ R3,$
	DJNZ R2,A1	
		RET
DE: MOV R7,#05H
	DJNZ R7,$
	RET

DELAYFOR: MOV R2,#04H
	L1:	MOV R1,#0FFH
	L2:	MOV R0,#0FFH
		DJNZ R0,$
		DJNZ R1,L2
		DJNZ R2,L1
		RET
		
	
 ORG 0200H
 DB "MICROCONT&LLER & EMBEDDED SYST."	
		END 