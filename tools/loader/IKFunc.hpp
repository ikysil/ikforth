#ifndef _IKFunc_
#define _IKFunc_

#include "IKFCommon.hpp"

void initName(char * buffer, int bufferSize, char const * value, int valueSize);

int     __stdcall sys_GetLastError();
HMODULE __stdcall fLoadLibrary(CELL nameLen, char const * nameAddr);
void    __stdcall fFreeLibrary(HMODULE libID);
FARPROC __stdcall fGetProcAddress(HMODULE libID, CELL nameLen, char const * nameAddr);
void    __stdcall sys_Bye();
void    __stdcall sys_Emit(char c);
void    __stdcall sys_Type(CELL sLen, char const * sAddr);
void    __stdcall fFileClose(HANDLE fileID);
HANDLE  __stdcall fFileCreate(CELL fileAccessMethod, CELL nameLen, char const * nameAddr);
__int64 __stdcall fFilePosition(HANDLE fileId);
HANDLE  __stdcall fFileOpen(CELL fileAccessMethod, CELL nameLen, char const * nameAddr);
void    __stdcall fFileReposition(HANDLE fileID, CELL HWord, CELL LWord);
__int64 __stdcall fFileReadLine(HANDLE fileId, CELL cLen, char * cAddr);
DWORD   __stdcall fStartThread(void * ParentUserDataAreaAddr, DWORD CreateSuspended, DWORD XT);
void *  __stdcall fAlloc(DWORD size);
void    __stdcall fFree(void * addr);
void *  __stdcall fReAlloc(DWORD newSize, void * addr);

#endif
