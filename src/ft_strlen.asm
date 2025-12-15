	; ft_strlen by hs4bir
	; 18.06.2022
	; nasm -f elf64 ft_strlen.asm

	segment .text

	global _ft_strlen

_ft_strlen:
	;    TODO: strlen doesn't handle null pointer check. Do we?
	test rdi, rdi
	jz   _null_ptr

	;   start address
	mov rax, rdi

_loop_chars:
	cmp byte [rdi], 0x0
	je  _done
	inc rdi
	jmp _loop_chars

_done:
	;   Calculate length (end - start)
	sub rdi, rax
	;   rax = return register
	mov rax, rdi
	ret

_null_ptr:
	;   Return 0 in case of NULL pointer
	xor rax, rax
	ret
