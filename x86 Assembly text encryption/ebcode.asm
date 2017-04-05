.code
rotor1r proc
	inc rotor1
	cmp rotor1, 26
	jne return_rotor1
	call rotor2r
	
	return_rotor1:
		mov ah, 0
		mov al, rotor1
		div int26
		mov rotor1, ah
		
	ret
rotor1r endp

rotor2r proc
	inc rotor2
	cmp rotor2, 26
	jne return_rotor2
	call rotor3r
	
	return_rotor2:
		mov al, rotor2
		mov ah, 0
		div int26
		mov rotor2, ah
		
	ret
rotor2r endp

rotor3r proc
	inc rotor3
	mov al, rotor3
	mov ah, 0
	div int26
	mov rotor3, ah
	
	ret
rotor3r endp

uppercasesub proc
sub letter,"A"
ret
uppercasesub endp

uppercaseadd proc
add letter,"A"
ret
uppercaseadd endp

lowercasesub proc
sub letter,"a"
ret
lowercasesub endp

lowercaseadd proc
add letter,"a"
ret
lowercaseadd endp

endecrypt proc
	
	mov ax, 0
	mov al, letter
	add al, rotor1
	add al, rotor2
	add al, rotor3
	mov ah, 0
	div int26
	mov al, ah
	mov letter, ah
	call rotor1r
	
	ret
endecrypt endp