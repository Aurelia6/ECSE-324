	.text
	.global _start

_start: 	LDR R4, =RESULTm	// The result location
			LDR R2, [R4, #4]	// R2 holds number of elements in the list
			ADD R3, R4, #8		// R3 holds the first number in the list
			LDR R0, [R3]		// R0 holds the first number in the list
			PUSH {R4}			// Push the value of R4 in the stack
			BL MIN				// Go to MIN using a subroutine
			STR R0, [R4]		// Store R0 in R4 which will hold the minimum value at the end

END: 		B END

MIN:		SUBS R2, R2, #1		// Decrement loop counter
			BEQ END_MIN			// End loop if counter has reached 0
			ADD R3, R3, #4		// R3 points to the next number in the list
			LDR R1, [R3]		// R1 holds the number pointed by R3
			CMP R1, R0			// Compare the current min and the number in R1 to get the minimum
			BGE MIN				// If R0 < R1, branch back to the loop MIN
			MOV R0, R1			// If R1 < R0, R0 will get a new minimum value
			B MIN				// Branch back to the loop MIN
	
END_MIN:	POP {R4}			// Pop the final result out of the stack in R4
			BX LR				// Return to the calling code

RESULTm:	.word 0				// Memory assigned for the minimum result
N: 			.word 3				// Number of entries in the list
NUMBERS:	.WORD -12, 2, 8		// List of numbers 


		
