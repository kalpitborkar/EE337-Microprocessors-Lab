/*************************************************
 	lcd.h: Header file for 16x2 LCD interfacing  
**************************************************/
//Functions contained in this header file

void dashtone(void);																//Dash tone generator
void dottone(void);																	//Dot tone generator


void morse_a(void);																	//morse code for A
void morse_b(void);																	//morse code for B
void morse_c(void);																	//morse code for C
void morse_d(void);																	//morse code for D
void morse_e(void);																	//morse code for E
//Function definitions

void dashtone(void) 
{ 
	
	unsigned i;
	for(i=0;i< 1500 ;i++){
	P0_7 = ~P0_7;
	msdelay(1); 		
		/* This function is a welcome change over the hardwork in the delay subroutines in earlier labs :D*/
	}
}
void dottone(void)
{ 
  // Similar to dashtone
	unsigned i;
	for(i=0;i< 750 ;i++){
	P0_7 = ~P0_7;
	msdelay(1); 		

}
	}

void morse_a(void)// .-
{
	dottone();
	msdelay(1000);
	dashtone();
	msdelay(1000);
}

void morse_b(void)// -...
{
	dashtone();
	msdelay(1000);
	dottone();
	msdelay(1000);
	dottone();
	msdelay(1000);
	dottone();
	msdelay(1000);
}
void morse_c(void)// -.-.
{
	dashtone();
	msdelay(1000);
	dottone();
	msdelay(1000);
	dashtone();
	msdelay(1000);
	dottone();
	msdelay(1000);
	
}
void morse_d(void)// -..
{
	dashtone();
	msdelay(1000);
	dottone();
	msdelay(1000);
	dottone();
	msdelay(1000);
}
void morse_e(void)// .
{
	dottone();
	msdelay(1000);
}
