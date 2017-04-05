.code
create proc near
	mov ah,3Ch
	mov cl,1
	int 21h
	mov handle,ax
	ret
create endp

open proc near
	mov ah,3Dh
	int 21h
	ret
open endp

read proc near
	mov ah,3Fh
	mov cx,512
	int 21h
	ret
read endp

read_name proc near
	lea di, edifile
	mov cx, 12
	lp:
		mov ah, 1
		int 21h
		
		cmp al, 13
		je ret_read
		stosb
		loop lp	
	ret_read:
		ret
read_name endp

write proc near
	mov ah,40h
	int 21h
	ret
write endp

display proc near
	push bx
	mov ah,40h
	mov bx, 1
	int 21h
	pop bx
	ret
display endp

delete proc near
	mov ah,41h 
	int 21h
	ret
delete endp

close proc near
	mov ah,3Eh
	int 21h
	ret
close endp
