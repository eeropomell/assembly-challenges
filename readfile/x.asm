%include "MACRO.asm"


; reads the file and prints the highest number, the name of the person who had the highest number and the number of columns


section .bss 
    num resb 5
    name resb 20

section .data
    filename db "records.dat", 0
    
section .text
    global _start 

    _start:

        openfile filename
        push rax
        call skateboard
        printNumber rdi             ; highest number
        print name, 20              ; name of highest number 
        printNumber rbx             ; columns

        ; example display
        
        ; 500000
        ; future
        ; 10

        exit

        skateboard:
            mov rbp, rsp
            sub rsp, 16
            mov byte [rbp - 8], 0
            xor ebx, ebx
            mov ecx, 2

            line:
                mov edi, [rbp + 8]
                mov eax, SYSREAD
                mov esi, buffer
                mov edx, 28
                syscall
                cmp eax, 0
                jz out
                inc ebx
                mov esi, buffer
                mov [rbp - 16], esi
                mov edx, [num]
                mov edi, num
                xor [edi], edx
                xor ecx, ecx
                column:
                    xor eax, eax
                    mov al, [esi]
                    inc esi

                    cmp ecx, 20
                    jl end
                    cmp al, " "
                    je end
                    mov [edi], al
                    inc edi


                end:
                inc ecx
                cmp ecx, 26
                jle column
   

            stringToNumber num  

            ; if number is higher than current highest                    
            cmp edi, [rbp - 8]                     
            jle around
            mov [rbp - 8], edi
            mov esi, [rbp - 16]                     ; starting address of the current line
            mov edi, name                           
            mov ecx, 19
            rep movsb
            mov byte [edi], 10
            around: 
            jmp line

            out:
            mov rsp, rbp
            mov edi, [rbp - 8]              ; higher number
            ret 8

        
            
            

            

            



        


        
        






        
