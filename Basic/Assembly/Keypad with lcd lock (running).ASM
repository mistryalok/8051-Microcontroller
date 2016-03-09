#include <REGX51.H>
	SBIT EN=P2.7
	SBIT RS=P2.6
	SBIT RW=P2.5
		ORG 0000H
	   	CLR C
		MOV R1,#31H
		
		
		MOV P1,#00H
	MOV P0,#00H
	MOV P2,#00H
	
		MOV TMOD,#20H
		MOV SCON,#50H
		MOV TH1,#0FDH
		SETB TR1
	
		/////////////////////// KEYPAD COMMANDS ///////////////////////////////////////////////////////////
START_AGAIN:	MOV A,#38H                           ; initialization LCD 2lines, 5×7 matrix.
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


		MOV R7,#8
		MOV DPTR,#0500H
		CLR A
SENDNEXT:	MOVC A,@A+DPTR
		ACALL DISP
		ACALL SMDELAY
		INC DPTR
		CLR A
		DJNZ R7,SENDNEXT
	
		MOV R7,#00H
		MOV DPTR,#0000H
		
		
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
				MOV 20H,A
				CJNE A,#"#",CONTINUE
				LJMP GETDATA
		

	CONTINUE:	MOV 20H,A
				
				//MOV C,01H
			//	JNC PASSWORD
			//	SJMP NEXT5
		
		MOV A,#"*"
			ACALL DISP
				ACALL STORETHIS
			
				RET

/* DELAY SUB\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\*/
DELAY:	
		MOV R2,#0FFh
	H2:	MOV R3,#0FFH
	H1:	DJNZ R3,H1
		DJNZ R2,H2
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

////////////////////// READ THE LCD DATA//////////////////////////////////////////
READ: MOV P0,A
	CLR RS		   ;DE DATA
	SETB RW		   ;R/W					aa
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

SMDELAY: MOV R3,#0FFH
		DJNZ R3,$
		RET


GETDATA:MOV R1,#31H
		MOV A,@R1
		CJNE A,#"0",ERROR
		INC R1
		MOV A,@R1
		CJNE A,#"0",ERROR
			INC R1
		MOV A,@R1
		CJNE A,#"4",ERROR
			INC R1
		MOV A,@R1
		CJNE A,#"7",ERROR
		INC R0
		CLR A
		LJMP OK
		LJMP CHECKIF

ERROR: 	
		////////////////////TO CLEAR THE STORED PASSWORD///////////////////////////////////////////////////////////

		MOV R1,#31H


	  	 MOV R6,#5
		MOV DPTR,#0600H
		MOV A,#01H
		ACALL COMM
		ACALL DELAY
		CLR A
	
	SENDNEXT2:		MOVC A,@A+DPTR
		ACALL DELAY
		
		ACALL DISP
		INC DPTR
		CLR A
		DJNZ R6,SENDNEXT2
		LJMP START_AGAIN
		RET

OK:  		MOV A,#01H
			ACALL COMM
			ACALL DELAY
			MOV R1,#31H
			

		 MOV R6,#2
		MOV DPTR,#0612H
		CLR A
	SENDNEXT1:		MOVC A,@A+DPTR
		ACALL DELAY
		ACALL DISP
		INC DPTR
		CLR A
		DJNZ R6,SENDNEXT1
	
		MOV 7FH,#0AAH ; TO INDICATE THAT PASSWORD IS OK IN THE NEXT PROGRAMM

		LJMP NEXTPRG
		RET
		
STORETHIS:		
				MOV @R1,20H
				INC R1
				RET
	
//***************************PASSWORD IS OKEY THEN COME TO THIS PROG.***************************************************************************		 


NEXTPRG:    
			MOV A,#02H
			ACALL COMM
			ACALL DELAY
			
			MOV A,#01H
			ACALL COMM
			ACALL DELAY
		//>////////////// DISPLAY  WELCOME!///////////////////////////////////////////////////////////////////	
					CLR A
					MOV DPTR,#0245H
					MOV R5,#8
			NEXTSEND4:	MOVC A,@A+DPTR
					ACALL DISP
					ACALL DELAY
					INC DPTR
					CLR A
					DJNZ R5,NEXTSEND4
					
					ACALL DELAY
					ACALL DELAY
					ACALL DELAY
					ACALL DELAY

		  // >/////////////DISPLAY ENTER NO.///////////////////////////////////////////////////////////////////////
					MOV A,#01H
					ACALL COMM
					ACALL DELAY
					MOV DPTR,#0250H
					MOV R5,#9
					CLR A
			NEXTSEND5:	MOVC A,@A+DPTR
					ACALL DISP
					ACALL DELAY
					CLR A
					INC DPTR
					DJNZ R5,NEXTSEND5
					///////////// TO ENTERN IN TO SECOND LINE/////////////////////////////////////////////////////////////////
					MOV A,#02H
					ACALL COMM
					ACALL DELAY
					MOV A,#01H
					ACALL DELAY
					ACALL DELAY
					MOV A,#0C0H
					ACALL COMM
					ACALL DELAY
					 
					ACALL AGAIN

			







	ORG 0200H
	DB "123"
	ORG 021FH
	DB "456"
	ORG 022FH
	DB "789"
	ORG 023FH
	DB "*0#"

 	ORG 0245H
	DB "WELCOME!"

	ORG 0250H
	DB "ENTER NO."
	

	
 
   ORG 0500H
   DB "PASSWORD"

   ORG 0600H
   DB "ERROR"

   ORG 0612H
   DB "OK"
	END