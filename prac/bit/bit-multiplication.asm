%include "MACRO.asm"



section .text
    global _start 

    _start:

        ; 10 * 5
        
        mov eax, 10
        mov ebx, eax
        shl eax, 2
        add eax, ebx
        printNumber rax

        ; eax * 7

        mov eax, 5
        mov ebx, eax
        shl eax, 2
        add eax, ebx
        add eax, ebx
        add eax, ebx
        printNumber rax

        ; eax * 9

        mov eax, 3
        mov ebx, eax
        shl eax, 3
        add eax, ebx
        printNumber rax

        ; eax * 10

        mov eax, 5
        mov ebx, eax
        shl eax, 3
        add eax, ebx
        add eax, ebx
        printNumber rax   

    exit