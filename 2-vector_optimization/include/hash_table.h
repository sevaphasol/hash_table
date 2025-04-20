#ifndef HASH_TABLE_H__
#define HASH_TABLE_H__

#include <inttypes.h>
#include <stdlib.h>
#include <immintrin.h>

#include "allocator.h"

//——————————————————————————————————————————————————————————————————————————————

const size_t BigArraySize  = 16;
const size_t ContainerSize = 1024 * 1024;

//——————————————————————————————————————————————————————————————————————————————

enum hash_table_status_t
{
    HASH_TABLE_SUCCESS            = 0,
    HASH_TABLE_STD_ALLOC_ERROR    = 1,
    HASH_TABLE_FIND_FAILURE       = 2,
    HASH_TABLE_CUSTOM_ALLOC_ERROR = 3,
    HASH_TABLE_SAME_KEY_ERROR     = 4,
};

//——————————————————————————————————————————————————————————————————————————————

typedef uint64_t data_t;

//==============================================================================

struct node_t
{
    char*   key;
    data_t  data;
    node_t* next;
};

//==============================================================================

struct bucket_t
{
    size_t size;
    node_t* list;
};

//==============================================================================

struct hash_table_t
{
    size_t      size;
    bucket_t*   buckets;
    uint32_t  (*hash_function)(char* key);
    allocator_t allocator;
};

//——————————————————————————————————————————————————————————————————————————————

hash_table_status_t hash_table_ctor (hash_table_t* hash_table,
                                     size_t        table_size,
                                     uint32_t    (*hash_function)(char* key));

//==============================================================================

hash_table_status_t hash_table_dtor (hash_table_t* hash_table);

//==============================================================================

hash_table_status_t hash_table_add  (hash_table_t* hash_table,
                                     char*         key,
                                     data_t        data);

//==============================================================================

hash_table_status_t hash_table_find (hash_table_t* hash_table,
                                     char*         key,
                                     data_t*       result);

//——————————————————————————————————————————————————————————————————————————————

#endif // HASH_TABLE_H__
