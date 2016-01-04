\
\  file.f
\
\  Copyright (C) 1999-2003 Illya Kysil
\

CR .( Loading FILE definitions )

CREATE-REPORT @
CREATE-REPORT OFF

S" File not found"
2 (EXCEPTION)

: DELETE-FILE (S c-addr u -- ior )
  S">Z" DUP DeleteFile DROP
  FREE THROW GetLastError ;

: RENAME-FILE (S c-addr1 u1 c-addr2 u2 -- ior )
  S">Z" -ROT S">Z" 2DUP MoveFile DROP
  FREE THROW FREE THROW GetLastError ;

: FILE-STATUS (S c-addr u -- x ior )
  S">Z" DUP GetFileAttributes
  SWAP FREE THROW GetLastError ;

: FLUSH-FILE (S FileHandle -- ior )
  FlushFileBuffers GetLastError ;

:NONAME PARSE" INCLUDED ;
:NONAME PARSE" POSTPONE SLITERAL POSTPONE INCLUDED ;
INT/COMP: INCLUDE" (S i*x "filename" -- j*y )

: FILE-SIZE (S FileHandle -- file-size-lo file-size-high ior )
  0 SP@ ROT GetFileSize SWAP GetLastError ;

: WRITE-LINE (S c-addr u FileHandle -- ior )
  DUP >R WRITE-FILE DROP CR-STR COUNT WRITE-FILE ;

: BIN 4 OR ;

CREATE-REPORT !
