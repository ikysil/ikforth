#include "../IKFCommon.hpp"

void *  __stdcall fAlloc(DWORD size) {
    void * result = (void *)GlobalAlloc(GPTR, size);
    if (result != NULL) {
        SetLastError(0);
    }
    return result;
}

void    __stdcall fFree(void * addr) {
    if (GlobalFree(HGLOBAL(addr)) == NULL) {
        SetLastError(0);
    }
}

void *  __stdcall fReAlloc(void * addr, DWORD newSize) {
    void * result = (void *)GlobalReAlloc(HGLOBAL(addr), newSize, GMEM_ZEROINIT);
    if (result != NULL) {
        SetLastError(0);
    }
    return result;
}
