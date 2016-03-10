#ifndef _sysio_
#define _sysio_

#ifndef INVALID_HANDLE_VALUE
#define INVALID_HANDLE_VALUE (0)
#endif

void sys_initIo();

bool sys_ReadFile(HANDLE hFile, void * lpBuffer, DWORD nNumberOfBytesToRead, DWORD * lpNumberOfBytesRead);

#endif
