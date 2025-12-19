	; ft_strcmp by hs4bir
	; 19.06.2022
	; nasm -f elf64 ft_strcmp.asm

	; function prototype -> strcmp(char *s1, char *s2)
	; returns 0 if the strings are equal
	; rdi register -> the first argument
	; rsi register -> the second argument

	segment .text; the text segment or section is dedicated to the actual code - aka code segment.

	global ft_strcmp

ft_strcmp:
	;   index = 0
	xor rcx, rcx

_loop_cmp:
	;     Load s1[i] and d2[i] (zero-extended)
	movzx rax, byte[rdi + rcx]
	movzx rdx, byte[rsi + rcx]

	;   Compare characters
	cmp al, dl
	jne _diff

	;    Check null terminator
	test al, al
	jz   _equal

	inc rcx
	jmp _loop_cmp

_diff:
	;   s1[i] - s2[i]
	sub rax, rdx
	ret

_equal:
	xor rax, rax
	ret

