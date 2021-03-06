; Siddharth Rajan
; CSC 21000
; Project 2: Text Editor
; Program to implement basic text editor, open, read, write, and save a file.

.model tiny

.data
WS  equ  20h
filename db 'txt3.txt', 0	
handle dw 0
buffer db 2000 DUP(?)

edit dw 0

.code
org 100h

start:

    mov ah,06h		        ; set background color
    mov al, 00h
    xor cx, cx
    mov dx,184fh
    mov bh,4eh
    int 10h

    mov ah, 3
    int 10h
    mov ah, 02h
    mov dh, 0		; set initial cursor for reading/writing buffer
    mov dl, 0
    mov bh, 0
    int 10h

    mov ah, 3dh				; open file for reading (txt3)
    mov al, 0
    mov dx, offset filename
    int 21h
    mov handle, ax

    mov ah, 3fh				     ; read from file (txt3)
    mov bx, handle
    mov cx, 2000
    mov dx, offset buffer
    int 21h

    mov dx, offset buffer
    add dx, ax
    mov bx, dx
    mov byte ptr [bx], '$'

    mov dx, offset buffer	      ; print data read (txt3)
    mov ah, 9
    int 21h

    mov ah, 3
    int 10h
    mov ah, 02h
    mov dh, 0		         ; set cursor at beginning again
    mov dl, 0
    mov bh, 0
    int 10h

    mov ah, 3eh                   ; close file (txt3)
    mov bx, handle
    int 21h

    mov si, offset buffer         ; user inputs
    input:
    mov ah, 0
    int 16h
    
    cmp ah, 4Dh           ; right Arrow key (key code)
    je right

    cmp ah, 4Bh           ; left Arrow key (key code)
    je left

    cmp al, 8             ; backspace key (ascii)
    je erase

    cmp al, 27            ; escape key (ascii)
    je exit

    cmp al, 9             ; tab key (ascii)
    je tab

    mov [si], al          ; anything else, write in buffer
    inc si
    mov edit, 1

    mov ah,0ah            ; print character in buffer
	mov cx,1
	mov bh,0
	int 10h

	add dl, 1
	mov ah, 2
	mov bh, 0
	int 10h

	jmp input

right:
    inc si
    mov ah, 3       
    int 10h

    mov ah, 2           ; move cursor right one space
    add dl, 1
    int 10h

    jmp input

left:
    dec si
    mov ah, 3  
    int 10h

    mov ah, 2           ; move cursor left one space
    sub dl, 1
    int 10h

    jmp input

tab:
    mov ah, 3
    int 10h

    mov ah, 2           ; move cursor right four spaces
    add dl, 4
    int 10h

    inc si
    inc si
    inc si
    inc si

    jmp input

erase:

	mov ah,02h
	sub dl, 1
	mov bh,0
	int 10h

	mov ah,0ah
	mov al,WS
	mov cx,1
	int 10h
    
    dec si
    mov al, WS
    mov [si], al
    mov edit, 1
	jmp input

exit:

    cmp edit, 0
	je close

    mov ah, 3dh         ; open file for writing (txt3)
    mov al, 1
    mov dx, offset filename
    int 21h
    mov handle, ax

    mov ah, 40h
    mov bx, handle          ; write to file (txt3)
    mov cx, word ptr 2000
    mov dx, offset buffer
    int 21h

    mov ah, 3eh     ; close file (txt3)
    mov bx, handle
    int 21h

close:
    mov ax, 003h
    int 10h

	mov ah, 4ch     ; quit
	int 21h

end start