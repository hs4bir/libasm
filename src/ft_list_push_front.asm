segment .text
global  ft_list_push_front
extern  malloc

	; t_list structure layout:
	; +0: data (void *)
	; +8: next (t_list *)
	; Total size: 16 bytes

	; void ft_list_push_front(t_list **begin_list, void *data)
	; rdi = begin_list (pointer to pointer)
	; rsi = data

ft_list_push_front:
	;    save begin_list, and data on the stack
	push rdi
	push rsi

	;    sizeof(t_list) = 16 bytes
	mov  rdi, 16
	;    allocate a new node, new_node = rax
	call malloc

	;    Check for malloc failure
	test rax, rax
	jz   _malloc_failed

	;   restore data, and begin_list in that order from the stack
	pop rsi
	pop rdi

	;   new_node->data = data
	mov [rax], rsi
	;   rcx = *begin_list (old head)
	mov rcx, [rdi]
	;   new_node->next = old_head
	mov [rax + 8], rcx
	;   *begin_list = new_node
	mov [rdi], rax

	ret

_malloc_failed:
	pop rsi
	pop rdi
	ret

