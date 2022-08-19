assume cs:code, ds:data

data segment
        db 'UNIX'
        db 'fork'
        db 'hello', 'hi', 'nihao'
data ends

code segment
        
start:  mov ax, data
        mov ds, ax

        mov al, 'a'
        mov bl, 'b'
        mov ax, 4c00h
        int 21h

code ends

end start