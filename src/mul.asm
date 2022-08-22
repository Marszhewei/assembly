assume cs:codesg

codesg segment
start:  mov al, 100
        mov ah, 10
        mul ah

        mov ax, 4c00h
        int 21h
codesg ends
end start