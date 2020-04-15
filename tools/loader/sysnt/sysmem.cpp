#include "../IKFCommon.hpp"

void *  __stdcall fAlloc(DWORD size) {
    void * result = (void *)GlobalAlloc(GPTR, size);
    if (result == NULL) {
        SetLastError(ERROR_NOT_ENOUGH_MEMORY);
    }
    else {
        SetLastError(0);
    }
    return result;
}

void    __stdcall fFree(void * addr) {
    if (GlobalFree(HGLOBAL(addr)) == NULL) {
        SetLastError(0);
    }
}

void *  __stdcall fReAlloc(DWORD newSize, void * addr) {
    void * result = (void *)GlobalReAlloc(HGLOBAL(addr), newSize, GMEM_ZEROINIT);
    if (result == NULL) {
        result = addr;
    }
    else {
        SetLastError(0);
    }
    return result;
}
