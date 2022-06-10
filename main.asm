%include "MACRO.asm"



section .bss 
    string resb 32
    num resb 5

section .text
    global _start 

    _start: 
        input num
        stringToNumber num
        push string
        push rdi
        call skateboard
        print string, 32

        exit

        skateboard: 
            mov rbp, rsp
            mov edi, [rbp + 16]

            mov al, "1"
            mov ecx, 32
            rep stosb
            dec edi

            mov eax, [rbp + 8]
            mov ebx, 2
            mov ecx, 32
            binary:
                cdq
                div ebx
                add dl, 48
                mov byte [edi], dl
                dec edi
                loop binary

            ret 16

            
        



        

        
        
        


   
        


        

        

        


                
               
                
   




