; Made by F1L1Pv2
BITS 64
section .bss
	operator: resb 100
	operator_len: equ $-operator
	first_number: resb 100
	first_number_len: equ $-first_number
	second_number: resb 100
	second_number_len: equ $-second_number
	continue: resb 1
	continue_len: equ $-continue
	result: resb 100
	result_len: equ $-result
section .data
	welcome_msg: db "Welcome Into my beautiful calculator written in assembly",10,"Made by F1L1Pv2",10,"Operations:",10,"1.add",10,"2.sub",10,"3.mul",10,"4.div",10,"Put operation: "
	welcome_msg_len: equ $-welcome_msg
	first_number_msg: db "Put First number: "
	first_number_msg_len: equ $-first_number_msg
	second_number_msg: db "Put second number: "
	second_number_msg_len: equ $-second_number_msg
	result_msg: db "Result is: "
	result_msg_len: equ $-result_msg
	want_continue_msg: db "Do you want to continue? (y/n): "
	want_continue_msg_len: equ $-want_continue_msg
	not_implemented_msg: db "Currently Not implemented",10
	not_implemented_msg_len: equ $-not_implemented_msg
	operator_err_msg: db "Not a valid operator", 10
	operator_err_msg_len: equ $-operator_err_msg
	not_a_number_msg: db "Not a number",10
	not_a_number_msg_len: equ $-not_a_number_msg

section .text

global _start

read:
	mov rax, 0
	mov rdi, 0
	syscall
	ret

write:
	mov rax, 1
	mov rdi, 1
	syscall
	ret

error:
	mov rax, 60
	mov rdi, 1
	syscall

not_implemented:

	mov rsi, not_implemented_msg
	mov rdx, not_implemented_msg_len
	call write

	call error
	
operator_err:
	mov rsi, operator_err_msg
	mov rdx, operator_err_msg_len
	call write

	mov rdi, rax
	mov rax, 60
	syscall


add_f:
	; rbx first number
	; rcx second number

	add rbx, rcx

	mov rax, rbx
	mov rsi, result
	call parse_number_into_buff
	
	add rdx, 1
	add rsi, rdx
	mov byte[rsi], 10

	; output in result buff
	ret
sub_f:
	; rbx first number
	; rcx second number

	sub rbx, rcx

	mov rax, rbx
	mov rsi, result
	call parse_number_into_buff

	add rdx, 1
	add rsi, rdx
	mov byte[rsi], 10



	; output in result buff
	ret
mul_f:
	; rbx first number
	; rcx second number

	mov rax, rbx
	mul rcx

	mov rsi, result
	call parse_number_into_buff


	add rdx, 1
	add rsi, rdx
	mov byte[rsi], 10



	; output in result buff
	ret
div_f:
	; rbx first number
	; rcx second number
	
	mov rdx, 0
	mov rax, rbx
	div rcx

	mov rsi, result
	call parse_number_into_buff

	add rdx, 1
	add rsi, rdx
	mov byte[rsi], 10




	; output in result buff
	ret

check_operator:
	
	mov rax, 0
	mov byte al, [operator]
	;mov byte al, [op]
	cmp rax, '1'
	je check_operator_out
	cmp rax, '2'
	je check_operator_out
	cmp rax, '3'
	je check_operator_out
	cmp rax, '4'
	je check_operator_out
	jne operator_err	

	check_operator_out:
	ret

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

	cmp bl, '0'
	jl parse_buff_into_number_loop_out	
	cmp bl, '9'
	jg parse_buff_into_number_loop_out	

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

	parse_buff_into_number_loop_out:
	; output in rax
	ret


string_int_len:
	; buff adress in rsi
	mov rcx, 0
	string_int_len_loop:
	mov rbp, rsi
	add rbp, rcx
	mov byte dl, [rbp] 

	add rcx,1
	
	cmp dl, '0'
	jl string_int_len_finish	
	cmp dl, '9'
	jg string_int_len_finish	

	jmp string_int_len_loop

	string_int_len_finish:

	mov rdx, rcx
	sub rdx, 1


	;out in rdx
	ret


calculate:

	pop rbx
	pop rax
	push rbx
	push rax ; save operator

	; TODO: parse both inputs and then put them into registers rbx and rcx

	; first bro
	mov rsi, first_number
	
	;mov rsi, first_test

	call string_int_len

	call parse_buff_into_number

	push rax ; save output of first number

	; second bro

	mov rsi, second_number
	
	;mov rsi, second_test

	call string_int_len

	call parse_buff_into_number
	mov rcx, rax ; get second number

	pop rbx ; restore first number

	pop rax ; restore operator
	
	; theese boys are supposed to put calculated result into 'result' buff
	cmp rax, '1'
	je add_f
	cmp rax, '2'
	je sub_f
	cmp rax, '3'
	je mul_f
	cmp rax, '4'
	je div_f
	jne operator_err


	mov rsi, result
	mov rax, [result]

	mov rdx, result_len
	call parse_number_into_buff	
	ret

_start:

	; Print welcome message
	mov rsi, welcome_msg
	mov rdx, welcome_msg_len
	call write

	; Get operation
	mov rsi, operator
	mov rdx, operator_len
	call read

	; Check if operator is valid

	call check_operator
	push rax

	; Print get first number
	mov rsi, first_number_msg
	mov rdx, first_number_msg_len
	call write

	; Get first number
	mov rsi, first_number
	mov rdx, first_number_len
	call read

	; Print get second number

	mov rsi, second_number_msg
	mov rdx, second_number_msg_len
	call write
	
	; Get second number
	
	mov rsi, second_number
	mov rdx, second_number_len 
	call read

	; Calculate
	call calculate

	; Print result
	mov rsi, result_msg
	mov rdx, result_msg_len
	call write
	
	mov rsi, result
	mov rdx, result_len
	call write

	mov rax, 60
	mov rdi, 0
	syscall
