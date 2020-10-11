#include "../sysio.hpp"

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#include "../IKFCommon.hpp"
#include "../IKFunc.hpp"

HANDLE hOut;

void sys_initIo() {
    hOut = GetStdHandle(STD_OUTPUT_HANDLE);
}

bool sys_ReadFile(HANDLE hFile, void * lpBuffer, DWORD nNumberOfBytesToRead, DWORD * lpNumberOfBytesRead) {
    return ReadFile(hFile, lpBuffer, nNumberOfBytesToRead, lpNumberOfBytesRead, NULL);
}

void __stdcall fFileClose(HANDLE fileId) {
    CloseHandle(fileId);
}

const long unsigned int accessMethod[3] = {GENERIC_READ, GENERIC_WRITE, GENERIC_READ | GENERIC_WRITE};

HANDLE  __stdcall fFileCreate(CELL fileAccessMethod, CELL nameLen, char const * nameAddr) {
    char fileName[MAX_FILE_PATH];
    initName(fileName, MAX_FILE_PATH, nameAddr, nameLen);
    HANDLE result = CreateFile(fileName, accessMethod[fileAccessMethod & 3], 0, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);
    if (result != INVALID_HANDLE_VALUE) {
        sys_resetLastError();
    }
    return result;
}

__int64 __stdcall fFilePosition(HANDLE fileId) {
    LONG HWord = 0;
    DWORD res = SetFilePointer(fileId, 0, &HWord, FILE_CURRENT);
    if (res != INVALID_SET_FILE_POINTER) {
        sys_resetLastError();
    }
    LONG LWord = res;
    return ((__int64)HWord << 32) | LWord;
}

HANDLE  __stdcall fFileOpen(CELL fileAccessMethod, CELL nameLen, char const * nameAddr) {
    char fileName[MAX_FILE_PATH];
    initName(fileName, MAX_FILE_PATH, nameAddr, nameLen);
    HANDLE result = CreateFile(fileName, accessMethod[fileAccessMethod & 3], 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
    return result;
}

void    __stdcall fFileReposition(HANDLE fileId, CELL HWord, CELL LWord) {
    LONG hPos = HWord;
    DWORD res = SetFilePointer(fileId, LWord, &hPos, FILE_BEGIN);
    if (res != INVALID_SET_FILE_POINTER) {
        sys_resetLastError();
    }
}

void sys_rewindFile(HANDLE fileId, CELL distance) {
    if (distance > 0) {
        SetFilePointer(fileId, -distance, NULL, FILE_CURRENT);
    }
}

void sys_resetLastError() { SetLastError(0); }
