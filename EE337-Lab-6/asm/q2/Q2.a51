LCD_data equ P2    ;LCD Data port
LCD_rs   equ P0.0  ;LCD Register Select
LCD_rw   equ P0.1  ;LCD Read/Write
LCD_en   equ P0.2  ;LCD Enable

ORG 0000H
MOV 70H, #0F3H
MOV 71H, #0B1H
ljmp start

//------DELAY FUNCTIONS---------------------------

TIMER_16_BIT_50000:
MOV TMOD, #01H // Set Timer0 in Mode 1 (16-bit mode)
MOV TH0, #3CH // Set 'N' = 50000
MOV TL0, #0AFH
//MOV IE, #82H // Enable the global interrupt and the timer0 interrupt
CLR TF0 // Clear timer0 zero flag
SETB TR0 // Start timer0
LOOP21: JNB TF0, LOOP21 // Loop while TF0 is 0
RET

DELAY_1S:
// Execute the TIMER_16_BIT_50000 subroutine 40 times
MOV R0, #40 // Store 30 in R0
LOOP22: CALL TIMER_16_BIT_50000
DJNZ R0, LOOP22
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

//---------- 4-bit number to binary ASCII --------------------
// The number is stored in lower nibble of 76H

BINARY_ASCII:
MOV A, 76H
ANL A,#0FH
//eg A = 0000 0111

MOV 72H, #30H
MOV 73H, #30H
MOV 74H, #30H
MOV 75H, #30H
RRC A 
JC LAST_BIT_IS_1
SECOND_LAST_BIT:
RRC A
JC SECOND_LAST_BIT_IS_1
THIRD_LAST_BIT:
RRC A
JC THIRD_LAST_BIT_IS_1
FOURTH_LAST_BIT:
RRC A
JC FOURTH_LAST_BIT_IS_1

RET



// THE ASCII VALUES ARE STORED IN 72H, 73H, 74H, 75H
LAST_BIT_IS_1:
MOV 75H, #31H
SJMP SECOND_LAST_BIT
SECOND_LAST_BIT_IS_1:
MOV 74H, #31H
SJMP THIRD_LAST_BIT
THIRD_LAST_BIT_IS_1:
MOV 73H, #31H
SJMP FOURTH_LAST_BIT
FOURTH_LAST_BIT_IS_1:
MOV 72H, #31H

RET


//--------------  END of 4-bit number to binary ASCII ----------------------



org 200h
start:

	  mov 70H, #23H
	  mov 71H, #45H
      mov P2,#00h
      mov P1,#00h
	  ;initial delay for lcd power up

	;here1:setb p1.0
      	  acall delay_1ms
	;clr p1.0
	  acall delay_1ms
	;sjmp here1


	  acall lcd_init      ;initialise LCD
	  
	  //-----------------LEVEL 1----------------
	  
	  mov a, 70H // Load level 1 and level 2 into accumulator
	  swap a // level 1 is now in upper nibble
	  mov P1, a // level 1 is now in p1.7-p1.4
	  

	  mov a,#80h		 ;Put cursor on first row,0 column
	  acall lcd_command	 ;send command to LCD

	  mov   dptr,#my_string1   ;Load DPTR with sring1 Addr, my_string1 = "     Level 1    "
	  acall lcd_sendstring	   ;call text strings sending routine


	  mov a,#0C0h		  ;Put cursor on second row,0 column
	  acall lcd_command
	  mov   dptr,#my_string2 //my_string2 = "Value: "
	  acall lcd_sendstring
	  
	  // Convert 8-bit to ASCII (level 1)
	  mov 76H, 70H
	  acall BINARY_ASCII // the ASCII conversion of level 1 is 72H - 75H
	  mov a, 72H
	  acall  lcd_senddata
	  mov a, 73H
	  acall  lcd_senddata
	  mov a, 74H
	  acall  lcd_senddata
	  mov a, 75H
	  acall  lcd_senddata
	  
	  acall DELAY_1S
	  

	  
	  
	  //----------------------LEVEL 2-------------------
	  
	  mov a, 70H // Load level 1 and level 2 into accumulator
	  // level 2 is now in upper nibble
	  mov P1, a // level 2 is now in p1.7-p1.4
	  
	

	  mov a,#80h		 ;Put cursor on first row,0 column
	  acall lcd_command	 ;send command to LCD

	  mov   dptr,#my_string3   ;Load DPTR with sring1 Addr/ my_string3 = "     Level 2    "
	  acall lcd_sendstring	   ;call text strings sending routine


	  mov a,#0C0h		  ;Put cursor on second row,0 column
	  acall lcd_command
	  mov   dptr,#my_string2 //my_string2 = "Value: "
	  acall lcd_sendstring
	  
	  // Convert 8-bit to ASCII (level 2)
	  mov a, 70H
	  swap a
	  mov 76H, a
	  acall BINARY_ASCII // the ASCII conversion of level 2 is 72H - 75H
	  mov a, 72H
	  acall  lcd_senddata
	  mov a, 73H
	  acall  lcd_senddata
	  mov a, 74H
	  acall  lcd_senddata
	  mov a, 75H
	  acall  lcd_senddata
	  
	  acall DELAY_1S
	  
	  
	  //----------------------LEVEL 3-------------------
	  
	  mov a, 71H // Load level 3 and level 4 into accumulator
	  swap a // level 3 is now in upper nibble
	  mov P1, a // level 3 is now in p1.7-p1.4
	  
	

	  mov a,#80h		 ;Put cursor on first row,0 column
	  acall lcd_command	 ;send command to LCD

	  mov   dptr,#my_string4   ;Load DPTR with sring1 Addr, my_string4 = "     Level 3    "
	  acall lcd_sendstring	   ;call text strings sending routine


	  mov a,#0C0h		  ;Put cursor on second row,0 column
	  acall lcd_command
	  mov   dptr,#my_string2
	  acall lcd_sendstring
	  
	  // Convert 8-bit to ASCII (level 3)
	  mov 76H, 71H
	  acall BINARY_ASCII // the ASCII conversion of level 1 is 72H - 75H
	  mov a, 72H
	  acall  lcd_senddata
	  mov a, 73H
	  acall  lcd_senddata
	  mov a, 74H
	  acall  lcd_senddata
	  mov a, 75H
	  acall  lcd_senddata
	  
	  acall DELAY_1S
	  
	  //----------------------LEVEL 4-------------------
	  
	  mov a, 71H // Load level 3 and level 4 into accumulator
	  // level 4 is now in upper nibble
	  mov P1, a // level 4 is now in p1.7-p1.4
	  
	

	  mov a,#80h		 ;Put cursor on first row,0 column
	  acall lcd_command	 ;send command to LCD

	  mov   dptr,#my_string5   ;Load DPTR with sring1 Addr, my_string5 = "     Level 4    "
	  acall lcd_sendstring	   ;call text strings sending routine


	  mov a,#0C0h		  ;Put cursor on second row,0 column
	  acall lcd_command
	  mov   dptr,#my_string2
	  acall lcd_sendstring
	  
	  // Convert 8-bit to ASCII (level 4)
	  mov a, 71H
	  swap a
	  mov 76H, a
	  acall BINARY_ASCII // the ASCII conversion of level 2 is 72H - 75H
	  mov a, 72H
	  acall  lcd_senddata
	  mov a, 73H
	  acall  lcd_senddata
	  mov a, 74H
	  acall  lcd_senddata
	  mov a, 75H
	  acall  lcd_senddata
	  
	  acall DELAY_1S
	  
	  
	  

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
         DB   "     Level 1    ", 00H
my_string2:
		 DB   "Value: ", 00H
my_string3:
		 DB   "     Level 2    ", 00H
my_string4:
		 DB   "     Level 3    ", 00H
my_string5:
		 DB   "     Level 4    ", 00H		 
my_string8:
		 DB   "  ", 00H	


end


























