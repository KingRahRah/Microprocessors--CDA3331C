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
hRESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer

;-------------------------------------------------------------------------------
			mov.b #0xFF, &P1DIR
			mov.b #0x00, &P2DIR

			clr R4				; Zero value Register
			clr R5
			clr R6
Write		mov.b &P2IN, R5
			and.b #0x38, R5
			mov.b R5, &P1OUT
MainLoop
			mov.b R5, R6
			and.b #0x38, R6
			mov.b R5, &P1OUT

			mov.b &P2IN, R6
			and.b #0x01, R6
			cmp.b #0x01, R6
			jne Rotate
			jmp Write


Rotate
			mov.b &P2IN, R6
			and.b #0x02, R6

			cmp.b #0, R6
			jeq	RotR
			jmp	RotL



RotR		call #ROTRIGHT

			jmp MainLoop

RotL		call #ROTLEFT

			jmp MainLoop


;-----------------------------------------------------------------------------------

ROTLEFT		mov.b R5, R6
			and.b #0x80, R6
			cmp.b #0x80, R6
			jne RLUse0
			rlc.b R5
			bis.b #0x01, R5
			jmp LDelayStart

RLUse0		rlc.b R5
			and.b #0xFE, R5

LDelayStart	mov.b &P2IN, R6
			and.b  #0x04, R6
			cmp.b #0, R6
			jeq RLSlow
			call #FASTDELAY
			jmp RLDONE

RLSlow		call #SLOWDELAY
			jmp RLDONE

RLDONE		ret

;-----------------------------------------------------------------------------------

ROTRIGHT	mov.b R5, R6
			and.b #0x01, R6
			cmp.b #0x01, R6
			jne RRUse0
			rrc.b R5
			bis.b #0x80, R5
			jmp RDelayStart

RRUse0		rrc.b R5
			and.b #0x7F, R5

RDelayStart	mov.b &P2IN, R6
			and.b  #0x04, R6
			cmp.b #0, R6
			jeq RRSlow
			call #FASTDELAY
			jmp RRDONE

RRSlow		call #SLOWDELAY
			jmp RRDONE


RRDONE		ret

;-----------------------------------------------------------------------------------

FASTDELAY	mov.w #0, R9
FRV			mov.w #25000, R8
FDLoop		dec.w R8
			cmp.w #0, R8
			jne FDLoop
			dec.w R9
			cmp.w #0, R9
			jge FRV
			ret

;-----------------------------------------------------------------------------------

SLOWDELAY	mov.w #3, R9
SRV			mov.w #65000, R8
SDLoop		dec.w R8
			cmp.w #0, R8
			jne SDLoop
			dec.w R9
			cmp.w #0, R9
			jge SRV
			ret
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
