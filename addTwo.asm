
; $ prefix means hex, % prefix means binary, no prefix means decimal.
number1 = 26
number2 = 55
;addResult = $8D

        icl 'equates.asm'
        icl 'routines.asm'

        org $2000

        .proc main
    
        ;=============================================================
        ; print a string example
        ;
        mva #1 csrhinh                  ; hide the cursor
        mva #6 rowcrs                   ; set output row
        mva #10 colcrs                  ; set output column
        
        mva #<string1 strptr_lo         ; low byte of string1 address
        mva #>string1 strptr_hi         ; high byte o f string1 address
        jsr print_string                ; print the string

        ; add two numbers
        lda #number1        ; A = literal value in number1
        clc                 ; clear the carry
        adc #number2        ; A = A + liter value in number 2
        ;sta addResult       ; memory[addResult] = A

        ;print both digits in HEX, from left to right 
        ;first digit, shift right four times to move the first digit to the second digit's place
        ;lsr 
        ;lsr
        ;lsr
        ;lsr 
        ;adc #offset_to_char   
        ;jsr putchar

        ;lda addResult       ; A = result from above
        ;and #%00001111      ; mask bottom 4 bits to obtain just the right digit
        ;adc #offset_to_char
        ;jsr putchar

        ; print both digits in base 10, from left to right
        ; strategy is to continue subracting 10 from our hex value until it is less than 10
        ; once we are there we now have the "tens digit" in X and the "ones digit" in A
        ldx #0
checkCount:
        ; if A < 10   → carry = 0  → bcc branches   (carry CLEAR)
        ; if A >= 10  → carry = 1  → bcs branches   (carry SET)
        cmp #10             ; Does A = 10?
        bcc done            ; branch if carry is cleared
        sec                 ; set carry
        sbc #10             ; A = A - 10
        inx                 ; X = X + 1
        bne checkCount

done:   
        pha                 ; push(A) (push A onto the stack)
        txa                 ; A = X
        clc
        adc #offset_to_char
        jsr putchar

        pla                 ; A = pop() (pop the next value off the stack)
        clc 
        adc #offset_to_char
        jsr putchar

        jmp stop                        ; stop is inside routines.asm
        ;=============================================================

                .endp

;===================================================================
; Data section
;===================================================================
        .local string1
        .byte 'RESULT=',0
        .endl


        run main