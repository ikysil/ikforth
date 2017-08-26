\
\  word.4th
\
\  Copyright (C) 1999-2017 Illya Kysil
\

\  6.1.2450 WORD
\  ( char "<chars>ccc<char>" -- c-addr )
\  Skip leading delimiters. Parse characters ccc delimited by char.
\  An ambiguous condition exists if the length of the parsed string is greater than the implementation-defined length of a counted string.
\
\  c-addr is the address of a transient region containing the parsed word as a counted string.
\  If the parse area was empty or contained no characters other than the delimiter,
\  the resulting string has a zero length. A program may replace characters within the string.
: WORD ( char "<chars>ccc<char>" -- c-addr )
   SOURCE >IN @ /STRING
   OVER >R           \ S: char c-addr u    R: c-addr
   SKIP-BLANK        \ S: char c-addr' u'  R: c-addr
   OVER R> - >IN+    \ fix >IN over skipped spaces
   (PARSE)
   \DEBUG CR S" WORD-A:" TYPE 2DUP TYPE
   DUP CHAR+ >IN+    \ fix >IN over parsed characters and delimiter
   S">POCKET
;
