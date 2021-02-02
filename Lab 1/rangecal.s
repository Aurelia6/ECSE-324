		.text
		.global _start

_start:
			LDR R4, =RESULTM	// R4 points to the result location of the max
			LDR R5, =RESULTm	// R5 points to the result location of the min
			LDR R7, =Range		// R7 points to the result location of the range
			LDR R2, [R4, #4]	// R2 holds the number of elements in the list
			ADD R3, R4, #8 		// R3 points to the first number 
			LDR R0, [R3] 		// R0 holds the first number in the list
			LDR R6, [R3]		// R6 holds the first number in the list

LOOP:		SUBS R2, R2, #1 	// decrement the loop counter
			BEQ DONE      		// end loop if counter has reached 0
			ADD R3, R3, #4  	// R3 points to next number in the list
			LDR R1, [R3] 		// R1 holds the next number in the list
			CMP R0, R1			// check if it is greater than the maximum
			BGE LOOP_2 			// if no, branch back to the loop_2, the minimum one
			MOV R0, R1			// if yes, update the current max
			B LOOP				// branch back to the loop 	

LOOP_2: 	CMP R1, R6			// check if the minimum is greater than the current number
			BGE LOOP 			// if no, branch back to the loop
			MOV R6, R1			// if yes, update the current min
			B LOOP				// branch back to the loop

DONE:		STR R0, [R4]		// store the maximum result to the memory location
			STR R6, [R5]		// store the minimum result to the memory location
			SUB R0, R0, R6		// calculate the range between the maximum and the minimu
			STR R0, [R7]		// store the range value
			

END:		B END 				// infinite loop!

RESULTM: 	.word 	0			// memory assigned for maximum result location

N:			.word 	7			// number of entries in the list
NUMBERS:	.word 	89, 73, 84, -91	// number of entries in the list
			.word 	87, 77, 94

RESULTm: 	.word 	1			// memory assigned for minimum result location
Range: 		.word 	2			// memory assigned for range result location
