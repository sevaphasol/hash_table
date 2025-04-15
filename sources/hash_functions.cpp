#include "hash_table.h"

//==============================================================================

uint32_t djb2_hash(char* str)
{
    uint32_t hash = 5381;
    uint32_t c    = 0;

    while ((c = *str++)) {
        hash = ((hash << 5) + hash) + c;
    }

    return hash;
}

//==============================================================================

uint32_t sdbm_hash(char* str)
{
    uint32_t hash = 0;
    uint32_t c    = 0;

    while ((c = *str++)) {
        hash = c + (hash << 6) + (hash << 16) - hash;
    }

    return hash;
}

//==============================================================================

uint32_t* init_crc32_table()
{
    static uint32_t crc32_table[256] = {};
    uint32_t        polynomial       = 0xEDB88320;

    for (int i = 0; i < 256; i++) {
        uint32_t crc = i;
        for (int j = 0; j < 8; j++) {
            if (crc & 1) {
                crc = (crc >> 1) ^ polynomial;
            } else {
                crc >>= 1;
            }
        }
        crc32_table[i] = crc;
    }

    return crc32_table;
}

//------------------------------------------------------------------------------

uint32_t crc32_hash(char* str)
{
    static uint32_t* crc32_table = init_crc32_table();
    uint32_t         crc         = 0xFFFFFFFF;

    int i = 0;
    while (str[i] != '\0') {
        crc = (crc >> 8) ^ crc32_table[(crc ^ str[i++]) & 0xFF];
    }

    return crc ^ 0xFFFFFFFF;
}

//==============================================================================

uint32_t intrin_crc32_hash(char* str)
{
    uint32_t crc = 0;

    int i = 0;
    while (str[i] != '\0') {
        crc = _mm_crc32_u8(crc, str[i++]);
    }

    return crc;
}

//==============================================================================

uint32_t avx2_crc32_hash(char* ptr_to_key)
{
    uint32_t crc = 0;

    crc = _mm_crc32_u64(crc, *((uint64_t*) ptr_to_key     ));
    crc = _mm_crc32_u64(crc, *((uint64_t*) ptr_to_key + 8 ));
    crc = _mm_crc32_u64(crc, *((uint64_t*) ptr_to_key + 16));
    crc = _mm_crc32_u64(crc, *((uint64_t*) ptr_to_key + 24));

    return crc;
}

//==============================================================================
