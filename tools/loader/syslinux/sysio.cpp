#include "../sysio.hpp"

#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

#include "../IKFCommon.hpp"
#include "../IKFunc.hpp"

void sys_initIo() {
}

bool sys_ReadFile(HANDLE hFile, void * lpBuffer, DWORD nNumberOfBytesToRead, DWORD * lpNumberOfBytesRead) {
    ssize_t readBytes = read(hFile, lpBuffer, nNumberOfBytesToRead);
    *lpNumberOfBytesRead = readBytes;
    return readBytes >= 0;
}

void __stdcall fFileClose(HANDLE fileId) {
    close(fileId);
}

const int accessMethod[3] = {O_RDONLY, O_WRONLY, O_RDWR};

const mode_t modeCreate = S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH;
const mode_t modeOpen = S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH;

HANDLE  __stdcall fFileCreate(CELL fileAccessMethod, CELL nameLen, char const * nameAddr) {
    sys_resetLastError();
    char fileName[MAX_FILE_PATH];
    initName(fileName, MAX_FILE_PATH, nameAddr, nameLen);
    return open(fileName, accessMethod[fileAccessMethod & 3] | O_CREAT | O_TRUNC, modeCreate);
}

__int64 __stdcall fFilePosition(HANDLE fileId) {
    sys_resetLastError();
    return lseek(fileId, 0, SEEK_CUR);
}

HANDLE __stdcall fFileOpen(CELL fileAccessMethod, CELL nameLen, char const * nameAddr) {
    sys_resetLastError();
    char fileName[MAX_FILE_PATH];
    initName(fileName, MAX_FILE_PATH, nameAddr, nameLen);
    return open(fileName, accessMethod[fileAccessMethod & 3], modeOpen);
}

void    __stdcall fFileReposition(HANDLE fileId, CELL HWord, CELL LWord) {
    sys_resetLastError();
    lseek(fileId, ((__int64) HWord << 32) | LWord, SEEK_SET);
}

__int64 __stdcall fFileReadLine(HANDLE fileId, CELL cLen, char * cAddr) {
    sys_resetLastError();
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
        lseek(fileId, -distance, SEEK_CUR);
    }
}

void sys_resetLastError() { errno = 0; }
