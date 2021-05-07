@ Nur Amalina Bte Md Sani 	[A0205174M]
@ Rishab Patwari 			[A0184456W]

 	.syntax unified
 	.cpu cortex-m3
 	.thumb
 	.align 2
 	.global	iir
 	.thumb_func

@ CG2028 Assignment, Sem 2, AY 2020/21
@ (c) CG2028 Teaching Team, ECE NUS, 2021

@Register map
@R0  - N, returns y
@R1  - b
@R2  - a
@R3  - x_n
@R4  - b[i], temporary storage reg
@R5  - a[0]
@R6  - a[i], temporary storage reg
@R7  - Loop counter
@R8  - Pointer to x_store[i]
@R9  - Pointer to y_store[i]
@R10 - y_n
@R11 - x_store[i]
@R12 - y_store[i]

iir:
	PUSH {R4-R12, LR}

	LDR R4, [R1]		@ 0x05114000
	LDR R5, [R2]		@ 0x05125000

	MUL R10, R3, R4 	@ 0x0000A413
	SDIV R10, R5

	MOV R7, R0			@ 0x01A07000
	LDR R8, =X_STORE
	LDR R9, =Y_STORE

loop:
	LDR R4, [R1, #4]!	@ 0x05B14004
	LDR R11, [R8], #4	@ 0x0498B004
	MUL R4, R11			@ 0x00004B14

	LDR R6, [R2, #4]!	@ 0x05B26004
	LDR R12, [R9], #4	@ 0x0499C004
	MUL R6, R12			@ 0x00006C16

	SUB R4, R6			@ 0x00444006
	SDIV R4, R5

	ADD R10, R4			@ 0x008AA004

	SUBS R7, #1			@ 0x02577001
	BPL loop			@ 0x5800002A

	SUB R7, R0, #1		@ 0x02407001
	SUB R8, #8			@ 0x02488008
	SUB R9, #8			@ 0x02499008

loop2:
	LDR R11, [R8, #-4]	@ 0x0518B004
	STR R11, [R8], #-4	@ 0x0408B004

	LDR R12, [R9, #-4]	@ 0x0519C004
	STR R12, [R9], #-4	@ 0x0409C004

	SUBS R7, #1			@ 0x02577001
	BNE loop2			@ 0x18000090

	STR R3, [R8]		@ 0x05083000
	STR R10, [R9]		@ 0x0509A000


	MOV R4, SCALE_FACTOR
	SDIV R0, R10, R4

	POP {R4-R12, LR}

	BX	LR

@ Equates
	.equ N_MAX, 10
	.equ SCALE_FACTOR, 100

@.lcomm label num_bytes
	.lcomm X_STORE 4*N_MAX
	.lcomm Y_STORE 4*N_MAX
