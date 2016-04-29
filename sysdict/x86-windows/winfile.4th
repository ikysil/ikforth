\
\  winfile.4th
\
\  Copyright (C) 1999-2016 Illya Kysil
\

CR .( Loading WINFILE definitions )

REPORT-NEW-NAME @
REPORT-NEW-NAME OFF

\  11.6.1.2080 READ-FILE
\  (S c-addr u1 fileid -- u2 ior )
:NONAME (S c-addr u1 fileid -- u2 ior )
  >R 2>R
  0 SP@ NIL SWAP 2R> SWAP R> ReadFile
  0= IF GetLastError ELSE 0 THEN
; IS READ-FILE

:NONAME (S c-addr u1 fileid -- ior )
  >R 2>R
  0 SP@ NIL SWAP 2R> SWAP R> WriteFile SWAP DROP
  0= IF GetLastError ELSE 0 THEN
; IS WRITE-FILE

: DELETE-FILE (S c-addr u -- ior )
  S">Z" DUP DeleteFile
  0= IF   GetLastError   ELSE   0   THEN
  SWAP FREE THROW
;

: RENAME-FILE (S c-addr1 u1 c-addr2 u2 -- ior )
  S">Z" -ROT S">Z" 2DUP MoveFile DROP
  FREE THROW FREE THROW GetLastError
;

: FILE-STATUS (S c-addr u -- x ior )
  S">Z" DUP GetFileAttributes
  DUP INVALID_FILE_ATTRIBUTES = IF   GetLastError   ELSE   0   THEN
  ROT FREE THROW
;

: FLUSH-FILE (S FileHandle -- ior )
  FlushFileBuffers GetLastError
;

: FILE-SIZE (S FileHandle -- file-size-lo file-size-high ior )
  0 SP@ ROT GetFileSize SWAP GetLastError
;

: WRITE-LINE (S c-addr u FileHandle -- ior )
  DUP >R WRITE-FILE THROW CR-STR R> WRITE-FILE
;

\  11.6.1.2147 RESIZE-FILE
\  ( ud fileid -- ior )
\  Set the size of the file identified by fileid to ud. ior is the
\  implementation-defined I/O result code.
\  If the resultant file is larger than the file before the operation,
\  the portion of the file added as a result of the operation might not have
\  been written. At the conclusion of the operation, FILE-SIZE returns
\  the value ud and FILE-POSITION returns an unspecified value.
: RESIZE-FILE ( ud fileid -- ior )
  >R 2>R
  FILE_BEGIN NIL 2R> SWAP R@ SetFilePointerEx
  0= IF R> DROP GetLastError EXIT THEN
  R> SetEndOfFile
  0= IF GetLastError ELSE 0 THEN
;

:NONAME
  4 OR
; IS BIN

:NONAME
  1
; IS W/O

:NONAME
  2
; IS R/W

REPORT-NEW-NAME !
