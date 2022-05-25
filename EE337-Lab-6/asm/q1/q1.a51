ORG 0H
LJMP MAIN

ORG 100H
MAIN:
MOV 30H, #04
MOV P1, #00H
REPEAT:
CALL BLINK_LED
SJMP REPEAT


TIMER_16_BIT_50000:
MOV TMOD, #01H // Set Timer0 in Mode 1 (16-bit mode)
MOV TH0, #3CH // Set 'N' = 50000
MOV TL0, #0AFH
//MOV IE, #82H // Enable the global interrupt and the timer0 interrupt
CLR TF0 // Clear timer0 zero flag
SETB TR0 // Start timer0
LOOP1: JNB TF0, LOOP1 // Loop while TF0 is 0
RET

DELAY_1S:
// Execute the TIMER_16_BIT_50000 subroutine 40 times
MOV R0, #40 // Store 40 in R0
LOOP2: CALL TIMER_16_BIT_50000
DJNZ R0, LOOP2
RET

CALL_DELAY_1S_N_TIMES:
MOV R1, 30H // Store the value of 'N' in R1
LOOP3: CALL DELAY_1S
DJNZ R1, LOOP3
RET


BLINK_LED:
CPL P1.4
CPL P1.5
CPL P1.6
CPL P1.7
CALL CALL_DELAY_1S_N_TIMES
RET




END