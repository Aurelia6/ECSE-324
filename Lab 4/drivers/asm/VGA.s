	.text
	.equ PIXEL_BUFFER, 0xC8000000
	.equ CHAR_BUFFER, 0xC9000000

	.global VGA_clear_charbuff_ASM
	.global VGA_clear_pixelbuff_ASM
	
	.global VGA_write_char_ASM 
	.global VGA_write_byte_ASM 

	.global VGA_draw_point_ASM 
	
	// specifications for pixels
	.equ x_pixel_max, 320 // x
	.equ y_pixel_max, 240 // y
	// specifications for characters
	.equ x_char_max, 80 // x
	.equ y_char_max, 60	//y
	
	base .req R5
	offset .req R6

	x_position .req R0
	y_position .req R1
	color .req R2


VGA_clear_charbuff_ASM:
	// range of x = {0, 79} & range of y = {0, 59}
	PUSH {R0-R8,LR}
	LDR R2, =CHAR_BUFFER
	MOV x_position, #0	// x = 0
	MOV y_position, #-1	// y = -1 - will be incremented at the beginning of the loop
	MOV R3, #0	
	MOV R6, #0			// use to clear

char_Y: //clear y
	ADD y_position, y_position, #1	// y is incremented here
	CMP y_position, #59 // while y <= 59 (its range)
	BGT char_done
	MOV x_position, #0

char_X: //clear x
	CMP x_position, #79 // while x <= 79 (its range)
	BGT char_Y
    LDR R7, =CHAR_BUFFER // offset set to base value
    ADD R7, R7, y_position, LSL #7 // left shift by 7, then adds to offset 
    ADD R7, R7, x_position
	STRB R6, [R7]		//store 0 at the offset
	ADD x_position, x_position, #1 // x++
	B char_X

char_done:
	POP {R0-R8,LR}
	BX LR


VGA_clear_pixelbuff_ASM:
 	//each pixel is represented as a 16-bit half-word
	// Blue = Red =5 bits & Green = 6 bits
	// range of x = {0, 319} & range of y = {0, 239}
	PUSH {R0-R9,LR}
	LDR R2, =PIXEL_BUFFER		// offset set to base value
	MOV x_position, #0		// x = 0
	MOV y_position, #-1		// y = -1 - will be incremented in the loop
	MOV R3, #0				
	MOV R6, #0				//used to clear

	LDR R7, = x_pixel_max

pixel_Y: // clear y
	ADD y_position, y_position, #1	// y++
    CMP y_position, #239 //y <= 239 (its range)
	BGT pixel_done 
	MOV x_position, #0

pixel_X: // clear x
	CMP x_position, #320 // x <= 319 (its range) - for no reason #319 and BGT did not work
	BEQ pixel_Y
    LDR R7, =PIXEL_BUFFER
    ADD R7, R7, y_position, LSL #10 //left shift by 10, then adds to offset 
    ADD R7, R7, x_position, LSL #1  // left shifts by 1, then adds to offset
	STRH R6, [R7]					//clear
	ADD x_position, x_position, #1 	// x++
	B pixel_X

pixel_done:
	POP {R0-R9,LR}
	BX LR


VGA_write_char_ASM:
	PUSH {R0-R7,LR}
	
	// check x
	CMP x_position, #x_char_max // compare x and its upper bound
	BGE write_char_done
	CMP x_position, #0 			// compare x and its lower bound
	BLT write_char_done
	// check y
	CMP y_position, #y_char_max //compare y and its upper bound
	BGE write_char_done
	CMP y_position, #0 			//compare y and its lower bound
	BLT write_char_done

    LDR R7, =CHAR_BUFFER 		// offset set to base value
    ADD R7, R7, y_position, LSL #7 // left shift by 7, then adds to offset 
    ADD R7, R7, x_position
	STRB color, [R7]			// store 0 at the offset

write_char_done:
	POP {R0-R7,LR}
	BX LR
	

VGA_write_byte_ASM:
// all the byte values lead to a character
	PUSH {R0-R10,LR}
	LDR R7, =HEX_CHAR
	MOV R3, R2
	LSR R2, R3, #4
	AND R2, R2, #15 		// R2 holds the last 4 bits of the byte
	LDRB R2, [R7, R2]
	BL VGA_write_char_ASM

	AND R2, R3, #15 		// R2 holds the first 4 bits of the byte
	ADD R0, R0, #1 			// Add 1 to x
	LDRB R2, [R7, R2]
	BL VGA_write_char_ASM

	POP {R0-R10,LR}
	BX LR
	
VGA_draw_point_ASM:
	PUSH {R0-R10,LR}
	LDR base, =PIXEL_BUFFER
	MOV R6, R2				//Color stored in R6

 	LDR R7, =PIXEL_BUFFER
    ADD R7, R7, y_position, LSL #10 // left shift by 10, then add to offset
    ADD R7, R7, x_position, LSL #1  // left shift by 1, then add to offset
	STRH R6, [R7]					//used to clear

	POP {R0-R10, LR}
	BX LR


HEX_CHAR:	
	.ascii "0123456789ABCDEF" //ASCII data to write in byte

	.end
