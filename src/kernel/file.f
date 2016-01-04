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
: _READ-LINE (S c-addr u1 fileid -- u2 flag ior )
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
;

\ 11.6.1.1717 INCLUDE-FILE 
\ (S i*x fileid -- j*x )
\ 
\ Remove fileid from the stack. Save the current input source specification,
\ including the current value of SOURCE-ID. Store fileid in SOURCE-ID.
\ Make the file specified by fileid the input source. Store zero in BLK.
\ Other stack effects are due to the words included. 
\ Repeat until end of file: read a line from the file, fill the input buffer
\ from the contents of that line, set >IN to zero, and interpret. 
\ Text interpretation begins at the file position where the next file read would occur. 
\ When the end of the file is reached, close the file and restore
\ the input source specification to its saved value. 
\ An ambiguous condition exists if fileid is invalid,
\ if there is an I/O exception reading fileid,
\ or if an I/O exception occurs while closing fileid.
\ When an ambiguous condition exists, the status (open or closed) of any files
\ that were being interpreted is implementation-defined.
: (_INCLUDE-FILE) (S -- exc-id )
  0
  BEGIN
    DUP 0= DUP          \ exc-id flag flag
    IF
      DROP
      SOURCE-ID FILE-POSITION THROW CURRENT-FILE-POSITION 2!
      REFILL
    THEN
  WHILE                 \ exc-id
    DROP ['] INTERPRET CATCH
  REPEAT
  SOURCE-ID CLOSE-FILE THROW
;

: _INCLUDE-FILE (S i*x fileid -- j*x )
  INPUT>R RESET-INPUT SOURCE-ID!
  ['] (_INCLUDE-FILE) CATCH \ (S exc-id 0 | exc-id )
  ?DUP DROP                 \ (S exc-id )
  R>INPUT THROW
;

\ 11.6.1.1718 INCLUDED 
\ (S i*x c-addr u -- j*x )
\ 
\ Remove c-addr u from the stack. Save the current input source specification,
\ including the current value of SOURCE-ID. Open the file specified by c-addr u,
\ store the resulting fileid in SOURCE-ID, and make it the input source.
\ Store zero in BLK. Other stack effects are due to the words included. 
\ Repeat until end of file: read a line from the file,
\ fill the input buffer from the contents of that line, set >IN to zero, and interpret. 
\ Text interpretation begins at the file position where the next file read would occur. 
\ When the end of the file is reached, close the file and restore
\ the input source specification to its saved value. 
\ An ambiguous condition exists if the named file can not be opened,
\ if an I/O exception occurs reading the file,
\ or if an I/O exception occurs while closing the file.
\ When an ambiguous condition exists, the status (open or closed) of any files
\ that were being interpreted is implementation-defined. 
: _INCLUDED (S i*x c-addr u -- j*x )
  R/O OPEN-FILE THROW INCLUDE-FILE
;

REPORT-NEW-NAME !
