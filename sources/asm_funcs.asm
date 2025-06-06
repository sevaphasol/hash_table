; ----------------------------------------------------------------------------------------
; Implementation of functions list_find and compare_keys for use in hash_table.cpp
; ----------------------------------------------------------------------------------------

section .text
global list_find
global compare_keys

; ----------------------------------------------------------------------------------------
; hash_table_status_t list_find(node_t *list, char *ptr_to_etalon_key, data_t *result)
;
; Entry: rdi = node_t* list
;        rsi = char*   ptr_to_etalon_key
;        rdx = data_t* result
;
; Exit:  rdx = &result (if successfull)
;        eax = status
;
; Destr: ymm0, rbx, rdi, rdx
; ----------------------------------------------------------------------------------------
list_find:

    ; __m256i etalon_key  = _mm256_load_si256((__m256i*) ptr_to_etalon_key);
        vmovdqa ymm0, [rsi]

    ; node_t* current_elem = list;
    ; r8 — caller-saved register
        mov r8, rdi

    ; while (current_elem)
    .while_loop:
        test    r8, r8
        jz      .while_end

    ; bool cmp_result = compare_keys(etalon_key, current_elem->key)
        mov rdi, [r8]
        call compare_keys

    ; if (cmp_result)
        ; test al, al
        jz .find_successfull

    .find_failed:
    ; current_elem = current_elem->next;
        mov r8, [r8 + 16]
        jmp .while_loop

    .find_successfull:
    ; *result = current_elem->data;
        mov rax, [r8+8]
        mov [rdx], rax

    ; return HASH_TABLE_SUCCESS
        mov eax, 0
        ret

    .while_end:
    ; return HASH_TABLE_FIND_FAILURE
        mov eax, 2
        ret

; ----------------------------------------------------------------------------------------
; bool compare_keys(__m256i etalon_key, char* ptr_to_key)
;
; Entry: ymm0 = etalon_key
;        rdi  = ptr_to_key
;
; Exit:  al = result
;
; Destr: ymm0
; ----------------------------------------------------------------------------------------
compare_keys:

    ;__m256i key = _mm256_load_si256((__m256i*) ptr_to_key);
        vpcmpeqb ymm1, ymm0, [rdi]

    ; __m256i cmp_mask = _mm256_cmpeq_epi8(etalon_key, key);
        vpmovmskb eax, ymm1

    ; int mask = _mm256_movemask_epi8(cmp_mask);
        inc eax
    ; setz al, al
        retn
