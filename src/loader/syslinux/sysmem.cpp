#include <errno.h>
#include <stdlib.h>
#include <string.h>
#include "../IKFCommon.hpp"

void *  __stdcall fAlloc(DWORD size) {
    void * result = (void *) malloc(size);
    return result;
}

void    __stdcall fFree(void * addr) {
    errno = 0;
    free(addr);
}

void *  __stdcall fReAlloc(void * addr, DWORD newSize) {
    void * result = (void *) realloc(addr, newSize);
    if (result != NULL) {
        memset(result, 0, newSize);
    }
    return result;
}
