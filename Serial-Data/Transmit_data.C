#include <REGX51.H>

/***********************************************************************************
**																																								**
** 	Project	=	This is a program to transmit Data on serial Port										**
** 	Use Hyper Terminal in 9600 BPS																								**
**	Author	=	Alok																																**
**																																								**
**																																								**		
***********************************************************************************/

void serialset();
void transmit_data(unsigned char str[]);

void main()
	{
		serialset(); // to set baudrate
		
		
		transmit_data("Hello");
	}
	
	
	
	
	
	
	
/////////////////////////////// functions ///////////////////////////////////////////////////////////////////////////////////////////	
void serialset()
{
TH1= 0xfd;
SCON= 0x50;
TMOD = 0x20;
TR1 =1;
}


void transmit_data(unsigned char str[])
	{
	 unsigned char st;
			for(st=0;str[st]!='\0';st++)
			{
			SBUF=str[st];
			while(TI==0);
			TI=0;
			}
}