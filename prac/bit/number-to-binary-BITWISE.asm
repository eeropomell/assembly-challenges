%include "MACRO.asm"

section .bss 
    string resb 33

section .text
    global _start 

    _start:
        push string 
        push 2147483647
        call skateboard
        print string, 32
        exit

        skateboard:
            mov eax, [rsp + 8]
            mov edi, [rsp + 16]
            mov ecx, 32
            binary:
                rol eax, 1
                jnc zero
                mov byte [edi], "1"
                jmp end
                zero:
                mov byte [edi], "0"
                end:
                inc edi
                loop binary
            ret