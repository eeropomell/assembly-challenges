%include "MACRO.asm"

; floating point subtraction without floating point instructions

section .data
    source dd 10.2
    source2 dd 8.5

section .text
    global _start 

    _start:
        skateboard:
            xor ebx, ebx
            xor ecx, ecx
            expand [source]
            ; store expanded parts in these registers
            mov bl, [exponent]
            mov eax, [fraction]
            mov cl, [sign]
            expand [source2]
            sub eax, [fraction]

            loop:
                inc ecx
                shl eax, 1
                test eax, 800000h
                jz loop
            end:
            sub ebx, ecx
            mov [exponent], ebx
            mov [fraction], eax

            combine result
            mov edx, [result]

            printNumber rdx

            exit