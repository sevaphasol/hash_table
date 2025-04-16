	.file	"testing.cpp"
	.text
	.type	_ZL10_mm_mallocmm, @function
_ZL10_mm_mallocmm:
.LFB328:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movq	%rsi, -32(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	cmpq	$1, -32(%rbp)
	jne	.L2
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	malloc@PLT
	jmp	.L7
.L2:
	cmpq	$2, -32(%rbp)
	je	.L4
	cmpq	$4, -32(%rbp)
	jne	.L5
.L4:
	movq	$8, -32(%rbp)
.L5:
	movq	-24(%rbp), %rdx
	movq	-32(%rbp), %rcx
	leaq	-16(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	posix_memalign@PLT
	testl	%eax, %eax
	sete	%al
	testb	%al, %al
	je	.L6
	movq	-16(%rbp), %rax
	jmp	.L7
.L6:
	movl	$0, %eax
.L7:
	movq	-8(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L8
	call	__stack_chk_fail@PLT
.L8:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE328:
	.size	_ZL10_mm_mallocmm, .-_ZL10_mm_mallocmm
	.type	_ZL8_mm_freePv, @function
_ZL8_mm_freePv:
.LFB329:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	call	free@PLT
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE329:
	.size	_ZL8_mm_freePv, .-_ZL8_mm_freePv
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
.LC0:
	.string	"for_testing/test2.bin"
	.section	.data.rel.ro.local,"aw"
	.align 8
	.type	_ZL8TestFile, @object
	.size	_ZL8TestFile, 8
_ZL8TestFile:
	.quad	.LC0
	.section	.rodata
	.align 8
	.type	_ZL13HashTableSize, @object
	.size	_ZL13HashTableSize, 8
_ZL13HashTableSize:
	.quad	3571
.LC1:
	.string	"test_adding failure\n"
.LC2:
	.string	"test_finding failure\n"
	.text
	.globl	main
	.type	main, @function
main:
.LFB4876:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$112, %rsp
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	vpxor	%xmm0, %xmm0, %xmm0
	vmovdqa	%xmm0, -112(%rbp)
	vmovq	%xmm0, -96(%rbp)
	leaq	-112(%rbp), %rax
	movq	%rax, %rdi
	call	_Z13test_ctx_ctorP10test_ctx_t
	testl	%eax, %eax
	setne	%al
	testb	%al, %al
	je	.L11
	movl	$0, %eax
	jmp	.L15
.L11:
	vpxor	%xmm0, %xmm0, %xmm0
	vmovdqa	%xmm0, -80(%rbp)
	vmovdqa	%xmm0, -64(%rbp)
	vmovdqa	%xmm0, -48(%rbp)
	vmovdqa	%xmm0, -32(%rbp)
	vmovq	%xmm0, -16(%rbp)
	leaq	-80(%rbp), %rax
	movq	_Z15avx2_crc32_hashPc@GOTPCREL(%rip), %rdx
	movl	$3571, %esi
	movq	%rax, %rdi
	call	_Z15hash_table_ctorP12hash_table_tmPFjPcE@PLT
	leaq	-80(%rbp), %rdx
	leaq	-112(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	_Z11test_addingP10test_ctx_tP12hash_table_t
	testl	%eax, %eax
	setne	%al
	testb	%al, %al
	je	.L13
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$20, %edx
	movl	$1, %esi
	leaq	.LC1(%rip), %rax
	movq	%rax, %rdi
	call	fwrite@PLT
	movl	$0, %eax
	jmp	.L15
.L13:
	leaq	-80(%rbp), %rdx
	leaq	-112(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	_Z12test_findingP10test_ctx_tP12hash_table_t
	testl	%eax, %eax
	setne	%al
	testb	%al, %al
	je	.L14
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$21, %edx
	movl	$1, %esi
	leaq	.LC2(%rip), %rax
	movq	%rax, %rdi
	call	fwrite@PLT
	movl	$0, %eax
	jmp	.L15
.L14:
	leaq	-80(%rbp), %rax
	movq	%rax, %rdi
	call	_Z15hash_table_dtorP12hash_table_t@PLT
	leaq	-112(%rbp), %rax
	movq	%rax, %rdi
	call	_Z13test_ctx_dtorP10test_ctx_t
	movl	$0, %eax
.L15:
	movq	-8(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L16
	call	__stack_chk_fail@PLT
.L16:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE4876:
	.size	main, .-main
	.globl	_Z11test_addingP10test_ctx_tP12hash_table_t
	.type	_Z11test_addingP10test_ctx_tP12hash_table_t, @function
_Z11test_addingP10test_ctx_tP12hash_table_t:
.LFB4877:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movq	%rdi, -40(%rbp)
	movq	%rsi, -48(%rbp)
	movq	-40(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -24(%rbp)
	movq	-40(%rbp), %rax
	movq	8(%rax), %rax
	movq	%rax, -16(%rbp)
	movq	-40(%rbp), %rax
	movq	16(%rax), %rax
	movq	%rax, -8(%rbp)
	movl	$0, -28(%rbp)
	jmp	.L18
.L21:
	movl	-28(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-8(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rdx
	movl	-28(%rbp), %eax
	sall	$5, %eax
	movslq	%eax, %rcx
	movq	-16(%rbp), %rax
	addq	%rax, %rcx
	movq	-48(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	_Z14hash_table_addP12hash_table_tPcm@PLT
	testl	%eax, %eax
	setne	%al
	testb	%al, %al
	je	.L19
	movl	$5, %eax
	jmp	.L20
.L19:
	addl	$1, -28(%rbp)
.L18:
	movl	-28(%rbp), %eax
	cltq
	cmpq	-24(%rbp), %rax
	jb	.L21
	movl	$0, %eax
.L20:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE4877:
	.size	_Z11test_addingP10test_ctx_tP12hash_table_t, .-_Z11test_addingP10test_ctx_tP12hash_table_t
	.globl	_Z12test_findingP10test_ctx_tP12hash_table_t
	.type	_Z12test_findingP10test_ctx_tP12hash_table_t, @function
_Z12test_findingP10test_ctx_tP12hash_table_t:
.LFB4878:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$64, %rsp
	movq	%rdi, -56(%rbp)
	movq	%rsi, -64(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movq	-56(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rbp)
	movq	-56(%rbp), %rax
	movq	8(%rax), %rax
	movq	%rax, -24(%rbp)
	movq	-56(%rbp), %rax
	movq	16(%rax), %rax
	movq	%rax, -16(%rbp)
	movq	$0, -40(%rbp)
	movl	$0, -44(%rbp)
	jmp	.L23
.L26:
	movl	-44(%rbp), %eax
	sall	$5, %eax
	movslq	%eax, %rdx
	movq	-24(%rbp), %rax
	leaq	(%rdx,%rax), %rcx
	leaq	-40(%rbp), %rdx
	movq	-64(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	_Z15hash_table_findP12hash_table_tPcPm@PLT
	movl	-44(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-16(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rdx
	movq	-40(%rbp), %rax
	cmpq	%rax, %rdx
	je	.L24
	movl	$6, %eax
	jmp	.L27
.L24:
	addl	$1, -44(%rbp)
.L23:
	movl	-44(%rbp), %eax
	cltq
	cmpq	-32(%rbp), %rax
	jb	.L26
	movl	$0, %eax
.L27:
	movq	-8(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L28
	call	__stack_chk_fail@PLT
.L28:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE4878:
	.size	_Z12test_findingP10test_ctx_tP12hash_table_t, .-_Z12test_findingP10test_ctx_tP12hash_table_t
	.section	.rodata
.LC3:
	.string	"rb"
	.align 8
.LC4:
	.string	"test_status_t test_ctx_ctor(test_ctx_t*)"
.LC5:
	.string	"sources/testing.cpp"
.LC6:
	.string	"return TEST_OPEN_FILE_ERROR"
.LC7:
	.string	"%s in %s:%d:%s\n"
.LC8:
	.string	"return TEST_STD_ALLOC_ERROR"
.LC9:
	.string	"return TEST_READ_DATA_ERROR"
	.text
	.globl	_Z13test_ctx_ctorP10test_ctx_t
	.type	_Z13test_ctx_ctorP10test_ctx_t, @function
_Z13test_ctx_ctorP10test_ctx_t:
.LFB4879:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movq	%rdi, -40(%rbp)
	leaq	.LC3(%rip), %rax
	movq	%rax, %rsi
	leaq	.LC0(%rip), %rax
	movq	%rax, %rdi
	call	fopen@PLT
	movq	%rax, -24(%rbp)
	cmpq	$0, -24(%rbp)
	jne	.L30
	movq	stderr(%rip), %rax
	leaq	.LC4(%rip), %r9
	movl	$135, %r8d
	leaq	.LC5(%rip), %rdx
	movq	%rdx, %rcx
	leaq	.LC6(%rip), %rdx
	leaq	.LC7(%rip), %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf@PLT
	movl	$1, %eax
	jmp	.L31
.L30:
	movq	-40(%rbp), %rax
	movq	-24(%rbp), %rdx
	movq	%rdx, %rcx
	movl	$1, %edx
	movl	$8, %esi
	movq	%rax, %rdi
	call	fread@PLT
	cmpq	$1, %rax
	setne	%al
	testb	%al, %al
	je	.L32
	movq	stderr(%rip), %rax
	leaq	.LC4(%rip), %r9
	movl	$139, %r8d
	leaq	.LC5(%rip), %rdx
	movq	%rdx, %rcx
	leaq	.LC6(%rip), %rdx
	leaq	.LC7(%rip), %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf@PLT
	movl	$1, %eax
	jmp	.L31
.L32:
	movq	-40(%rbp), %rax
	movq	(%rax), %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	salq	$3, %rax
	movq	%rax, -16(%rbp)
	movq	-16(%rbp), %rax
	movl	$32, %esi
	movq	%rax, %rdi
	call	_ZL10_mm_mallocmm
	movq	%rax, -8(%rbp)
	cmpq	$0, -8(%rbp)
	jne	.L33
	movq	stderr(%rip), %rax
	leaq	.LC4(%rip), %r9
	movl	$147, %r8d
	leaq	.LC5(%rip), %rdx
	movq	%rdx, %rcx
	leaq	.LC8(%rip), %rdx
	leaq	.LC7(%rip), %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf@PLT
	movl	$3, %eax
	jmp	.L31
.L33:
	movq	-24(%rbp), %rcx
	movq	-16(%rbp), %rdx
	movq	-8(%rbp), %rax
	movl	$1, %esi
	movq	%rax, %rdi
	call	fread@PLT
	cmpq	%rax, -16(%rbp)
	setne	%al
	testb	%al, %al
	je	.L34
	movq	stderr(%rip), %rax
	leaq	.LC4(%rip), %r9
	movl	$149, %r8d
	leaq	.LC5(%rip), %rdx
	movq	%rdx, %rcx
	leaq	.LC9(%rip), %rdx
	leaq	.LC7(%rip), %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf@PLT
	movl	$4, %eax
	jmp	.L31
.L34:
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	fclose@PLT
	movq	-40(%rbp), %rax
	movq	-8(%rbp), %rdx
	movq	%rdx, 8(%rax)
	movq	-40(%rbp), %rax
	movq	(%rax), %rax
	salq	$5, %rax
	movq	%rax, %rdx
	movq	-8(%rbp), %rax
	addq	%rax, %rdx
	movq	-40(%rbp), %rax
	movq	%rdx, 16(%rax)
	movl	$0, %eax
.L31:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE4879:
	.size	_Z13test_ctx_ctorP10test_ctx_t, .-_Z13test_ctx_ctorP10test_ctx_t
	.globl	_Z13test_ctx_dtorP10test_ctx_t
	.type	_Z13test_ctx_dtorP10test_ctx_t, @function
_Z13test_ctx_dtorP10test_ctx_t:
.LFB4880:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movq	-8(%rbp), %rax
	movq	8(%rax), %rax
	movq	%rax, %rdi
	call	_ZL8_mm_freePv
	movl	$0, %eax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE4880:
	.size	_Z13test_ctx_dtorP10test_ctx_t, .-_Z13test_ctx_dtorP10test_ctx_t
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
