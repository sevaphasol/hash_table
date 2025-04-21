#include <stdio.h>
#include <string.h>
#include <sys/stat.h>
#include <immintrin.h>

#include "hash_table.h"
#include "custom_assert.h"

//——————————————————————————————————————————————————————————————————————————————

#define HASH_TABLE_FIND_RUNS 1

//——————————————————————————————————————————————————————————————————————————————

const char* const TestData      = "for_testing/test.bin";
const size_t      HashTableSize = 3571;

//——————————————————————————————————————————————————————————————————————————————

struct test_ctx_t
{
    char*       buffer;
    data_key_t* keys;
    data_t*     data;
    size_t      n_strings;
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

extern uint32_t crc32_hash (char* str);

//------------------------------------------------------------------------------

test_status_t test_ctx_ctor (test_ctx_t* ctx);
test_status_t test_ctx_dtor (test_ctx_t* ctx);
test_status_t test_adding   (test_ctx_t* ctx, hash_table_t* hash_table);
test_status_t test_finding  (test_ctx_t* ctx, hash_table_t* hash_table);
test_status_t get_data_for_hash_func         (hash_table_t* hash_table);

//——————————————————————————————————————————————————————————————————————————————

int main()
{
    test_ctx_t ctx = {};
    if (test_ctx_ctor(&ctx)) {
        return 0;
    }

    //--------------------------------------------------------------------------

    hash_table_t hash_table = {};
    hash_table_ctor(&hash_table, HashTableSize, crc32_hash);

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

    get_data_for_hash_func(&hash_table);

    //--------------------------------------------------------------------------

    hash_table_dtor(&hash_table);
    test_ctx_dtor(&ctx);

    return 0;
}

//==============================================================================

test_status_t test_adding(test_ctx_t* ctx, hash_table_t* hash_table)
{
    size_t      n_strings  = ctx->n_strings;
    data_key_t* keys       = ctx->keys;
    data_t*     data       = ctx->data;

    //--------------------------------------------------------------------------

    for (int i = 0; i < n_strings; i++) {
        if (hash_table_add(hash_table, keys[i], data[i])) {
            return TEST_ADDING_FAILURE;
        }
    }

    //--------------------------------------------------------------------------

    return TEST_SUCCESS;
}

//==============================================================================

test_status_t test_finding(test_ctx_t* ctx, hash_table_t* hash_table)
{
    size_t      n_strings = ctx->n_strings;
    data_key_t* keys      = ctx->keys;
    data_t*     data      = ctx->data;
    data_t      result    = 0;

    //--------------------------------------------------------------------------

    for (int j = 0; j < HASH_TABLE_FIND_RUNS; j++) {
        for (int i = 0; i < n_strings; i++) {
            hash_table_find(hash_table, keys[i], &result);

            if (result != data[i]) {
                return TEST_FINDING_FAILURE;
            }
        }
    }

    //--------------------------------------------------------------------------

    return TEST_SUCCESS;
}

//==============================================================================

test_status_t get_data_for_hash_func(hash_table_t* hash_table)
{
    FILE* file = fopen("plot_data", "w");

    if (!file) {
        fprintf(stderr, "Error while opening the file.\n");
        return TEST_OPEN_FILE_ERROR;
    }

    for (size_t i = 0; i < HashTableSize; i++) {
        fprintf(file, "%zu %zu\n", i, hash_table->buckets[i].size);
    }

    fclose(file);

    return TEST_SUCCESS;
}

//==============================================================================

test_status_t test_ctx_ctor(test_ctx_t* ctx)
{
    FILE* test_file = fopen(TestData, "rb");
    VERIFY(!test_file, return TEST_OPEN_FILE_ERROR);

    //--------------------------------------------------------------------------
    // Reading sizes through struct, so we can use only one fread().
    //--------------------------------------------------------------------------

    struct {
        size_t file_size;
        size_t keys_size;
        size_t n_strings;
    } sizes = {};

    VERIFY(fread(&sizes, sizeof(sizes), 1, test_file) != 1,
           return TEST_OPEN_FILE_ERROR);

    //--------------------------------------------------------------------------
    // Reading whole file (except sizes) in ctx->buffer.
    //--------------------------------------------------------------------------

    ctx->buffer = (char*) calloc(sizes.file_size +
                                 sizes.n_strings * sizeof(data_key_t),
                                 sizeof(char));
    VERIFY(!ctx->buffer, return TEST_STD_ALLOC_ERROR);

    size_t remained_size = sizes.file_size - sizeof(sizes);

    VERIFY(fread(ctx->buffer, sizeof(char), remained_size, test_file) != remained_size,
           return TEST_READ_DATA_ERROR);

    fclose(test_file);

    //--------------------------------------------------------------------------
    // Relative pointers are accumulated lens of strings (see script.py)
    // We are making them absolute pointers to strings (keys)
    //--------------------------------------------------------------------------

    ctx->data                 = (data_t*) (ctx->buffer + sizes.keys_size);
    char** relative_pointers  = (char**)  (ctx->buffer + sizes.keys_size +
                                           sizes.n_strings * sizeof(data_t));

    char* base_pointer = ctx->buffer;

    for (int i = 0; i < sizes.n_strings; i++) {
        relative_pointers[i] += (size_t) base_pointer;
    }

    ctx->keys      = relative_pointers;
    ctx->n_strings = sizes.n_strings;

    //--------------------------------------------------------------------------

    return TEST_SUCCESS;
}

//==============================================================================

test_status_t test_ctx_dtor(test_ctx_t* ctx)
{
    free(ctx->buffer);

    return TEST_SUCCESS;
}

//==============================================================================
