%include "MACRO.asm"

section .text
    global _start 

    _start:
        
        push 4
        mov eax, 1
        call factorial
        printNumber rax             ; 24

        exit
        factorial:
            cmp byte [rsp + 8], 0
            jz end

            mov r8d, [rsp + 8]
            dec r8d
            push r8
            call factorial
            imul eax, [rsp + 8]
        end:
            ret 8