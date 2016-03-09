#include <REGX51.H>
#include<string.h>

void delay();
void Transmit(char *dat);
void HandleReceive();
void HandleTransmit();
//char dat1[8]="Relay On";
unsigned char b[];
unsigned char msg[];


//unsigned char a[]= "AT+CMGS=1,AT+CMGR=How are You.9904428567";
unsigned int k,m,n;

void main()
{

	//float val;
		    TMOD =0X20;
			TH1=0XFD;	// baud rate
			SCON=0X50;
			TR1=1;
			EA=1;
			ES=1;
	        HandleTransmit();
			
			while(1);
	 
	     }

	  
	  void serial (void) interrupt 4 using 1 
	  
	  {	  
	  		n++;
	       if(TI)
		   HandleTransmit();
		   if (RI)
		   HandleReceive();
		   } 
	 
	 
	 void HandleTransmit()
	    {
	       Transmit("AT+CMGS=1,AT+CMGR=2");
		   }
	 
	 
	 void Transmit(char *dat)
	  {
		 unsigned char len=strlen(dat);
	//while(1)
	//{
		for(k=n;k<=len;k++)
			{
				SBUF=dat[k];
				while(TI==0);
			
				delay();
				delay();
				delay();
				delay();
				delay();
				delay();
				delay();
				delay();
				delay();
				TI=0;
	//	}
	}

 }


  
  void HandleReceive()
  
   {

     for(m=0;m<=9;m++)
	  {
       while(RI==0);
       msg[m]=SBUF;
	   b[m]=msg[m];
	   RI=0;
	    }
	    
	/*  if(strcmp(b,"Relay On")==0)
	   {
	     P1_0=1;  
	      }
		else
		
		  P1_0=0;	  */
		 
		  }	   
		  	  

void delay()
 {
	int i,j;
	for(i=0;i<=2000;i++)
		for(j=0;j<=1000;j++);
	
    }
	
