#include <REGX51.H>
	ORG 0000H
	MOV TMOD,#20H
	MOV SCON,#50H
	MOV TH1,#0FDH
	SETB TR1
//////////////////////////DPTR ADD. initial keypad 1234567890//////////////////////////////////////////////
	MOV 12H,#00H ; DPL
	MOV 13H,#02H ; DPH

	MOV 14H,#1FH ;
	MOV 15H,#02H

	MOV 16H,#2FH
	MOV 17H,#02H

	MOV 18H,#3FH
	MOV 19H,#02H

/////////////////////////////// MAIN PROG.///////////////////////////////////

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
SW1:  
		MOV DPL,12H
		MOV DPH,13H

			SWAP A
	RT1:	RRC A
		JNC L1
		INC DPTR
		AJMP RT1

SW2:   MOV DPL,14H
		MOV DPH,15H

  
NEXT2:	SWAP A
	RT2:	RRC A
		JNC L1
		INC DPTR
		AJMP RT2



SW3:  	 MOV DPL,16H
		MOV DPH,17H
NEXT3:		SWAP A
	RT3:	RRC A
		JNC L1
		INC DPTR
		AJMP RT3


SW4:  	MOV DPL,18H
		MOV DPH,19H

NEXT4:		SWAP A
	RT4:	RRC A
		JNC L1
		INC DPTR
		AJMP RT4
/* SEND SUB\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\*/
SEND:	CLR A
		CLR TI
			MOVC A,@A+DPTR			; Get frst char in acC.
		CJNE A,#"*",PRECHECK	  ; (1)COMPARE IF FIRST BYTE IS "*" IF NOT THEN STORE AND CHECK NEXT BYT ; (2)IF * ALRDY SENT THEN GOTO CHECK WEATHER THERE IS * IN R7 OR NOT?
		LJMP CHECKCODE				 ; IF "*" Pressed THEN GOTO CHECKCODE(TO CHECK NEXT CHAR WHICH MIGHT BE "#" & DO NOT SEND THAT BYTE > 
PRECHECK:	CJNE R7,#"*",GOTONEXT	  ; IF NO "*" IN R7(THAT MEANS NOT PRESSED BFORE) THAT MEANS NO CODE AND CONTINUE. WITH NORMAL PROGRAM. 
			LJMP CHECKNO			   ; IF "*" IN R7 THEN WAIT FOR NEXT "#".. WHICH IS THE ACTUAL CODE. LAST DIGIT OF CODE


			MOVC A,@A+DPTR///////////////////////////////////////; CHECK THIS LINE B4..........///////////////////////////////////////////////////////////////		 
	
GOTONEXT:		MOV SBUF,A
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


	CHECKIF: 	/*MOV P1,#0FFH					  */
	CH:	MOV P1,#01110000B
		MOV A,P1
		ACALL DELAY
	
		CJNE A,#01110000B,CH
								   ; NOT PRESSED FOR LONG TIME

		RET	

CHECKCODE:		MOV R7,A					  ; SAVE THE * IN R7 USED IN NEXT INSTRUCTION

				LJMP CHECKIF				  ; CONTINUE TO RECEIVE NEW BYT
CHECKNO:	XRL A,#"#"
			MOV R7,#00H
			JZ CHANGETHE
		//	XRL A,#"A"
		//	MOV R7,#00H					/////////////////////NEW
		//	JZ CHANGETHE
			LJMP GOTONEXT

	

CHANGETHE: 	  MOV A,DPH
				CLR C
				MOV 7FH,A
				SUBB A,#03H
NEXTONE:		JZ CHNGTOklm
				JC CHNGTOabc
				
				CLR C
				MOV A,7FH
				SUBB A,#05H
				JZ CHNGTO123
				JC CHNGTOuvw



			//MOV 12H,#00H ; AS IT IS		   DPL IS SAME	 
CHNGTOabc:	MOV R6,#03H
			ACALL CHANGETHIS
			LJMP CHECKIF

			
CHANGETHIS:	MOV 13H,R6 ; DPH

		//	MOV 14H,#1FH ;					  DPL IS SAME
			MOV 15H,R6

		//	MOV 16H,#2FH					;	DPL IS SAME
			MOV 17H,R6
											;	  DPL IS SAME
		//	MOV 18H,#3FH
			MOV 19H,R6
			RET

CHNGTO123:	MOV R6,#02H
			ACALL CHANGETHIS
			LJMP CHECKIF


CHNGTOklm:	MOV R6,#04H
			ACALL CHANGETHIS
			LJMP CHECKIF

CHNGTOuvw: MOV R6,#05H
			ACALL CHANGETHIS
			LJMP CHECKIF


	ORG 0200H
	DB "123"
	ORG 021FH
	DB "456"
	ORG 022FH
	DB "789"
	ORG 023FH
	DB "*0#"
//////////////////////CHANGED TO ABC.////////////////////////////////////
	ORG 0300H
	DB "ABC"
	ORG 031FH
	DB "DEF"
	ORG 032FH
	DB "GHI"
	ORG 033FH
	DB "*J#"

///////////////////////// KLMNOPQRST///////////////////////	
	ORG 0400H
	DB "KLM"
	ORG 041FH
	DB "NOP"
	ORG 042FH
	DB "QRS"
	ORG 043FH
	DB "*T#"

/////////////////////////// UVWXYZ/////////////////

	ORG 0500H
	DB "UVW"
	ORG 051FH
	DB "XYZ"
	ORG 052FH
	DB "ALO"
	ORG 053FH
	DB "*K#"



	END