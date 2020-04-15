#include <unistd.h>
#include <string.h>

#include "IKFUtils.hpp"
#include "dictmem.hpp"
#include "sysio.hpp"

int StartForth(int const argc, char const * argv[], char const * envp[],
               char const * ImageFileName, char const * StartFileName) {
    sys_initIo();
    HANDLE fHandle = fFileOpen(0, strlen(ImageFileName), ImageFileName);
    if (fHandle == INVALID_HANDLE_VALUE) {
        ShowLastError("Cannot open image file.");
        return 1;
    }
    DWORD bRead = 0;
    sys_ReadFile(fHandle, &IHeader, sizeof(ImageHeader), &bRead);
    if ((IHeader.Signature[0] == 'M') && (IHeader.Signature[1] == 'Z')) {
        fFileReposition(fHandle, 0, 0x200);
        sys_ReadFile(fHandle, &IHeader, sizeof(ImageHeader), &bRead);
    }
    if (strncmp("IKFI", IHeader.Signature, 4) != 0) {
        char msg[] = " is not valid IKForth image.";
        sys_Type(strlen(ImageFileName), ImageFileName);
        sys_Type(strlen(msg), msg);
        sys_Type(2, "\n\r");
        fFileClose(fHandle);
        return 1;
    }
    ImageHeader * lHeader = (ImageHeader *) AllocateDictionaryAddressSpace(IHeader.DesiredBase, IHeader.DesiredSize);
    if (lHeader != IHeader.DesiredBase) {
        char msg[] = "Cannot allocate memory for dictionary.";
        sys_Type(strlen(msg), msg);
        sys_Type(2, "\n\r");
        fFileClose(fHandle);
        return 1;
    }
    lHeader = (ImageHeader *) CommitDictionaryMemory(lHeader, IHeader.DesiredSize);
    __int64 fPosition = fFilePosition(fHandle) - sizeof(ImageHeader);
    fFileReposition(fHandle, (DWORD)(fPosition >> 32), (DWORD)(fPosition & 0xFFFFFFFF));
    sys_ReadFile(fHandle, lHeader, IHeader.DesiredSize, &bRead);
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
    while (!CanExit) { usleep(100000); }
    DecommitDictionaryMemory(lHeader, IHeader.DesiredSize);
    FreeDictionaryAddressSpace(lHeader, IHeader.DesiredSize);
    return exitCode;
}
