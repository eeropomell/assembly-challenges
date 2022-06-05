%include "MACRO.asm"

; finds all prime numbers within a given range
; max value it can take is about 4 billiongit 


%macro crossOut 3
    mov rbx, %1     ;array
    mov rcx, %3
    add rcx, rbx    ; last array element / array length

    xor edx, edx
    mov rax, %2     ;every nth number to be crossed out 
    mov rsi, rax
    imul rsi
    sub rcx, 1

    mov rax, %2
    %%loop:
        add rbx, rax
        cmp rbx, rcx
        jge %%exit

        mov byte [rbx], 1

        jmp %%loop

    %%exit:
%endmacro


section .bss 
    buffer resb 100
    numbers resq 1

section .data
    arrayLength dq 0

section .text
    global _start

    _start:
        call getLength
        call initList
        call algorithm
        call printNumbers
        
        exit

        algorithm: 
            mov r10, 2     ;starting index
            mov r11, 2     ;every nth number to be crossed out
            .loop:
                mov rax, r11
                imul r11
                cmp rax, [arrayLength]
                jg return

                mov rax, [numbers]
                mov rbp, [arrayLength]
                crossOut rax, r11, rbp           ;if this returns 0 it means all non primes are already crossed out   
                call getNextPrime                           ; get next r10d and r11d
                jmp .loop
            return:
                ret

        getNextPrime:                 ;gets the next item that isnt already crossed out (0 means not crossed)
            mov rax, [numbers]
            .loop:
                inc r10
                inc r11
     
                cmp byte [rax + r10], 0             
                jnz .loop

                ret

        getLength:
            mov eax, SYSREAD
            mov edi, 1
            mov esi, buffer
            mov edx, 100
            syscall
            stringToNumber buffer         ; returns edi as number

            mov [arrayLength], rdi      ; save in pointer
            extern malloc
            call malloc
            mov [numbers], rax          
            ret

        initList:
            mov rbx, 0          ;index
            mov rbp, [arrayLength]
            mov rax, [numbers]
            
            .loop:
                mov byte [rax + rbx], 0

                inc rbx
                cmp rbx, rbp
                jl .loop
            ret

        printNumbers:
            mov rbp, [arrayLength]
            mov r9d, 2          ; index and value
            
            printLoop:
                mov rax, [numbers]

                cmp byte [rax + r9], 0
                je handlePrime
                
                loopend:
                    inc r9d
                    cmp r9, rbp        ;return at array length
                    jnge printLoop
                    ret
                    
            handlePrime:
                printNumber r9
                jmp loopend