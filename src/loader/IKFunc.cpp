#include <nt/wtypes.h>
#include <nt/windef.h>
#include <nt/wincon.h>

#include "IKFunc.hpp"

void const * sysfunctions[] = {
// order MUST be the same as in ftable.inc FUNC_TABLE
  fLoadLibrary,
  fFreeLibrary,
  fGetProcAddress,
  fBye,
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

HMODULE __stdcall fLoadLibrary(int nameLen, char const * nameAddr) {
  char libName[MAX_FILE_PATH];
  ZeroMemory(libName, sizeof(char) * MAX_FILE_PATH);
  strncpy(libName, nameAddr, nameLen);
  HMODULE result = LoadLibrary(libName);
  if (result != 0) {
    SetLastError(0);
  }
  return result;
}

void    __stdcall fFreeLibrary(HMODULE libId) {
  FreeLibrary(libId);
}

FARPROC __stdcall fGetProcAddress(HMODULE libId, int nameLen, char const * nameAddr) {
  char procName[MAX_FILE_PATH];
  ZeroMemory(procName, sizeof(char) * MAX_FILE_PATH);
  strncpy(procName, nameAddr, nameLen);
  SetLastError(0);
  return GetProcAddress(libId, procName);
}

void    __stdcall fBye() {
  CanExit = true;
  while (true) {
    Sleep(1000);
  }
}

void    __stdcall fEmit(char c) {
  DWORD written = 0;
  WriteConsole(hOut, &c, sizeof(c), &written, NULL);
}

void    __stdcall fType(int sLen, char const * sAddr) {
  if (sLen < 1) {
    return;
  }
  DWORD written = 0;
  WriteConsole(hOut, sAddr, sLen, &written, NULL);
}

void    __stdcall fFileClose(HANDLE fileId) {
  CloseHandle(fileId);
}

const int accessMethod[3] = {GENERIC_READ, GENERIC_WRITE, GENERIC_READ | GENERIC_WRITE};

HANDLE  __stdcall fFileCreate(int fileAccessMethod, int nameLen, char const * nameAddr) {
  char fileName[MAX_FILE_PATH];
  ZeroMemory(fileName, sizeof(char) * MAX_FILE_PATH);
  strncpy(fileName, nameAddr, nameLen);
  HANDLE result = CreateFile(fileName, accessMethod[fileAccessMethod & 3], 0, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);
  if (result != INVALID_HANDLE_VALUE) {
    SetLastError(0);
  }
  return result;
}

__int64 __stdcall fFilePosition(HANDLE fileId) {
  LONG LWord;
  LONG HWord = 0;
  LWord = SetFilePointer(fileId, 0, &HWord, FILE_CURRENT);
  return ((__int64)HWord << 32) | LWord;
}

HANDLE  __stdcall fFileOpen(int fileAccessMethod, int nameLen, char const * nameAddr) {
  char fileName[MAX_FILE_PATH];
  ZeroMemory(fileName, sizeof(char) * MAX_FILE_PATH);
  strncpy(fileName, nameAddr, nameLen);
  HANDLE result = CreateFile(fileName, accessMethod[fileAccessMethod & 3], 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
  return result;
}

void    __stdcall fFileReposition(HANDLE fileId, LONG HWord, LONG LWord) {
  SetFilePointer(fileId, LWord, &HWord, FILE_BEGIN);
}

__int64 __stdcall fFileReadLine(HANDLE fileId, int cLen, char * cAddr) {
  char c;
  bool eof = false;
  int flag = 0;
  int i = 0;
  int skipped = 0;
  bool crSeen = false;
  bool lfSeen = false;
  int rewind = 0;
  while (i + skipped < cLen) {
    DWORD res = 0;
    if (!ReadFile(fileId, &c, sizeof(c), &res, NULL)) {
      res = -1;
    }
    if (res <= 0) {
      eof = true;
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
  if (rewind > 0) {
    SetFilePointer(fileId, -rewind, NULL, FILE_CURRENT);
  }
  if (eof && (i == 0)) {
    flag = 0;
  }
  else {
    flag = -1;
  }
  return ((__int64)flag << 32) | i;
}

typedef struct _ForthThreadParams {
  void * UserDataAreaAddr;
  DWORD  ExecutionToken;
} ForthThreadParams;

DWORD WINAPI fThreadFunc(LPVOID lpParameter) {
  ForthThreadParams * ftp = (ForthThreadParams *)lpParameter;
  IHeader.ThreadProcAddr(ftp->UserDataAreaAddr, ftp->ExecutionToken);
  fFree(ftp->UserDataAreaAddr);
  fFree(ftp);
  return 0;
}

DWORD  __stdcall fStartThread(void * ParentUserDataAreaAddr, DWORD CreateSuspended, DWORD XT) {
  DWORD flags = 0;
  ForthThreadParams * ftp = (ForthThreadParams *)fAlloc(sizeof(ForthThreadParams));
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

void *  __stdcall fAlloc(DWORD size) {
  void * result = (void *)GlobalAlloc(GPTR, size);
  if (result != NULL) {
    SetLastError(0);
  }
  return result;
}

void    __stdcall fFree(void * addr) {
  if (GlobalFree(HGLOBAL(addr)) == NULL) {
    SetLastError(0);
  }
}

void *  __stdcall fReAlloc(void * addr, DWORD newSize) {
  void * result = (void *)GlobalReAlloc(HGLOBAL(addr), newSize, GMEM_ZEROINIT);
  if (result != NULL) {
    SetLastError(0);
  }
  return result;
}
