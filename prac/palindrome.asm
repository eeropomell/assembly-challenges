%include "MACRO.asm"


section .bss 
    string resb 10
    rString resb 10

section .data
    alert db "Enter a word and i'll report if it's a palindrome", 10
    alertlen equ $ -alert
    yep db "Yep.", 10
    nope db "Nope.", 10

section .text
    global _start 

    _start:
        loopp:
        print newline, 1
        print alert, alertlen
        input string
        reverseString string, rString
        mov esi, string
        mov edi, [rString]
        repe cmpsb
        jnz around
        print yep, 5
        jmp loopp
        around:
        print nope, 7
        jmp loopp
        exit