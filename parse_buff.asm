BITS 64
section .bss
	input: resb 100
	input_len: equ $-input
	output: resb 100
	output_len: equ $-input


section .data
	test: db "10"
	test_len: equ $-test

section .text
global _start

int_len:
	; input in rax
	push rax ; save initial value of rax

	mov rcx, 0
	int_len_loop:
	mov rdx, 0
	mov rbx, 10
	div rbx

	add rcx, 1
	cmp rax, 0
	jne int_len_loop	

	mov rdx, rcx

	; output in rdx
	pop rax ; restore initial value of rax

	ret

parse_number_into_buff:
	; number input in rax
	; buff adress in rsi
	call int_len ; get int len


	mov rcx, 0
	push rax
	parse_number_into_buff_loop:
	mov rbp, rsi
	add rbp, rdx
	sub rbp, rcx ; calculate offset

	push rdx

	mov rdx, 0
	mov rbx, 10
	div rbx ; number in modulo (rdx)

	add rdx, '0' ; convert to ascii values
	
	mov byte[rbp], dl ; put into buff

	pop rdx

	add rcx, 1 ; update iterator
	cmp rcx, rdx
	jne parse_number_into_buff_loop

	pop rax
	

	

	; output in provided buff
	ret

pow:
	;base in rax
	;pow in rbx
	push rcx
	push rdx
	push rbp

	cmp rbx,0
	je pow_zero

	cmp rbx,1
	je pow_out

	sub rbx, 1	

	mov rcx, 0
	mov rbp, rax
	pow_loop:

	mul rbp

	add rcx, 1	
	cmp rcx, rbx
	jne pow_loop	

	jmp pow_out

	pow_zero:
	mov rax, 1


	;output in rax
	pow_out:
	pop rbp
	pop rdx
	pop rcx
	ret

parse_buff_into_number:
	; buff adress in rsi
	; buff len in rdx
	mov rax, 0
	mov rcx, 0

	parse_buff_into_number_loop:
	mov rbp, rsi
	add rbp, rcx
	
	mov rbx, 0
	mov byte bl, [rbp] ; get character

	sub rbx, '0' ; convert to number
	


	push rdx ; save buff len

	sub rdx, rcx ; get pow 

	push rax
	push rbx
	
	sub rdx, 1

	mov rax, 10
	mov rbx, rdx
	call pow

	pop rbx

	mul rbx

	mov rbx, rax

	pop rax

	add rax, rbx

	pop rdx

	add rcx,1
	cmp rcx, rdx
	jne parse_buff_into_number_loop	


	; output in rax
	ret

_start:

	;mov rax, 3232
	;mov rsi, output
	;call parse_number_into_buff

	;add rdx, 1
	;add rsi, rdx

	;mov byte[rsi], 10 ; add new line	

	
	;mov rax, 1
	;mov rdi, 1
	;mov rsi, output
	;mov rdx, output_len
	;syscall

	mov rsi, test
	mov rdx, test_len
	call parse_buff_into_number

	mov rdi, rax
	mov rax, 60
	syscall


	mov rax, 60
	mov rdi, 0
	syscall
