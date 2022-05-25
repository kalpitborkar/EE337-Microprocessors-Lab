ORG 0H
LJMP MAIN
ORG 100H
MAIN:
CALL SEARCH
HERE: SJMP HERE
ORG 130H


SEARCH:
MOV R0, 30H // Store the starting address in R0
MOV R1, 31H, // Store the value of 'N' in R1

LOOP:
// Store N/2 + starting address in R2
// First store N/2 in accumulator
MOV A, R1
MOV B, #02H
DIV AB // Now accumulator contains N/2


// Set R2 to (starting point + N/2)
ADD A, R0
MOV R2, A


CJNE @R2, 32H, NOTEQUAL // Compare the middle element with the given element

// The numbers are equal -
SJMP FOUND

JC GREATER // if C = 1, @R2 > Given number

// @R2 < Given number
// set N = (N+1)/2
MOV A, R1
ADD A, #01H
MOV B, #02H
DIV AB
MOV R1, A
// set starting point (R1) to R2
MOV R1, R2
SJMP LOOP

GREATER:
// @R2 > Given number
// N = N/2 (starting point remains same)
MOV A, R1
MOV B, #02H
DIV AB
MOV R1, A
SJMP LOOP


FOUND: 
MOV 33H, R2 // Store the address of the found element in 33H
RET
END