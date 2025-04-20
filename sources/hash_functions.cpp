#include "hash_table.h"

//——————————————————————————————————————————————————————————————————————————————

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
    uint32_t         crc         = 0;

    int i = 0;
    while (str[i] != '\0') {
        crc = (crc >> 8) ^ crc32_table[(crc ^ str[i++]) & 0xFF];
    }

    return crc;
}

//==============================================================================

uint32_t djb2_hash(char* key)
{
    uint32_t hash = 5381;

    for (int i = 0; key[i] != '\0'; i++) {
        hash = ((hash << 5) + hash) + (unsigned char)key[i];
    }

    return hash;
}

//==============================================================================

uint32_t sdbm_hash(char* key)
{
    uint32_t hash = 0;

    for (int i = 0; key[i] != '\0'; i++) {
        hash = (unsigned char)key[i] + (hash << 6) + (hash << 16) - hash;
    }

    return hash;
}

//==============================================================================

uint32_t rotating_hash(char* key)
{
    uint32_t hash = 0;

    for (int i = 0; key[i] != '\0'; i++) {
        hash = (hash << 5) ^ (hash >> 27);
        hash ^= (unsigned char)key[i];
    }

    return hash;
}

//==============================================================================

uint32_t fnv1a_hash(char* key)
{
    uint32_t hash = 2166136261;

    for (int i = 0; key[i] != '\0'; i++) {
        hash ^= (unsigned char)key[i];
        hash *= 16777619;
    }

    return hash;
}

//==============================================================================

uint32_t murmurhash3(char* key)
{
    const uint32_t c1 = 0xcc9e2d51;
    const uint32_t c2 = 0x1b873593;
    uint32_t hash = 0;

    for (int i = 0; key[i] != '\0'; i++) {
        uint32_t k = (unsigned char) key[i];

        k *= c1;

        k = (k << 15) | (k >> (32 - 15));

        k *= c2;

        hash ^= k;
        hash = (hash << 13) | (hash >> (32 - 13));
        hash = hash * 5 + 0xe6546b64;
    }

    hash ^= hash >> 16;
    hash *= 0x85ebca6b;
    hash ^= hash >> 13;
    hash *= 0xc2b2ae35;
    hash ^= hash >> 16;

    return hash;
}

//==============================================================================
