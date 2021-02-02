		.text
		.equ PUSH_BUTTON_DATA, 0xFF200050
		.equ PUSH_BUTTON_MASK, 0xFF200058
		.equ PUSH_BUTTON_EDGE, 0xFF20005C
		.global read_PB_data_ASM
		.global PB_data_is_pressed_ASM
		.global read_PB_edgecap_ASM
		.global PB_edgecap_is_pressed_ASM
		.global PB_clear_edgecap_ASM
		.global enable_PB_INT_ASM
		.global disable_PB_INT_ASM

read_PB_data_ASM:					// access pushbutton register
		LDR R1, =PUSH_BUTTON_DATA	
		LDR R0, [R1]				// pushbutton register is loaded into R1
		BX LR						// use subroutine - R0 pass the arguments back		

PB_data_is_pressed_ASM:				// R0 contains which one-hot encoded button
		LDR R1, =PUSH_BUTTON_DATA	
		LDR R2, [R1]				// pushbutton register is loaded into R2
		AND R2, R2, R0
		CMP R2, R0
		MOVEQ R0, #1				// if pressed - True
		MOVNE R0, #0				// if not pressed - False
		BX LR

read_PB_edgecap_ASM:				// no input, access edgecap register
		LDR R1, =PUSH_BUTTON_EDGE	
		LDR R0, [R1]				// pushbutton register is loaded into R1
		AND R0, R0, #0xF			// get only last bits (edge)
		BX LR						// use subroutines - using R0	
		
PB_edgecap_is_pressed_ASM:			// R0 contains which one-hot encoded button
		LDR R1, =PUSH_BUTTON_EDGE	
		LDR R2, [R1]				// pushbutton register is loaded into R2
		AND R2, R2, R0
		CMP R2, R0
		MOVEQ R0, #1				// if pressed - True 
		MOVNE R0, #0				// if not pressed - False
		BX LR

PB_clear_edgecap_ASM:				// R0 is the pushbutton value
		LDR R1, =PUSH_BUTTON_EDGE
		MOV R2, R0					// store any value in edgecap - initializes reset
		STR R2, [R1]
		BX LR

enable_PB_INT_ASM:					// R0 contains which one-hot encoded button too enable
		LDR R1, =PUSH_BUTTON_MASK
		AND R2, R0, #0xF			// only 4 digits for pushbutton, use 0xF
		STR R2, [R1]		
		BX LR

disable_PB_INT_ASM:					// R0 contains which one-hot encoded button to disable
		LDR R1, =PUSH_BUTTON_MASK	// load mask location
		LDR R2, [R1]				// load mask bits
		BIC R2, R2, R0				// AND on R0
		STR R2, [R1]				// store into mask
		BX LR
		
		.end
