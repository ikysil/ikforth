\
\  file.f
\
\  Copyright (C) 1999-2003 Illya Kysil
\

CR .( Loading FILE definitions )

REPORT-NEW-NAME @
REPORT-NEW-NAME OFF

:NONAME PARSE" INCLUDED ;
:NONAME PARSE" POSTPONE SLITERAL POSTPONE INCLUDED ;
INT/COMP: INCLUDE" (S i*x "filename" -- j*y )

\ 11.6.1.2080 READ-FILE 
\ (S c-addr u1 fileid -- u2 ior )
DEFER READ-FILE (S c-addr u1 fileid -- u2 ior )

DEFER WRITE-FILE (S c-addr u1 fileid -- ior )

DEFER W/O (S -- fam)
DEFER R/W (S -- fam)
DEFER BIN (S fam -- fam1)

USER FILE-CHAR 1 CHARS USER-ALLOC

\ READ-FILE-CHAR
\ (S file-id -- char flag ior )
\ flag is true if char was read successfully
: READ-FILE-CHAR (S file-id -- char flag ior )
  FILE-CHAR SWAP [ 1 CHARS ] LITERAL SWAP READ-FILE
  >R [ 1 CHARS ] LITERAL = FILE-CHAR C@ SWAP R>
;

: ?EOL (S char -- flag )
  13 OVER = SWAP 10 = OR
;

\ 11.6.1.2090 READ-LINE 
\ (S c-addr u1 fileid -- u2 flag ior )
\
\ Read the next line from the file specified by fileid into memory at the address c-addr.
\ At most u1 characters are read.
\ Up to two implementation-defined line-terminating characters may be read into memory
\ at the end of the line, but are not included in the count u2.
\ The line buffer provided by c-addr should be at least u1+2 characters long. 
\
\ If the operation succeeded, flag is true and ior is zero.
\ If a line terminator was received before u1 characters were read,
\ then u2 is the number of characters, not including the line terminator,
\ actually read (0 <= u2 <= u1). When u1 = u2, the line terminator has yet to be reached. 
\
\ If the operation is initiated when the value returned by FILE-POSITION is equal
\ to the value returned by FILE-SIZE for the file identified by fileid,
\ flag is false, ior is zero, and u2 is zero.
\ If ior is non-zero, an exception occurred during the operation and
\ ior is the implementation-defined I/O result code. 
\
\ An ambiguous condition exists if the operation is initiated when the value
\ returned by FILE-POSITION is greater than the value returned by FILE-SIZE
\ for the file identified by fileid, or if the requested operation attempts
\ to read portions of the file not written. 
\
\ At the conclusion of the operation, FILE-POSITION returns the next file position
\ after the last character read. 
: READ-FILE-LINE (S c-addr u1 fileid -- u2 flag ior )
\  2 PICK >R
  2>R 0 TRUE 0
  BEGIN
    2DROP
    DUP 2R@ -ROT           \ S: c-addr u fileid u u1
    = 
    IF                     \ end of input buffer
      DROP TRUE 0
      TRUE
    ELSE
      READ-FILE-CHAR       \ S: c-addr u char flag ior
      ?DUP                 
      IF                   \ if ior <> 0
        >R 2DROP TRUE R>
        TRUE
      ELSE
        IF                 \ if flag
          DUP >R
          ROT C!+ SWAP
          R> ?EOL >R
          R@ INVERT
          IF               \ increment length if not EOL
            1+
          THEN
          TRUE 0 R>
        ELSE               \ end of file (ior = 0 & flag = false)
          DROP DUP 0> 0 TRUE
        THEN
      THEN
    THEN
\ S: c-addr u flag ior until-flag
  UNTIL
  2>R NIP 2R>
  2R> 2DROP
\  2 PICK R> SWAP CR TYPE
;

REPORT-NEW-NAME !
