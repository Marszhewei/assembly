assume cs:code, ds:data

data segment
        db 'abcdefgh'
        db 'IJKLMNOP'
data ends

code segment
start:  mov ax, data
        mov ds, ax

        mov cx, 8h
        mov bx, 0h

flag:   mov ax, 20h
        sub ds:[bx], ax ; lower case to upper case
        inc bx
        loop flag

        mov cx, 8h
        mov bx, 8h

flag1:  mov ax, 20h
        add ds:[bx], ax ; upper case to lower case
        inc bx
        loop flag1

        mov ax, 4c00h
        int 21h
code ends

end start