	.text
	.global _start

_start: 	MOV R0, #2   	// R0 contains the value 2 at the beginning

LOOP:		PUSH {R0}		// The current value of R0 is pushed to the stack
			ADD R0, #1		// 1 is added to the value of the current R0
			CMP R0, #4		// While the value inside R0 is different than 4
			BLE LOOP		// Branch back to the LOOP
			POP {R1 - R3}	// Pop the 3 last value of the stack in R1, R2 and R3
		
END: B END

