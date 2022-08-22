assume cs:codesg

codesg segment

        mov ax, 4c00h   ; cs : 0000h
        int 21h

start:  mov ax, 0
s:      nop             ; s:  cs : 0008h
        nop             ; jmp 0000h

        mov di, offset s
        mov si, offset s2
        mov ax, cs:[si]
        mov cs:[di], ax

s0:     jmp short s

s1:     mov ax, 0
        int 21h
        mov ax, 0

s2:     jmp short s1      ; -8h
        nop

codesg ends
end start