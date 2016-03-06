#ifndef __AT89C51_H__
#define __AT89C51_H__


sfr LCDdata = 	0x80; 	//P0 0x80, P1 0x90
sbit EN			=		P2^7;		//P2_7
sbit RS			=		P2^6;		//P2_6
sbit RW			=		P2^5;		//P2_5


// some commands named basis of their working


// Functions

void int_lcd();
void command(unsigned char );
void display();
void rotate_lcd(unsigned char );
void display_char(unsigned char );
void display_data(unsigned char []);
void delay();
#endif