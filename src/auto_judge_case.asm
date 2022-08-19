assume cs:code, ds:data

data segment
        db 'VisualBasic'
data ends

code segment
start:  mov ax, data
        mov ds, ax

        mov cx, 0Bh
        mov bx, 0h
        
flag:   mov al, ds:[bx]
        and al, 11011111b   ; if a letter is lower case, convert it to upper
        mov ds:[bx], al
        inc bx
        loop flag

        mov ax, 4c00h
        int 21h
code ends
end start