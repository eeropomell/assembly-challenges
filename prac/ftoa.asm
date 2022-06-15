%include "MACRO.asm"

; this is pretty shit


section .bss 
    string resb 10

section .data
    value dd 85.4
    power dd 100.0


section .text
    global _start 

    _start:

        push qword [value]
        push 4
        push 1
        call program
        print string, 10
        exit


        program:
        mov rbp, rsp
        push rcx
        push rax
        push rbx

        xor ecx, ecx
        fld dword [value]
        ftst
        fstsw ax
        and ax, C0
        jz notnegative
        mov byte [string], "-"
        inc ecx
        fchs
        notnegative:
        fld dword [power]
        loop:
        xor ebx, ebx
        fcom
        fstsw ax
        push ax
        and ax, C3
        jnz subtract
        pop ax
        and ax, C0
        jnz around
        fdiv dword [ten]
        jmp loop

        around:
        
        fxch
        subtract:
        inc ebx
        fsub st0, st1
        fcom
        fstsw ax
        and ax, C0
        jz subtract
        ftst
        fstsw ax
        and ax, C3
        jnz end

        fadd dword [round]
        fxch

        ; if factrial part
        cmp byte [point], true
        je around2
        fcom dword [one]
        fstsw ax
        and ax, C0
        jz around2
        mov byte [point], true
        mov byte [string + ecx], "."
        inc ecx
        around2:

        add bl, 30h
        mov byte [string + ecx], bl

        inc ecx
        cmp ecx, [rbp + 16]
        jne loop
        end:
        pop rbx
        pop rax
        pop rcx
        mov rsp, rbp

        ret