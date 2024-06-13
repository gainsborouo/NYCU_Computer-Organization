#include "CacheManager.h"
#include <math.h>
#include <iostream>

// Fully Associative Cache
// Replacement Policy
// Cache: LRU

CacheManager::CacheManager(Memory *memory, Cache *cache){
    // TODO: implement your constructor here
    // TODO: set tag_bits accord to your design.
    // Hint: you can access cache size by cache->get_size();
    // Hint: you need to call cache->set_block_size();
    this->memory = memory;
    this->cache = cache;
    size = cache->get_size();
    cache->set_block_size(4);
    tag_bits = 32 - 2;
    capacity = cache->get_len();
    valid_bits.resize(capacity, false);
};

CacheManager::~CacheManager(){

};

// std::pair<unsigned, unsigned> CacheManager::directed_map(unsigned int addr){
//     // map addr by directed-map method
//     unsigned int index_bit = int(log2(cache->get_len()));
//     unsigned int index = (addr >> 2) % cache->get_len(); 
//     unsigned int tag = addr >> index_bit >> 2;
//     return {index, tag};
// }

void CacheManager::updateLRU(unsigned int addr){
    bool found = false;
    for(auto it = lru_list.begin(); it != lru_list.end(); it++){
        if(*it == addr){
            if(it != lru_list.begin()){ 
                lru_list.push_front(*it);  
                lru_list.erase(it);
            }
            found = true;
            break;
        }
    }

    if(!found){
        if (lru_list.size() >= capacity) {
            unsigned int lruTag = lru_list.back();
            lru_list.pop_back();
            lru_map.erase(lruTag);
        }
        lru_list.push_front(addr);
    }
    lru_map[addr] = lru_list.begin();
}


int CacheManager::findCacheIndex(unsigned int addr) {
    for(unsigned int i = 0; i < capacity; i++){
        if(valid_bits[i] && (*cache)[i].tag == addr){
            return i;
        }
    }
    return -1;
}

unsigned int* CacheManager::find(unsigned int addr){
    // TODO:: implement function determined addr is in cache or not
    // if addr is in cache, return target pointer, otherwise return nullptr.
    // you shouldn't access memory in this function.
    int index = findCacheIndex(addr);
    if(index != -1){
        updateLRU((*cache)[index].tag);
        return &((*cache)[index][0]);
    }
    return nullptr;
}

unsigned int CacheManager::read(unsigned int addr){
    // TODO:: implement replacement policy and return value
    unsigned int* value_ptr = find(addr);
    if(value_ptr != nullptr){
        return *value_ptr;
    }
    else{
        unsigned int value = memory->read(addr);
        for(unsigned int i = 0; i < capacity; i++){
            if(!valid_bits[i]){
                (*cache)[i].tag = addr;
                (*cache)[i][0] = value;
                valid_bits[i] = true;
                updateLRU(addr);
                return value;
            }
        }

        unsigned int least_recent = lru_list.back();
        lru_list.pop_back();
        for(unsigned int i = 0; i < capacity; i++){
            if((*cache)[i].tag == least_recent){
                (*cache)[i].tag = addr;
                (*cache)[i][0] = value;
                valid_bits[i] = true;
                updateLRU(addr);
                return value;
            }
        }
    }
    return 0;
}

void CacheManager::write(unsigned int addr, unsigned value){
    // TODO:: write value to addr
    unsigned int* value_ptr = find(addr);
    if(value_ptr != nullptr){
        *value_ptr = value;
    }
    else{
        bool written = false;
        for(unsigned int i = 0; i < capacity; i++){
            if(!valid_bits[i]){
                (*cache)[i].tag = addr;
                (*cache)[i][0] = value;
                valid_bits[i] = true;
                updateLRU(addr);
                written = true;
                break;
            }
        }

        if(!written){
            unsigned int least_recent = lru_list.back();
            lru_list.pop_back();
            for(unsigned int i = 0; i < capacity; i++){
                if ((*cache)[i].tag == least_recent){
                    (*cache)[i].tag = addr;
                    (*cache)[i][0] = value;
                    valid_bits[i] = true;
                    updateLRU(addr);
                    break;
                }
            }
        }
    }
    memory->write(addr, value);
};
