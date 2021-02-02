	.text	
	.global _start

_start:		LDR R4, =RESULT
			MOV R0, #5		// Move in R0 the factorial number we want to calculate, here it is 5
			BL FACT			// Branch link to FACT, i.e. use a subroutine
			STR R0, [R4]	// Store the result in R4 at the end

END:		B END			

FACT:		PUSH {R1, LR}	// Stack the current value of R1 and the Link register
			CMP R0, #1		// Check if the value in R0 is different than 1
			BEQ FACT_END	// If R0 = 1, Branch to FACT_END
			MOV R1, R0		// Change R1 to contain the value of R0
			SUB R0, R0, #1	// Substract 1 to the value of R0
			BL FACT			// Branch link to FACT

			MUL R0, R1, R0	// Multiply R1 by R0 and store it in R0

FACT_END:	POP {R1, LR}	// Pop the values from the stack and the Link register and then multyply one by one each number with the current result
			BX LR

RESULT: 	.word 0
