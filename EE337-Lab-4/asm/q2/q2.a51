ORG 0H
LJMP MAIN
ORG 100H
MAIN:

// First load the data
MOV 50H, #25H
MOV 51H, #06H
MOV 52H, #19H
MOV 53H, #83H
HERE:
CALL DISPLAY_DATE
SJMP HERE
ORG 130H
	

DISPLAY_DATE:



MOV A, 50H // Load the first byte on accumulator
CALL DISPLAY
CALL DISPLAY_SLASH
MOV A, 51H // Load the second byte on accumulator
CALL DISPLAY
CALL DISPLAY_SLASH
MOV A, 52H // Load the second byte on accumulator
CALL DISPLAY
MOV A, 53H // Load the second byte on accumulator
CALL DISPLAY
CALL DISPLAY_SLASH

RET

	
	
DISPLAY: // Displays the content of accumulator on LEDs for 200ms

// First the upper nibble of accumulator
MOV P1, A
CALL delay_200ms

// Next the lower nibble of accumulator
SWAP A // Swap the upper and lower nibbles
MOV P1, A
CALL delay_200ms
RET

DISPLAY_SLASH:
MOV A, #0FFH
MOV P1, A
CALL delay_200ms
RET
	
	
delay_200ms:
MOV R1, #0C8H // hexadecimal for 200
LOOP:
CALL delay_1ms
DJNZ R1, LOOP
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



END