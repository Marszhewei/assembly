assume cs:code

code segment

        mov ax, 2000h
        mov ds, ax

        mov bx, 1000h

        mov ax, ds:[bx]
        inc bx
        inc bx

        mov ds:[bx], ax
        inc bx
        inc bx

        mov ds:[bx], ax
        inc bx

        mov ds:[bx], al
        inc bx

        mov ax, 4c00h
        int 21h

code ends

end