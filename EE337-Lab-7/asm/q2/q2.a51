LCD_data equ P2    ;LCD Data port
LCD_rs   equ P0.0  ;LCD Register Select
LCD_rw   equ P0.1  ;LCD Read/Write
LCD_en   equ P0.2  ;LCD Enable

ORG 0000H
MOV TMOD, #11H // Set timer0 and timer1 in mode 1
ljmp start

ORG 000BH
LJMP NoteOrderInterrupt
RETI

org 200h
//------DELAY FUNCTIONS---------------------------

TIMER_16_BIT_50000:
//MOV TMOD, #11H // Set Timer0 in Mode 1 (16-bit mode)
MOV TH1, #3CH // Set 'N' = 50000
MOV TL1, #0AFH
//MOV IE, #82H // Enable the global interrupt and the timer0 interrupt
CLR TF1 // Clear timer0 zero flag
SETB TR1 // Start timer0
LOOP21: JNB TF1, LOOP21 // Loop while TF1 is 0
RET

DELAY_500MS:
// Execute the TIMER_16_BIT_50000 subroutine 20 times
MOV R0, #20 // Store 30 in R0
LOOP22: CALL TIMER_16_BIT_50000
DJNZ R0, LOOP22
RET


DELAY_750MS:
// Execute the TIMER_16_BIT_50000 subroutine 30 times
MOV R0, #30 // Store 30 in R0
LOOP23: CALL TIMER_16_BIT_50000
DJNZ R0, LOOP23
RET


DELAY_1S:
// Execute the TIMER_16_BIT_50000 subroutine 40 times
MOV R0, #40 // Store 30 in R0
LOOP24: CALL TIMER_16_BIT_50000
DJNZ R0, LOOP24
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

//----------------- NoteOrderInterrupt function ---------------------

NoteOrderInterrupt:
CPL P0.7
MOV TH0, R6
MOV TL0, R7
CLR TF0
RETI

//----------------- END OF NoteOrderInterrupt function ---------------------

//------------------ Wave generator with given time and frequency ---------------------------
NoteOrder1:

MOV TH0, #0EEH
MOV TL0, #3FH
MOV R6, TH0
MOV R7, TL0
MOV IE, #82H
SETB TR0
acall DELAY_750MS
CLR TR0
CLR TF0
RET


NoteOrder2:
//MOV TMOD, #11H // Set timer0 and timer1 in mode 1
MOV TH0, #0F0H
MOV TL0, #2FH
MOV R6, TH0
MOV R7, TL0
MOV IE, #82H
SETB TR0 
acall DELAY_750MS
CLR TR0
RET

NoteOrder3:
//MOV TMOD, #11H // Set timer0 and timer1 in mode 1
MOV TH0, #0F2H
MOV TL0, #0B7H
MOV R6, TH0
MOV R7, TL0
MOV IE, #82H
SETB TR0
acall DELAY_750MS
CLR TR0
RET

NoteOrder4:
//MOV TMOD, #11H // Set timer0 and timer1 in mode 1
MOV TH0, #0F0H
MOV TL0, #2FH
MOV R6, TH0
MOV R7, TL0
MOV IE, #82H
SETB TR0
acall DELAY_750MS
CLR TR0
RET


NoteOrder5:
//MOV TMOD, #11H // Set timer0 and timer1 in mode 1
MOV TH0, #0F5H
MOV TL0, #71H
MOV R6, TH0
MOV R7, TL0
MOV IE, #82H
SETB TR0 
acall DELAY_1S
CLR TR0
RET
RET


NoteOrder6:


CLR P0.7 
acall DELAY_500MS
RET

NoteOrder7:
//MOV TMOD, #11H // Set timer0 and timer1 in mode 1
MOV TH0, #0F5H
MOV TL0, #71H
MOV R6, TH0
MOV R7, TL0
MOV IE, #82H
SETB TR0
acall DELAY_1S
CLR TR0
RET

NoteOrder8:
//MOV TMOD, #11H // Set timer0 and timer1 in mode 1
MOV TH0, #0F4H
MOV TL0, #2AH
MOV R6, TH0
MOV R7, TL0
MOV IE, #82H
SETB TR0 
acall DELAY_1S
CLR TR0
RET


//---------- END OF Wave generator function ---------------------


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
	  

	  
	  

	  

	  mov a,#80h		 ;Put cursor on first row,0 column
	  acall lcd_command	 ;send command to LCD

	  mov   dptr,#my_string1   ;Load DPTR with sring1 Addr, my_string1 = "  ROLLING TIME  "
	  acall lcd_sendstring	   ;call text strings sending routine
	  
	  acall NoteOrder1
	  acall NoteOrder2
	  acall NoteOrder3
	  acall NoteOrder4
	  acall NoteOrder5
	  acall NoteOrder6
	  acall NoteOrder7
	  acall NoteOrder8
	  
	  

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
         DB   "  ROLLING TIME  ", 00H
my_string2:
		 DB   "If LED glows ", 00H
my_string3:
		 DB   "Reaction Time   ", 00H
my_string4:
		 DB   " Count is   ", 00H
my_string5:
		 DB   "     Level 4    ", 00H		 
my_string8:
		 DB   "  ", 00H	


end


























