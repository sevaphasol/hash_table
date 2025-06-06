#include <string.h>
#include <stdio.h>

#include "hash_table.h"
#include "custom_assert.h"

//——————————————————————————————————————————————————————————————————————————————

extern "C" void                compare_keys             (__m256i etalon_key,
                                                         char*   ptr_to_key);

extern "C" hash_table_status_t list_find                (node_t* list,
                                                         char* ptr_to_etalon_key,
                                                         data_t* result);

//------------------------------------------------------------------------------

static hash_table_status_t     check_key_for_uniqueness (char*   ptr_to_key,
                                                         node_t* list);

//------------------------------------------------------------------------------

uint32_t avx2_crc32_hash (char* ptr_to_key);

//——————————————————————————————————————————————————————————————————————————————

hash_table_status_t hash_table_ctor(hash_table_t* hash_table,
                                    size_t        table_size,
                                    uint32_t    (*hash_function)(char* ptr_to_key))
{
    hash_table->buckets = (bucket_t*) calloc(table_size, sizeof(bucket_t));

    if (!hash_table->buckets) {
        return HASH_TABLE_STD_ALLOC_ERROR;
    }

    //--------------------------------------------------------------------------

    hash_table->size          = table_size;
    hash_table->hash_function = hash_function;

    //--------------------------------------------------------------------------

    allocator_ctor(&hash_table->allocator,
                   BigArraySize, ContainerSize, sizeof(node_t));

    //--------------------------------------------------------------------------

    return HASH_TABLE_SUCCESS;
}

//==============================================================================

hash_table_status_t hash_table_dtor(hash_table_t* hash_table)
{
    allocator_dtor(&hash_table->allocator);

    free(hash_table->buckets);

    return HASH_TABLE_SUCCESS;
}

//==============================================================================

hash_table_status_t hash_table_add(hash_table_t* hash_table,
                                   char*         ptr_to_key,
                                   data_t        data)
{
    size_t  index = hash_table->hash_function(ptr_to_key) % hash_table->size;
    node_t* list  = hash_table->buckets[index].list;

    //--------------------------------------------------------------------------

    VERIFY(check_key_for_uniqueness(ptr_to_key, list),
           return HASH_TABLE_SAME_KEY_ERROR);

    //--------------------------------------------------------------------------

    node_t* new_node = (node_t*) allocate(&hash_table->allocator);
    VERIFY(!new_node, return HASH_TABLE_CUSTOM_ALLOC_ERROR);

    //--------------------------------------------------------------------------

    new_node->key  = ptr_to_key;
    new_node->data = data;

    //--------------------------------------------------------------------------

    new_node->next = hash_table->buckets[index].list;
    hash_table->buckets[index].list = new_node;
    hash_table->buckets[index].size++;

    //--------------------------------------------------------------------------

    return HASH_TABLE_SUCCESS;
}

//==============================================================================

hash_table_status_t check_key_for_uniqueness(char* ptr_to_key, node_t* list)
{
    __m256i key  = _mm256_load_si256((__m256i*) ptr_to_key);

    node_t* current_elem = list;

    while (current_elem) {

        compare_keys(key, current_elem->key);

        asm volatile("jz .HASH_TABLE_SAME_KEY_ERROR");

        current_elem = current_elem->next;
    }

    //--------------------------------------------------------------------------

    int volatile key_is_not_unuique = 0;

    asm volatile("jmp .HASH_TABLE_SUCCESS");

    asm volatile(".HASH_TABLE_SAME_KEY_ERROR:"
                 "mov $1, %[key_is_not_unuique]"
                 : [key_is_not_unuique] "=r" (key_is_not_unuique)::);

    asm volatile(".HASH_TABLE_SUCCESS:");

    if (key_is_not_unuique) {
        return HASH_TABLE_SAME_KEY_ERROR;
    } else {
        return HASH_TABLE_SUCCESS;
    }
}

//==============================================================================

hash_table_status_t hash_table_find(hash_table_t* hash_table,
                                    char*         ptr_to_etalon_key,
                                    data_t*       result)
{
    size_t index = hash_table->hash_function(ptr_to_etalon_key) % hash_table->size;
    node_t* list = hash_table->buckets[index].list;

    //--------------------------------------------------------------------------

    return list_find(list, ptr_to_etalon_key, result);
}

//==============================================================================

uint32_t avx2_crc32_hash(char* ptr_to_key)
{
    uint32_t crc = 0;

    for (int i = 0; i < 4; i++) {
        crc = _mm_crc32_u64(crc, *((uint64_t*) ptr_to_key + i));
    }

    return crc;
}

//==============================================================================

