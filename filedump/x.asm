%include "MACRO.asm"


; an example of this program being run is at the bottom

section .bss 
    hex resb 2
    alert resb 16
    char resb 1
    filename resb 20

section .data
    TABLE db "0123456789ABCDEF", 0
    log db "Show more? (y/n)", 10, 0
    loglen equ $ -log

section .text
    global _start 

    _start:
        input filename
        
        mov eax, 2
        mov rdi, filename
        mov rsi, 0
        mov edx, 0777
        syscall


        mov ebx, TABLE
        push rax
        program:   
            mov eax, SYSREAD
            pop rdi
            push rdi
            mov esi, buffer
            mov edx, 320
            syscall
            ; check for end of file
            cmp eax, 0
            je eof
            mov edi, buffer

            ; print 20 lines
            mov ecx, 20
            printer: 
                call displayhex    
                print space, 1
                print alert, 16
                print newline, 1    
            loop printer


        print log, loglen
        input char
        cmp byte [char], "y"
        je program

        eof:
        exit


        displayhex:
            push rcx
            ; string characters stored here
            mov esi, alert
            
            ; get 16 characters from file
            mov ecx, 16
            loop:
                push rcx
                mov al, [edi]

                cmp al, 10
                je addspace
                cmp al, 13
                je continue
                mov [esi], al
                jmp continue
                addspace:
                mov byte [esi], 32
                continue:

                ; convert ascii decimal to ascii hex
                mov cx, 16
                cwd
                div cx
                push rax
                mov al, dl
                xlat
                mov [hex + 1], al
                pop rax
                cwd
                div cx
                mov al, dl
                xlat
                mov [hex], al

                
                print space, 1
                print hex, 2

                end:
                inc esi
                inc edi
                pop rcx
                dec ecx
                cmp ecx, 0
                jnz loop

            pop rcx
            ret


; 0D 0A 4C 61 76 65 6E 61 0D 0A 4C 61 76 65 72 6E u Lavena  Lavern
; 61 0D 0A 4C 61 76 65 72 6E 65 0D 0A 4C 61 76 69 a  LaverneL Lavi
; 6E 61 0D 0A 4C 61 76 69 6E 69 61 0D 0A 4C 61 76 na  Lavinia  Lav
; 69 6E 69 65 0D 0A 4C 61 79 6C 61 0D 0A 4C 61 79 inieL Layla  Lay
; 6E 65 0D 0A 4C 61 79 6E 65 79 0D 0A 4C 65 61 0D nei Layneya Leay
; 0A 4C 65 61 68 0D 0A 4C 65 61 6E 64 72 61 0D 0A  Leaha Leandraa 
; 4C 65 61 6E 6E 0D 0A 4C 65 61 6E 6E 61 0D 0A 4C Leanna Leannaa L
; 65 61 6E 6F 72 0D 0A 4C 65 61 6E 6F 72 61 0D 0A eanora Leanora  
; 4C 65 62 62 69 65 0D 0A 4C 65 64 61 0D 0A 4C 65 Lebbie  Ledar Le
; 65 0D 0A 4C 65 65 61 6E 6E 0D 0A 4C 65 65 61 6E ee Leeanne Leean
; 6E 65 0D 0A 4C 65 65 6C 61 0D 0A 4C 65 65 6C 61 ne  Leelae Leela
; 68 0D 0A 4C 65 65 6E 61 0D 0A 4C 65 65 73 61 0D he Leenaa Leesaa
; 0A 4C 65 65 73 65 0D 0A 4C 65 67 72 61 0D 0A 4C  Leesen Legras L
; 65 69 61 0D 0A 4C 65 69 67 68 0D 0A 4C 65 69 67 eiae Leighg Leig
; 68 61 0D 0A 4C 65 69 6C 61 0D 0A 4C 65 69 6C 61 haa Leilah Leila
; 68 0D 0A 4C 65 69 73 68 61 0D 0A 4C 65 6C 61 0D ha Leishah Lelaa
; 0A 4C 65 6C 61 68 0D 0A 4C 65 6C 61 6E 64 0D 0A  Lelahs Lelanda 
; 4C 65 6C 69 61 0D 0A 4C 65 6E 61 0D 0A 4C 65 6E Leliah Lenaa Len
; 65 65 0D 0A 4C 65 6E 65 74 74 65 0D 0A 4C 65 6E eel Lenettea Len
; 6B 61 0D 0A 4C 65 6E 6E 61 0D 0A 4C 65 6E 6F 72 kal Lennat Lenor
