

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
    buffer resb 20

section .data
    newline db 10
    carriage db 13
    null db 0
    space db 32

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
    mov esi, %1
    mov eax, SYSWRITE
    mov edi, 1
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

;example:
;"123"  -> starting from 1

;1 + 0 * 10  = 1
;2 + 1 * 10  = 12
;3 + 12 * 10 = 123

%macro stringToNumber 1
    mov rdi, 0                 ; number stored here
    mov ebp, %1  
    mov ecx, 0 

    cmp byte [ebp], "-"
    jne %%loop
    inc ecx

    %%loop:
    xor esi, esi
    mov sil, byte [ebp + ecx]
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
        cmp byte [ebp], "-"
        jne %%around
            neg rdi
        %%around:
%endmacro

%macro getStringLength 1
    mov edx, %1
    xor ecx, ecx      ;counter

    %%loop:
        mov bl, [edx + ecx]
        inc ecx

        cmp bl, 0
        je %%exit
        cmp bl, 10
        je %%exit
        jmp %%loop
    %%exit:
    sub ecx, 1
%endmacro



%macro divideBy2 1

    xor edx, edx
    mov eax, %1
    mov esi, 2
    div esi
%endmacro

%macro copyString 2
    mov r8d, %1
    mov r9d, %2
    getStringLength r8d

    xor edx, edx
    loop:
        mov sil, byte [r8d + edx]
        mov byte [r9d + edx], sil
        inc edx

        cmp edx, ecx
        jng loop
%endmacro


%macro mathPow  2
    push rcx
    push rbx
    push rdx
    mov r15, %2
    mov rbx, %1
    mov rcx, 1
    mov rax, rbx

    cmp r15d, 1
    je %%exit
    cmp r15d, 0
    jnz %%loop
    mov rax, 1
    jmp %%exit

    %%loop:
        mul rbx

        inc rcx
        cmp rcx, r15
        jne %%loop
    
    %%exit:
    pop rdx
    pop rbx
    pop rcx
%endmacro



%macro input 1
    mov eax, SYSREAD
    mov edi, 1
    mov esi, buffer
    mov edx, 20
    syscall
    mov esi, buffer
    mov edi, %1
    %%loop:
        cmp byte [esi], 0
        je %%exitinput
        movsb
        jmp %%loop
    
    %%exitinput:
%endmacro