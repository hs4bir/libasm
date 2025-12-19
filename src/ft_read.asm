	; ft_read by hs4bir
	; 19.06.2022
	; nasm -f elf64 ft_read.asm

	; function prototype -> read(int fd, char *buf, size_t count)
	; attempts to read o count from fd into buf.

	segment .text

	global ft_read
	extern __errno_location

ft_read:
	;   Move 0x00 the number of read systemcall in the syscall table structure to rax
	mov rax, 0x00
	;   Invoke syscall
	syscall
	ret

	;   Check for error
	cmp rax, 0
	jl  _error

_error:
	neg  rax
	mov  rdi, rax
	call __errno_location wrt ..plt
	mov  [rax], rdi
	mov  rax, -1
	ret
