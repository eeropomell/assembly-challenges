%include "MACRO.asm"



section .text
    global _start 

    _start:
        push 729
        call skateboard                ; xmm0 = 9

        exit

        skateboard:
            mov rbp, rsp
            push rbx

            ; 1.0
            movss xmm0, [root]
            mov ebx, [rbp + 8]
            mov dword [testvalue], ebx

            ; get rid of "garbage" values
            xorps xmm4, xmm4
            .loop:
            ; root - oldroot
            movss xmm4, xmm0
            subss xmm4, xmm3
            ; get absolute value
            pslld xmm4, 1
            psrld xmm4, 1
            ; return if less than
            comiss xmm4, [smallvalue]
            jc end

            ; oldroot = root
            movss xmm3, xmm0

            movss xmm1, xmm0
            
            ; (2.0 * root + x/(root*root)) / 3.0
            mulss xmm0, [two]
            mulss xmm1, xmm1
            cvtsi2ss xmm2, [testvalue]
            divss xmm2, xmm1
            addss xmm0, xmm2
            divss xmm0, [three]
            jmp .loop
            end:

            pop rbx
            mov rsp, rbp
            ret 8