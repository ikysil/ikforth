#include <stdio.h>

#include "IKFCommon.hpp"
#include "sysio.hpp"

/*
    READ-LINE
    ( c-addr u1 fileid -- u2 flag ior )
    Read the next line from the file specified by fileid into memory at the address c-addr. At most u1 characters are
    read. Up to two implementation-defined line-terminating characters may be read into memory at the end of the line,
    but are not included in the count u2. The line buffer provided by c-addr should be at least u1+2 characters long.

    If the operation succeeded, flag is true and ior is zero. If a line terminator was received before u1 characters
    were read, then u2 is the number of characters, not including the line terminator, actually read (0 <= u2 <= u1).
    When u1 = u2 the line terminator has yet to be reached.

    If the operation is initiated when the value returned by FILE-POSITION is equal to the value returned by FILE-SIZE
    for the file identified by fileid, flag is false, ior is zero, and u2 is zero. If ior is non-zero, an exception
    occurred during the operation and ior is the implementation-defined I/O result code.

    An ambiguous condition exists if the operation is initiated when the value returned by FILE-POSITION is greater than
    the value returned by FILE-SIZE for the file identified by fileid, or if the requested operation attempts to read
    portions of the file not written.

    At the conclusion of the operation, FILE-POSITION returns the next file position after the last character read.

    Implementation note:
    this function returns only u2 and flag, ior is retrieved by a separate call to sys_GetLastError().
 */

const CELL EOF_READ_LINE = (__int64)fFALSE << 32;

__int64 __stdcall fFileReadLine(HANDLE fileId, CELL cLen, char* cAddr) {
    sys_resetLastError();
    const DWORD toRead = cLen + 2;
    DWORD actuallyRead = 0;
    if (!sys_ReadFile(fileId, cAddr, toRead, &actuallyRead)) {
        return EOF_READ_LINE;
    }
    if (actuallyRead == 0) {
        return EOF_READ_LINE;
    }
    // printf("\n actuallyRead: %d", actuallyRead);
    CELL rewind = actuallyRead;
    bool crSeen = false;
    bool lfSeen = false;
    CELL lineLen = 0;
    for (char* indexChar = cAddr; indexChar < cAddr + actuallyRead; indexChar++, rewind--) {
        char c = *indexChar;
        if (lfSeen) {
            if (c == 0x0D) {
                rewind--;
            }
            break;
        }
        if (crSeen) {
            if (c == 0x0A) {
                rewind--;
            }
            break;
        }
        if (c == 0x0A) {
            lfSeen = true;
            continue;
        }
        if (c == 0x0D) {
            crSeen = true;
            continue;
        }
        lineLen++;
    }
    if (lineLen > cLen) {
        rewind += lineLen - cLen;
        lineLen = cLen;
    }
    // printf("\n rewind: %d, lineLen: %d", rewind, lineLen);
    sys_rewindFile(fileId, rewind);
    return ((__int64)fTRUE << 32) | lineLen;
}
