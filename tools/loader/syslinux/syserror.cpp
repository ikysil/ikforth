#include <stdio.h>
#include <errno.h>
#include "../IKFunc.hpp"

void ShowLastError(char const * where) {
    perror(where);
}

int     __stdcall sys_GetLastError() {
    return errno;
}
