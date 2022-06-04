%include "MACRO.asm"


section .bss 
    buffer resb 100
    numbers resb 0

section .data
    arrayLength db 0

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
            loop3:
                mov rax, [numbers]
                mov rbp, [arrayLength]
                crossOut rax, r10, r11, rbp           ;if this returns 0 it means all non primes are already crossed out   
                jz return               
                call getIndex                           ; get next r10d and r11d
                jmp loop3
            return:
                ret

        getIndex:                 ;gets the next item that isnt already crossed out (0 means not crossed)
            mov rax, [numbers]
            loop2:
                inc r10
                inc r11

                mov r12b, byte [rax + r10]             
                cmp r12b, 0                     
                jnz loop2

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
            
            initloop:
                mov byte [rax + rbx], 0

                inc rbx
                cmp rbx, rbp
                jl initloop
            ret

        printNumbers:
            mov rbp, [arrayLength]
            mov r8d, 2          ; value
            mov r9d, 0          ; index
            
            printLoop:
                mov rax, [numbers]
                mov r11b, byte [rax + r9]

                cmp r11b, 0
                je handlePrime
                
                loopend:
                    inc r9d
                    inc r8d
                    cmp r9, rbp        ;return at array length
                    jnge printLoop
                    ret
                    
            handlePrime:
                printNumber r8
                jmp loopend


;ld -g -o main main.o -dynamic-linker /lib64/ld-linux-x86-64.so.2 -lc -m elf_x86_64
; nasm -gdwarf -f elf64 main.asm
; ld -m elf_x86_64 -g -o main main.o


    

