#include <at89c5131.h>
#include "lcd.h"	   //Header file with LCD interfacing functions
#include "MorseCode.h" //Header file for Morse Code

sbit LED = P1 ^ 7;
sbit p1_0 = P1 ^ 0;
sbit p1_1 = P1 ^ 1;
sbit p1_2 = P1 ^ 2;
sbit p1_3 = P1 ^ 3;


/*
Port P0.7 is used for the audio signal output
*/
// Main function

void main(void)
{

	// Call initialization functions
	lcd_init();

	// Read input nibble here
	P1 = 0x0F;

	// Insert Priority Logic
	while(1){
	if (p1_0)
	{
		lcd_write_string("A");
		morse_a();
		continue;
	}
	else if (p1_1)
	{
		lcd_write_string("B");
		morse_b();
		continue;
	}
	else if (p1_2)
	{
		lcd_write_string("C");
		morse_c();
		continue;
	}
	else if (p1_3)
	{
		lcd_write_string("D");
		morse_d();
		continue;
	}
	else
	{
		lcd_write_string("E");
		morse_e();
		continue;
	}
	while(1);
	}

	// Inside each condition, call the functions from MorseCode.h. Fill functions in MorseCode.h

	// Write to LCD using function lcd_write_string() in side the condition as well

	//
}
