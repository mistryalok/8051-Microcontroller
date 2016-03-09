#include <REGX51.H>
		ORG 0000H
		MOV SCON,#50H
		MOV TMOD,#20H
		MOV TH1,#0FDH
		SETB TR1
		CLR A
		
	   	MOV R0,#20H
		MOV R6,#0DH			 ;GET  DATA FROM ROM.
		MOV DPTR,#02DDH
GET:		MOVC A,@A+DPTR
		MOV @R0,A
		INC R0
		INC DPTR
		CLR A
		DJNZ R6,GET

	


AG:		MOV R0,#0DH	 		  ;REC. total 13 chars. COUNT
		MOV R1,#20H;  REC. AND COMP WITH LOCATION ADD.
NEXT:	ACALL REC		 ;CALL TO REC subroutine
		MOV R7,A			 ; TO GET THE SMS NO. LAST CHAR. OF SMS.
		MOV 04H,@R1		  ; TO COMPARE SOME CHARS.					  ;04H=R4
		XRL A,@R1			; IF BOTH DATA ARE SAME THEN A=00H. XRL LOGIC.
		INC R1				 ; INC. MEMORY POINT.
		JNZ CHECKIF		   ; IF DATA ARE NOT SAME THEN GO TO CHECK IF.. 
ST:		DJNZ R0,NEXT	   ; decrement till all characters are not received
		MOV 44H,R7			; COPY THE LAST BYTE WHICH IS THE SMS ADD. IN GSM MODEM. 
		LJMP SEND




			REC:							   ; Receive subroutine
			CLR RI								  ; clr RI flag
			HERE:JNB RI,HERE						  
			MOV A,SBUF								  	 
			CLR RI		 ; clr to receive a new byte
			RET			 ; return to 							"NEXT "


CHECKIF: 	   CJNE R4,#" ",NEXT1
			LJMP ST
		NEXT1:	   CJNE R4,#"X",ENDE										;END.. NOT EQUAL
				   LJMP ST
	
						/*	 " CHAR COMP. SUB."
						
							CHECK:   MOV A,@R0		;COMPARE SUB.
									 ANL A,@R1
									 JNZ ENDE
									 INC R0
									 CHECK		 */
									
						/*			CJNE A,"+",ENDE 
									 INC R0
									 MOV A,@R0
									 CJNE A,#"C",ENDE
						
									
										
										
										CJNE A,#"M",ENDE
										RET
										CJNE A,#"T",ENDE
										RET
										CJNE A,#"I",ENDE
										RET
										CJNE A,#":",ENDE
										RET
										CJNE A,#" ",A4
										RET
								A4:		CJNE A,#"S",ENDE
										RET
										CJNE A,#"M",ENDE
										RET
										CJNE A,#" ",A5
										RET
									A5:	CJNE A,#",",ENDE
										RET
										CJNE A,#"8",ENDE
										RET
						
									
									RET	   */
			



			/*	GETSND:	 MOV R3,#08
						 MOV R0,#50H
					NXTBYT:	MOVC A,@A+DPTR
						MOV @R0,A
						INC DPTR
						INC R0
						CLR A
						DJNZ R3,NXTBYT
						AJMP RDMSG			  */



				/* 	 RDMSG:	MOV R3,#08H
						MOV R0,#50H 	  ;SEND DATA ADD.
					SND:   MOV A,@R0
							CLR TI
							MOV SBUF,A
					WAIT:	JNB TI,WAIT
						CLR TI
						INC R0
						DJNZ R3,SNDL
					SNDL: MOV A,44H
							MOV SBUF,A
						HR:	JNB TI,HR
							LJMP RECMSG
						
				
				  				RECMSG:		 */

SEND: 	MOV P1,#00H												; SENT 00 & FF TO PORT 1
	CONT:	MOV P1,#0FFH
		ACALL DELAY
		MOV P1,#00H
		ACALL DELAY
		AJMP CONT

		

DELAY: MOV R0,#08H
A3:		MOV R1,#0FFH
A2:		MOV R2,#0FFH
A1:		DJNZ R2,A1
		DJNZ R1,A2
		DJNZ R0,A3
		RET


ENDE:	NOP

		ORG 02DDH

	DB "+CMTI:  SM ,X"	 
/*	DB "AT+CMGR="	*/	
	END
		

		