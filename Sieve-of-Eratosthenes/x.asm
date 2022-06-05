%include "MACRO.asm"

; finds all prime numbers within a given range
; max value it can take is about 2 million
; takes ~2 seconds to complete


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
            mov r10, 0     ;starting index
            mov r11, 2     ;every nth number to be crossed out
            .loop:
                mov rax, [numbers]
                mov rbp, [arrayLength]
                crossOut rax, r10, r11, rbp           ;if this returns 0 it means all non primes are already crossed out   
                jz return               
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
        
            mov rbp, rdi                ; store in ebp
            sub rbp, 2                  ; if user enters 30 then array length should be 28
                                        ; since first array item is 2

            mov [arrayLength], rbp      ; save in pointer
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
            mov r8d, 2          ; value
            mov r9d, 0          ; index
            
            .loop:
                mov rax, [numbers]

                cmp byte [rax + r9], 0
                je handlePrime
                
                loopend:
                    inc r9d
                    inc r8d
                    cmp r9, rbp        ;return at array length
                    jnge .loop
                    ret
                    
            handlePrime:
                printNumber r8
                jmp loopend