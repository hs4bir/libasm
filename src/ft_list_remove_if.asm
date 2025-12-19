segment .text
global  ft_list_remove_if
extern  free

	; t_list structure layout:
	; +0: data (void *)
	; +8: next (t_list *)
	; Total size: 16 bytes

	; void ft_list_remove_if(t_list **begin_list, void *data_ref, int (*cmp)(), void (*free_fct)(void *))
	; rdi = begin_list
	; rsi = data_ref
	; rdx = cmp function
	; rcx = free_fct function

ft_list_remove_if:
	;    Save callee-saved registers
	push rbx
	push r12
	push r13
	push r14
	push r15

	test rdi, rdi
	jz   _remove_done

	;   r12 = begin_list (pointer to pointer)
	mov r12, rdi
	;   r13 = data_ref
	mov r13, rsi
	;   r14 = cmp function
	mov r14, rdx
	;   r15 = free_fct function
	mov r15, rcx

_remove_loop:
	;    rbx = *begin_list (current node)
	mov  rbx, [r12]
	test rbx, rbx
	jz   _remove_done

	;;   Call cmp(current->data, data_ref)
	;    Save begin_list pointer
	push r12

	;    rdi = current->data
	;    rdi = data_ref
	mov  rdi, [rbx]
	mov  rsi, r13
	call r14

	;   Restore the begin_list pointer
	pop r12

	test rax, rax
	jnz  _continue

	;;  Remove this node
	;   rcx = current->next
	mov rcx, [rbx + 8]
	;   *begin_list = current->next
	mov [r12], rcx

	;    Free the data
	push r12
	push rbx

	;    rdi = current->data
	mov  rdi, [rbx]
	;    Call free_fct(rdi)
	call r15

	;    Restore node pointer
	pop  rbx
	mov  rdi, rbx
	call free

	pop r12

	jmp _remove_loop

_continue:
	;   begin_list = &(current->next)
	lea r12, [rbx+8]
	jmp _remove_loop

_remove_done:
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	ret
