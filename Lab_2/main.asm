;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file

;-------------------------------------------------------------------------------
            .text                           ; Assemble into program memory
            .retain                         ; Override ELF conditional linking
                                            ; and retain current section
            .retainrefs                     ; Additionally retain any sections
                                            ; that have references to current
            .global RESET                              ; section
;-------------------------------------------------------------------------------

ARY1		.set		0x0200
ARY1S		.set		0x0210

ARY2		.set		0x0220
ARY2S		.set		0x0230

RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer

;-------------------------------------------------------------------------------

 			clr		R4
 			clr		R5
 			clr		R6

SORT1
 			mov.w #ARY1, R4
 			mov.w #ARY1S, R5
 			call #ArraySetupOne
 			call #COPY
 			call #SORT

SORT2
			mov.w #ARY2, R4
			mov.w #ARY2S, R5
			call #ArraySetupTwo
			call #COPY
			call #SORT

Mainloop	jmp		Mainloop

ArraySetupOne
			mov.b #10, 0(R4)
			mov.b #20, 1(R4)
			mov.b #89, 2(R4)
			mov.b #-5, 3(R4)
			mov.b #13, 4(R4)
			mov.b #63, 5(R4)
			mov.b #-1, 6(R4)
			mov.b #88, 7(R4)
			mov.b #2, 8(R4)
			mov.b #-88, 9(R4)
			mov.b #1, 10(R4)

			ret

ArraySetupTwo
			mov.b #10, 0(R4)
			mov.b #90, 1(R4)
			mov.b #-10, 2(R4)
			mov.b #-45, 3(R4)
			mov.b #25, 4(R4)
			mov.b #-46, 5(R4)
			mov.b #-8, 6(R4)
			mov.b #99, 7(R4)
			mov.b #20, 8(R4)
			mov.b #0, 9(R4)
			mov.b #-64, 10(R4)

			ret

COPY
		mov.w R4, R10
		mov.w R5, R11

		mov.b @R4, R6 ; R6 = Length Counter
		inc R6

Loop	mov.b @R4+, 0(R11)
		inc R11
		dec R6
		cmp #0, R6
		jnz Loop
		mov.w R5, R11
		ret

SORT

RST			clr R12 ; R12 = Exchange counter
			mov.w R11, R5
			mov.b @R5, R6 ; length value into R6
			dec R6
			inc R5

TST			mov.b @R5+, R14
			mov.b @R5, R15
		;	cmp.b R15, R14
			cmp.b R14, R15
			jeq NOSWAP
			Jl	NOSWAP

			mov.b R15, -1(R5)
			mov.b R14, 0(R5)
			inc R12

NOSWAP		dec R6
			cmp #0, R6
			jnz TST
			cmp.b #0, R12
			jeq return
			jge RST

return		ret

                                            ; Main loop here
;-------------------------------------------------------------------------------


;-------------------------------------------------------------------------------
;           Stack Pointer definition
;-------------------------------------------------------------------------------
            .global __STACK_END
            .sect 	.stack

;-------------------------------------------------------------------------------
;           Interrupt Vectors
;-------------------------------------------------------------------------------
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET
