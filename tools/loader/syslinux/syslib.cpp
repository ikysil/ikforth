#include <dlfcn.h>
#include <errno.h>
#include <stdio.h>
#include "../IKFCommon.hpp"
#include "../IKFunc.hpp"

CELL __stdcall fLoadLibrary(CELL nameLen, char const * nameAddr) {
    dlerror();    /* Clear any existing error */
    errno = 0;
    char libName[MAX_FILE_PATH];
    initName(libName, MAX_FILE_PATH, nameAddr, nameLen);
    CELL result = (CELL) dlopen(libName, RTLD_LAZY | RTLD_NOW);
    // perror(dlerror());
    return result;
}

void    __stdcall fFreeLibrary(CELL libId) {
    dlerror();    /* Clear any existing error */
    errno = 0;
    if (libId != 0) {
        dlclose((void *) libId);
    }
}

FARPROC __stdcall fGetProcAddress(CELL libId, CELL nameLen, char const * nameAddr) {
    dlerror();    /* Clear any existing error */
    errno = 0;
    char procName[MAX_FILE_PATH];
    initName(procName, MAX_FILE_PATH, nameAddr, nameLen);
    CELL result = (CELL) dlsym((void *) libId, procName);
    return result;
}

