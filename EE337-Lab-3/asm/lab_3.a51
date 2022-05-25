ORG 0H
LJMP MAIN
ORG 100H
MAIN:
CALL SEARCH
HERE: SJMP HERE
ORG 130H


SEARCH:
MOV R0, 30H // Store the starting address in R0
MOV R2, 31H // Store the value of 'N' in R2
// R1 will carry the address of the "middle" element

LOOP:
// Store (N/2 + starting address) in R1
// First store N/2 in accumulator
MOV A, R2 // Store N in accumulator
MOV B, #02H // Divide by 2
DIV AB // Now accumulator contains N/2

// If N = 0, go to NOTFOUND
JZ NOTFOUND


// Set R1 to (starting point + N/2)
ADD A, R0 // Add N/2 to the starting address
MOV R1, A // Store (N/2 + starting address in R1)

MOV A, @R1 // Move the "middle" element in accumulaator
CJNE A, 32H, NOTEQUAL // Compare the middle element with the given element

// The numbers are equal -
SJMP FOUND // if the numbers are equal, the number is found.

NOTEQUAL:

JNC GREATER // if C = 0, @R1 > Given number go to GREATER

// Case 1 : @R1 < Given number
// set N = (N+1)/2
MOV A, R2
ADD A, #01H
MOV B, #02H
DIV AB
MOV R2, A
// set starting point (R0) to the middle element (R1)
MOV A, R1
MOV R0, A
SJMP LOOP

GREATER:
// @R1 > Given number
// N = N/2 (starting point remains same)
MOV A, R2
MOV B, #02H
DIV AB
MOV R2, A
SJMP LOOP

NOTFOUND:
MOV 33H, #0EH // Store #0EH in 33H, since element not found
RET



FOUND: 
MOV 33H, R1 // Store the address of the found element in 33H
RET
END