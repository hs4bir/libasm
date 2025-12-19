segment .text
global  ft_list_size

	; t_list structure layout:
	; +0: data (void *)
	; +8: next (t_list *)
	; Total size: 16 bytes

	; int ft_list_size(t_list *begin_list)
	; rdi = begin_list

ft_list_size:
	xor  rax, rax
	;    Check if the list is null
	test rdi, rdi
	jz   _done

_count_loop:
	inc  rax
	;    rdi = current->next
	mov  rdi, [rdi + 8]
	test rdi, rdi
	jnz  _count_loop

_done:
	ret
