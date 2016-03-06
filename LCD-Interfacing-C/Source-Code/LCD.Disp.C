#include "includes.h"


/*******************************************************
******* 		To initialize LCD, commands			************
*******************************************************/

void int_lcd()

{
		P0=0x00;  // to make both port as output.
		P2=0x00;
	
		command(0x38);	// 8bit char, 2 Line and 5x7 Matrix
		command(0x0E);	//	Display on, cursor off
		command(0x01);	//	clear screen
		command(0x06);	// Increment cursor, right sied
		command(0x80);	//	Force cursor on 1st line, begning.
}


/*******************************************************
************* 		To send command	to LCD		************
*******************************************************/

void command(unsigned char cmd)
	{
		LCDdata=cmd;				//	send data to port 0
		RS=0;					//	make rs low
		RW=0;					//	make write enable
		EN=1;				//	toggle En pin
		EN=0;					//
		delay();			//Delay here
	}

	
/*******************************************************
************* 		To send Data on LCD		****************
*******************************************************/
	
void display()
	{
		LCDdata=ACC;				// copy data on port
		RS=1;						// make rs high
		RW=0;						//	make write enable
		EN=1;						//	toggle EN	
		EN=0;
		delay();	
	}

	
/*******************************************************
*********** 		To rotate displayed data		************
*******************************************************/
void rotate_lcd(unsigned char rot)
	{
		int r;
		for(r=0;r<rot;r++)
			{
			command(0x18);		// send rotate command 
			delay();					// To provide delay amid the rotation
			delay();
			}
	}
	

/*******************************************************
*********** 		send a char to be displayed		**********
*******************************************************/	

void display_char(unsigned char dt)
	{
			ACC=dt;		// copy to acc register
			display();//	send it to display function for further process
			delay();	//	provide delay amid each character
	}
		
		
/*******************************************************
************* 		To display Array			****************
*******************************************************/			
		
void display_data(unsigned char dsp[])
	{
		unsigned char temp;
			for(temp=0;dsp[temp]!='\0';temp++)	// Make loop for each character of the Array, untill null character, end of string
				{
					ACC=dsp[temp];									// Display indivisual char.
					display();
					delay();
				}
	}
		
		
/*******************************************************
***********	Provide delay needed to LCD	****************
*******************************************************/	
		
	void delay()
	{
		
		int j,k;
		for(j=0;j<=21;j++)
			{
			for(k=0;k<=300;k++);
			}

		}
