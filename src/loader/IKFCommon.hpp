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
    void const ** sysfunctions;
} MainProcContext;

typedef void __stdcall (* MainProc)(MainProcContext *);
typedef void __stdcall (* ForthThreadProc)(void *, DWORD);

typedef struct _ImageHeader{
  char              Signature[16];
  void *            DesiredBase;
  DWORD             DesiredSize;
  MainProc          MainProcAddr;
  ForthThreadProc   ThreadProcAddr;
  DWORD             UserDataAreaSize;
  DWORD             DataStackSize;
} ImageHeader;

extern bool CanExit;

extern ImageHeader IHeader;
extern HANDLE hOut;

extern void const * sysfunctions[];

#endif
