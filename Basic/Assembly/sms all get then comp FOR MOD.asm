#include <REGX51.H>
		ORG 0000H
		MOV SCON,#50H
		MOV TMOD,#20H
		MOV TH1,#0FDH
		SETB TR1
		CLR A
/*  GET DATA FROM ROM TO RAM   */		

		MOV DPTR,#0333H							 ; GET ALL DATA TO INTERNAL RAM.	 ALL DATA TO BE COMP.
		MOV R1,#40H								; DATA COUNT... NO.S OF DATA
		MOV R6,#20H								 ; STORE FROM MEMORY LOCATION...20
		CLR A
AGAIN:	MOVC A,@A+DPTR
		MOV	@R1,A								 ; GET ALL DATAs
		CLR A
		INC DPTR
		DJNZ R6,AGAIN

/* SEND 1ST COMMAND  AT+CMNI=2,2,0,0,0     at rom location 02DDh  */		
				
	 	MOV R0,#11H						 ; SEND AT 1ST COMMAND	   AT+CNMI
		MOV DPTR,#02DDH
AG:		LCALL SEND					  ; CALL TO SEND AT+CNMI..	 
		LCALL OK				  ; CALL CHECK RESPONCE		IF NOI OK THEN GOTO AG:


/* GIVE SOME DEALY BETWEEN TWO COMMANDS  */	
		LCALL DELAY						; MAKE SOME DELAY.


/* SEND 2ND COMMAND  AT+CMGF=1 				AT ROM LOCATION 0300h */
AG1:	MOV DPTR,#0300H						 ;  CALL 2ND AT COMMAND ,AT+CMGF=1
		MOV R0,#09H							 ; COMMAND LENGTH
		CLR A
		LCALL SEND					   ; 
		SETB C
		LCALL OK							  ; REC. OK.

/* CHECK SMS CODE */
		LCALL SMS					; CHECK SMS

 /* IF MSG SAME THEN OP AT PORT..*/
			MOV P1,#00H												; SENT 00 & FF TO PORT 1
			STA:MOV P1,#0FFH
			LCALL DELAY
			MOV P1,#00H
			LCALL DELAY
			LJMP STA

   /* ENDE										*/
ENDE:		LJMP ENDE1








/****************************************		SUBROUTINE		**************************************************************************/




/* CHECK SMS SUB. */
	SMS:	MOV R3,#45
	CON:	LCALL REC	
			DJNZ R3,CON						  ; CONT UNTILL 51 CHAR ARE RECVD.
		  /* REC. NEXT 9 BYTES */
			MOV R0,#4EH
			MOV R3,#09H
		CH:	ACALL REC
			XRL A,@R0
			JNZ ENDE
			INC R0
			DJNZ R3,CH						
		 	RET
	  

		
		
		
	
								
	


/* 	CHECK RESPONCE OK... SUB.....*/

OK: 	MOV 20H,"O"				 ;CHECK OK.
		MOV 21H,"K"
		MOV R7,#02H
		MOV R1,#20H
	CONT1:	ACALL REC
		XRL A,@R1
	
		JZ NEXT			 ; IF CARRY THEN JUMP TO SECOND COMMAND OTHERWISE ON FIRST COMMAND
		JC AG1
		LJMP AG
		
 NEXT:	INC R1
		DJNZ R7,CONT1
		RET		 


		
			
	
	
						
/*	REC. SUB		*/						
REC:	CLR RI				  ; REC SUB.
	MOV A,SBUF
	HERE1:	JNB RI,HERE1
	CLR RI
	RET						

 
 /*	SEND SUB			*/
	SEND:	MOVC A,@A+DPTR				  ; SEND SUB.
	CLR TI
	MOV SBUF,A
	HERE:	JNB TI,HERE
	CLR TI
	CLR A
	INC DPTR
	DJNZ R0,SEND
		RET	
	
			 	
/*  DELAY SUB. 				*/	
 DELAY: MOV R0,#08H
A3:		MOV R1,#0FFH
A2:		MOV R2,#0FFH
A1:		DJNZ R2,A1
		DJNZ R1,A2
		DJNZ R0,A3
		RET
		




		ORG 02DDH
	 DB "AT+CNMI=2,2,0,0,0"
		ORG 0300H
	 DB "AT+CMGF=1"
		ORG 0333H		
	 DB "+918460771266"		 			; 40
	 DB "SWITCH ON"						 ;4E-57
	 DB "SWITCH OFF"					 ;58-

/*	ORG 03DDH

	DB "SWITCH ON"
		ORG 04FFH
	DB "SWITCH OFF"	 
	DB "AT+CMGR="	*/	
	
ENDE1: NOP	
		END

		