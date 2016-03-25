#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include "IKFunc.hpp"

void const * sysfunctions[] = {
// order MUST be the same as in ftable.asm FUNC_TABLE
    sys_GetLastError,
    fLoadLibrary,
    fFreeLibrary,
    fGetProcAddress,
    sys_Bye,
    fEmit,
    fType,
    fFileClose,
    fFileCreate,
    fFilePosition,
    fFileOpen,
    fFileReposition,
    fFileReadLine,
    fStartThread,
    fAlloc,
    fFree,
    fReAlloc
};

void initName(char * buffer, int bufferSize, char const * value, int valueSize) {
    if (bufferSize < 1) {
        perror("IKFE001: Invalid buffer size in initName");
        abort();
    }
    memset(buffer, 0, sizeof(char) * bufferSize);
    strncpy(buffer, value, MIN(bufferSize, MAX(0, valueSize)));
    // make sure buffer ALWAYS ends with \0
    buffer[bufferSize - 1] = '\0';
}

void __stdcall sys_Bye() {
    CanExit = true;
    while (true) { usleep(100000); }
}
