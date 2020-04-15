#include <wtypes.h>
#include <winnt.h>
#include "../dictmem.hpp"

void * AllocateDictionaryAddressSpace(void * addr, size_t size) {
    return VirtualAlloc(addr, size, MEM_RESERVE , PAGE_NOACCESS);
}

void * CommitDictionaryMemory(void * addr, size_t size) {
    return VirtualAlloc(addr, size, MEM_COMMIT, PAGE_EXECUTE_READWRITE);
}

void DecommitDictionaryMemory(void * addr, size_t size) {
    VirtualFree(addr, size, MEM_DECOMMIT);
}

void FreeDictionaryAddressSpace(void * addr, size_t) {
    VirtualFree(addr, 0, MEM_RELEASE);
}
