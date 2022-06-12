%include "MACRO.asm"



section .bss 
    string resb 6

section .text
    global _start 

    _start:

        push string
        push 1000
        call skateboard 
        print string, 6
        exit
        
        skateboard: 
            mov edi, [rsp + 16]
            mov al, "0"
            mov ecx, 6
            rep stosb

            mov eax, [rsp + 8]
            .loop:
                cmp eax, 0
                jz .end

                mov edx, eax
                sar eax, 3
                and edx, 7h

                add dl, 30h
                dec edi
                mov byte [edi], dl
                
                jmp .loop

            .end:
            ret