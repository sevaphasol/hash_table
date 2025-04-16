	.file	"allocator.cpp"
	.text
	.section	.rodata
	.align 8
.LC0:
	.string	"allocator_status_t allocator_ctor(allocator_t*, size_t, size_t, size_t)"
.LC1:
	.string	"sources/allocator.cpp"
	.align 8
.LC2:
	.string	"return ALLOCATOR_STD_CALLOC_ERROR"
.LC3:
	.string	"%s in %s:%d:%s\n"
	.text
	.globl	_Z14allocator_ctorP11allocator_tmmm
	.type	_Z14allocator_ctorP11allocator_tmmm, @function
_Z14allocator_ctorP11allocator_tmmm:
.LFB17:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	%rdx, -24(%rbp)
	movq	%rcx, -32(%rbp)
	movq	-16(%rbp), %rax
	movl	$8, %esi
	movq	%rax, %rdi
	call	calloc@PLT
	movq	%rax, %rdx
	movq	-8(%rbp), %rax
	movq	%rdx, 40(%rax)
	movq	-8(%rbp), %rax
	movq	40(%rax), %rax
	testq	%rax, %rax
	jne	.L2
	movq	stderr(%rip), %rax
	leaq	.LC0(%rip), %r9
	movl	$19, %r8d
	leaq	.LC1(%rip), %rdx
	movq	%rdx, %rcx
	leaq	.LC2(%rip), %rdx
	leaq	.LC3(%rip), %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf@PLT
	movl	$2, %eax
	jmp	.L3
.L2:
	movq	-8(%rbp), %rax
	movq	-16(%rbp), %rdx
	movq	%rdx, (%rax)
	movq	-8(%rbp), %rax
	movq	-24(%rbp), %rdx
	movq	%rdx, 8(%rax)
	movq	-8(%rbp), %rax
	movq	-32(%rbp), %rdx
	movq	%rdx, 16(%rax)
	movq	-8(%rbp), %rax
	movq	$0, 24(%rax)
	movq	-8(%rbp), %rax
	movq	$0, 32(%rax)
	movl	$0, %eax
.L3:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE17:
	.size	_Z14allocator_ctorP11allocator_tmmm, .-_Z14allocator_ctorP11allocator_tmmm
	.globl	_Z14allocator_dtorP11allocator_t
	.type	_Z14allocator_dtorP11allocator_t, @function
_Z14allocator_dtorP11allocator_t:
.LFB18:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movq	$0, -8(%rbp)
	jmp	.L5
.L7:
	movq	-24(%rbp), %rax
	movq	40(%rax), %rax
	movq	-8(%rbp), %rdx
	salq	$3, %rdx
	addq	%rdx, %rax
	movq	(%rax), %rax
	testq	%rax, %rax
	je	.L6
	movq	-24(%rbp), %rax
	movq	40(%rax), %rax
	movq	-8(%rbp), %rdx
	salq	$3, %rdx
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	free@PLT
.L6:
	addq	$1, -8(%rbp)
.L5:
	movq	-24(%rbp), %rax
	movq	24(%rax), %rax
	cmpq	%rax, -8(%rbp)
	jb	.L7
	movq	-24(%rbp), %rax
	movq	40(%rax), %rax
	movq	%rax, %rdi
	call	free@PLT
	movl	$0, %eax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE18:
	.size	_Z14allocator_dtorP11allocator_t, .-_Z14allocator_dtorP11allocator_t
	.section	.rodata
.LC4:
	.string	"void* allocate(allocator_t*)"
.LC5:
	.string	"return nullptr"
.LC6:
	.string	"bello\n"
	.text
	.globl	_Z8allocateP11allocator_t
	.type	_Z8allocateP11allocator_t, @function
_Z8allocateP11allocator_t:
.LFB19:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movq	%rdi, -40(%rbp)
	movq	-40(%rbp), %rax
	movq	32(%rax), %rcx
	movq	-40(%rbp), %rax
	movq	24(%rax), %rdx
	movq	-40(%rbp), %rax
	movq	8(%rax), %rax
	imulq	%rdx, %rax
	cmpq	%rax, %rcx
	jb	.L10
	movq	-40(%rbp), %rax
	movq	%rax, %rdi
	call	_ZL18allocate_containerP11allocator_t
	testl	%eax, %eax
	setne	%al
	testb	%al, %al
	je	.L10
	movq	stderr(%rip), %rax
	leaq	.LC4(%rip), %r9
	movl	$57, %r8d
	leaq	.LC1(%rip), %rdx
	movq	%rdx, %rcx
	leaq	.LC5(%rip), %rdx
	leaq	.LC3(%rip), %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf@PLT
	movl	$0, %eax
	jmp	.L11
.L10:
	movq	-40(%rbp), %rax
	movq	32(%rax), %rax
	movq	-40(%rbp), %rdx
	movq	8(%rdx), %rsi
	movl	$0, %edx
	divq	%rsi
	movq	%rax, -24(%rbp)
	movq	-40(%rbp), %rax
	movq	32(%rax), %rax
	movq	-40(%rbp), %rdx
	movq	8(%rdx), %rcx
	movl	$0, %edx
	divq	%rcx
	movq	%rdx, -16(%rbp)
	movq	-40(%rbp), %rax
	movq	40(%rax), %rax
	movq	-24(%rbp), %rdx
	salq	$3, %rdx
	addq	%rdx, %rax
	movq	(%rax), %rdx
	movq	-40(%rbp), %rax
	movq	16(%rax), %rax
	imulq	-16(%rbp), %rax
	addq	%rdx, %rax
	movq	%rax, -8(%rbp)
	cmpq	$0, -8(%rbp)
	jne	.L12
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$6, %edx
	movl	$1, %esi
	leaq	.LC6(%rip), %rax
	movq	%rax, %rdi
	call	fwrite@PLT
.L12:
	movq	-40(%rbp), %rax
	movq	32(%rax), %rax
	leaq	1(%rax), %rdx
	movq	-40(%rbp), %rax
	movq	%rdx, 32(%rax)
	movq	-8(%rbp), %rax
.L11:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE19:
	.size	_Z8allocateP11allocator_t, .-_Z8allocateP11allocator_t
	.section	.rodata
	.align 8
.LC7:
	.string	"allocator_status_t allocate_container(allocator_t*)"
	.align 8
.LC8:
	.string	"return ALLOCATOR_BIG_ARRAY_REALLOC_ERROR"
	.text
	.type	_ZL18allocate_containerP11allocator_t, @function
_ZL18allocate_containerP11allocator_t:
.LFB20:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	subq	$24, %rsp
	.cfi_offset 3, -24
	movq	%rdi, -24(%rbp)
	movq	-24(%rbp), %rax
	movq	24(%rax), %rdx
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	cmpq	%rax, %rdx
	jb	.L14
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	_ZL20reallocate_big_arrayP11allocator_t
	testl	%eax, %eax
	setne	%al
	testb	%al, %al
	je	.L14
	movq	stderr(%rip), %rax
	leaq	.LC7(%rip), %r9
	movl	$85, %r8d
	leaq	.LC1(%rip), %rdx
	movq	%rdx, %rcx
	leaq	.LC8(%rip), %rdx
	leaq	.LC3(%rip), %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf@PLT
	movl	$4, %eax
	jmp	.L15
.L14:
	movq	-24(%rbp), %rax
	movq	8(%rax), %rdx
	movq	-24(%rbp), %rax
	movq	16(%rax), %rax
	imulq	%rdx, %rax
	movq	-24(%rbp), %rdx
	movq	40(%rdx), %rcx
	movq	-24(%rbp), %rdx
	movq	24(%rdx), %rdx
	salq	$3, %rdx
	leaq	(%rcx,%rdx), %rbx
	movl	$1, %esi
	movq	%rax, %rdi
	call	calloc@PLT
	movq	%rax, (%rbx)
	movq	-24(%rbp), %rax
	movq	40(%rax), %rdx
	movq	-24(%rbp), %rax
	movq	24(%rax), %rax
	salq	$3, %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	testq	%rax, %rax
	jne	.L16
	movq	stderr(%rip), %rax
	leaq	.LC7(%rip), %r9
	movl	$94, %r8d
	leaq	.LC1(%rip), %rdx
	movq	%rdx, %rcx
	leaq	.LC2(%rip), %rdx
	leaq	.LC3(%rip), %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf@PLT
	movl	$2, %eax
	jmp	.L15
.L16:
	movq	-24(%rbp), %rax
	movq	24(%rax), %rax
	leaq	1(%rax), %rdx
	movq	-24(%rbp), %rax
	movq	%rdx, 24(%rax)
	movl	$0, %eax
.L15:
	movq	-8(%rbp), %rbx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE20:
	.size	_ZL18allocate_containerP11allocator_t, .-_ZL18allocate_containerP11allocator_t
	.section	.rodata
	.align 8
.LC9:
	.string	"allocator_status_t reallocate_big_array(allocator_t*)"
	.text
	.type	_ZL20reallocate_big_arrayP11allocator_t, @function
_ZL20reallocate_big_arrayP11allocator_t:
.LFB21:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	salq	$4, %rax
	movq	%rax, %rdx
	movq	-24(%rbp), %rax
	movq	40(%rax), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	realloc@PLT
	movq	%rax, -8(%rbp)
	cmpq	$0, -8(%rbp)
	jne	.L18
	movq	stderr(%rip), %rax
	leaq	.LC9(%rip), %r9
	movl	$112, %r8d
	leaq	.LC1(%rip), %rdx
	movq	%rdx, %rcx
	leaq	.LC8(%rip), %rdx
	leaq	.LC3(%rip), %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf@PLT
	movl	$4, %eax
	jmp	.L19
.L18:
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	leaq	(%rax,%rax), %rdx
	movq	-24(%rbp), %rax
	movq	%rdx, (%rax)
	movq	-24(%rbp), %rax
	movq	-8(%rbp), %rdx
	movq	%rdx, 40(%rax)
	movl	$0, %eax
.L19:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE21:
	.size	_ZL20reallocate_big_arrayP11allocator_t, .-_ZL20reallocate_big_arrayP11allocator_t
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
