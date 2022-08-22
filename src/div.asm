assume cs:codesg

codesg segment
start:  mov dx, 1h
        mov ax, 86A1h
        mov bx, 100
        div bx

        mov ax, 1001
        mov bl, 100
        div bl

        mov ax, 4c00h
        int 21h
codesg ends
end start