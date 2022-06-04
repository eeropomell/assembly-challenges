

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
    length resb 1
    number resb 1

; for printing numbers (int)

%macro printNumber 1
    mov rax, %1

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

%macro crossOut 4
    xor rdi, rdi     ;edi keeps track of how many numbers were crossed out
                     ;if 0 end loop
    mov rbx, %1     ;array
    add rbx, %2     ;move position to starting index
    mov rax, %3     ;every nth number to be crossed out 

    mov rbp, %4     ; array length
    mov rcx, 0      ;counter
    
    %%loop:

        add rcx, rax
        cmp rcx, rbp
        jge %%exit

        add rbx, rax
        cmp byte [rbx], 0           
        je %%crossout

        jmp %%loop
    %%crossout:
        mov byte [rbx], 1
        inc rdi
        jmp %%loop

    %%exit:
        cmp rdi, 0
%endmacro


;example:
;"123"  -> starting from 1

;1 + 0 * 10  = 1
;2 + 1 * 10  = 12
;3 + 12 * 10 = 123

%macro stringToNumber 1
    mov rdi, 0                 ; number stored here
    mov ebx, %1  
    mov ecx, 0   

    %%loop:
    xor esi, esi
    mov sil, byte [ebx + ecx]
    sub sil, 48

    cmp esi, 9                  ;if this is greater than 9 the string has ended
    jg %%exit

    mov rax, 10
    mul rdi                     ; multiply by 10
    add rsi, rax
    mov rdi, rsi

    inc ecx
    jmp %%loop
    
    %%exit:
%endmacro
