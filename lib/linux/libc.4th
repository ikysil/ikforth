\
\  libc.4th
\
\  Copyright (C) 2016 Illya Kysil
\

REQUIRES" lib/win32/dllintf.f"

CR .( Loading libc definitions )

REPORT-NEW-NAME @
REPORT-NEW-NAME OFF

DLLImport LIBC.SO "libc.so.6"

: (cdecl-import-c0) (S 'Name' -- )
   CREATE 0 ,
   DOES> @ CALL-CDECL-C0
;

: cdecl-import-c0 (S 'Name' 'DLL' 'DLLName' -- )
   (cdecl-import-c0) DLLEntry.Init
;

: (cdecl-import-c1) (S 'Name' -- )
   CREATE 0 ,
   DOES> @ CALL-CDECL-C1
;

: cdecl-import-c1 (S 'Name' 'DLL' 'DLLName' -- )
   (cdecl-import-c1) DLLEntry.Init
;

: (cdecl-import-c2) (S 'Name' -- )
   CREATE 0 ,
   DOES> @ CALL-CDECL-C2
;

: cdecl-import-c2 (S 'Name' 'DLL' 'DLLName' -- )
   (cdecl-import-c2) DLLEntry.Init
;

cdecl-import-c1 _time LIBC.SO time

: libc-time (S -- x )
   (G Returns the current calendar time )
   0 1 _time
;

USER libc-localtime-tm 16 CELLS USER-ALLOC

cdecl-import-c1 _localtime_r LIBC.SO localtime_r

: libc-localtime (S x -- addr )
   (G Convert the simple time x to broken-down time representation,
      expressed relative to the user's specified time zone. )
   (G Return address of tm structure. )
   \ localtime_r has 2 actual parameters but we would like to remove x as well
   SP@ libc-localtime-tm SWAP 3 _localtime_r
;

1900 CONSTANT LOCALTIME-BASEYEAR

:NONAME (S -- +n1 +n2 +n3 +n4 +n5 +n6 )
   libc-time libc-localtime
   @+ SWAP
   @+ SWAP
   @+ SWAP
   @+ SWAP
   @+ 1+ SWAP
   @ LOCALTIME-BASEYEAR +
; IS TIME&DATE

:NONAME
   4 OR
; IS BIN

:NONAME
   1
; IS W/O

:NONAME
   2
; IS R/W

: libc-write (S u1 c-addr fileid -- x )
   (G This function writes u1 bytes from c-addr to file.
      It returns the number of bytes written, zero at EOF, or -1 on error.
      It will return zero or a number less than u1 if the disk is full,
      and may return less than u1 even under valid conditions. )
   3 S" write" LIBC.SO (GetProcAddress) CALL-CDECL-C1
;

:NONAME (S c-addr u1 fileid -- ior )
   ROT SWAP libc-write
   0< IF GetLastError ELSE 0 THEN
; IS WRITE-FILE

cdecl-import-c0 _free LIBC.SO free

: libc-free (S addr -- )
   (G The free function frees the memory space pointed to by ptr, which
      must have been returned by a previous call to malloc, calloc, or
      realloc.  Otherwise, or if free has already been called
      before, undefined behavior occurs.  If addr is NULL, no operation is
      performed. )
   1 _free
;

0 CONSTANT STDIN
1 CONSTANT STDOUT
2 CONSTANT STDERR

cdecl-import-c0 _memset LIBC.SO memset

:NONAME (S c-addr u char -- )
   SWAP ROT 3 _memset
; IS FILL

cdecl-import-c0 _usleep LIBC.SO usleep

:NONAME (S u -- )
   (G Wait at least u milliseconds. )
   1000 * 1 _usleep
; IS MS

REPORT-NEW-NAME !
