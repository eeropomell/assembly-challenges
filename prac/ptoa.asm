%include "MACRO.asm"


; packed BCD into string

section .bss 
    string resb 22

section .data
    num dq 0x8000000000009123

section .text
    global _start 


    _start:
        push num
        push string
        call skateboard
        print string, 19            ; prints          -9123
        exit

        skateboard:
            mov rbp, rsp
            push rax
            push rdx
            push rdi
            push rcx
            xor eax, eax
            mov edx, [rbp + 16]
            mov edi, [rbp + 8]
            add edi, 18
            mov ecx, 7
     
            solve:
            xor ax, ax
            mov al, [edx]
            mov ah, al
            and al, 0fh
            add al, 30h
            cmp al, "0"
            jnz around 
            mov al, 32
            around:
            mov [edi], al
            dec edi
            shr ah, 4
            add ah, 30h
            cmp ah, "0"
            jnz around2
            mov ah, 32
            around2:
            mov [edi], ah
            dec edi
            inc edx
            loop solve
            xor eax, eax
            mov al, [edx]
            and al, 8fh
            jz around3
            
            loop:
                xor al, al
                mov al, [edi]
                cmp al, 47
                jnle addneg
                inc edi
                jmp loop
            addneg:
                dec edi
                mov byte [edi], "-"
            around3:
            
            pop rcx
            pop rdi
            pop rdx
            pop rax
            ret
