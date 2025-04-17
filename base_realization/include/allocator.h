#ifndef ALLOCATOR_H__
#define ALLOCATOR_H__

//——————————————————————————————————————————————————————————————————————————————

#include <stdint.h>
#include <stdlib.h>

//——————————————————————————————————————————————————————————————————————————————

enum allocator_status_t
{
    ALLOCATOR_SUCCESS                 = 0,
    ALLOCATOR_STRUCT_NULL_PTR_ERROR   = 1,
    ALLOCATOR_STD_CALLOC_ERROR        = 2,
    ALLOCATOR_INVALID_NEW_NODE_ERROR  = 3,
    ALLOCATOR_BIG_ARRAY_REALLOC_ERROR = 4,
    ALLOCATOR_ARRAYS_CALLOC_ERROR     = 5,
};

//——————————————————————————————————————————————————————————————————————————————

struct allocator_t
{
    size_t big_array_size;
    size_t container_size;
    size_t elem_size;
    size_t allocated_containers;
    size_t free_place;
    void** big_array;
};

//——————————————————————————————————————————————————————————————————————————————

allocator_status_t allocator_ctor (allocator_t* allocator,
                                   size_t       big_array_size,
                                   size_t       container_size,
                                   size_t       elem_size);

//==============================================================================

allocator_status_t allocator_dtor (allocator_t* allocator);

//==============================================================================

void*              allocate       (allocator_t* allocator);

//——————————————————————————————————————————————————————————————————————————————

#endif // ALLOCATOR_H__
