.model small
.stack 100h
include ebcode.asm				; This file contains code for Encryption/Decryption algorithm.
include fileop.asm				; This file contains all the necessary file opeartion procdures.
.data												

edifile db 12 dup(0),0
edofile db "edoufile.txt", 0
title1 db 13,10,"File Encryption/Decryption program.$"
title2 db 13,10,"Created by Faraz Mazhar BCSF14M529.$"
opprompt db 13,10,"Please select from following: $"
op1 db 13,10,"1. Encrypt/Decrypt from file.$"
op2 db 13,10,"2. Encrypt/Decrypt from file and display.$"
op3 db 13,10,"3. Encrypt/Decrypt on console.$"
exitop db 13,10,"0. Exit.$"
opselect db 13,10,"Please enter your option: $"
rotorprompt db 13,10,"Enter rotor configration: $"
rotor1in db 13,10,"Rotor 1: $"
rotor2in db 13,10,"Rotor 2: $"
rotor3in db 13,10,"Rotor 3: $"
startprompt db 13,10,"Processing please wait. $"
endprompt db 13,10,"Process complete. $"
wrongvalue db 13,10,"Please enter correct value.$"
exitnote db 13,10,"Thank you for using this program.$"
err db 13,10, "Error; Input file does not exists.$"
textinputprompt db 13, 10, "Enter text: $"
input_prompt db 13,10, "Text before crypting: $"
output_prompt db 13,10, "Text after crypting: $"
delete_prompt db 13,10, "Delete files? $"
delete_op1 db 13,10,"1. Delete input file.$"
delete_op2 db 13,10,"2. Delete output file. (edoufile.txt)$"
delete_op3 db 13,10,"3. Delete both files. (edinfile.txt and edoutfile.txt)$"
delete_op0 db 13,10,"Press any key to exit without deleteing.$"
name_of_file db 13,10,"Enter input file name (less than 9 characters excluding .txt): $"

handle dw ?
buffer db 512 dup(0)
cryptbuffer db 512 dup(0)
letter db 0
rotor1 db ?
rotor2 db ?
rotor3 db ?
int26 db 26
displaycheck db 0
table db 65 dup("$"), "ZYXWVUTSRQPONMLKJIHGFEDCBA", 6 dup("$"), "zyxwvutsrqponmlkjihgfedcba"
.code
main proc

mov ax,@data
mov ds,ax
mov es,ax
	;Starting of the program.
	mov ah, 09h
	lea dx, title1
	int 21h
	lea dx, title2
	int 21h

main_menu:
	mov ah, 09h				; This is the main menu. This ask user to select desired operation.
	lea dx, opprompt
	int 21h
	lea dx, op1
	int 21h
	lea dx, op2
	int 21h
	lea dx, op3
	int 21h
	lea dx, exitop
	int 21h
	lea dx, opselect
	int 21h

mm:
	mov ah, 01h  				;Operation selection input
	int 21h
	cmp al, 30h
	je exitprog
	cmp al, 31h
	je en_de
	cmp al, 32h
	je en_de_dispr
	cmp al, 33h
	je en_de_conr
	
	mov ah, 09h
	lea dx, wrongvalue
	int 21h
	jmp mm
	
	en_de_dispr:
		lea dx, name_of_file 	; Here console asks for input file name.
		mov ah, 09h
		int 21h
		call read_name			;this reads name
		jmp en_de_disp
	
	en_de_conr:
		jmp en_de_con
	
	exitprog:
		jmp exit

; Op 1	
	en_de:						; This will encrypt/decrpyt data in the input file and store it in the edoufile.txt
		lea dx, name_of_file 	; Here console asks for input file name.
		mov ah, 09h
		int 21h
		call read_name			;this reads name

		lea dx, edifile
		mov al, 0
		call open
		jc open_error1
		mov handle, ax

		lea dx, buffer
		mov bx, handle
		call read
		jmp exit1
			
		open_error1:			; If input file of the given name doesn't exit, console will show an error prompt and then exit the program.
			lea dx, err
			mov ah,09h
			int 21h
			jmp exit

		exit1:
			mov bx, handle
			call close
		
	; setting up rotors	
	call rotorsetup				; This is where the first part of encryption/decrpytion occurs.
	; rotor setup end
	
	mov ah, 9
	lea dx, startprompt
	int 21h
	
	lea si, buffer
	lea di, cryptbuffer
	
	;crypting
	call crypt					; Encryption/Decryption gets stored in second buffer.
	;crypting complete
	
	lea dx, edofile
	call create
	mov al, 1
	call open
	mov handle, ax
	lea dx, cryptbuffer  		
	mov bx, handle
	mov cx, 512
	call write					; This write Encryption/Decryption buffer in the output file. 
	call close
	
	mov ah, 09
	lea dx, endprompt
	int 21h
	
	jmp main_menu
; Op 1 end

; Op 2							; This works exactly the same as above only difference
	en_de_disp:					; is that it also displays data of input file and outfile (after encryption/decrpytion).
		mov ah, 09h
		lea dx, input_prompt
		int 21h
		
		lea dx, edifile
		mov al, 2
		call open
		jc open_error2
		mov handle, ax

		lea dx, buffer
		mov bx, handle
		call read
		mov cx,ax
		call display
		jmp exit2
			
		open_error2:
			lea dx, err
			mov ah,09h
			int 21h
			jmp exit

		exit2:
			mov bx, handle
			call close
		
	; setting up rotors	
	call rotorsetup
	; rotor setup end
	
	mov ah, 9
	lea dx, startprompt
	int 21h
	
	lea si, buffer
	lea di, cryptbuffer
	
	;crypting
	call crypt
	;crypting complete
	
	mov ah, 09h
	lea dx, output_prompt
	int 21h
	
	lea dx, edofile
	call create
	mov al, 1
	call open
	mov handle, ax
	lea dx, cryptbuffer
	mov bx, handle
	mov cx, 512
	call write
	mov cx,ax
	call display
	call close
	
	mov ah, 09
	lea dx, endprompt
	int 21h

	jmp main_menu
; Op 2 end
	
; Op 3
	en_de_con:
		lea dx, textinputprompt
		mov ah, 09h
		int 21h
		
		mov cx, 512
		lea si, buffer
	
	cons:	
		mov ah, 01h
		int 21h
		cmp al, 13
		je input_end
		
		mov [si], al
		inc si
		loop cons
		
	input_end:
		call rotorsetup
	
	mov ah, 9
	lea dx, startprompt
	int 21h
	
	lea si, buffer
	lea di, cryptbuffer
	
	;crypting
	call crypt
	;crypting complete
	
	lea dx, edofile
	call create
	mov al, 1
	call open
	mov handle, ax
	lea dx, cryptbuffer
	mov bx, handle
	mov cx, 512
	call write
	call close
	
	mov ah, 09
	lea dx, endprompt
	int 21h
	jmp main_menu

exit:
	call delete_files
	lea dx, exitnote
	mov ah, 09
	int 21h
	
	mov ah,4ch
	int 21h
main endp

rotorsetup proc
		mov ah, 09h
		lea dx, rotorprompt
		int 21h
		
		mov ah, 09h
		lea dx, rotor1in
		int 21h
		mov ah, 01h
		int 21h
		mov rotor1, al
		
		mov ah, 09h
		lea dx, rotor2in
		int 21h
		mov ah, 01h
		int 21h
		mov rotor2, al
		
		mov ah, 09h
		lea dx, rotor3in
		int 21h
		mov ah, 01h
		int 21h
		mov rotor3, al
		ret
	rotorsetup endp

crypt proc
		mov cx, 512
		lea bx, table
	crypting:
		lodsb
		mov letter,al
		cmp al,"A"
		jb contencrypt
		cmp al,"Z"
		ja lowercheck
		call uppercasesub
		call endecrypt
		call uppercaseadd
		jmp contencrypt
		
	lowercheck:
		cmp al,"a"
		jb contencrypt
		cmp al,"z"
		ja contencrypt
		call lowercasesub
		call endecrypt
		call lowercaseadd
		
	contencrypt:	
		mov al, letter
		cmp al, "A"
		jb no_xlat
		cmp al, "Z"
		jb yes_xlat
		cmp al, "a"
		jb no_xlat
		cmp al, "z"
		ja no_xlat
	yes_xlat: 
		xlat
	no_xlat:
		stosb
		loop crypting
		ret
crypt endp

delete_files proc					; This proc asks about which files user want to delete.
	mov ah, 09h
	lea dx, delete_prompt
	int 21h
	lea dx, delete_op1
	int 21h
	lea dx, delete_op2
	int 21h
	lea dx, delete_op3
	int 21h
	lea dx, delete_op0
	int 21h
	lea dx, opselect
	int 21h
	mov ah, 01h
	int 21h
	
	cmp al, 30h
	je return
	cmp al, 31h
	je delete_infile
	cmp al, 32h
	je delete_outfile
	cmp al, 33h
	je delete_both
	jmp return
	
	delete_infile:
		lea dx, edifile
		mov ah, 41h
		int 21h
		jmp return
	
	delete_outfile:
		lea dx, edofile
		mov ah, 41h
		int 21h
		jmp return
	
	delete_both:
		lea dx, edifile
		mov ah, 41h
		int 21h
		lea dx, edofile
		mov ah, 41h
		int 21h
		jmp return
		
	return:
		ret
delete_files endp

end main