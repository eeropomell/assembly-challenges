%include "macro.asm"

section .data
    fizz db "fizz", 10
    buzz db "buzz", 10
    fizzbuzz db "fizzbuzz", 10

section .text
    global _start

    _start:
        mov r8w, 0      ;fizzbuzz number
       
        loop:
            inc r8w
            cmp r8w, 50
            jg _exit

            mod 3
            je _printFizz
            mod 5
            je _printBuzz
            mod 15
            je _printFizzBuzz

            printNumber r8d
            jmp loop

        _printFizz:
            print fizz, 5
            jmp loop

        _printBuzz:
            print buzz, 5
            jmp loop

        _printFizzBuzz:
            print fizzbuzz, 9
            jmp loop

        _exit:
            exit