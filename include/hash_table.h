#ifndef HASH_TABLE_H__
#define HASH_TABLE_H__

#include <inttypes.h>
#include <stdlib.h>
#include <immintrin.h>

#include "allocator.h"

//——————————————————————————————————————————————————————————————————————————————

const size_t BigArraySize  = 8;
const size_t ContainerSize = 1024;

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

typedef char*    data_key_t;
typedef uint64_t data_t;

//==============================================================================

struct node_t
{
    data_key_t key;
    data_t     data;
    node_t*    next;
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
    uint32_t  (*hash_function)(data_key_t key);
    allocator_t allocator;
};

//——————————————————————————————————————————————————————————————————————————————

hash_table_status_t hash_table_ctor (hash_table_t* hash_table,
                                     size_t        table_size,
                                     uint32_t    (*hash_function)(data_key_t key));

//==============================================================================

hash_table_status_t hash_table_dtor (hash_table_t* hash_table);

//==============================================================================

hash_table_status_t hash_table_add  (hash_table_t* hash_table,
                                     data_key_t    key,
                                     data_t        data);

//==============================================================================

hash_table_status_t hash_table_find (hash_table_t* hash_table,
                                     data_key_t    key,
                                     data_t*       result);

//==============================================================================

uint32_t crc32_hash    (char* str);
uint32_t djb2_hash     (char* key);
uint32_t sdbm_hash     (char* key);
uint32_t fnv1a_hash    (char* key);
uint32_t rotating_hash (char* key);
uint32_t murmurhash3   (char* key);

//——————————————————————————————————————————————————————————————————————————————

#endif // HASH_TABLE_H__
