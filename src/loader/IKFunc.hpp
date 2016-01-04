#ifndef _IKFunc_
#define _IKFunc_

#include "IKFCommon.hpp"
#include "IKFUtils.hpp"

HMODULE __stdcall fLoadLibrary(int nameLen, char const * nameAddr);
void    __stdcall fFreeLibrary(HMODULE libID);
FARPROC __stdcall fGetProcAddress(HMODULE libID, int nameLen, char const * nameAddr);
void    __stdcall fBye();
void    __stdcall fEmit(char c);
void    __stdcall fType(int nameLen, char const * nameAddr);
void    __stdcall fFileClose(HANDLE fileID);
HANDLE  __stdcall fFileCreate(int fileAccessMethod, int nameLen, char const * nameAddr);
__int64 __stdcall fFilePosition(HANDLE fileId);
HANDLE  __stdcall fFileOpen(int fileAccessMethod, int nameLen, char const * nameAddr);
void    __stdcall fFileReposition(HANDLE fileID, LONG HWord, LONG LWord);
__int64 __stdcall fFileReadLine(HANDLE fileId, int cLen, char * cAddr);
DWORD   __stdcall fStartThread(void * ParentUserDataAreaAddr, DWORD CreateSuspended, DWORD XT);
void    __stdcall fPage();
void *  __stdcall fAlloc(DWORD size);
void    __stdcall fFree(void * addr);
void *  __stdcall fReAlloc(void * addr, DWORD newSize);

#endif
