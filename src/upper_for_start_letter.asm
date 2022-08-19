assume cs:codesg, ds:datasg

datasg segment
        db '1. file         '
        db '2. edit         '
        db '3. search       '
        db '4. view         '
        db '5. options      '
        db '6. help         '
datasg ends

codesg segment
start:  mov ax, datasg
        mov ds, ax

        mov cx, 6h
        mov si, 0h

flag:   mov al, ds:3h[si]
        sub al, 20h
        mov ds:3h[si], al
        add si, 10h
        loop flag

        mov ax, 4c00h
        int 21h
codesg ends
end start