#ifndef _IKFCommon_
#define _IKFCommon_

#include <stdint.h>

#define MIN(a,b) (((a)<(b))?(a):(b))
#define MAX(a,b) (((a)>(b))?(a):(b))

typedef uint32_t CELL;

#ifdef WIN32
#include <wtypes.h>
#include <windef.h>
#else
#define HANDLE  CELL
#define HMODULE CELL
#define FARPROC CELL
#define DWORD   CELL
#define LONG    uint64_t
#define __int64 uint64_t
#define HLOCAL(x) (x)
#endif

#ifndef __stdcall
#define __stdcall __attribute__((stdcall))
#endif

#ifndef nullptr
#define nullptr (0)
#endif

const CELL fFALSE = 0;
const CELL fTRUE  = 0xFFFFFFFF;

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
typedef void __stdcall (* ForthThreadProc)(void *, CELL);

typedef struct _ImageHeader {
    char              Signature[16];
    void *            DesiredBase;
    CELL              DesiredSize;
    MainProc          MainProcAddr;
    ForthThreadProc   Win32ThreadProcAddr;
    ForthThreadProc   LinuxThreadProcAddr;
    CELL              UserDataAreaSize;
    CELL              DataStackSize;
} ImageHeader;

typedef struct _ForthThreadParams {
    void *  UserDataAreaAddr;
    CELL    ExecutionToken;
} ForthThreadParams;

extern bool CanExit;

extern ImageHeader IHeader;

extern void const * sysfunctions[];

#endif
