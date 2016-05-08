\  6.1.2450 WORD
\  ( char "<chars>ccc<char>" -- c-addr )
\  Skip leading delimiters. Parse characters ccc delimited by char.
\  An ambiguous condition exists if the length of the parsed string is greater than the implementation-defined length of a counted string.
\
\  c-addr is the address of a transient region containing the parsed word as a counted string.
\  If the parse area was empty or contained no characters other than the delimiter,
\  the resulting string has a zero length. A program may replace characters within the string.
: WORD ( char "<chars>ccc<char>" -- c-addr )
   SOURCE >IN @ /STRING (PARSE-NAME) S">POCKET
;
