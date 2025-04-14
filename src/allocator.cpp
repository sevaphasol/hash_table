#include <stdlib.h>

#include "allocator.h"
#include "custom_assert.h"

//——————————————————————————————————————————————————————————————————————————————

static allocator_status_t reallocate_big_array (allocator_t* allocator);
static allocator_status_t allocate_containter  (allocator_t* allocator);

//——————————————————————————————————————————————————————————————————————————————

allocator_status_t allocator_ctor(allocator_t* allocator,
                                  size_t       big_array_size,
                                  size_t       container_size,
                                  size_t       elem_size)
{
    allocator->big_array = (void**) calloc(big_array_size, sizeof(void*));
    VERIFY(!allocator->big_array,
            return ALLOCATOR_STD_CALLOC_ERROR);

    //--------------------------------------------------------------------------

    allocator->big_array_size       = big_array_size;
    allocator->container_size       = container_size;
    allocator->elem_size            = elem_size;
    allocator->allocated_containers = 0;
    allocator->free_place           = 0;

    //--------------------------------------------------------------------------

    return ALLOCATOR_SUCCESS;
}

//==============================================================================

allocator_status_t allocator_dtor(allocator_t* allocator)
{
    for (size_t i = 0; i < allocator->allocated_containers; i++) {
        if (allocator->big_array[i]) {
            free(allocator->big_array[i]);
        }
    }

    free(allocator->big_array);

    //--------------------------------------------------------------------------

    return ALLOCATOR_SUCCESS;
}

//==============================================================================

void* allocate(allocator_t* allocator)
{
    if (allocator->free_place >= (allocator->allocated_containers *
                                  allocator->container_size)) {
        VERIFY(allocate_containter(allocator),
               return nullptr);
    }

    //--------------------------------------------------------------------------

    size_t cur_container = allocator->free_place / allocator->container_size;
    size_t free_unit     = allocator->free_place % allocator->container_size;

    void* allocated_memory = (char*) allocator->big_array[cur_container] +
                                     allocator->elem_size * free_unit;

    if (!allocated_memory) {
        fprintf(stderr, "bello\n");
    }

    allocator->free_place++;

    //--------------------------------------------------------------------------

    return allocated_memory;
}

//==============================================================================

allocator_status_t allocate_containter(allocator_t* allocator)
{
    if (allocator->allocated_containers >= allocator->big_array_size) {
        VERIFY(reallocate_big_array(allocator),
               return ALLOCATOR_BIG_ARRAY_REALLOC_ERROR)
    }

    //--------------------------------------------------------------------------

    allocator->big_array[allocator->allocated_containers] =
        calloc(allocator->container_size * allocator->elem_size, sizeof(char));

    VERIFY(!allocator->big_array[allocator->allocated_containers],
        return ALLOCATOR_STD_CALLOC_ERROR);

    allocator->allocated_containers++;

    //--------------------------------------------------------------------------

    return ALLOCATOR_SUCCESS;
}

//==============================================================================

allocator_status_t reallocate_big_array(allocator_t* allocator)
{
    void* new_big_array = realloc(allocator->big_array,
                                  2 * allocator->big_array_size *
                                  sizeof(void*));

    VERIFY(!new_big_array,
            return ALLOCATOR_BIG_ARRAY_REALLOC_ERROR);

    //--------------------------------------------------------------------------

    allocator->big_array_size *= 2;
    allocator->big_array = (void**) new_big_array;

    //--------------------------------------------------------------------------

    return ALLOCATOR_SUCCESS;
}

//——————————————————————————————————————————————————————————————————————————————
