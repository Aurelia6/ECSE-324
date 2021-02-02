    .text
    .equ HEX_0to3, 0xFF200020 // HEX0 - HEX1 - HEX2 - HEX3
    .equ HEX_4and5, 0xFF200030 // HEX4 - HEX5
    .global HEX_clear_ASM
    .global HEX_flood_ASM
    .global HEX_write_ASM

HEX_clear_ASM:		
		PUSH {R1-R8,LR} 		// pushes all registers to save for subroutines
		LDR R1, =HEX_0to3
		MOV R2, #0 				// R2 will be the counter
		
clear_LOOP:
		CMP R2, #6				// verifies if all HEX looped
		BEQ clear	

		AND R4, R0, #1			// ANDs, shifts if not equal by 1
		CMP R4, #1				// if equal, HEX is found
		BEQ clear				// branches to next
							
		ASR R0, R0, #1			// if not equal, 1 bit shifted right
		ADD R2, R2, #1			// counter + 1, keeps track of HEX
		B clear_LOOP			// loop if not right
		
clear:
		CMP R2, #3				// if counter > 3, HEX 4-5
		SUBGT R2, R2, #4		// counter updated for HEX4-5
		LDRGT R1, =HEX_4and5	// set to next disp HEX
		LDR R3, [R1]
		MOV R5, #0xFFFFFF00		// initial value
		B clear_LOOP2			// branch next

clear_LOOP2:
		CMP R2, #0				// if counter = 0
		BEQ clear_DONE			// branch next
		LSL R5, R5, #8			// shift left 8
		ADD R5, R5, #0xFF		// keep our empty space constant
		SUB R2, R2, #1			// counter --
		B clear_LOOP2

clear_DONE:
		AND R3, R3, R5			
		STR R3, [R1]			// store on display R1
		POP {R1-R8, R14}		// pop all registers and LR
		BX LR

HEX_flood_ASM:					// R0 hot-one encoded
		PUSH {R1-R8,R14}
		LDR R1, =HEX_0to3		// place loc of Hex0-3 in R1
		MOV R2, #0				// counter initialized
		
flood_LOOP:
		CMP R2, #6				// if all HEXs looped
		BEQ flood				// branch

		AND R4, R0, #1			// AND, shift if not equal
		CMP R4, #1				// if equal, This is the HEX
		BEQ flood	//branch
							
		ASR R0, R0, #1			// if !=, shift right 1 bit
		ADD R2, R2, #1			// counter ++
		B flood_LOOP			// loop again
		
flood:
		CMP R2, #3				// if count > 3, HEX4-5
		SUBGT R2, R2, #4		// counter updated for HEX4-5
		LDRGT R1, =HEX_4and5	// set to next disp HEX
		LDR R3, [R1]
		MOV R5, #0x000000FF		// init val
		B flood_LOOP2			// branch next

flood_LOOP2:
		CMP R2, #0				// if = 0
		BEQ flood_DONE			// branch to done
		LSL R5, R5, #8			// shift left 8
		SUB R2, R2, #1			// counter --
		B flood_LOOP2

flood_DONE:
		ORR R3, R3, R5			// ORR the two vals
		STR R3, [R1]			// store to display R1
		POP {R1-R8,LR}
		BX LR

HEX_write_ASM:					// R0 hot-one encoded
		MOV R10, R0
		MOV R9, R1
		PUSH {R1-R8,LR}
		BL HEX_clear_ASM		// display cleared
		POP {R1-R8,R14}
		MOV R0, R10
		
		PUSH {R1-R8,LR}
		LDR R1, =HEX_0to3		// localization HEX0-3 placed in R1
		MOV R2, #0				// new counter for write subroutine
		
		B write_comparison

write_comparison:
		// check which value should be written
		CMP R9, #48 
		BEQ write0
		
		CMP R9, #49
		BEQ write1
		
		CMP R9, #50
		BEQ write2
		
		CMP R9, #51
		BEQ write3
		
		CMP R9, #52
		BEQ write4
		
		CMP R9, #53
		BEQ write5
	
		CMP R9, #54
		BEQ write6
		
		CMP R9, #55
		BEQ write7
		
		CMP R9, #56
		BEQ write8
		
		CMP R9, #57
		BEQ write9
		
		CMP R9, #58
		BEQ writeA
		
		CMP R9, #59
		BEQ writeB
		
		CMP R9, #60
		BEQ writeC
		
		CMP R9, #61
		BEQ writeD
		
		CMP R9, #62
		BEQ writeE
		
		CMP R9, #63
		BEQ writeF
		
		B write_LOOP

write0:
		MOV R5, #0x3F 	// write the value 0 in R5
		MOV R8, R5
		B write_LOOP

write1:
		MOV R5, #0x06	// write the value 1 in R5
		MOV R8, R5
		B write_LOOP

write2:
		MOV R5, #0x5B	// write the value 2 in R5
		MOV R8, R5
		B write_LOOP

write3:	
		MOV R5, #0x4F	// write the value 3 in R5
		MOV R8, R5
		B write_LOOP

write4:
		MOV R5, #0x66	// write the value 4 in R5
		MOV R8, R5
		B write_LOOP

write5:
		MOV R5, #0x6D	// write the value 5 in R5
		MOV R8, R5
		B write_LOOP

write6:
		MOV R5, #0x7D	// write the value 6 in R5
		MOV R8, R5
		B write_LOOP

write7:
		MOV R5, #0x7	// write the value 7 in R5
		MOV R8, R5
		B write_LOOP

write8:
		MOV R5, #0x7F	// write the value 8 in R5
		MOV R8, R5
		B write_LOOP

write9:
		MOV R5, #0x67	// write the value 9 in R5
		MOV R8, R5
		B write_LOOP

writeA:
		MOV R5, #0x77	// write the value A in R5
		MOV R8, R5
		B write_LOOP

writeB:
		MOV R5, #0x7C	// write the value b in R5
		MOV R8, R5
		B write_LOOP

writeC:
		MOV R5, #0x39	// write the value C in R5
		MOV R8, R5
		B write_LOOP

writeD:
		MOV R5, #0x5E	// write the value d in R5
		MOV R8, R5
		B write_LOOP

writeE:
		MOV R5, #0x79	// write the value E in R5
		MOV R8, R5
		B write_LOOP

writeF:
		MOV R5, #0x71	// write the value F in R5
		MOV R8, R5
		B write_LOOP
		
write_LOOP:
		CMP R2, #6				
		BEQ write	
		AND R4, R0, #1			
		CMP R4, #1				
		BEQ write	
							
		ASR R0, R0, #1			
		ADD R2, R2, #1			
		B write_LOOP		
		
write:
		CMP R2, #3				
		SUBGT R2, R2, #4		
		LDRGT R1, =HEX_4and5	
		LDR R3, [R1]
		MOV R5, R8				
		B write_LOOP2		

write_LOOP2:
		CMP R2, #0				
		BEQ write_DONE			
		LSL R5, R5, #8			
		SUB R2, R2, #1			
		B write_LOOP2

write_DONE:
		ORR R3, R3, R5			
		STR R3, [R1]			
		POP {R1-R8,LR}
		BX LR

		.end
