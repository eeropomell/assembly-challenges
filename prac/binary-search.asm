%include "MACRO.asm"



section .data
    array dd 1, 2, 3, 4, 5, 6, 7, 8

section .text
    global _start 

    _start:
        push array
        push 1
        call skateboard
        printNumber rax
        exit
        
        skateboard:
            mov rbp, rsp
            sub rsp, 16
            push rdx
            push rcx
            push rdi
            push rbx
            mov edx, [rbp + 16]         ; array
            mov dword [rbp - 8], 7       ; top index
            mov dword [rbp - 16], 0      ; mid index
            mov ecx, 0                  ; bottom index

            loop:
                cmp cl, byte [rbp - 8]
                jg notfound

                ; midindex = (bottom index + top index) / 2
                mov eax, ecx            ; 
                add eax, [rbp - 8]
                sar eax, 1
                
                mov edi, [edx + 4 * eax]
                cmp [rbp + 8], edi
                je end

                cmp [rbp + 8], edi
                jnl bigger
                mov [rbp - 8], eax
                dec dword [rbp - 8]
                jmp loop

                bigger:
                mov ecx, eax
                inc ecx
                jmp loop    

            notfound:
                mov eax, 0   
            end:
            pop rbx
            pop rdi
            pop rcx
            pop rdx
            mov rsp, rbp
            ret 8