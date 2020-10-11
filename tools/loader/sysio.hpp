#ifndef _sysio_
#define _sysio_

#define _LARGEFILE64_SOURCE 1

#include <unistd.h>

#include "IKFCommon.hpp"

#ifndef INVALID_HANDLE_VALUE
#define INVALID_HANDLE_VALUE (0)
#endif

#if defined(WIN32)
#if defined(__MINGW32__)
#if !defined(lseek)
#define lseek _lseeki64
#endif
#endif
#if defined(_MSC_VER)
#define lseek lseek64
#endif
#endif

void sys_initIo();

bool sys_ReadFile(HANDLE hFile, void *lpBuffer, DWORD nNumberOfBytesToRead, DWORD *lpNumberOfBytesRead);

/* Rewind file identified with fileId by the specified distance (positive number of bytes). */
void sys_rewindFile(HANDLE fileId, CELL distance);

/* Reset last error value. */
void sys_resetLastError();

#endif
