	.file	"hash_functions.cpp"
	.text
	.section	.rodata
	.align 8
	.type	_ZL12BigArraySize, @object
	.size	_ZL12BigArraySize, 8
_ZL12BigArraySize:
	.quad	16
	.align 8
	.type	_ZL13ContainerSize, @object
	.size	_ZL13ContainerSize, 8
_ZL13ContainerSize:
	.quad	1048576
	.text
	.globl	_Z9djb2_hashPc
	.type	_Z9djb2_hashPc, @function
_Z9djb2_hashPc:
.LFB4876:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -24(%rbp)
	movl	$5381, -8(%rbp)
	movl	$0, -4(%rbp)
	jmp	.L2
.L3:
	movl	-8(%rbp), %eax
	sall	$5, %eax
	movl	%eax, %edx
	movl	-8(%rbp), %eax
	addl	%eax, %edx
	movl	-4(%rbp), %eax
	addl	%edx, %eax
	movl	%eax, -8(%rbp)
.L2:
	movq	-24(%rbp), %rax
	leaq	1(%rax), %rdx
	movq	%rdx, -24(%rbp)
	movzbl	(%rax), %eax
	movsbl	%al, %eax
	movl	%eax, -4(%rbp)
	cmpl	$0, -4(%rbp)
	setne	%al
	testb	%al, %al
	jne	.L3
	movl	-8(%rbp), %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE4876:
	.size	_Z9djb2_hashPc, .-_Z9djb2_hashPc
	.globl	_Z9sdbm_hashPc
	.type	_Z9sdbm_hashPc, @function
_Z9sdbm_hashPc:
.LFB4877:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -24(%rbp)
	movl	$0, -8(%rbp)
	movl	$0, -4(%rbp)
	jmp	.L6
.L7:
	movl	-8(%rbp), %eax
	sall	$6, %eax
	movl	%eax, %edx
	movl	-4(%rbp), %eax
	addl	%eax, %edx
	movl	-8(%rbp), %eax
	sall	$16, %eax
	addl	%edx, %eax
	subl	-8(%rbp), %eax
	movl	%eax, -8(%rbp)
.L6:
	movq	-24(%rbp), %rax
	leaq	1(%rax), %rdx
	movq	%rdx, -24(%rbp)
	movzbl	(%rax), %eax
	movsbl	%al, %eax
	movl	%eax, -4(%rbp)
	cmpl	$0, -4(%rbp)
	setne	%al
	testb	%al, %al
	jne	.L7
	movl	-8(%rbp), %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE4877:
	.size	_Z9sdbm_hashPc, .-_Z9sdbm_hashPc
	.local	_ZZ16init_crc32_tablevE11crc32_table
	.comm	_ZZ16init_crc32_tablevE11crc32_table,1024,32
	.globl	_Z16init_crc32_tablev
	.type	_Z16init_crc32_tablev, @function
_Z16init_crc32_tablev:
.LFB4878:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	$-306674912, -4(%rbp)
	movl	$0, -16(%rbp)
	jmp	.L10
.L15:
	movl	-16(%rbp), %eax
	movl	%eax, -12(%rbp)
	movl	$0, -8(%rbp)
	jmp	.L11
.L14:
	movl	-12(%rbp), %eax
	andl	$1, %eax
	testl	%eax, %eax
	je	.L12
	movl	-12(%rbp), %eax
	shrl	%eax
	xorl	-4(%rbp), %eax
	movl	%eax, -12(%rbp)
	jmp	.L13
.L12:
	shrl	-12(%rbp)
.L13:
	addl	$1, -8(%rbp)
.L11:
	cmpl	$7, -8(%rbp)
	jle	.L14
	movl	-16(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rcx
	leaq	_ZZ16init_crc32_tablevE11crc32_table(%rip), %rdx
	movl	-12(%rbp), %eax
	movl	%eax, (%rcx,%rdx)
	addl	$1, -16(%rbp)
.L10:
	cmpl	$255, -16(%rbp)
	jle	.L15
	leaq	_ZZ16init_crc32_tablevE11crc32_table(%rip), %rax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE4878:
	.size	_Z16init_crc32_tablev, .-_Z16init_crc32_tablev
	.local	_ZZ10crc32_hashPcE11crc32_table
	.comm	_ZZ10crc32_hashPcE11crc32_table,8,8
	.local	_ZGVZ10crc32_hashPcE11crc32_table
	.comm	_ZGVZ10crc32_hashPcE11crc32_table,8,8
	.globl	_Z10crc32_hashPc
	.type	_Z10crc32_hashPc, @function
_Z10crc32_hashPc:
.LFB4879:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movzbl	_ZGVZ10crc32_hashPcE11crc32_table(%rip), %eax
	testb	%al, %al
	sete	%al
	testb	%al, %al
	je	.L18
	leaq	_ZGVZ10crc32_hashPcE11crc32_table(%rip), %rax
	movq	%rax, %rdi
	call	__cxa_guard_acquire@PLT
	testl	%eax, %eax
	setne	%al
	testb	%al, %al
	je	.L18
	call	_Z16init_crc32_tablev
	movq	%rax, _ZZ10crc32_hashPcE11crc32_table(%rip)
	leaq	_ZGVZ10crc32_hashPcE11crc32_table(%rip), %rax
	movq	%rax, %rdi
	call	__cxa_guard_release@PLT
.L18:
	movl	$-1, -8(%rbp)
	movl	$0, -4(%rbp)
	jmp	.L19
.L20:
	movl	-8(%rbp), %eax
	shrl	$8, %eax
	movl	%eax, %edi
	movq	_ZZ10crc32_hashPcE11crc32_table(%rip), %rcx
	movq	-24(%rbp), %rsi
	movl	-4(%rbp), %eax
	leal	1(%rax), %edx
	movl	%edx, -4(%rbp)
	cltq
	addq	%rsi, %rax
	movzbl	(%rax), %eax
	movsbl	%al, %eax
	xorl	-8(%rbp), %eax
	movl	%eax, %eax
	movzbl	%al, %eax
	salq	$2, %rax
	addq	%rcx, %rax
	movl	(%rax), %eax
	xorl	%edi, %eax
	movl	%eax, -8(%rbp)
.L19:
	movl	-4(%rbp), %eax
	movslq	%eax, %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	testb	%al, %al
	jne	.L20
	movl	-8(%rbp), %eax
	notl	%eax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE4879:
	.size	_Z10crc32_hashPc, .-_Z10crc32_hashPc
	.globl	_Z17intrin_crc32_hashPc
	.type	_Z17intrin_crc32_hashPc, @function
_Z17intrin_crc32_hashPc:
.LFB4880:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -24(%rbp)
	movl	$0, -12(%rbp)
	movl	$0, -8(%rbp)
	jmp	.L23
.L25:
	movq	-24(%rbp), %rcx
	movl	-8(%rbp), %eax
	leal	1(%rax), %edx
	movl	%edx, -8(%rbp)
	cltq
	addq	%rcx, %rax
	movzbl	(%rax), %eax
	movzbl	%al, %eax
	movl	-12(%rbp), %edx
	movl	%edx, -4(%rbp)
	movb	%al, -13(%rbp)
	movzbl	-13(%rbp), %edx
	movl	-4(%rbp), %eax
	crc32b	%dl, %eax
	nop
	movl	%eax, -12(%rbp)
.L23:
	movl	-8(%rbp), %eax
	movslq	%eax, %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	testb	%al, %al
	jne	.L25
	movl	-12(%rbp), %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE4880:
	.size	_Z17intrin_crc32_hashPc, .-_Z17intrin_crc32_hashPc
	.globl	_Z15avx2_crc32_hashPc
	.type	_Z15avx2_crc32_hashPc, @function
_Z15avx2_crc32_hashPc:
.LFB4881:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -88(%rbp)
	movl	$0, -68(%rbp)
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movl	-68(%rbp), %edx
	movq	%rdx, -16(%rbp)
	movq	%rax, -8(%rbp)
	movq	-16(%rbp), %rax
	crc32q	-8(%rbp), %rax
	nop
	movl	%eax, -68(%rbp)
	movq	-88(%rbp), %rax
	addq	$64, %rax
	movq	(%rax), %rax
	movl	-68(%rbp), %edx
	movq	%rdx, -32(%rbp)
	movq	%rax, -24(%rbp)
	movq	-32(%rbp), %rax
	crc32q	-24(%rbp), %rax
	nop
	movl	%eax, -68(%rbp)
	movq	-88(%rbp), %rax
	subq	$-128, %rax
	movq	(%rax), %rax
	movl	-68(%rbp), %edx
	movq	%rdx, -48(%rbp)
	movq	%rax, -40(%rbp)
	movq	-48(%rbp), %rax
	crc32q	-40(%rbp), %rax
	nop
	movl	%eax, -68(%rbp)
	movq	-88(%rbp), %rax
	addq	$192, %rax
	movq	(%rax), %rax
	movl	-68(%rbp), %edx
	movq	%rdx, -64(%rbp)
	movq	%rax, -56(%rbp)
	movq	-64(%rbp), %rax
	crc32q	-56(%rbp), %rax
	nop
	movl	%eax, -68(%rbp)
	movl	-68(%rbp), %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE4881:
	.size	_Z15avx2_crc32_hashPc, .-_Z15avx2_crc32_hashPc
	.ident	"GCC: (Ubuntu 13.2.0-23ubuntu4) 13.2.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	1f - 0f
	.long	4f - 1f
	.long	5
0:
	.string	"GNU"
1:
	.align 8
	.long	0xc0000002
	.long	3f - 2f
2:
	.long	0x3
3:
	.align 8
4:
