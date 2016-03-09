#include <stdlib.h>
#include <stdio.h>
#include <pthread.h>
#include <string.h>
#include "../IKFCommon.hpp"
#include "../IKFunc.hpp"

void * fThreadFunc(void * lpParameter) {
    ForthThreadParams * ftp = (ForthThreadParams *) lpParameter;
    IHeader.ThreadProcAddr(ftp->UserDataAreaAddr, ftp->ExecutionToken);
    fFree(ftp->UserDataAreaAddr);
    fFree(ftp);
    return 0;
}

DWORD  __stdcall fStartThread(void * ParentUserDataAreaAddr, DWORD CreateSuspended, DWORD XT) {
    //~ DWORD flags = 0;
    //~ if (CreateSuspended == fTRUE) {
        //~ flags |= CREATE_SUSPENDED;
    //~ }
    ForthThreadParams * ftp = (ForthThreadParams *) fAlloc(sizeof(ForthThreadParams));
    ftp->ExecutionToken = XT;
    ftp->UserDataAreaAddr = fAlloc(IHeader.UserDataAreaSize);
    if (ParentUserDataAreaAddr != NULL) {
        memmove(ftp->UserDataAreaAddr, ParentUserDataAreaAddr, IHeader.UserDataAreaSize);
    }
    pthread_t threadId;
    pthread_create(&threadId, NULL, &fThreadFunc, ftp);
    return threadId;
}
