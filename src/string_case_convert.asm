assume cs:codesg, ds:datasg

datasg segment
        db 'FIrst'
        db 'sEcOn'
datasg ends

codesg segment
start:  mov ax, datasg
        mov ds, ax

        mov cx, 5h
        mov bx, 0h
flag:   mov al, ds:[0h+bx]
        or al, 00100000b        ; upper to lower
        mov ds:[0h+bx], al

        mov al, ds:[5h+bx]
        and al, 11011111b       ; lower to upper
        mov ds:[5+bx], al
        inc bx
        loop flag

        mov ax, 4c00h
        int 21h
codesg ends
end start