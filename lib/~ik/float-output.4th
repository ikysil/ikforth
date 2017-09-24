\
\  float-output.4th
\
\  Copyright (C) 1999-2017 Illya Kysil
\

REQUIRES" lib/~ik/sformat.4th"

CR .( Loading FLOAT-OUTPUT definitions )

REPORT-NEW-NAME @
REPORT-NEW-NAME OFF

ONLY FORTH DEFINITIONS

VOCABULARY FLOAT-OUTPUT-PRIVATE

ALSO FLOAT-OUTPUT-PRIVATE DEFINITIONS

\ private definitions go here

ONLY FORTH DEFINITIONS ALSO FLOAT-OUTPUT-PRIVATE

\ public definitions go here
\ private definitions are available for use


: %FS (F r -- )
   \G Append string representation of floating point number r to the current formatted string.
   +S"BUFFER /S"BUFFER
   2DUP BL FILL
   PRECISION MIN
   2DUP 2>R
   REPRESENT
   2R> -TRAILING 2>R
   IF
      \ r was in the implementation-defined range of floating-point numbers.
      %SIGN
      2R> DUP 0=  IF  2DROP DROP EXIT  THEN
      OVER C@ DUP [CHAR] 0 <> SWAP %C
      %DOT
      IF
         1 /STRING
         %S
      ELSE
         2DROP
      THEN
      [CHAR] E %C
      1- %N
   ELSE
      2DROP
      2R>
      %S
   THEN
;


: FS. (F r -- ) \ 12.6.2.1613 FS.
   \G Display, with a trailing space, the top number on the floating-point stack in scientific notation: <significand><exponent> where:
   \G
   \G <significand>	:=	[-]<digit>.<digits0>
   \G <exponent>	:=	E[-]<digits>
   \G An ambiguous condition exists if the value of BASE is not (decimal) ten or if the character string representation exceeds
   \G the size of the pictured numeric output string buffer.
   <% %FS BL %C %> TYPE
;


: FE. (F r -- ) \ 12.6.2.1513 FE.
   \G Display, with a trailing space, the top number on the floating-point stack using engineering notation,
   \G where the significand is greater than or equal to 1.0 and less than 1000.0 and the decimal exponent is a multiple of three.
   \G
   \G An ambiguous condition exists if the value of BASE is not (decimal) ten or if the character string representation exceeds
   \G the size of the pictured numeric output string buffer.
   +S"BUFFER /S"BUFFER
   2DUP BL FILL
   PRECISION MIN
   2DUP 2>R
   REPRESENT
   2R> -TRAILING 2>R
   IF
      \ r was in the implementation-defined range of floating-point numbers.
      IF  [CHAR] - EMIT  THEN
      2R> DUP 0=  IF  SPACE 2DROP DROP EXIT  THEN
      OVER C@ DUP [CHAR] 0 <> SWAP EMIT
      IF
         1 /STRING
         2>R
         DUP 3 MOD 1- 3 + 3 MOD
         DUP 2R@ NIP MIN
         BEGIN
            DUP 0>
         WHILE
            2R>
            1 /STRING
            OVER C@ EMIT
            2>R
            1-
         REPEAT
         DROP
         [CHAR] . EMIT
         2R>
         TYPE
      ELSE
         2DROP
         [CHAR] . EMIT
         0
      THEN
      [CHAR] E EMIT
      - 1- S>D (D.)
   ELSE
      2DROP
      2R>
      TYPE
   THEN
   SPACE
;


: F. (F r -- ) \ 12.6.2.1427 F.
   \G Display, with a trailing space, the top number on the floating-point stack using fixed-point notation:
   \G
   \G [-]<digits>.<digits0>
   \G An ambiguous condition exists if the value of BASE is not (decimal) ten or if the character string representation exceeds
   \G the size of the pictured numeric output string buffer.
   FS.
;


ONLY FORTH DEFINITIONS

REPORT-NEW-NAME !
