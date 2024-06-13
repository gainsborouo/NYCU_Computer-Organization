#include "CacheManager.h"
#include <math.h>

// Fully Associative Cache
// Replacement Policy
// Cache: LRU
// Victim Buffer: FIFO (not used)

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
    // victim_buffer_capacity = (int)pow(2, 9);
};

CacheManager::~CacheManager(){
    for (auto& entry : cache_map){
        delete entry.second;
    }
    for (auto& entry : victim_buffer_map){
        delete entry.second;
    }
};

std::pair<unsigned, unsigned> CacheManager::directed_map(unsigned int addr){
    // map addr by directed-map method
    unsigned int index_bit = int(log2(cache->get_len()));
    unsigned int index = (addr >> 2) % cache->get_len(); 
    unsigned int tag = addr >> index_bit >> 2;
    return {index, tag};
}

void CacheManager::updateLRU(unsigned int addr){
    if(lru_map.find(addr) != lru_map.end()){
        lru_list.erase(lru_map[addr]);
    }
    else if(lru_list.size() >= capacity){
        unsigned least_recent = lru_list.back();
        lru_list.pop_back();
        // addToVictimBuffer(least_recent, *cache_map[least_recent]);
        delete cache_map[least_recent];
        cache_map.erase(least_recent);
        lru_map.erase(least_recent);
    }
    lru_list.push_front(addr);
    lru_map[addr] = lru_list.begin();
}

unsigned int* CacheManager::findInVictimBuffer(unsigned int addr){
    if(victim_buffer_map.find(addr) != victim_buffer_map.end()){
        victim_buffer_list.remove(addr);
        unsigned int* value_ptr = victim_buffer_map[addr];
        victim_buffer_map.erase(addr);
        return value_ptr;
    }
    return nullptr;
}

void CacheManager::addToCache(unsigned int addr, unsigned int value){
    updateLRU(addr);
    cache_map[addr] = new unsigned int(value);
}

void CacheManager::addToVictimBuffer(unsigned int addr, unsigned int value){
    if (victim_buffer_list.size() >= victim_buffer_capacity) {
        unsigned int oldest_addr = victim_buffer_list.back();
        victim_buffer_list.pop_back();
        delete victim_buffer_map[oldest_addr];
        victim_buffer_map.erase(oldest_addr);
    }
    victim_buffer_list.push_front(addr);
    victim_buffer_map[addr] = new unsigned int(value);
}

unsigned int* CacheManager::find(unsigned int addr){
    // TODO:: implement function determined addr is in cache or not
    // if addr is in cache, return target pointer, otherwise return nullptr.
    // you shouldn't access memory in this function.
    if(cache_map.find(addr) != cache_map.end()){
        updateLRU(addr);
        return cache_map[addr];
    }
    // unsigned int* value_ptr = findInVictimBuffer(addr);
    // if(value_ptr != nullptr){
    //     addToCache(addr, *value_ptr);
    //     delete value_ptr;
    //     return cache_map[addr];
    // }
    else return nullptr;
}

unsigned int CacheManager::read(unsigned int addr){
    // TODO:: implement replacement policy and return value
    unsigned int* value_ptr = find(addr);
    if(value_ptr != nullptr){
        return *value_ptr;
    }
    // value_ptr = findInVictimBuffer(addr);
    // if(value_ptr != nullptr){
    //     addToCache(addr, *value_ptr);
    //     return *value_ptr;
    // }
    unsigned int value = memory->read(addr);
    addToCache(addr, value);
    return value;
}

void CacheManager::write(unsigned int addr, unsigned value){
    // TODO:: write value to addr
    unsigned int* value_ptr = find(addr);
    if(value_ptr != nullptr){
        *value_ptr = value;
    }
    else{
        value_ptr = findInVictimBuffer(addr);
        if(value_ptr != nullptr){
            addToCache(addr, *value_ptr);
        } 
        else{
            addToCache(addr, value);
        }
    }
    memory->write(addr, value);
};
