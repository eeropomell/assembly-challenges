%include "MACRO.asm"

; Program for copying and making new files

section .bss 
    f2name resb 20

section .data
    nfalert db "file not found", 10, 0
    nflen equ $ -nfalert
    rpalert db "file already exists, do you want to replace it? (y/n)", 10, 0
    rplen equ $ -rpalert
    srcalert db "enter file name of file to copy:", 10, 0
    srclen equ $ -srcalert
    destalert db "enter name of new file", 10, 0
    destlen equ $ -destalert
    walert db "Bytes written: ", 0
    wlen equ $ -walert

section .text
    global _start 

    _start:
        print srcalert, srclen
        input f2name
        openfile f2name
        cmp eax, 0
        jl notfound
        push rax

        print destalert, destlen
        input f2name

        openfile f2name
        cmp eax, 0
        jl around
        print rpalert, rplen
        input buffer
        cmp byte [buffer], "y"
        jne end
        around:


        newfile f2name
        push rax
        call copyfile
        print walert, wlen
        printNumber rbx
           
        end:
            exit
   
        copyfile:
            xor ebx, ebx
            readwrite:
            mov eax, SYSREAD
            mov edi, [rsp + 16]
            mov esi, buffer
            mov edx, 50
            syscall
            cmp eax, 0
            je endofile

            ; bytes written
            add ebx, eax

            mov edx, eax
            mov edi, [rsp + 8]
            mov eax, SYSWRITE
            mov esi, buffer
            syscall
            jmp readwrite

            endofile:       
            ret

        notfound:
            print nfalert, nflen
            jmp end

        exit