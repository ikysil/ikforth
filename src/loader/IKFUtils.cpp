#include <wtypes.h>
#include <winnt.h>

#include "IKFUtils.hpp"
#include "dictmem.hpp"

void ShowLastError(char const * where) {
  DWORD err = GetLastError();
  char * errMessage;
  FormatMessage(FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_FROM_SYSTEM,
                NULL, err, 0, (LPTSTR)&errMessage, 0, NULL);
  if (where != NULL) {
    fType(strlen(where), where);
    fType(2, "\n\r");
  }
  fType(strlen(errMessage), errMessage);
  fType(2, "\n\r");
  LocalFree(HLOCAL(errMessage));
}

int StartForth(int const argc, char const * argv[], char const * envp[],
               char const * ImageFileName, char const * StartFileName) {
  hOut = GetStdHandle(STD_OUTPUT_HANDLE);
  HANDLE fHandle = fFileOpen(0, strlen(ImageFileName), ImageFileName);
  if (fHandle == INVALID_HANDLE_VALUE) {
    ShowLastError("Cannot open image file.");
    return 1;
  }
  DWORD bRead = 0;
  ReadFile(fHandle, &IHeader, sizeof(ImageHeader), &bRead, NULL);
  if ((IHeader.Signature[0] == 'M') && (IHeader.Signature[1] == 'Z')) {
    fFileReposition(fHandle, 0, 0x200);
    ReadFile(fHandle, &IHeader, sizeof(ImageHeader), &bRead, NULL);
  }
  if (strncmp("IKFI", IHeader.Signature, 4) != 0) {
    char msg[] = " is not valid IKForth image.";
    fType(strlen(ImageFileName), ImageFileName);
    fType(strlen(msg), msg);
    fType(2, "\n\r");
    fFileClose(fHandle);
    return 1;
  }
  ImageHeader * lHeader = (ImageHeader *) AllocateDictionaryAddressSpace(IHeader.DesiredBase, IHeader.DesiredSize);
  if (lHeader != IHeader.DesiredBase) {
    char msg[] = "Cannot allocate memory by VirtualAlloc.";
    fType(strlen(msg), msg);
    fType(2, "\n\r");
    fFileClose(fHandle);
    return 1;
  }
  lHeader = (ImageHeader *) CommitDictionaryMemory(lHeader, IHeader.DesiredSize);
  __int64 fPosition = fFilePosition(fHandle) - sizeof(ImageHeader);
  fFileReposition(fHandle, (DWORD)(fPosition >> 32), (DWORD)(fPosition & 0xFFFFFFFF));
  ReadFile(fHandle, lHeader, IHeader.DesiredSize, &bRead, NULL);
  fFileClose(fHandle);
  int exitCode = 0;
  MainProcContext mainProcCtx;
  mainProcCtx.argc = argc;
  mainProcCtx.argv = argv;
  mainProcCtx.envp = envp;
  mainProcCtx.startFileName = StartFileName;
  mainProcCtx.startFileNameLength = strlen(StartFileName);
  mainProcCtx.exitCode = &exitCode;
  mainProcCtx.sysfunctions = sysfunctions;
  IHeader.MainProcAddr(&mainProcCtx);
  while (!CanExit) { Sleep(100); }
  DecommitDictionaryMemory(lHeader, IHeader.DesiredSize);
  FreeDictionaryAddressSpace(lHeader, IHeader.DesiredSize);
  fFileClose(hOut);
  return exitCode;
}
