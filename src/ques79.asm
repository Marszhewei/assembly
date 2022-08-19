assume cs:codesg, ds:datasg, ss:stacksg

datasg segment
        db '1. display      '
        db '2. brows        '
        db '3. replace      '
        db '4. modify       '
datasg ends

stacksg segment stack
        dw 0, 0, 0, 0, 0, 0, 0, 0
stacksg ends

codesg segment
start:  mov ax, datasg
        mov ds, ax
        mov ax, stacksg
        mov ss, ax
        mov sp, 20h

        mov cx, 4h
        mov bx, 0h
outer:  push cx
        mov cx, 4h
        mov si, 3h
inner:  mov al, ds:[bx + si]
        and al, 11011111b
        mov ds:[bx + si], al
        inc si
        loop inner

        add bx, 10h
        pop cx
        loop outer

        mov ax, 4c00h
        int 21h
codesg ends
end start