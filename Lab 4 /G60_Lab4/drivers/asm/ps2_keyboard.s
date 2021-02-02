	.text
	.equ PS2_DATA, 0xFF200100
	.global read_PS2_data_ASM

read_PS2_data_ASM:
	PUSH {R1, LR}
	LDR R1, =PS2_DATA
	LDR R1, [R1]

	TST R1, #0X8000 // extract the RVALID field
	BEQ rinvalid	// if the data entered is not valid - go to rinvalid
	AND R1, #0XFF	// else, if it is a valid data, byte3 =PS2_DATA & 0xFF - this saves the last 3 bytes of data
	STR R1, [R0]	
	MOV R0, #1
	B done

rinvalid:
	MOV R0, #0

done:
	POP {R1, LR}
	BX LR

	.end
