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
        SetLastError(0);
    }
    return result;
}

__int64 __stdcall fFilePosition(HANDLE fileId) {
    LONG HWord = 0;
    DWORD res = SetFilePointer(fileId, 0, &HWord, FILE_CURRENT);
    if (res != INVALID_SET_FILE_POINTER) {
        SetLastError(0);
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
        SetLastError(0);
    }
}

__int64 __stdcall fFileReadLine(HANDLE fileId, CELL cLen, char * cAddr) {
    SetLastError(0);
    char c;
    bool eof = false;
    int flag = 0;
    CELL i = 0;
    CELL skipped = 0;
    bool crSeen = false;
    bool lfSeen = false;
    int rewind = 0;
    while (i + skipped < cLen) {
        DWORD res = 0;
        if (!sys_ReadFile(fileId, &c, sizeof(c), &res)) {
            res = -1;
        }
        if (res <= 0) {
            eof = (i + skipped) == 0;
            break;
        }
        if (lfSeen) {
            if (c != 0x0D) {
                rewind += res;
            }
            break;
        }
        if (crSeen) {
            if (c != 0x0A) {
                rewind += res;
            }
            break;
        }
        *(cAddr++) = c;
        if (c == 0x0A) {
            lfSeen = true;
            skipped++;
            continue;
        }
        if (c == 0x0D) {
            crSeen = true;
            skipped++;
            continue;
        }
        i++;
    }
    sys_rewindFile(fileId, rewind);
    flag = (eof && (i == 0)) ? fFALSE : fTRUE;
    return ((__int64)flag << 32) | i;
}

void sys_rewindFile(HANDLE fileId, CELL distance) {
    if (distance > 0) {
        SetFilePointer(fileId, -distance, NULL, FILE_CURRENT);
    }
}
