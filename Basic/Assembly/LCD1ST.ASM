#include <REGX51.H>
SBIT EN=P2.7
SBIT RS=P2.6
SBIT RW=P2.5
/*SBIT EN P2.7
P2.6  RS	 */
	ORG 0000H
	MOV P0,#00H
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


AGAIN: MOV A,#'A'
	
	ACALL DISP


	MOV A,#'L'
	ACALL DELAY

	ACALL DISP
	ACALL DELAY

MOV A,#38H                           ; initialization LCD 2lines, 5×7 matrix.
ACALL COMM                   ; call command subroutine.
ACALL DELAY                          ; call delay subroutine.
MOV A,#0EH                           ; display on, cursor on
ACALL COMM
ACALL DELAY


MOV A,#06H                           ; shift cursor right
ACALL COMM
ACALL DELAY

MOV A,#0C0H
	ACALL COMM
	ACALL DELAY
	
	MOV A,#'B'
   ACALL DISP
   ACALL DELAY




AJMP $





	  

DELAY: MOV R3,#50
A1:		MOV R4,#255
		DJNZ R4,$
		DJNZ R3,A1
		RET

COMM: MOV P0,A
	CLR RS		   ;DE DATA
	CLR RW		   ;R/W					aa
	SETB EN		   ;ENA

	CLR EN
	RET

 DISP: MOV P0,A
 		SETB RS
		CLR RW
		SETB EN
	
		CLR EN
		RET


	END

 		
			