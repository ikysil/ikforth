\
\  float-output.4th
\
\  Copyright (C) 1999-2017 Illya Kysil
\

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


: FS. (F r -- ) \ 12.6.2.1613 FS.
   \G Display, with a trailing space, the top number on the floating-point stack in scientific notation: <significand><exponent> where:
   \G
   \G <significand>	:=	[-]<digit>.<digits0>
   \G <exponent>	:=	E[-]<digits>
   \G An ambiguous condition exists if the value of BASE is not (decimal) ten or if the character string representation exceeds
   \G the size of the pictured numeric output string buffer.
   +S"BUFFER /S"BUFFER
   2DUP BL FILL
   PRECISION MIN
   2DUP 2>R
   REPRESENT
   IF
      \ r was in the implementation-defined range of floating-point numbers.
      IF  [CHAR] - EMIT  THEN
      2R> -TRAILING
      DUP 0=  IF  SPACE 2DROP EXIT  THEN
      OVER C@ DUP [CHAR] 0 <> SWAP
      EMIT [CHAR] . EMIT
      IF
         1 /STRING
         TYPE
         [CHAR] E EMIT
         1- S>D (D.)
      THEN
   ELSE
      2DROP
      2R> -TRAILING
      TYPE
   THEN
   SPACE
;


: FE. (F r -- ) \ 12.6.2.1513 FE.
   \G Display, with a trailing space, the top number on the floating-point stack using engineering notation,
   \G where the significand is greater than or equal to 1.0 and less than 1000.0 and the decimal exponent is a multiple of three.
   \G
   \G An ambiguous condition exists if the value of BASE is not (decimal) ten or if the character string representation exceeds
   \G the size of the pictured numeric output string buffer.
   FS.
;


: F. (F r -- ) \ 12.6.2.1427 F.
   \G Display, with a trailing space, the top number on the floating-point stack using fixed-point notation:
   \G
   \G [-] <digits>.<digits0>
   \G An ambiguous condition exists if the value of BASE is not (decimal) ten or if the character string representation exceeds
   \G the size of the pictured numeric output string buffer.
   FS.
;


ONLY FORTH DEFINITIONS

REPORT-NEW-NAME !
