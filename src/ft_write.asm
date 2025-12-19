	; ft_write by hs4bir
	; 19.06.2022
	; nasm -f elf64 ft_strlen.asm

	; function prototype -> write(int fd, const char *buf, size_t nbyte)
	; writes nbyte from buf on the specified fd.

	segment .text

	extern __errno_location
	global ft_write

ft_write:
	;   Call the write system-call, its number in the systemcall table structure is 0x01 for x64 arch
	mov rax, 0x01
	syscall
	ret

	;   Check for err
	cmp rax, 0
	jl  _error
	ret

_error:
	;    Make error code positive
	neg  rax
	;    Save error code
	mov  rdi, rax
	;    Get errno address. Note, we should call ___error on macOS
	call __errno_location wrt ..plt
	;    store error code at errno location
	mov  [rax], rdi
	mov  rax, -1
	ret

