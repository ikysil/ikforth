#include "../IKFCommon.hpp"
#include "../IKFunc.hpp"

HMODULE __stdcall fLoadLibrary(CELL nameLen, char const * nameAddr) {
    char libName[MAX_FILE_PATH];
    initName(libName, MAX_FILE_PATH, nameAddr, nameLen);
    HMODULE result = LoadLibrary(libName);
    if (result != 0) {
        SetLastError(0);
    }
    return result;
}

void    __stdcall fFreeLibrary(HMODULE libId) {
    FreeLibrary(libId);
}

FARPROC __stdcall fGetProcAddress(HMODULE libId, CELL nameLen, char const * nameAddr) {
    char procName[MAX_FILE_PATH];
    initName(procName, MAX_FILE_PATH, nameAddr, nameLen);
    SetLastError(0);
    return GetProcAddress(libId, procName);
}

