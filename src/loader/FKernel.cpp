#include <stdio.h>

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
int main(int const argc, char const * argv[]) {
  char * ImageFileName = (char *)fAlloc(MAX_FILE_PATH);
  char * StartFileName = (char *)fAlloc(MAX_FILE_PATH);
  strcpy(StartFileName, argv[0]);
  strcpy(ImageFileName, StartFileName);
  ChangeFileExt(StartFileName, ".f");
  ChangeFileExt(ImageFileName, ".img");
  int returnCode = StartForth(argc, argv, (char const **)environ, ImageFileName, StartFileName);
  fFree(StartFileName);
  fFree(ImageFileName);
  return returnCode;
}
