assume cs:codesg, ds:datasg

datasg segment
        db 0ah, 8h, 7h, 6h, 8h, 0fh, 0h, 8h
datasg ends



codesg segment
start:
        mov ax, datasg
        mov ds, ax
        mov cx, 8
        mov ax, 0
        mov bx, 0

flag:   cmp byte ptr ds:[bx], 8
        jnb next
        inc ax
next:   inc bx
        loop flag

        mov ax, 4c00h
        int 21h
codesg ends
end start