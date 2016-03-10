#include <stdio.h>

#ifdef WIN32
#include <wtypes.h>
#include <winnt.h>
#endif

#include "../IKFunc.hpp"

void ShowLastError(char const * where) {
    DWORD err = GetLastError();
    char * errMessage;
    FormatMessage(FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_FROM_SYSTEM,
                    NULL, err, 0, (LPTSTR)&errMessage, 0, NULL);
    if (where != NULL) {
        fType(strlen(where), where);
        fType(2, "\n\r");
    }
    fType(strlen(errMessage), errMessage);
    fType(2, "\n\r");
    LocalFree(HLOCAL(errMessage));
}

int     __stdcall sys_GetLastError() {
    return GetLastError();
}
