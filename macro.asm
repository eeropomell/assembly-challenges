

%macro exit 0
    mov rax, 60
    mov rdi, 0
    syscall
%endmacro

SYSREAD equ 0
SYSWRITE equ 1
SYSOPEN equ 2
SYSCLOSE equ 3
SYSSEEK equ 8

section .bss
    digit resb 0

; for printing numbers (int)

%macro printNumber 1
    mov eax, %1

    %%printInt:
        mov rcx, digit      ;set rcx to digit memory address
        mov rbx, 10         ; moving a newline into rbx
        mov [rcx], rbx      ; setting digit to rbx
        inc rcx             ; increment rcx position by one byte

    %%storeLoop:
        xor rdx, rdx        ; zero out rdx
        mov rbx, 10         
        div rbx             ; rax / rbx (10)

                            ; rdx holds the remainder of the divison
        add rdx, 48         ; add 48 to rdx to make in ascii character
                            
        mov [rcx], dl       ; get the character part of rdx
        inc rcx             ; increment digit position again

        cmp rax, 0
        jnz %%storeLoop       ; continue looping until rax is 0

    %%printLoop:
        push rcx

        ;perform sys write
        mov rax, SYSWRITE
        mov rdi, 1
        mov rsi, rcx
        mov rdx, 1
        syscall

        pop rcx
        dec rcx
        cmp rcx, digit      ; first byte of digit (10)
        jge %%printLoop

%endmacro


%macro print 2
    mov eax, SYSWRITE
    mov edi, 1
    mov esi, %1
    mov edx, %2
    syscall
%endmacro
    

%macro mod 1
    xor eax, eax
    mov r12b, %1
    mov ax, r8w
    div r12b
    cmp ah, 0
%endmacro
