%include "macro.asm"

section .text
    global _start

    _start:
        
        mov r8, 0      ; first number
        mov r9, 1      ; second number
        mov r10, 1    ; loop counter

        loop:
            mov r11, r9
            add r9, r8
            mov r8, r11   
            
            print r8
            inc r10d

            cmp r10d, 50
            jng loop

        exit