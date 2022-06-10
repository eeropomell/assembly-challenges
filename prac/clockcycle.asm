%include "MACRO.asm"

; 5x^3 - 7x^2 + 3x - 10

section .text
    global _start

    _start:
        mov eax, 3
        mov ebx, eax
        imul eax, 5
        imul eax, ebx
        imul eax, ebx
        mov ecx, eax

        mov eax, ebx
        imul eax, 7
        imul eax, ebx
        sub ecx, eax
        
        mov eax, ebx
        imul eax, 3
        add ecx, eax
        sub ecx, 10
        printNumber rcx

        ; Clock cycles: 71
        ; Bytes of object code: 35

        mov eax, 3
        mov ebx, eax
        imul eax, 5
        sub eax, 7

        imul eax, ebx
        add eax, 3
        imul eax, ebx
        sub eax, 10
        printNumber rax

        ; Clock cycles: 36
        ; Bytes of object code: 21

    exit