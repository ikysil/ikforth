\
\  libc.4th
\
\  Copyright (C) 2016 Illya Kysil
\

REQUIRES" sysdict/dynlib.4th"

CR .( Loading libc definitions )

REPORT-NEW-NAME @
REPORT-NEW-NAME OFF

S" libc.so.6" DYNLIB LIBC.SO

LIBC.SO S" time" DYNLIB-SYMBOL 1 CDECL-C1 _time

: libc-time (S -- x )
   (G Returns the current calendar time )
   0 _time
;

USER libc-localtime-tm 16 CELLS USER-ALLOC

LIBC.SO S" localtime_r" DYNLIB-SYMBOL 2 CDECL-C1 _localtime_r

: libc-localtime (S x -- addr )
   (G Convert the simple time x to broken-down time representation,
      expressed relative to the user's specified time zone. )
   (G Return address of tm structure. )
   SP@ libc-localtime-tm SWAP _localtime_r NIP
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

(G This function writes u1 bytes from c-addr to file.
   It returns the number of bytes written, zero at EOF, or -1 on error.
   It will return zero or a number less than u1 if the disk is full,
   and may return less than u1 even under valid conditions. )
\ ssize_t write(int fileid, const void *buf, size_t nbyte);
LIBC.SO S" write" DYNLIB-SYMBOL 3 CDECL-C1 _write (S u1 c-addr fileid -- x )

:NONAME (S c-addr u1 fileid -- ior )
   ROT SWAP _write
   0< IF GetLastError ELSE 0 THEN
; IS WRITE-FILE

(G This function shall attempt to read nbyte bytes from the file associated
   with the open file descriptor, fileid, into the buffer pointed to by buf.
   The behavior of multiple concurrent reads on the same pipe, FIFO,
   or terminal device is unspecified. )
\ ssize_t read(int fileid, void *buf, size_t nbyte);
LIBC.SO S" read" DYNLIB-SYMBOL 3 CDECL-C1 _read (S u1 c-addr fileid -- x )

:NONAME ( c-addr u1 fileid -- u2 ior )
   ROT SWAP _read
   DUP 0< IF GetLastError ELSE 0 THEN
; IS READ-FILE

(S addr -- )
(G The free function frees the memory space pointed to by ptr, which
   must have been returned by a previous call to malloc, calloc, or
   realloc.  Otherwise, or if free has already been called
   before, undefined behavior occurs.  If addr is NULL, no operation is
   performed. )
LIBC.SO S" free" DYNLIB-SYMBOL 1 CDECL-C0 libc-free

0 CONSTANT STDIN
1 CONSTANT STDOUT
2 CONSTANT STDERR

\ void *memset(void *s, int c, size_t n);
LIBC.SO S" memset" DYNLIB-SYMBOL 3 CDECL-C0 _memset

:NONAME (S c-addr u char -- )
   ROT _memset
; IS FILL

LIBC.SO S" usleep" DYNLIB-SYMBOL 1 CDECL-C0 _usleep

:NONAME (S u -- )
   (G Wait at least u milliseconds. )
   1000 * _usleep
; IS MS

LIBC.SO S" isatty" DYNLIB-SYMBOL 1 CDECL-C1 _isatty

: ISATTY (S fd -- flag )
   (G ISATTY returns TRUE if fd is an open file descriptor referring to a terminal;
      otherwise FALSE is returned. )
   _isatty 0<>
;

LIBC.SO S" tcgetattr" DYNLIB-SYMBOL 2 CDECL-C1 _tcgetattr
LIBC.SO S" tcsetattr" DYNLIB-SYMBOL 3 CDECL-C1 _tcsetattr

\ int __fxstat64(int ver, int fildes, struct stat64 * stat_buf);
\ ver shall be 3 or the behavior of these functions is undefined.
LIBC.SO S" __fxstat64" DYNLIB-SYMBOL 3 CDECL-C1 __fxstat64

\ int __xstat64(int __ver, const char *__filename, struct stat64 *__stat_buf)
LIBC.SO S" __xstat64" DYNLIB-SYMBOL 3 CDECL-C1 __xstat64

3 CONSTANT MAGIC__fxstat64
3 CONSTANT MAGIC__xstat64

\ int fsync(int fd);
LIBC.SO S" fsync" DYNLIB-SYMBOL 1 CDECL-C1 _fsync

\ int ftruncate64(int fd, off_t length);
LIBC.SO S" ftruncate64" DYNLIB-SYMBOL 3 CDECL-C1 _ftruncate64

\ int unlink(const char *path);
LIBC.SO S" unlink" DYNLIB-SYMBOL 1 CDECL-C1 _unlink

\ int rename(const char *old, const char *new);
LIBC.SO S" rename" DYNLIB-SYMBOL 2 CDECL-C1 _rename

REPORT-NEW-NAME !
