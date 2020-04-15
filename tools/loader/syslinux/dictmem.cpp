#include <sys/mman.h>
#include "../dictmem.hpp"

void * AllocateDictionaryAddressSpace(void * addr, size_t size) {
    void * ptr = mmap(addr, size, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0);
    msync(ptr, size, MS_SYNC|MS_INVALIDATE);
    return ptr;
}

void * CommitDictionaryMemory(void * addr, size_t size) {
    void * ptr = mmap(addr, size, PROT_READ|PROT_WRITE|PROT_EXEC, MAP_FIXED|MAP_SHARED|MAP_ANONYMOUS, -1, 0);
    msync(addr, size, MS_SYNC|MS_INVALIDATE);
    return ptr;
}

void DecommitDictionaryMemory(void * addr, size_t size) {
    // instead of unmapping the address, we're just gonna trick
    // the TLB to mark this as a new mapped area which, due to
    // demand paging, will not be committed until used.
    mmap(addr, size, PROT_NONE, MAP_FIXED|MAP_PRIVATE|MAP_ANONYMOUS, -1, 0);
    msync(addr, size, MS_SYNC|MS_INVALIDATE);
}

void FreeDictionaryAddressSpace(void * addr, size_t size) {
    msync(addr, size, MS_SYNC);
    munmap(addr, size);
}
