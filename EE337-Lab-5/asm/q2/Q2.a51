ORG 0H
LJMP MAIN
ORG 100H
MAIN:
CALL EIGHT_BIT_TO_ASCII
HERE: SJMP HERE
ORG 150H

	
EIGHT_BIT_TO_ASCII:	
MOV A, 30H // Load the 8-bit number in accumulator
ANL A, #0FH // Store the lower nibble in accumulator
CALL LOWER_NIBBLE_TO_ASCII
MOV 61H, A

// Do the same for the upper nibble
MOV A, 30H // Load the 8-bit number in accumulator
SWAP A // Swap the upper and lower nibbles
ANL A, #0FH // Store the upper nibble in accumulator
CALL LOWER_NIBBLE_TO_ASCII
MOV 60H, A
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

END