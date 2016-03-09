#include <REGX51.H>
	org 0000h
ag:	mov p1,#0ffh
	mov a,p1
	mov p3,#00h
	mov p3,a

	ajmp ag
	end