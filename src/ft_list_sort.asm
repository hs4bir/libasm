segment .text
global  ft_list_sort

	; t_list structure layout:
	; +0: data (void *)
	; +8: next (t_list *)
	; Total size: 16 bytes

	; void ft_list_sort(t_list **begin_list, int (*cmp)())
	; rdi = begin_list
	; rsi = cmp function pointer

ft_list_sort:
	;    save callee-saved registers
	push rbx
	push r12
	push r13

	;    Check if the begin_list is null
	test rdi, rdi
	jz   _sort_done

	;    r12 = *begin_list (head)
	mov  r12, [rdi]
	test r12, r12
	jz   _sort_done

	;   r13 = cmp function pointer
	mov r13, rsi

_outer_loop:
	;   swapped = false
	xor bl, bl
	;   current = head
	mov rcx, r12

_inner_loop:
	;    rdx = current->next
	mov  rdx, [rcx + 8]
	test rdx, rdx
	jz   _check_swapped

	;    Call cmp(current->data, next->data)
	push rcx
	push rdx

	mov  rdi, [rcx]
	mov  rsi, [rdx]
	call r13

	pop rdx
	pop rcx

	;   current > next ?
	cmp rax, 0
	;   Skip if in order
	jle _next_node

	;;  swap pointers
	;   rax = current->data
	mov rax, [rcx]
	;   rbx = next->data
	mov rbx, [rdx]
	;   current->data = next->data
	mov [rcx], rbx
	;   next->data = current->data
	mov [rdx], rax

	;   swapped = true
	mov bl, 1

_next_node:
	;   current = current->next
	mov rcx, [rcx + 8]
	jmp _inner_loop

_check_swapped:
	test bl, bl
	;    continue if swapped
	jnz  _outer_loop

_sort_done:
	;   Restore the callee-saved registers
	pop r12
	pop r12
	pop rbx
	ret
