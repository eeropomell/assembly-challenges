%include "MACRO.asm"

; string to packed bcd

section .bss 
    num resb 32

section .data
    string db "-1469"           ; 69140008             

section .text
    global _start 


    _start:
        mov edi, string
        mov edx, num
        cmp byte [edi], "-"
        jne loop
        inc edi
        mov cl, 1
        loop:
        xor al, al
        mov al, [edi]
        cmp al, 0
        jz out
        shl al, 4
        mov bl, [edi + 1]
        and bl, 0Fh
        or al, bl
        cmp bl, 0
        jnz around
        shr al, 4
        around:
        shrd [edx], eax, 8
        add edi, 2
        jmp loop

        out:
        cmp cl, 1
        jne skip
        mov byte [num], 8
        skip:
        mov ebx, [num]
        printNumber rbx
       
        exit