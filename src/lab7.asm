assume cs:codesg

datasg segment

        db '1975', '1976', '1977', '1978', '1979'
        db '1980', '1981', '1982', '1983', '1984', '1985', '1986', '1987', '1988', '1989'
        db '1990', '1991', '1992', '1993', '1994', '1995'                                       ; yaer

        dd 16, 22, 382, 1356, 2390, 8000, 16000, 24486, 50065, 97479, 140417, 197514
        dd 345980, 590827, 803530, 1183000, 1843000, 2759000, 3753000, 4649000, 5937000         ; total revenue

        dw 3, 7, 9, 13, 28, 38, 130, 220, 476, 778, 1001, 1442, 2258, 2793, 4037, 5635, 8228
        dw 11542, 14430, 15257, 17800                                                           ; total people
datasg ends



table segment

        db 21 dup ('.... .... .. .. ')
table ends



stacksg segment stack

        db 20 dup (0)
stacksg ends



codesg segment

start:  mov ax, datasg
        mov ds, ax
        mov ax, table
        mov es, ax

        mov cx, 21
        mov bp, 0h
        mov bx, 0h
        mov di, 0h

outer:  push cx

        mov cx, 2h
        mov si, 0h
year:   mov ax, ds:[bp + si]
        mov es:[bx + si], ax
        add si, 2h
        loop year

        mov cx, 2h
        mov si, 0
income: mov ax, ds:[bp + si + 84]
        mov es:[bx + si + 5], ax
        add si, 2h
        loop income

        mov ax, ds:[di + 168]
        mov es:[bx + 10], ax
        
        mov ax, ds:[bp + 84]
        mov dx, ds:[bp + 2 + 84]
        div word ptr ds:[di + 168]
        mov es:[bx + 13], ax
        
        add bp, 4h
        add di, 2h
        add bx, 10h
        pop cx
        loop outer

        mov ax, 4c00h
        int 21h
codesg ends
end start