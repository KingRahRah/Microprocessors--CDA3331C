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
                                            ; section
;-------------------------------------------------------------------------------
RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer

;-------------------------------------------------------------------------------

LAB1

Setup
			clr R4							; clear registers needed.
			clr R5
			clr R6
			clr R7
			clr R10

			mov.b #4, R4					; adding values to registers
			mov.b #3, R5
			mov.b #10, R6
			mov.b #15, R10



Addition									; adding registers R4-R6 into R7
			add.b R4, R7
			add.b R5, R7
			add.b R6, R7

Subtraction									; subtract register R10 from register R7
			sub.b R10, R7

Store										; store contnets in address starting at 0x200
			mov.w R4, &0200h
			mov.w R5, &0202h
			mov.w R6, &0204h
			mov.w R10, &0206h
			mov.w R7, &0208h

Mainloop	jmp		Mainloop				; infinite loop                                           ; Main loop here
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
