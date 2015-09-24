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

LAB3		mov.w #-7, R4 	;Load "a" into R4

CLEAR						; Clear the Registers
			clr R5
			clr R6
			clr R7
			clr R8
			clr R9
			clr R10
			clr R11
			clr R12
			clr R13
			clr R14
			clr R15

Test		mov.w #6, R12
			mov.w #2, R13
			call #DIVIDE


XCALC		mov.w R4, R12	;move R4 (a) into R12 (i)
			cmp.w #0, R12	;compare R14 (i) with 0
			jl Absi

Back		mov.w #5, R8	; move the value 5 into the number being added in multiply (R8)
			mov.w R12, R9	; move R12 (i) into the counter in multiply (R9)

			call #MULTIPLY	; call Multiply

			mov.w R11, R10	; move the result of multiply (R11) into R10 for future use

			mov.w #10, R13	; move the value 10 into the denominator for dividing (R13)

			push.w R12		;push R12 (i) into the SP
			mov.w R10, R12	; move the future additon (R10) into the numerator for divide (R12)

			call #DIVIDE	; call Divide

			cmp.w #0, R12	; the remainder (R12) with 0
			jne	StepUp		; if greater than 0, jump to Step Up

SLoop
			mov.w R14, R15	; move the quotient (R7) into the value to factorial (R15)

			call #FACTORIAL	; call Factorial

			add.w R15, R10	; add the result of factorial (R15) to Future use (R10)

			add.w R10, R5	; add the furture use (R10) into R5 (X)

			pop.w R12		; pop back the value into R12 (i)

			dec.w R12		; R12--

			cmp.w #0, R12	; compare R12 (i) with 0
			jge Back		; if not equal, jump to Back
			jl DoneX		; if equal, jump to Done X-Calculation


Absi		inv.w R12		; inverse R12 (i)
			inc.w R12		; R12++
			jmp Back

StepUp		inc.w R14		; Quotient++
			jmp  SLoop		; Jump to SLoop

DoneX


YCALC		mov.w #-7, R8	; move the vaule -7 into the number being added for multiply (R8)
			mov.w R4, R9	; move R4 (a) into the counter for multiply (R9)

			call #MULTIPLY	; call Multiply

			mov.w R11, R6	; move the result of multiply (R11) into R6 (Y)
			add.w #15, R6	; add the value 15 and R6 (Y)

			mov.w R6, R8	;  move R6 (Y) into the number being added for multiply (R8)
			mov.w R6, R9	;  move R6 (Y) into the counter for multiply (R9)

			call #MULTIPLY	; call Multiply

			mov.w R11, R6	; move the result of multiply (R11) into R6 (Y)

FCALC		mov.w #50, R7	; move the value 50 into R7 (F)
			add.w R5, R7	; add R5 (X) with R7 (F)

			mov.w R7, R12	; move R7 (F) into the numerator for division (R12)
			mov.w R6, R13	; move R6 (Y) into the denominator for division (R13)

			call #DIVIDE	; call Divide

			mov.w R14, R7	; move the quotient from division (R14) into R7 (F)

MainLoop jmp MainLoop		; Infinite Loop

;------------------------------------------------------------------------------

MULTIPLY	push.w R10  	; push values into the SP so registers can be used
			push.w R12
			clr R11			; clear registers being used
			clr R10

CheckN		cmp.w #2, R10	; compare negative counter (R10) with 2
			jeq Abs			; if equal jump to Absolute Value

CheckZ		cmp.w #0, R9	; compare the counter (R9) with 0
			jeq DoneM		; if edual jump to Done Multiply
			jl Exchange		; if the counter (R9) is negative, jump to Exchange

Loop		add.w R8, R11	; add the number being added (R8) into the Result (R11)
			dec.w R9		; Counter--
			cmp.w #0, R9	; compare the counter with 0
			jne	Loop		; if not equal, jump back to the Loop

			cmp.w #2, R10	; compare the negative counter (R10) with 2
			jeq AbsR		; if equal, jump to Absoulute Value of the Result
			Jne DoneM		; if not equal, jump to Done Multiply

Exchange	mov.w R9, R12	; move the counter (R9) into a random register (R12)
			mov.w R8, R9	; move the number being added (R8) into the counter (R9)
			mov.w R12, R8 	; move the value from the random register (R12) into the number being added (R8)
			inc.w R10		; negative counter++
			jmp CheckN		; if equal, jump to Check Negative

Abs			inv.w R9		; inverse the counter (R9)
			inc.w R9		; counter ++
			jmp CheckZ		; jump to Check Zero

AbsR		inv.w R11		; inverse the result (R11)

			inc.w R11		; result ++
			jmp DoneM		; jump to Done Multiply

DoneM		pop.w R12		; Pop vaules back into the registers
			pop.w R10
			ret				; Return

;-------------------------------------------------------------------------------

DIVIDE		clr R14			; clear registers needed
			clr R11

Check		cmp.w #0, R12	; compare the remainder (R12) to 0
			jeq DoneD		; if equal, jump to Done Divide
			jl AbsN			; if the remainder is negative, jump to Absoulte Value of the Numerator

			cmp.w #0, R13	; compare the denominator (R13) to 0
			jl AbsD			; if negative, jump to Absolute Value of the Denominator

DLoop		cmp.w R13, R12	; compare the remainder (R12) to the denominator (R13)
			jl DoneD		; if negative, jump to Done Divide

			sub.w R13,R12	; subtract the denominator (R13) from the numerator (R12)
			inc.w R14		; Quotent++
			jmp DLoop		; jump to Divide Loop

AbsN		inv.w R12		; inverse the numerator (R12)
			inc.w R12		; Numerator++
			inc.w R11		; Negative counter++
			jmp Check		; jump to Check

AbsD		inv.w R13		; inverse the denominator (R13)
			inc.w R13		; Denominator++
			inc.w R11		; Negative counter++
			jmp Check		; Jump to Check

DoneD		cmp.w #1, R11	; compare the negative counter with 1
			jeq AbsDR		; if equal, jump to Absolute Value of the Divison Result

			ret				; Return

AbsDR		inv.w R14		; inverse the Quotient
			inc.w R14		; Quotent++

			ret				; Return

;-------------------------------------------------------------------------------

FACTORIAL	push.w R10		; push registers into the SP to free up registers
			cmp.w #0, R15	; compare the result (R15) with 0
			jeq FacZ		; if equal, jump to Factorial Zero
			jl FacN			; if negative, jump to Factorial Negative

			mov.w R15, R10	; move the result (R15) into the counter (R10)
			mov.b R15, R8	; move the result (R15) into the number being added to get ready to multiply (R8)

Fac			dec.w R10		; Counter--
			cmp.w #0, R10	; compare the counter (R10) with 1
			jeq FinalCheck		; if equal, jump to DOne Factorial

			mov.w R10, R9	; move the counter (R10) into the counter for multiply (R9)

			call #MULTIPLY	; call subroutine MULTIPLY

			mov.w R11, R8	; move the result of multiply (R11) back into the number being added for multiply (R8)

			jmp Fac			; jump to Factorial Loop

FacZ		mov.w #1, R15	; move 1 into the result (R15)
			pop.w R10
			ret				; return

FacN		mov.w #0, R15	; move 0 into the result (R15)
			pop.w R10
			ret				; return

FinalCheck	cmp #0, R11
			jeq DoneF

			mov.w R11, R15	; move the result of multiply (R11) into the result (R15)
			pop.w R10		; pop values back from the SP to recieve old values
			ret				; return

DoneF		pop.w R10
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
