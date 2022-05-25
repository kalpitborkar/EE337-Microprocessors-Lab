LCD_data equ P2    ;LCD Data port
LCD_rs   equ P0.0  ;LCD Register Select
LCD_rw   equ P0.1  ;LCD Read/Write
LCD_en   equ P0.2  ;LCD Enable

ORG 0000H
ljmp start

ORG 000BH
inc R4
RETI

org 200h
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
	  
	  //-----------------STAGE 1----------------
	  
	  

	  

	  mov a,#80h		 ;Put cursor on first row,0 column
	  acall lcd_command	 ;send command to LCD

	  mov   dptr,#my_string1   ;Load DPTR with sring1 Addr, my_string1 = "Toggle SW1"
	  acall lcd_sendstring	   ;call text strings sending routine


	  mov a,#0C0h		  ;Put cursor on second row,0 column
	  acall lcd_command
	  mov   dptr,#my_string2 //my_string2 = "  If LED glows  "
	  acall lcd_sendstring
	  
	  mov TMOD, #01H // Timer0 in Mode 1
	  mov TH0, #00H
	  mov TL0, #00H
	  mov IE, #82H // Enable timer0 interrupt and the global interrupt
	  mov R4, #00H // Tracks the number of times timer0 has overflown
	  
	  acall delay_1s
	  acall delay_1s
	  
	  
	  
	  mov p1, #11H // Glow LED P1.4 and take SW1 as input
	  //setb P1.4
	  //setb P1.0
	  setb TR0 // Start timer
	  
	  //time_count: sjmp time_count // wait for interrupt
	  
	  

	  
	  
	  //----------------------STAGE 2-------------------
	  
	  CHECKSW1: jnb P1.0, CHECKSW1 // Check for SW1
	  clr TR0 // Stop timer0
	  
	  mov p1, #01H // Turn off LED P1.4
	  
	  
	  //----------------------STAGE 3-------------------
	  
	  
	  
	

	  mov a,#80h		 ;Put cursor on first row,0 column
	  acall lcd_command	 ;send command to LCD

	  mov   dptr,#my_string3   ;Load DPTR with sring1 Addr, my_string3 = "  Reaction Time "
	  acall lcd_sendstring	   ;call text strings sending routine


	  mov a,#0C0h		  ;Put cursor on second row,0 column
	  acall lcd_command
	  mov   dptr,#my_string4 //my_string4 = "Count is "
	  acall lcd_sendstring
	  
	  mov 30H, R4 // Load the first two digits in 30H for conversion to ASCII
	  acall EIGHT_BIT_TO_ASCII
	  //Store the ASCII conversion of the first two digits (times overflown) in 40H and 41H
	  mov 40H, 60H
	  mov 41H, 61H
	  
	  mov 30H, TH0 // Load the next two digits in 30H for conversion to ASCII
	  acall EIGHT_BIT_TO_ASCII
	  //Store the ASCII conversion of the first two digits (times overflown) in 42H and 43H
	  mov 42H, 60H
	  mov 43H, 61H
	  
	  mov 30H, TL0 // Load the next two digits in 30H for conversion to ASCII
	  acall EIGHT_BIT_TO_ASCII
	  //Store the ASCII conversion of the first two digits (times overflown) in 44H and 45H
	  mov 44H, 60H
	  mov 45H, 61H
	  
	  //Display the first two bits
	  mov a, 40H
	  acall  lcd_senddata
	  mov a, 41H
	  acall  lcd_senddata
	  
	  // Display " "
	  mov   dptr,#my_string5   //my_string5 = " "
	  acall lcd_sendstring	   ;call text strings sending routine


	  //Display the next two bits
	  mov a, 42H
	  acall  lcd_senddata
	  mov a, 43H
	  acall  lcd_senddata
	  
	  //Display the next two bits
	  mov a, 44H
	  acall  lcd_senddata
	  mov a, 45H
	  acall  lcd_senddata
	  
	  
	  acall delay_1s
	  acall delay_1s
	  acall delay_1s
	  acall delay_1s
	  acall delay_1s
	  
	  
	  
	  
	  

ljmp start			//loop

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
         DB   "   Toggle SW1   ", 00H
my_string2:
		 DB   "  If LED glows  ", 00H
my_string3:
		 DB   "  Reaction Time ", 00H
my_string4:
		 DB   " Count is ", 00H 
my_string5:
		 DB   " ", 00H	


end


























