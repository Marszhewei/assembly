assume cs:code, ds:data

data segment
        db 1h, 2h, 3h, 4h, 5h, 6h, 7h, 8h
data ends

code segment
start:  mov ax, data
        mov ds, ax

        mov bx, 0h
        
        mov ax, ds:[bx+1h]
        mov ax, ds:[2h+bx]
        mov ax, ds:3h[bx]
        mov ax, ds:[bx].4h

        mov ax, 4c00h
        int 21h
code ends
end start