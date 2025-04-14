#include <stdio.h>
#include <string.h>
#include <sys/stat.h>

#include "hash_table.h"
#include "custom_assert.h"

//——————————————————————————————————————————————————————————————————————————————

#define GREEN "\033[1;32m"
#define RED   "\033[1;31m"
#define WHITE "\033[0m"

//——————————————————————————————————————————————————————————————————————————————

struct test_ctx_t
{
    char*       buffer;
    size_t      buffer_size;
    data_key_t* keys;
    data_t*     data;
    size_t      n_strings;
};

//——————————————————————————————————————————————————————————————————————————————

uint64_t no_hash(data_key_t key);
static uint64_t sdbm_hash            (data_key_t key);
static uint64_t get_file_size        (FILE* const file_ptr);
static void test_ctx_ctor            (test_ctx_t* test_ctx);
static void test_ctx_dtor            (test_ctx_t* test_ctx);
static int  fill_hash_table          (hash_table_t* hash_table,
                                      test_ctx_t* test_ctx);
static int  find_elems_in_hash_table (hash_table_t* hash_table,
                                      test_ctx_t* test_ctx);
static void get_keys_and_data        (test_ctx_t* test_ctx);
static void read_test_file           (test_ctx_t* test_ctx);
static void read_test_file           (test_ctx_t* test_ctx);
static void get_n_strings            (test_ctx_t* test_ctx);

//——————————————————————————————————————————————————————————————————————————————

int main()
{
    test_ctx_t test_ctx = {};
    test_ctx_ctor(&test_ctx);

    //--------------------------------------------------------------------------

    hash_table_t hash_table = {};
    hash_table_ctor(&hash_table, 1000000, sdbm_hash);

    //--------------------------------------------------------------------------

    if (fill_hash_table(&hash_table, &test_ctx)) {
        printf(RED "Error while adding to hash table\n" WHITE);
    } else {
        printf(GREEN "Added test info to hash table successfully\n" WHITE);
    }

    if (find_elems_in_hash_table(&hash_table, &test_ctx)) {
        printf(RED "Error while finding in hash table\n" WHITE);
    } else {
        printf(GREEN "Finded test info in hash table successfully\n" WHITE);
    }

    //--------------------------------------------------------------------------

    hash_table_dtor(&hash_table);
    test_ctx_dtor(&test_ctx);

    return 0;
}

//==============================================================================

uint64_t sdbm_hash(data_key_t key)
{
    uint64_t hash = 0;
    int c;

    while ((c = *key++)) {
        hash = c + (hash << 6) + (hash << 16) - hash;
    }

    return hash;
}

//==============================================================================

void test_ctx_ctor(test_ctx_t* test_ctx)
{
    read_test_file(test_ctx);
    get_keys_and_data(test_ctx);
}

//==============================================================================

void test_ctx_dtor(test_ctx_t* test_ctx)
{
    free(test_ctx->keys);
    free(test_ctx->buffer);
}

//==============================================================================

int fill_hash_table(hash_table_t* hash_table, test_ctx_t* test_ctx)
{
    size_t n_strings  = test_ctx->n_strings;
    data_key_t* keys  = test_ctx->keys;
    data_t*     data  = test_ctx->data;

    //--------------------------------------------------------------------------

    for (int i = 0; i < n_strings; i++) {
        if (hash_table_add(hash_table, keys[i], data[i])) {
            return -1;
        }
    }

    return 0;
}

//==============================================================================

int find_elems_in_hash_table(hash_table_t* hash_table, test_ctx_t* test_ctx)
{
    size_t      n_strings = test_ctx->n_strings;
    data_key_t* keys      = test_ctx->keys;
    data_t*     data      = test_ctx->data;
    data_t      result;

    for (int i = 0; i < n_strings; i++) {
        hash_table_find(hash_table, keys[i], &result);

        if (result != data[i]) {
            return -1;
        }
    }

    return 0;
}

//==============================================================================

void get_keys_and_data(test_ctx_t* test_ctx)
{
    get_n_strings(test_ctx);
    size_t n_strings  = test_ctx->n_strings;

    //--------------------------------------------------------------------------

    data_key_t* keys  = (data_key_t*) calloc(n_strings * sizeof(data_key_t) +
                                             n_strings * sizeof(data_t),
                                             sizeof(char));

    //--------------------------------------------------------------------------

    data_t* data  = (data_t*) (keys + n_strings);

    //--------------------------------------------------------------------------

    keys[0] = (data_key_t) strtok(test_ctx->buffer, " \n");
    data[0] = (data_t)     atoi(strtok(NULL,        " \n"));

    for (int i = 1; i < n_strings; i++) {
        keys[i] = (data_key_t)      strtok(NULL, " \n");
        data[i] = (data_t)     atoi(strtok(NULL, " \n"));
    }

    //--------------------------------------------------------------------------

    test_ctx->keys = keys;
    test_ctx->data = data;
}

//==============================================================================

void read_test_file(test_ctx_t* test_ctx)
{
    FILE* file_ptr = fopen("test_data.bin", "rb");
    VERIFY(!file_ptr, return);

    //--------------------------------------------------------------------------

    size_t buffer_size = 0;
    char*  buffer      = nullptr;

    buffer_size = get_file_size(file_ptr);

    buffer = (char*) calloc(buffer_size, sizeof(char));
    VERIFY(fread(buffer, sizeof(char), buffer_size, file_ptr) != buffer_size,
           return)

    //--------------------------------------------------------------------------

    fclose(file_ptr);

    //--------------------------------------------------------------------------

    test_ctx->buffer      = buffer;
    test_ctx->buffer_size = buffer_size;
}

//==============================================================================

void get_n_strings(test_ctx_t* test_ctx)
{
    size_t n_strings = 0;
    size_t size      = test_ctx->buffer_size;
    char*  buffer    = test_ctx->buffer;

    //--------------------------------------------------------------------------

    for (int i = 0; i < size; i++) {
        if (buffer[i] == '\n') {
            n_strings++;
        }
    }

    //--------------------------------------------------------------------------

    test_ctx->n_strings = n_strings;
}

//==============================================================================

uint64_t get_file_size(FILE* const file_ptr)
{
    struct stat file_status = {};

    //--------------------------------------------------------------------------

    if (fstat(fileno(file_ptr), &file_status) < 0) {
        return -1;
    }

    //--------------------------------------------------------------------------

    return file_status.st_size;
}

//——————————————————————————————————————————————————————————————————————————————
