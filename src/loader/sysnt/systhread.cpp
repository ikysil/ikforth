#include "../IKFCommon.hpp"
#include "../IKFunc.hpp"

DWORD WINAPI fThreadFunc(LPVOID lpParameter) {
    ForthThreadParams * ftp = (ForthThreadParams *) lpParameter;
    IHeader.Win32ThreadProcAddr(ftp->UserDataAreaAddr, ftp->ExecutionToken);
    fFree(ftp->UserDataAreaAddr);
    fFree(ftp);
    return 0;
}

DWORD  __stdcall fStartThread(void * ParentUserDataAreaAddr, DWORD CreateSuspended, DWORD XT) {
    DWORD flags = 0;
    ForthThreadParams * ftp = (ForthThreadParams *) fAlloc(sizeof(ForthThreadParams));
    ftp->ExecutionToken = XT;
    ftp->UserDataAreaAddr = fAlloc(IHeader.UserDataAreaSize);
    if (ParentUserDataAreaAddr != NULL) {
        memmove(ftp->UserDataAreaAddr, ParentUserDataAreaAddr, IHeader.UserDataAreaSize);
    }
    if (CreateSuspended == fTRUE) {
        flags |= CREATE_SUSPENDED;
    }
    DWORD threadId = 0;
    CreateThread(NULL, IHeader.DataStackSize, &fThreadFunc, ftp, flags, &threadId);
    return threadId;
}
