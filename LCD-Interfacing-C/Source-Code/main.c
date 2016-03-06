#include "includes.h"


/***********************************************************************************
**																																								**
**  Project	= This is a program to interface LCD with 8051, in 8-bit mode					**
**	Author	=	Alok																																**
**																																								**		
************************************************************************************
**						LCD CONFIG								**																				**
**	LCD data	=			P0 or P1(Proteus)		**							 													**
**		EN			=			P2.7								**																				**
**		RS			=			P2.6								**																				**
**		RW			=			P2.5								**																				**
**																			**																				**
***********************************************************************************/

void main()

{
	P0=0x00;
	P1=0x00;
	P2=0x00;
	P3=0x00;
	
	int_lcd();			// Initial LCD commands
	display_data("Hello Alok!");	// Enter Array here
	rotate_lcd(10);			// Send instruction to rotate 5 times left
	while(1);					// Halt program here.
}