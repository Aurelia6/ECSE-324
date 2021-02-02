		.text
		.global _start

_start:		LDR R4, =RESULTM	// R4 points to the result location of the max
			LDR R5, =RESULTm	// R5 points to the result location of the min
			ADD R3, R4, #8 		// R3 points to the first number 

			LDR R1, [R3]		// R1 will contain the minimum values
			LDR R2, [R3]		// R2 will contain the maximum values


			LDR R9, [R3]		// R9 will hold the sum of the first number in the list and one of the others
			LDR R10, [R3]		
			LDR R11, [R3]		
			LDR R12, [R3]		

			LDR R0, [R3] 		// R0 holds the first number of the list
			LDR R6, [R3, #4]	// R6 holds the second number of the list
			LDR R7,	[R3, #8]	// R7 holds the third number of the list
			LDR R8, [R3, #12]	// R8 holds the fourth number of the list


COMPARISON: ADD R9, R0,R6		// CASE 1: R9 holds X1 + X2
			ADD R10, R7,R8		// R10 holds X3 + X4
			MUL R10, R10, R9	// R10 holds of R10 * R9
			
			ADD R9, R0,R7		// CASE 2: R9 holds X1 + X3
			ADD R11, R6, R8		// R11 holds X2 + X4
			MUL R11, R9,R11		// R11 holds R11 * R9
			
			MOV R1, R10			// R1 holds R10
			MOV R2, R11			// R2 holds R11

			CMP R11, R10		// we compare R11 and R10
			BGE A				// if no, branch to A
			MOV R1, R11			// we change the minimum value to what R10 contains
			B A					// Branch to A

A:			CMP R10, R11		// we compare R10 and R11
			BGE B				// if no, branch to B
			MOV R2, R10			// we change the maximum value to what R10 contains
			B B					// branch to B

B:			ADD R9, R0,R8		// CASE 3: R9 holds X1 + X4
			ADD R12, R6, R7		// R12 holds X2 + X3
			MUL R12, R12, R9	// R12 holds R12 * R9
			
			CMP R12, R1			// we compare R12 and our current min	
			BGE C				// if no, branch to C
			MOV R1, R12			// we change the minimum value to what R12 contains
			B C					// branch to C

C:			CMP R2, R12			// we compare our current max and R12
			BGE DONE			// if no, branch to DONE
			MOV R2, R12			// we change the maximum value to what contauns R12
			B DONE				// branch to DONE
			

DONE:		STR R1, [R4]		// store the minimum result to the memory location
			STR R2, [R5]		// store the maximum result to the memory location			

END:		B END 				// infinite loop!

RESULTM: 	.word 	0			// memory assigned for maximum result location

N:			.word 	4			// number of entries in the list
NUMBERS:	.word 	1, 2, 3, 4  // number of entries in the list

RESULTm: 	.word 	1			// memory assigned for minimum result location

