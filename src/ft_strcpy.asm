	; ft_strcpy by hs4bir
	; 19.06.2022
	; nasm -f elf64 ft_strcpy.asm

	segment .text

	global ft_strcpy

	; rdi -> the first argument passed
	; rsi -> the second argument passed
	; strcpy prototype -> strcpy(char *dst, char *src)

ft_strcpy:
	;   Save dst for return value
	mov rax, rdi

_loop_cpy:
	;    load from src
	mov  dl, byte[rsi]
	;    Store to dts
	mov  byte[rdi], dl
	;    Advance src and dst
	inc  rsi
	inc  rdi
	;    Was it null byte?
	test dl, dl
	jnz  _loop_cpy
	ret

