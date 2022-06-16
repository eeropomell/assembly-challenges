%include "MACRO.asm"


; williams, pharrell -> pharrell williams

section .bss 
    string resb 20

section .text
    global _start 

    _start:
        mov eax, SYSREAD
        mov edi, 1
        mov esi, buffer
        mov edx, 20
        syscall
        xor eax, eax
        mov esi, buffer
        mov edi, temp
        loop:
            movsb
            cmp byte [esi], ","
            jne loop
        loop2:
            inc esi
            cmp byte [esi], "A"
            jnge loop2
        mov edi, string
        loop3:
            movsb
            cmp byte [esi], 10
            jne loop3
        mov byte [edi], 32
        inc edi
        mov esi, temp
        loop4:
            movsb
            cmp byte [esi], 0
            jnz loop4
        print string, 20
    
    exit