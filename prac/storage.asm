%include "MACRO.asm"

section .bss    
    storage resb 1024
    string resb 10

section .text
    global _start 

    _start:
        mov edi, storage
        call program
        call display

        exit
        
        program:
            push rdi
            input string
            pop rdi
            cmp byte [string], "$"
            je end
            
            mov esi, string
            .loop:
                cmp byte [esi], 10
                je endofstring
                movsb
                jmp .loop

            endofstring:
                mov esi, carriage
                movsb
                mov esi, newline
                movsb
                jmp program

        end:
            mov esi, null
            movsb
            ret

        display:
        xor ecx, ecx
        .loop:
            lea eax, [storage + ecx]
            cmp byte [eax], 0
            je endisplay

            push rcx
            print eax, 1
            pop rcx
            
            inc ecx
            jmp .loop

        endisplay:
            ret