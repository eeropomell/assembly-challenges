%include "MACRO.asm"

; reverses a string idk what you expected
; takes in a source and a destination
; also works when they are equal

%macro reverseString 2
    mov edi, %1
    mov eax, %2
    copyString edi, tempString          ; store it in a copy
    mov r8d, tempString
    mov [eax], r8d                      ; make destination point at copy
    getStringLength tempString         ;returns ecx
    mov ebx, ecx
    xor ecx, ecx

    mov ebp, 0

    push rax
    divideBy2 ebx
    mov ebp, eax
    pop rax

    ; loop switches current index with opposite index
    ; for example if string length is 10 and current index is 2
    ; it will exchange characters at index 2 and index 8
    %%loop:
        sub ebx, 1              

        mov sil, [tempString + ecx]
        xchg sil, [tempString + ebx]
        mov [tempString + ecx], sil
        inc ecx
        cmp ecx, ebp                    ;loop until reaches half of string
        jne %%loop
%endmacro

section .bss 
    stringLength resq 1
    rString resb 20
    tempString resb 20

section .data
    string db "NERD", 10
    string2 db "StrangerThings", 10

section .text
    global _start

    _start:

                      ;source  ;destination
        reverseString string2, rString
        
        print [string], 15          ;sgnihTregnartS
        exit
