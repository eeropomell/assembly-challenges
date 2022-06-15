%include "MACRO.asm"


; floating point division without floating point instructions

section .text
    global _start 

    _start:
        push result
        push __float32__(50.2)
        push __float32__(20.9)
        call skateboard
        mov edx, [result]
        printNumber rdx

        exit

        skateboard:
            mov rbp, rsp
            push rdx
            push rbx
            push rdx
            push rax
            push rdi
            mov edx, [rbp + 16]
            mov edi, [rbp + 8]

            cmp edi, 0
            je error

            expand edx
            xor ecx, ecx
            mov cl, [sign]
            mov bl, [exponent]
            mov edx, [fraction]
            expand edi
            xor cl, [sign]
            sub bl, [exponent]
            add bl, 127
        
            mov eax, edx
            mov edi, [fraction]
            shl rax, 23
            cdq
            div rdi

            mov dword [fraction], eax
            mov byte [sign], cl
            mov byte [exponent], bl  
            mov edx, [rbp + 24]
            combine edx   

            pop rdi
            pop rax
            pop rdx
            pop rbx
            pop rdx
            jmp end

        error:
            mov dword [result], infinity
        end:
            ret  