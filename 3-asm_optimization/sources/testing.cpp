#include <stdio.h>
#include <string.h>
#include <sys/stat.h>
#include <immintrin.h>

#include "hash_table.h"
#include "custom_assert.h"

//——————————————————————————————————————————————————————————————————————————————

#define HASH_TABLE_FIND_RUNS 100

//——————————————————————————————————————————————————————————————————————————————

const char* const TestFile      = "for_testing/test.bin";
const size_t      HashTableSize = 3571;

//——————————————————————————————————————————————————————————————————————————————

struct test_ctx_t
{
    size_t  n_words;
    char*   keys;
    data_t* data;
};

//——————————————————————————————————————————————————————————————————————————————

enum test_status_t
{
    TEST_SUCCESS          = 0,
    TEST_OPEN_FILE_ERROR  = 1,
    TEST_READ_SIZES_ERROR = 2,
    TEST_STD_ALLOC_ERROR  = 3,
    TEST_READ_DATA_ERROR  = 4,
    TEST_ADDING_FAILURE   = 5,
    TEST_FINDING_FAILURE  = 6,
};

//——————————————————————————————————————————————————————————————————————————————

extern uint32_t avx2_crc32_hash (char* str);

//------------------------------------------------------------------------------

test_status_t test_ctx_ctor (test_ctx_t* ctx);
test_status_t test_ctx_dtor (test_ctx_t* ctx);
test_status_t test_adding   (test_ctx_t* ctx, hash_table_t* hash_table);
test_status_t test_finding  (test_ctx_t* ctx, hash_table_t* hash_table);

//——————————————————————————————————————————————————————————————————————————————

int main()
{
    test_ctx_t ctx = {};
    if (test_ctx_ctor(&ctx)) {
        return 0;
    }

    //--------------------------------------------------------------------------

    hash_table_t hash_table = {};
    hash_table_ctor(&hash_table, HashTableSize, avx2_crc32_hash);

    //--------------------------------------------------------------------------

    if (test_adding(&ctx, &hash_table)) {
        fprintf(stderr, "test_adding failure\n");
        return 0;
    }

    if (test_finding(&ctx, &hash_table)) {
        fprintf(stderr, "test_finding failure\n");
        return 0;
    }

    //--------------------------------------------------------------------------

    hash_table_dtor(&hash_table);
    test_ctx_dtor(&ctx);

    return 0;
}

//==============================================================================

test_status_t test_adding(test_ctx_t* ctx, hash_table_t* hash_table)
{
    size_t  n_words = ctx->n_words;
    char*   keys    = ctx->keys;
    data_t* data    = ctx->data;

    //--------------------------------------------------------------------------

    for (int i = 0; i < n_words; i++) {
        if (hash_table_add(hash_table, &keys[i * 32], data[i])) {
            return TEST_ADDING_FAILURE;
        }
    }

    //--------------------------------------------------------------------------

    return TEST_SUCCESS;
}

//==============================================================================

test_status_t test_finding(test_ctx_t* ctx, hash_table_t* hash_table)
{
    size_t  n_words = ctx->n_words;
    char*   keys    = ctx->keys;
    data_t* data    = ctx->data;
    data_t  result  = 0;

    //--------------------------------------------------------------------------

    for (int j = 0; j < HASH_TABLE_FIND_RUNS; j++) {
        for (int i = 0; i < n_words; i++) {
            hash_table_find(hash_table, &keys[i * 32], &result);

            if (result != data[i]) {
                return TEST_FINDING_FAILURE;
            }
            if (!hash_table) {
                return TEST_FINDING_FAILURE;
            }
        }
    }

    //--------------------------------------------------------------------------

    return TEST_SUCCESS;
}

//==============================================================================

test_status_t test_ctx_ctor(test_ctx_t* ctx)
{
    FILE* test_file = fopen(TestFile, "rb");
    VERIFY(!test_file, return TEST_OPEN_FILE_ERROR);

    //--------------------------------------------------------------------------

    VERIFY(fread(&ctx->n_words, sizeof(size_t), 1, test_file) != 1,
           return TEST_OPEN_FILE_ERROR);

    size_t file_size = ctx->n_words * (32 + sizeof(data_t));

    //--------------------------------------------------------------------------

    char* buffer = (char*) _mm_malloc(file_size, 32);
    VERIFY(!buffer, return TEST_STD_ALLOC_ERROR);

    VERIFY(fread(buffer, sizeof(char), file_size, test_file) != file_size,
           return TEST_READ_DATA_ERROR);

    fclose(test_file);

    //--------------------------------------------------------------------------

    ctx->keys = buffer;
    ctx->data = (data_t*) (buffer + ctx->n_words * 32);

    //--------------------------------------------------------------------------

    return TEST_SUCCESS;
}

//==============================================================================

test_status_t test_ctx_dtor(test_ctx_t* ctx)
{
    _mm_free(ctx->keys);

    return TEST_SUCCESS;
}

//==============================================================================
