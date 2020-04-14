\
\  linfile.4th
\
\  Unlicense since 1999 by Illya Kysil
\

CR .( Loading linfile definitions )

REPORT-NEW-NAME @
REPORT-NEW-NAME OFF

: WRITE-LINE (S c-addr u fileid -- ior )
   DUP >R WRITE-FILE THROW S\" \n" R> WRITE-FILE
;

: STACK-ALLOCATE (S n -- i*x i )
   (G Allocate i stack items enough to hold n bytes and return i )
   DUP 1 CELLS /
   SWAP 1 CELLS 1- AND 0<> IF   1+   THEN
   DUP >R
   0 DO 0 LOOP
   R>
;

: ALLOCATE-EXECUTE (S i*x n xt -- i*x )
   (G Allocate buffer of size n and execute xt passing buffer's address on TOS )
   SWAP ALLOCATE THROW >R
   R@ SWAP CATCH
   R> FREE THROW
   THROW
;

: FILE-SIZE (S fileid -- file-size-lo file-size-high ior )
   LINCONST: SIZEOF_STRUCT_STAT64
   [: (S fileid addr -- file-size-lo file-size-high ior )
      DUP ROT MAGIC__fxstat64 __fxstat64 0<> \ S: addr flag
      IF
         DROP -1. GetLastError
      ELSE
         LINCONST: OFFSETOF_ST_SIZE64 + 2@ SWAP 0
      THEN
   ;]
   ALLOCATE-EXECUTE
;

: FLUSH-FILE (S fileid -- ior )
   _fsync
   0<> IF   GetLastError   ELSE   0   THEN
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
   SWAP ROT ROT
   _ftruncate64
   0<> IF   GetLastError   ELSE   0   THEN
;

: DELETE-FILE (S c-addr u -- ior )
   S">Z" DUP _unlink
   0<> IF   GetLastError   ELSE   0   THEN
   SWAP FREE THROW
;

\  RENAME-FILE
\  ( c-addr1 u1 c-addr2 u2 -- ior )
\  Rename the file named by the character string c-addr1 u1 to the name
\  in the character string c-addr2 u2.
\  ior is the implementation-defined I/O result code.
: RENAME-FILE (S c-addr1 u1 c-addr2 u2 -- ior )
   S">Z" -ROT S">Z" 2DUP _rename
   FREE THROW FREE THROW
   0<> IF   GetLastError   ELSE   0   THEN
;

\  FILE-STATUS
\  ( c-addr u -- x ior )
\  Return the status of the file identified by the character string c-addr u.
\  If the file exists, ior is zero; otherwise ior is the implementation-defined I/O result code.
\  x contains implementation-defined information about the file.
: FILE-STATUS (S c-addr u -- x ior )
   LINCONST: SIZEOF_STRUCT_STAT64
   [: (S c-addr u addr -- x ior )
      DUP 2SWAP S">Z" DUP >R  \ S: addr addr z-addr       R: z-addr
      MAGIC__xstat64          \ S: addr addr z-addr ver   R: z-addr
      __xstat64 0<>           \ S: addr flag              R: z-addr
      IF
         DROP 0 GetLastError
      ELSE
         LINCONST: OFFSETOF_ST_MODE64 + @ 0
      THEN
      R> FREE THROW
   ;]
   ALLOCATE-EXECUTE
;

REPORT-NEW-NAME !
