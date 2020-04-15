#include <stdio.h>
#include <wtypes.h>
#include <winnt.h>
#include "../IKFunc.hpp"

void ShowLastError(char const * where) {
    DWORD err = GetLastError();
    char * errMessage;
    FormatMessage(FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_FROM_SYSTEM,
                    NULL, err, 0, (LPTSTR)&errMessage, 0, NULL);
    if (where != NULL) {
        sys_Type(strlen(where), where);
        sys_Type(2, "\n\r");
    }
    sys_Type(strlen(errMessage), errMessage);
    sys_Type(2, "\n\r");
    LocalFree(HLOCAL(errMessage));
}

int     __stdcall sys_GetLastError() {
    return GetLastError();
}
