	.text
	.equ TIM_0, 0xFFC08000 // timer counter
	.equ TIM_1, 0xFFC09000 // push button counter
	.equ TIM_2, 0xFFD00000 // not used
	.equ TIM_3, 0xFFD01000 // not used
	.global HPS_TIM_config_ASM // make the subroutines available to the package
	.global HPS_TIM_clear_INT_ASM
	.global HPS_TIM_read_INT_ASM

//configure
HPS_TIM_config_ASM:
		PUSH {R4-R7, LR}
		MOV R1, #0 			// counter initialized to 0
		MOV R2, #1
		LDR R3, [R0]		// load TIM into R3
		B loop

loop:
		TST R3, R2, LSL R1	// same as an AND for R2 and R1 shifted to the left, but the result is used and then discarded
		BEQ run					
		BL config

run:
		ADD R1, R1, #1
		CMP R1, #4			// if counter is less or equal than 4
		BLT loop			// branch 

done:
		POP {R4-R7, LR} 	// restore data
		BX LR

config:
		PUSH {LR}
		LDR R3, =HPS_TIM_BASE
		LDR R4, [R3, R1, LSL #2] 
		// use different subroutines to configure the timer
		BL disable
		BL set_value
		BL set_bit
		BL set_int_bit
		BL set_enable_bit
		
		POP {LR}
		BX LR 

disable: 
		LDR R5, [R4, #0x8] 		// disable timer before doing config
		AND R5, R5, #0xFFFFFFFE // disable E bit, keep other the same
		STR R5, [R4, #0x8]
		BX LR

set_value:
		LDR R5, [R0, #0x4] 		// load timeout
		MOV R6, #25
		MUL R5, R5, R6
		CMP R1, #2
		LSLLT R5, R5, #2
		STR R5, [R4]			// configure timeout
		BX LR

set_bit:
		LDR R5, [R4, #0x8]		// load "LD_enable"
		LDR R6, [R0, #0x8]
		AND R5, R5, #0xFFFFFFFD
		ORR R5, R5, R6, LSL #1	// left shift by 1 (M bit)
		STR R5, [R4, #0x8]
		BX LR

set_int_bit:
		LDR R5, [R4, #0x8] 		// load "INT_enable"
		LDR R6, [R0, #0xC]
		EOR R6, R6, #0x00000001
		AND R5, R5, #0xFFFFFFFB
		ORR R5, R5, R6, LSL #2	// left shift by 2 (I bit)
		STR R5, [R4, #0x8]
		BX LR

set_enable_bit:
		LDR R5, [R4, #0x8]		// load "enable"
		LDR R6, [R0, #0x10]
		AND R5, R5, #0xFFFFFFFE
		ORR R5, R5, R6			// get string of M, I and E bits
		STR R5, [R4, #0x8]		// store into control
		BX LR

//Clear 
HPS_TIM_clear_INT_ASM:
		PUSH {LR}
		MOV R1, #0 				// counter initialized
		MOV R2, #1
		B clear_loop

clear_loop:
		TST R0, R2, LSL R1 
		BEQ clear_run
		BL clear_int

clear_run:
		ADD R1, R1, #1 			// increment counter
		CMP R1, #4
		BLT clear_loop
		B clear_done

clear_done:
		POP {LR}
		BX LR

clear_int:
		LDR R3, =HPS_TIM_BASE
		LDR R3, [R3, R1, LSL #2] 
		LDR R3, [R3, #0xC]
		BX LR

//read
HPS_TIM_read_INT_ASM:
		PUSH {LR}
		PUSH {R4}
		MOV R1, #0
		MOV R2, #1
		MOV R4, #0
		B read_loop

read_loop:
		TST R0, R2, LSL R1
		BEQ read_run
		BL read_int

read_run:
		ADD R1, R1, #1
		CMP R1, #4
		BEQ read_done
		LSL R4, R4, #1
		B read_loop

read_done:
		MOV R0, R4
		POP {R4}
		POP {LR}
		BX LR

read_int:
		LDR R3, =HPS_TIM_BASE
		LDR R3, [R3, R1, LSL #2]
		LDR R3, [R3, #0x10]
		AND R3, R3, #0x1
		EOR R4, R4, R3
		BX LR

HPS_TIM_BASE:	
		.word 0xFFC08000, 0xFFC09000, 0xFFD00000, 0xFFD01000

		.end
