LCD_data equ P2    ;LCD Data port
LCD_rs   equ P0.0  ;LCD Register Select
LCD_rw   equ P0.1  ;LCD Read/Write
LCD_en   equ P0.2  ;LCD Enable

ORG 0000H
ljmp start

//------DELAY FUNCTIONS---------------------------
delay_1s:
MOV R2, #005H
LOOP1_DELAY:
CALL delay_200ms
DJNZ R2, LOOP1_DELAY
RET
	
	
delay_200ms:
MOV R1, #0C8H // hexadecimal for 200
LOOP_DELAY:
CALL delay_1ms
DJNZ R1, LOOP_DELAY
RET


delay_1ms:
push 00h
mov r0, #4
h2: acall delay_250us
djnz r0, h2
pop 00h
ret

delay_250us:
push 00h
mov r0, #244
h1: djnz r0, h1
pop 00h
ret

//---------- END OF DELAY FUCNTIONS ---------------------

//---------- 8-bit to ASCII FUNCTION --------------------

EIGHT_BIT_TO_ASCII:	
MOV A, 30H // Load the 8-bit number in accumulator
ANL A, #0FH // Store the lower nibble in accumulator
CALL LOWER_NIBBLE_TO_ASCII
MOV 61H, A // Store the ASCII of lower nibble

// Do the same for the upper nibble
MOV A, 30H // Load the 8-bit number in accumulator
SWAP A // Swap the upper and lower nibbles
ANL A, #0FH // Store the upper nibble in accumulator
CALL LOWER_NIBBLE_TO_ASCII
MOV 60H, A //Store the ASCII of upper nibble
RET

LOWER_NIBBLE_TO_ASCII:


CJNE A, #0AH, NOT_EQUAL // Compare the number with #0AH

NOT_EQUAL:
JNC GREATER // If the number is greater than #0AH go to GREATER
ADD A, #30H // If the number is less than #0AH, add #30H
RET

GREATER:
ADD A, #37H // If the number is greater then add #37H
RET

//-------------- END OF 8-bit to ASCII FUNCTION ----------------------



org 200h
start:
      mov P2,#00h
      mov P1,#00h
	  ;initial delay for lcd power up

	;here1:setb p1.0
      	  acall delay_1ms
	;clr p1.0
	  acall delay_1ms
	;sjmp here1


	  acall lcd_init      ;initialise LCD
	  
	  //-----------------STATE 0----------------
	  
	  mov P1, #0FFH // Glow all 4 LEDs
	

	  mov a,#80h		 ;Put cursor on first row,0 column
	  acall lcd_command	 ;send command to LCD

	  mov   dptr,#my_string1   ;Load DPTR with sring1 Addr
	  acall lcd_sendstring	   ;call text strings sending routine


	  mov a,#0C0h		  ;Put cursor on second row,0 column
	  acall lcd_command
	  acall delay
	  mov   dptr,#my_string2
	  acall lcd_sendstring
	  
	  acall delay_1s

	  
	  //----------------------STATE 1-------------------
	  
	  mov a,#80h		 ;Put cursor on first row,0 column
	  acall lcd_command	 ;send command to LCD

	  mov   dptr,#my_string6   ;Load DPTR with sring1 Addr, string6 = "READING INPUTS"
	  acall lcd_sendstring	   ;call text strings sending routine


	  mov a,#0C0h		  ;Put cursor on second row,0 column
	  acall lcd_command
	  acall delay
	  mov   dptr,#my_string2 // string2 = "EE337-2022"
	  acall lcd_sendstring
	  
	  
	  mov P1, #8FH // Set LED 1 to glow, and take input from port P1
	  acall delay_1s
	  acall delay_1s
	  mov A, P1 // Store the input in accumulator
	  swap A // Now the input is in the upper nibble of the accumulator
	  anl A, #0F0H // make the lower nibble 0000
	  mov 33H, A //N1H 0000
	  
	  
	  //----------------------STATE 2-------------------
	  
	  mov P1, #4FH
	  acall delay_1s
	  acall delay_1s
	  mov A, P1 // Store the input in accumulator
	  anl A, #0FH // make the upper nibble 0000
	  mov 34H, A //0000 N1L
	  
	  add A, 33H // Add the upper nibble from STATE 1 to the lower nibble from STATE 2
	  mov 30H, A // Store complete N1 in 30H
	  
	  //----------------------STATE 3-------------------
	  
	  mov P1, #2FH
	  acall delay_1s
	  acall delay_1s
	  mov A, P1
	  swap A // Now the input is in the upper nibble of the accumulator
	  anl A, #0F0H // make the lower nibble 0000
	  mov 35H, A //N2H 0000
	  
	  //----------------------STATE 4-------------------
	  
	  mov P1, #1FH
	  acall delay_1s
	  acall delay_1s
	  mov A, P1
	  anl A, #0FH // make the upper nibble 0000
	  mov 36H, A //0000 N2L
	  
	  add A, 35H
	  mov 31H, A // Store complete N2 in 31H
	  
	  
	  
	  //----------------------STATE 5-------------------
	  mov P1, #00H

	  
	  mov a,#80h		 ;Put cursor on first row,0 column
	  acall lcd_command	 ;send command to LCD
	  
	  mov   dptr,#my_string3   ;Load DPTR with sring1 Addr, string3 = "COMPUTING RESULT"
	  acall lcd_sendstring	   ;call text strings sending routine
	  
	  
	  acall EIGHT_BIT_TO_ASCII // the ASCII conversion of N1 is now stored in 60H and 61H
	  mov 62H, 60H // N1 is now stored in 62H and 63H
	  mov 63H, 61H
	  mov 66H, 60H // also store N1 ASCII in 66H and 67H for future reference
	  mov 67H, 61H
	  
	  mov 30H, 31H // Load N2 in 30H
	  
	  acall EIGHT_BIT_TO_ASCII // the ASCII conversion of N2 is now stored in 60H and 61H
	  mov 68H, 60H // also store N2 ASCII in 68H and 69H for future reference
	  mov 69H, 61H
	  
	  mov a,#0C0h		  ;Put cursor on second row,0 column
	  acall lcd_command
	  
	  mov   dptr,#my_string4 //string4 = "NUM1:"
	  acall lcd_sendstring
	  
	  
	  //Display N1
	  mov a, 62H
	  acall  lcd_senddata
	  mov a, 63H
	  acall  lcd_senddata
	  
	  mov   dptr,#my_string5 //string5 = ", NUM2:"
	  acall lcd_sendstring
	  
	  
	  //Display N2
	  mov a, 60H
	  acall  lcd_senddata
	  mov a, 61H
	  acall  lcd_senddata
	  
	  acall delay_1s
	  acall delay_1s
	  
	  // Multiply the two numbers
	  mov A, 30H
	  mov B, 31H
	  mul AB
	  mov 50H, A
	  mov 51H, B
	  
	  //---------- STATE 6 -------------------

	  
	  mov 30H, 50H
	  acall EIGHT_BIT_TO_ASCII // the ASCII conversion of the num stored in 50H is now in 60H and 61H
	  
	  mov 62H, 60H // moved to 62H and 63H
	  mov 63H, 61H
	  
	  mov 30H, 51H
	  acall EIGHT_BIT_TO_ASCII // the ASCII conversion of the num stored in 51H is now in 60H and 61H
	  
	  mov a,#80h		 ;Put cursor on first row,0 column
	  acall lcd_command	 ;send command to LCD
	  
	  mov   dptr,#my_string7   ;Load DPTR with sring1 Addr
	  acall lcd_sendstring	   ;call text strings sending routine
	  
	  mov a,#08Bh		  ;Put cursor on second row,0 column
	  acall lcd_command
	  
	  mov a, 60H
	  acall  lcd_senddata
	  mov a, 61H
	  acall  lcd_senddata
	  
	  mov a, 62H
	  acall  lcd_senddata
	  mov a, 63H
	  acall  lcd_senddata
	  
	  mov a,#0C0h		  ;Put cursor on second row,0 column
	  acall lcd_command
	  
	  mov   dptr,#my_string4
	  acall lcd_sendstring
	  
	  mov a, 66H
	  acall  lcd_senddata
	  mov a, 67H
	  acall  lcd_senddata
	  
	  mov   dptr,#my_string5
	  acall lcd_sendstring
	  
	  mov a, 68H
	  acall  lcd_senddata
	  mov a, 69H
	  acall  lcd_senddata
	  
	  
	  
	  
	  
	  
	  //mov   dptr,#my_string8
	  //acall lcd_sendstring
	  
	  
	  

here: sjmp here				//stay here 

;------------------------LCD Initialisation routine----------------------------------------------------
lcd_init:
         mov   LCD_data,#38H  ;Function set: 2 Line, 8-bit, 5x7 dots
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
	     acall delay

         mov   LCD_data,#0CH  ;Display on, Curson off
         clr   LCD_rs         ;Selected instruction register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
         
		 acall delay_1ms
         mov   LCD_data,#01H  ;Clear LCD
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
         
		 acall delay

         mov   LCD_data,#06H  ;Entry mode, auto increment with no shift
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en

		 acall delay
         
         ret                  ;Return from routine

;-----------------------command sending routine-------------------------------------
 lcd_command:
         mov   LCD_data,A     ;Move the command to LCD port
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
		 acall delay
    
         ret  
;-----------------------data sending routine-------------------------------------		     
 lcd_senddata:
         mov   LCD_data,A     ;Move the command to LCD port
         setb  LCD_rs         ;Selected data register
         clr   LCD_rw         ;We are writing
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
         acall delay
		 acall delay
         ret                  ;Return from busy routine

;-----------------------text strings sending routine-------------------------------------
lcd_sendstring:
	push 0e0h
	lcd_sendstring_loop:
	 	 clr   a                 ;clear Accumulator for any previous data
	         movc  a,@a+dptr         ;load the first character in accumulator
	         jz    exit              ;go to exit if zero
	         acall lcd_senddata      ;send first char
	         inc   dptr              ;increment data pointer
	         sjmp  LCD_sendstring_loop    ;jump back to send the next character
exit:    pop 0e0h
         ret                     ;End of routine 

;----------------------delay routine-----------------------------------------------------
delay:	 push 0
	 push 1
         mov r0,#1
loop2:	 mov r1,#255
	 loop1:	 djnz r1, loop1
	 djnz r0, loop2
	 pop 1
	 pop 0 
	 ret

;------------- ROM text strings---------------------------------------------------------------
org 450h
my_string1:
         DB   "  ENTER INPUTS  ", 00H
my_string2:
		 DB   "   EE337-2022   ", 00H
my_string3:
		 DB   "COMPUTING RESULT", 00H
my_string4:
		 DB   "NUM1:", 00H
my_string5:
		 DB   ", NUM2:", 00H
my_string6:
		 DB   " READING INPUTS ", 00H
my_string7:
		 DB   "  RESULT =      ", 00H			 
my_string8:
		 DB   "  ", 00H	


end

