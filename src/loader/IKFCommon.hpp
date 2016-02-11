#ifndef _IKFCommon_
#define _IKFCommon_

#include <nt/wtypes.h>
#include <nt/windef.h>

const DWORD fFALSE = 0;
const DWORD fTRUE  = 0xFFFFFFFF;

const int MAX_FILE_PATH = 1024;

typedef struct _MainProcContext {
    int           argc;
    char const ** argv;
    char const ** envp;
    char const *  startFileName;
    int           startFileNameLength;
    int  const *  exitCode;
} MainProcContext;

typedef void __stdcall (* MainProc)(MainProcContext *);
typedef void __stdcall (* ForthThreadProc)(void *, DWORD);

typedef struct _FuncTable{
// order MUST be the same as in ftable.inc FUNC_TABLE
  void * fLoadLibrary;
  void * fFreeLibrary;
  void * fGetProcAddress;
  void * fBye;
  void * fEmit;
  void * fType;
  void * fFileClose;
  void * fFileCreate;
  void * fFilePosition;
  void * fFileOpen;
  void * fFileReposition;
  void * fFileReadLine;
  void * fStartThread;
  void * fAlloc;
  void * fFree;
  void * fReAlloc;
} FuncTable;

typedef struct _ImageHeader{
  char              Signature[16];
  void *            DesiredBase;
  DWORD             DesiredSize;
  MainProc          MainProcAddr;
  ForthThreadProc   ThreadProcAddr;
  FuncTable *       FuncTableAddr;
  DWORD             UserDataAreaSize;
  DWORD             DataStackSize;
} ImageHeader;

extern bool CanExit;

extern ImageHeader IHeader;
extern HANDLE hOut;

#endif
