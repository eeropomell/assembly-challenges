

%macro exit 0
    mov rax, 60
    mov rdi, 0
    syscall
%endmacro

section .data
    filename db "first-names.txt"

section .bss 
    name resb 15

section .text
    global _start

    _start:
        
        call _open
        call _read
        call _close

        mov rax, 1
        mov rdi, 1
        mov rsi, name
        mov rdx, 16
        syscall

        
        exit

    _open:
        mov rax, 2
        mov rdi, filename 
        mov rsi, 0
        mov rdx, 0777o
        syscall
        mov rdx, rax   ; 1

        ret

    _read:
        mov rax, 0
        mov rdi, rdx
        mov rsi, name
        mov rdx, 16
        syscall


    _close:
        mov rax, 3
        mov rdi, rdx   ; 2
        syscall
        ret


  
        


    

