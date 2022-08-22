assume cs:codesg, ds:datafrom, es:datato

datafrom segment
        db 1, 2, 3, 4, 5, 6, 7, 8
        db 9, 10, 11, 12, 13, 14, 15, 16
datafrom ends


datato segment
        db 16 dup (0)
datato ends


codesg segment
start:
        mov ax, datafrom
        mov ds, ax
        mov ax, datato
        mov es, ax

        ; mov cx, 10h
        mov cx, 8
        mov si, 0
        mov di, 0

        ; rep movsb
        rep movsw

        mov ax, 4c00h
        int 21h
codesg ends
end start