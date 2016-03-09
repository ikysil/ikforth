#include <dlfcn.h>
#include "../IKFCommon.hpp"
#include "../IKFunc.hpp"

CELL __stdcall fLoadLibrary(CELL nameLen, char const * nameAddr) {
    char libName[MAX_FILE_PATH];
    initName(libName, MAX_FILE_PATH, nameAddr, nameLen);
    CELL result = (CELL) dlopen(libName, RTLD_LAZY | RTLD_GLOBAL);
    return result;
}

void    __stdcall fFreeLibrary(CELL libId) {
    dlclose((void *) libId);
}

FARPROC __stdcall fGetProcAddress(CELL libId, CELL nameLen, char const * nameAddr) {
    char procName[MAX_FILE_PATH];
    initName(procName, MAX_FILE_PATH, nameAddr, nameLen);
    return (CELL) dlsym((void *) libId, procName);
}

