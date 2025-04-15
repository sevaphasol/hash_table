#include <string.h>
#include <stdio.h>

#include "hash_table.h"
#include "custom_assert.h"

//——————————————————————————————————————————————————————————————————————————————

static bool compare_keys(data_key_t key1, data_key_t key2);

//——————————————————————————————————————————————————————————————————————————————

hash_table_status_t hash_table_ctor(hash_table_t* hash_table,
                                    size_t        table_size,
                                    uint64_t    (*hash_function)(data_key_t key))
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
                                   data_key_t    key,
                                   data_t        data)
{
    size_t index = hash_table->hash_function(key) % hash_table->size;

    //--------------------------------------------------------------------------

    node_t* current = hash_table->buckets[index].list;
    while (current) {
        if (compare_keys(current->key, key)) {
            return HASH_TABLE_SAME_KEY_ERROR;
        }

        current = current->next;
    }

    //--------------------------------------------------------------------------

    node_t* new_node = (node_t*) allocate(&hash_table->allocator);
    VERIFY(!new_node,
           return HASH_TABLE_CUSTOM_ALLOC_ERROR);

    //--------------------------------------------------------------------------

    new_node->key  = key;
    new_node->data = data;

    //--------------------------------------------------------------------------

    new_node->next = hash_table->buckets[index].list;
    hash_table->buckets[index].list = new_node;
    hash_table->buckets[index].size++;

    //--------------------------------------------------------------------------

    return HASH_TABLE_SUCCESS;
}

//==============================================================================

hash_table_status_t hash_table_find(hash_table_t* hash_table,
                                    data_key_t    key,
                                    data_t*       result)
{
    size_t index = hash_table->hash_function(key) % hash_table->size;

    //--------------------------------------------------------------------------

    node_t* current = hash_table->buckets[index].list;
    while (current) {
        if (compare_keys(current->key, key)) {
            *result = current->data;
            return HASH_TABLE_SUCCESS;
        }
        current = current->next;
    }

    return HASH_TABLE_FIND_FAILURE;
}

//==============================================================================

bool compare_keys(data_key_t key1, data_key_t key2)
{
    return !strcmp(key1, key2);
}

//——————————————————————————————————————————————————————————————————————————————
