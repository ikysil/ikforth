#include <nt/wtypes.h>
#include <nt/winnt.h>
#include <nt/wincon.h>

#include "FKernel.hpp"

bool CanExit = false;

ImageHeader IHeader;
HANDLE hOut;

void ChangeFileExt(char * fName, char * fExt){
  char * dIndex = strrchr(fName, '.');
  char * sIndex = strrchr(fName, '\\');
  if(dIndex > sIndex)
    *dIndex = '\0';
  strcat(fName, fExt);
}

#pragma off(unreferenced)
int PASCAL WinMain(HINSTANCE this_inst, HINSTANCE prev_inst, LPSTR cmdline, int cmdshow){
  char * ImageFileName = (char *)fAlloc(MAX_FILE_PATH);
  char * StartFileName = (char *)fAlloc(MAX_FILE_PATH);
  GetModuleFileName(this_inst, StartFileName, MAX_FILE_PATH);
  strcpy(ImageFileName, StartFileName);
  ChangeFileExt(StartFileName, ".f");
  ChangeFileExt(ImageFileName, ".img");
  StartForth(ImageFileName, StartFileName);
  fFree(StartFileName);
  fFree(ImageFileName);
  return 0;
}
