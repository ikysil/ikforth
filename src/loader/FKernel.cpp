#include <stdio.h>
#include <string.h>

#include "FKernel.hpp"

bool CanExit = false;

ImageHeader IHeader;

void ChangeFileExt(char * fName, char const * fExt) {
    char * dIndex = strrchr(fName, '.');
    char * sIndex = strrchr(fName, '\\');
    if (sIndex == NULL) {
        sIndex = strrchr(fName, '/');
    }
    if (dIndex > sIndex) {
        *dIndex = '\0';
    }
    strcat(fName, fExt);
}

int main(int const argc, char const ** argv, char const ** envp) {
    char * ImageFileName = (char *)fAlloc(MAX_FILE_PATH);
    char * StartFileName = (char *)fAlloc(MAX_FILE_PATH);
    strcpy(StartFileName, argv[0]);
    strcpy(ImageFileName, StartFileName);
    ChangeFileExt(StartFileName, ".4th");
    ChangeFileExt(ImageFileName, ".img");
    int returnCode = StartForth(argc, argv, envp, ImageFileName, StartFileName);
    fFree(StartFileName);
    fFree(ImageFileName);
    return returnCode;
}
