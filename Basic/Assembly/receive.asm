#include <REGX51.H>
	ORG 0000H
	MOV TMOD,#20H
	MOV SCON,#50H
	MOV TH1,#0FDH
	SETB TR1
	CLR RI
AG:	MOV A,SBUF
	CLR TI
	AJMP AG
	END