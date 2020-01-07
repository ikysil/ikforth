\
\  string-escape.4th
\
\  Unlicense since 1999 by Illya Kysil
\

CR .( Loading STRING-ESCAPE definitions )

REPORT-NEW-NAME @
REPORT-NEW-NAME OFF

DECIMAL

DEFER ESCAPE\" (S c-addr u d-addr -- c-addr' u' d-addr' )
(G Process an escape sequence at c-addr after \ and store converted characters at d-addr. )
(G Do nothing if u is zero. )
(G Modify c-addr and u according to the number of processed characters. )
(G Modify d-addr according to the number of converted characters. )

:NONAME (S c-addr u d-addr -- c-addr' u' d-addr' )
   OVER 0= IF   EXIT   THEN
   >R OVER C@ R> 2SWAP
   1 /STRING
   2SWAP C!+
; IS ESCAPE\"

:NONAME (S c-addr u d-addr -- c-addr' u' d-addr' )
   OVER 0= IF   EXIT   THEN
   >R
\  \a   BEL             (alert, ASCII 7)
   OVER C@ [CHAR] a = IF
      1 /STRING
      7 R> C!+
      EXIT
   THEN
\  \b   BS              (backspace, ASCII 8)
   OVER C@ [CHAR] b = IF
      1 /STRING
      8 R> C!+
      EXIT
   THEN
\  \e   ESC             (escape,    ASCII 27)
   OVER C@ [CHAR] e = IF
      1 /STRING
      27 R> C!+
      EXIT
   THEN
\  \f   FF              (form feed, ASCII 12)
   OVER C@ [CHAR] f = IF
      1 /STRING
      12 R> C!+
      EXIT
   THEN
\  \l   LF              (line feed, ASCII 10)
   OVER C@ [CHAR] l = IF
      1 /STRING
      10 R> C!+
      EXIT
   THEN
\  \m   CR/LF   pair    (ASCII 13, 10)
   OVER C@ [CHAR] m = IF
      1 /STRING
      13 R> C!+ 10 SWAP C!+
      EXIT
   THEN
\  \n   newline         (implementation dependent , e.g., CR/LF, CR, LF, LF/CR)
   OVER C@ [CHAR] n = IF
      1 /STRING
      10 R> C!+
      EXIT
   THEN
\  \q   double-quote    (ASCII 34)
   OVER C@ [CHAR] q = IF
      1 /STRING
      [CHAR] " R> C!+
      EXIT
   THEN
\  \r   CR              (carriage return,   ASCII 13)
   OVER C@ [CHAR] r = IF
      1 /STRING
      13 R> C!+
      EXIT
   THEN
\  \t   HT                (horizontal tab,    ASCII 9)
   OVER C@ [CHAR] t = IF
      1 /STRING
      9 R> C!+
      EXIT
   THEN
\  \v   VT                (vertical tab,  ASCII 11)
   OVER C@ [CHAR] v = IF
      1 /STRING
      11 R> C!+
      EXIT
   THEN
\  \z   NUL               (no character,  ASCII 0)
   OVER C@ [CHAR] z = IF
      1 /STRING
      0 R> C!+
      EXIT
   THEN
\  \x<hexdigit><hexdigit>
\  The resulting character is the conversion of these two hexadecimal digits.
\  An ambiguous conditions exists if \x is not followed by two hexadecimal characters.
   OVER C@ [CHAR] x = IF
      1 /STRING
      0 0 2OVER DROP 2 ['] >NUMBER 16 BASE-EXECUTE 2DROP DROP
      R> 2SWAP 2 /STRING 2SWAP C!+
      EXIT
   THEN
\  \"   double-quote      (ASCII 34)
\  \\   backslash itself  (ASCII 92)
   R> DEFERRED ESCAPE\"
; IS ESCAPE\"

: CONVERT\ (S char c-addr1 u1 d-addr -- c-addr1' u1' d-u )
   DUP >R >R \ S: char c-addr1 u1 ; R: d-addr d-addr'
   BEGIN
      DUP 0>
   WHILE
      \ S: char c-addr1' u1' ; R: d-addr d-addr'
      OVER C@ 3 PICK <>
   WHILE
      OVER C@ DUP
      [CHAR] \ =
      IF
         DROP
         1 /STRING
         R> ESCAPE\" >R
      ELSE
         R> C!+ >R
         1 /STRING
      THEN
   REPEAT THEN
   ROT DROP
   DUP IF   1 /STRING   THEN
   R> R> - \ assuming one-byte characters here
;

: CONVERT\" (S c-addr1 u1 d-addr -- c-addr1' u1' d-u )
  [CHAR] " SWAP 2SWAP ROT CONVERT\
;

: PARSE\ (S char "ccc<char>" -- c-addr u )
   (G Parse ccc delimited by the delimiter char.)
   (G c-addr is the address [within the input buffer] and u is the length of the parsed string.)
   (G If the parse area was empty, the resulting string has a zero length.)
   SOURCE >IN @ /STRING
   DUP >R +S"BUFFER DUP >R
   CONVERT\ \ S: c-addr1' u1' d-u ; R: source-len d-addr
   ROT DROP
   R>  SWAP \ S: u1' d-addr d-u ; R: source-len
   ROT R> SWAP - >IN +!
;

: PARSE\" (S "ccc<quote>" -- c-addr u )
   (G Parse ccc delimited by " [double-quote] and return c-addr and u describing )
   (G a string consisting of the characters ccc. )
   [CHAR] " PARSE\
;

: C\"
  PARSE\"
  POSTPONE (C") ,C"
; IMMEDIATE/COMPILE-ONLY

:NONAME
  PARSE\"
;
:NONAME
  PARSE\"
  POSTPONE (S") ,S"
;
INT/COMP: S\"

REPORT-NEW-NAME !
