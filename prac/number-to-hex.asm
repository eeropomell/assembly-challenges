%include "MACRO.asm"



section .bss 
    string resb 10

section .data
    TABLE db "0123456789ABCDEF"
    
section .text
    global _start 

    _start:
        mov ebx, TABLE
        push string
        push 1000
        call skateboard
        print string, 10
        

        exit

        
        skateboard:
            mov rbp, rsp
            push rax
            push rdi
            push rsi
            push rcx
            push rdx
            
            mov edi, [rbp + 16]
            mov al, " "
            mov ecx, 7
            rep stosb
            mov eax, [rbp + 8]
            mov esi, 16
            mov ecx, 8
        hex:
            cdq
            div esi
            push rax
            xor eax, eax
            mov al, dl
            xlat
            mov [edi], al    
            dec edi 
            pop rax
            loop hex

        end:
            pop rdi
            pop rax
            pop rsi
            pop rcx
            pop rdx
            mov rsp, rbp
            
        ret 16