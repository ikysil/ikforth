#include <errno.h>
#include <stdlib.h>
#include <string.h>
#include "../IKFCommon.hpp"

void *  __stdcall fAlloc(DWORD size) {
    errno = 0;
    void * result = (void *) malloc(size);
    return result;
}

void    __stdcall fFree(void * addr) {
    errno = 0;
    free(addr);
}

void *  __stdcall fReAlloc(DWORD newSize, void * addr) {
    void * result = (void *) realloc(addr, newSize);
    if (result == NULL) {
        result = addr;
    }
    else {
        errno = 0;
    }
    return result;
}
