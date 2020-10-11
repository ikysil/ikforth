#include "IKFCommon.hpp"
#include "sysio.hpp"

__int64 __stdcall fFileReadLine(HANDLE fileId, CELL cLen, char* cAddr) {
    sys_resetLastError();
    char c;
    bool eof = false;
    int flag = 0;
    CELL i = 0;
    CELL skipped = 0;
    bool crSeen = false;
    bool lfSeen = false;
    int rewind = 0;
    while (i + skipped < cLen) {
        DWORD res = 0;
        if (!sys_ReadFile(fileId, &c, sizeof(c), &res)) {
            res = -1;
        }
        if (res <= 0) {
            eof = (i + skipped) == 0;
            break;
        }
        if (lfSeen) {
            if (c != 0x0D) {
                rewind += res;
            }
            break;
        }
        if (crSeen) {
            if (c != 0x0A) {
                rewind += res;
            }
            break;
        }
        *(cAddr++) = c;
        if (c == 0x0A) {
            lfSeen = true;
            skipped++;
            continue;
        }
        if (c == 0x0D) {
            crSeen = true;
            skipped++;
            continue;
        }
        i++;
    }
    sys_rewindFile(fileId, rewind);
    flag = (eof && (i == 0)) ? fFALSE : fTRUE;
    return ((__int64)flag << 32) | i;
}
