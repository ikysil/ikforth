\
\  file.f
\
\  Copyright (C) 1999-2001 Illya Kysil
\

CR .( Loading FILE definitions )

CREATE-REPORT @
CREATE-REPORT OFF

S" File not found"
2 (EXCEPTION)

: DELETE-FILE (S c-addr u -- ior )
  S">ASCIIZ DUP DeleteFile DROP
  FREE DROP GetLastError ;

: RENAME-FILE (S c-addr1 u1 c-addr2 u2 -- ior )
  S">ASCIIZ -ROT S">ASCIIZ 2DUP MoveFile DROP
  FREE DROP FREE DROP GetLastError ;

: FILE-STATUS (S c-addr u -- x ior )
  S">ASCIIZ DUP GetFileAttributes
  SWAP FREE DROP GetLastError ;

: FLUSH-FILE (S FileHandle -- ior )
  FlushFileBuffers GetLastError ;

:NONAME [CHAR] " PARSE INCLUDED ;
:NONAME [CHAR] " PARSE POSTPONE SLITERAL POSTPONE INCLUDED ;
INT/COMP: INCLUDE" (S i*x "filename" -- j*y )

: FILE-SIZE (S FileHandle -- file-size-lo file-size-high ior )
  0 SP@ ROT GetFileSize SWAP GetLastError ;

: WRITE-LINE (S c-addr u FileHandle -- ior )
  DUP >R WRITE-FILE DROP CR-STR COUNT WRITE-FILE ;

: BIN 4 OR ;

CREATE-REPORT !
