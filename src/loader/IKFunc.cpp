#include <nt\wtypes.h>
#include <nt\windef.h>
#include <nt\wincon.h>

#include "IKFunc.hpp"

HMODULE __stdcall fLoadLibrary(int nameLen, char const * nameAddr){
  char libName[MAX_FILE_PATH];
  ZeroMemory(libName, sizeof(char) * MAX_FILE_PATH);
  strncpy(libName, nameAddr, nameLen);
  HMODULE result = LoadLibrary(libName);
  if(result != 0)
    SetLastError(0);
  return result;
}

void    __stdcall fFreeLibrary(HMODULE libId){
  FreeLibrary(libId);
}

FARPROC __stdcall fGetProcAddress(HMODULE libId, int nameLen, char const * nameAddr){
  char procName[MAX_FILE_PATH];
  ZeroMemory(procName, sizeof(char) * MAX_FILE_PATH);
  strncpy(procName, nameAddr, nameLen);
  SetLastError(0);
  return GetProcAddress(libId, procName);
}

void    __stdcall fBye(){
  CanExit = true;
  while (true) {
    Sleep(1000);
  }
}

void    __stdcall fEmit(char c){
  DWORD written = 0;
  WriteConsole(hOut, &c, sizeof(c), &written, NULL);
}

void    __stdcall fType(int sLen, char const * sAddr){
  DWORD written = 0;
  WriteConsole(hOut, sAddr, sLen, &written, NULL);
}

void    __stdcall fFileClose(HANDLE fileId){
  CloseHandle(fileId);
}

int accessMethod[3] = {GENERIC_READ, GENERIC_WRITE, GENERIC_READ | GENERIC_WRITE};

HANDLE  __stdcall fFileCreate(int fileAccessMethod, int nameLen, char const * nameAddr){
  char fileName[MAX_FILE_PATH];
  ZeroMemory(fileName, sizeof(char) * MAX_FILE_PATH);
  strncpy(fileName, nameAddr, nameLen);
  HANDLE result = CreateFile(fileName, accessMethod[fileAccessMethod & 3], 0, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);
  if(result != INVALID_HANDLE_VALUE)
    SetLastError(0);
  return result;
}

__int64 __stdcall fFilePosition(HANDLE fileId){
  LONG LWord;
  LONG HWord = 0;
  LWord = SetFilePointer(fileId, 0, &HWord, FILE_CURRENT);
  return ((__int64)HWord << 32) | LWord;
}

HANDLE  __stdcall fFileOpen(int fileAccessMethod, int nameLen, char const * nameAddr){
  char fileName[MAX_FILE_PATH];
  ZeroMemory(fileName, sizeof(char) * MAX_FILE_PATH);
  strncpy(fileName, nameAddr, nameLen);
  HANDLE result = CreateFile(fileName, accessMethod[fileAccessMethod & 3], 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
  return result;
}

void    __stdcall fFileReposition(HANDLE fileId, LONG HWord, LONG LWord){
  SetFilePointer(fileId, LWord, &HWord, FILE_BEGIN);
}

__int64 __stdcall fFileReadLine(HANDLE fileId, int cLen, char * cAddr){
  char c;
  bool eof = false;
  int flag = 0;
  int i = 0;
  while (i < cLen){
    DWORD res = 0;
    if(!ReadFile(fileId, &c, sizeof(c), &res, NULL))
      res = -1;
    if(res <= 0){
      eof = true;
      break;
    }
    *(cAddr++) = c;
    if((c == '\n') || (c == '\r'))
      break;
    i++;
  }
  if(eof && (i == 0))
    flag = 0;
  else
    flag = -1;
  return ((__int64)flag << 32) | i;
}

typedef struct _ForthThreadParams {
  void * UserDataAreaAddr;
  DWORD  ExecutionToken;
} ForthThreadParams;

DWORD WINAPI fThreadFunc(LPVOID lpParameter){
  ForthThreadParams * ftp = (ForthThreadParams *)lpParameter;
  IHeader.ThreadProcAddr(ftp->UserDataAreaAddr, ftp->ExecutionToken);
  fFree(ftp->UserDataAreaAddr);
  fFree(ftp);
  return 0;
}

DWORD  __stdcall fStartThread(void * ParentUserDataAreaAddr, DWORD CreateSuspended, DWORD XT){
  DWORD flags = 0;
  ForthThreadParams * ftp = (ForthThreadParams *)fAlloc(sizeof(ForthThreadParams));
  ftp->ExecutionToken = XT;
  ftp->UserDataAreaAddr = fAlloc(IHeader.UserDataAreaSize);
  if(ParentUserDataAreaAddr != NULL)
    memmove(ftp->UserDataAreaAddr, ParentUserDataAreaAddr, IHeader.UserDataAreaSize);
  if(CreateSuspended == fTRUE)
    flags |= CREATE_SUSPENDED;
  DWORD threadId = 0;
  CreateThread(NULL, IHeader.DataStackSize, &fThreadFunc, ftp, flags, &threadId);
  return threadId;
}

void    __stdcall fPage(){
  _COORD C;
  CONSOLE_SCREEN_BUFFER_INFO CSBI;
  DWORD Chars;
  C.X = 0;
  C.Y = 0;
  GetConsoleScreenBufferInfo(hOut, &CSBI);
  FillConsoleOutputCharacter(hOut, ' ', CSBI.dwSize.X * CSBI.dwSize.Y, C, &Chars);
  SetConsoleCursorPosition(hOut, C);      
}

void *  __stdcall fAlloc(DWORD size){
  void * result = (void *)GlobalAlloc(GPTR, size);
  if(result != NULL)
    SetLastError(0);
  return result;
}

void    __stdcall fFree(void * addr){
  if(GlobalFree(HGLOBAL(addr)) == NULL)
    SetLastError(0);
}

void *  __stdcall fReAlloc(void * addr, DWORD newSize){
  void * result = (void *)GlobalReAlloc(HGLOBAL(addr), newSize, GMEM_ZEROINIT);
  if(result != NULL)
    SetLastError(0);
  return result;
}
