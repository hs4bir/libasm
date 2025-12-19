	; ft_strdup by hs4bir
	; 23.06.2022
	; nasm -f elf64 ft_strdip.asm

	; function prototype -> strdup(const char *s1)
	; allocates sufficient memory for a copy of the string 's1' and copy it.
	; returns a string of chars
	; rdi register -> the argument 's1'

	segment .text

	global ft_strdup
	extern ft_strlen
	extern ft_strcpy
	extern __errno_location
	extern malloc

ft_strdup:
	;    Null check
	test rdi, rdi
	jz   _null_input

	;    Save original string pointer to the top of the stack
	push rdi
	;    Call strlen on rdi (already set)
	call ft_strlen
	;    +1 for null terminator sanity
	inc  rax

	;    mov the size to rdi
	mov  rdi, rax
	call malloc wrt ..plt

	;    Check malloc errors
	test rax, rax
	jz   _malloc_error

	;    dst = allocated memory
	mov  rdi, rax
	;    src = original string on the top of the stack.
	pop  rsi
	call ft_strcpy
	ret

_malloc_error:
	;    clean up the stack
	pop  rdi
	call __errno_location wrt ..plt
	;    12: ENOMEM
	mov  dword [rax], 12
	xor  rax, rax
	ret

_null_input:
	call __errno_location wrt ..plt
	;    22: EINVAL
	mov  dword [rax], 22
	xor  rax, rax
	ret

