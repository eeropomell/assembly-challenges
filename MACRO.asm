

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
true equ 1
false equ 0

C0 equ 0000000100000000b
C3 equ 0100000000000000b

infinity equ 01111111100000000000000000000000b

section .bss
    digit resb 0
    length resb 1
    number resq 1
    buffer resb 20
    result resd 1


section .data
    newline db 10
    carriage db 13
    null db 0
    space db 32
    minus db false
    point db false
    two dd 2.0
    ten dd 10.0
    round dd 0.000005
    one dd 1.0
    root dd 1.0
    three dd 3.0
    zero dd 0.0
    smallvalue dd 0.001
    testvalue dw 0

    sign db 0
    exponent dw 0
    fraction dd 0

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

    cmp esi, 9                  ; if this is greater than 9 the string has ended
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

%macro atof 1
    push rdi
    push rbx
    mov edi, %1
    fld1
    fldz

    cmp byte [edi], "-"
    jne %%loop
    mov byte [minus], true
    inc edi

    %%loop:
        mov bl, [edi]
        je %%endofstring

        cmp bl, "."
        jne around
        mov byte [point], true
        inc edi
        jmp %%loop     
        around:

        ; ascii to int
        and bx, 0Fh
        mov word [num], bx

        ; value * 10
        fld dword [ten]
        fmul
        fiadd dword [num]

        inc edi

        ; if number is after point, divisor * 10
        cmp byte [point], true
        jne %%loop
        fxch
        fmul dword [ten]
        fxch
        jmp %%loop

    %%endofstring:
        fdivr
        cmp byte [minus], true
        jne %%pop
        fchs
    %%pop:
        pop rdi
        pop rbx
%endmacro

%macro expand 1
    push rax
    mov eax, %1
    rol eax, 1
    mov byte [sign], al
    and byte [sign], 1
    rol eax, 8
    mov byte [exponent], al
    shr eax, 9
    or eax, 800000h
    mov dword [fraction], eax
    pop rax
%endmacro

%macro combine 1
    push rsi
    push rcx
    push rax
    push rbx
    push rdx
    mov esi, %1
    xor ecx, ecx
    mov eax, [fraction]
    mov ebx, [exponent]
    mov edx, [sign]
    shrd ecx, eax, 23
    shrd ecx, ebx, 8
    shrd ecx, edx, 1
    mov dword [esi], ecx
    pop rdx
    pop rbx
    pop rax
    pop rcx
    pop rsi
%endmacro

%macro normalize 1
    cmp dword [fraction], 0
    jz end
    %%loop:
        mov eax, [fraction]
        and eax, 0ff000000h
        jz %%endloop
        shr [fraction], 1
        inc word [exponent]
        jmp %%loop
    %%endloop:
    %%loop2:
        mov eax, [fraction]
        and eax, 800000h
        jnz %%end
        shl [fraction], 1
        dec word [exponent]
        jmp %%loop2
    end:
%endmacro