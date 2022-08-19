assume cs:code

code segment

        mov bx, 0h
        mov cx, 16
        ; mov cx, 8
        
        mov ax, 0ffffh
        mov ds, ax
        mov ax, 0020h
        mov es, ax

flag:   mov al, ds:[bx]
        mov es:[bx], al
        inc bx
        ; mov ax, ds:[bx]
        ; mov es:[bx], ax
        ; add bx, 2h

        loop flag

        mov ax, 4c00h
        int 21h

code ends
end