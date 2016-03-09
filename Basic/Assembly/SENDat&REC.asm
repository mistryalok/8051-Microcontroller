#include <REGX51.H>
		ORG 0000H

		MOV SCON,#50H		; SCON [SM0]-[SM1]-[SM2]-[REN]-[TB8]-[RB8]-[Ti]-[Ri]
		MOV TMOD,#20H
		MOV TH1,#0FDH
		SETB TR1
		CLR A

		MOV A,#"A"
		ACALL SEND
		MOV A,#"T"
		ACALL SEND
		
		ACALL REC
		CJNE A,#"O",END
		ACALL REC
		CJNE A,#"K",END

SEND:	CLR TI
		MOV SBUF,A
		JNB TI,$
		CLR TI
		RET

REC:	CLR RI
		JNB RI,$
		CLR RI
		MOV A,SBUF
		RET