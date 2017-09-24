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


: %FSL (S uw -- ) (F r -- )
   \G Append string representation of floating point number r to the current formatted string.
   \G The string representation is left justified in the field of minimum width uw.
   %CURR NIP + >R
   %FS
   %CURR NIP R> SWAP - 0 MAX %SPACES
;


: %FSR (S uw -- ) (F r -- )
   \G Append string representation of floating point number r to the current formatted string.
   \G The string representation is right justified in the field of minimum width uw.
   %CURR CHARS + >R          \ S: uw                 R: c-addr1
   %FS
   %CURR CHARS +             \ S: uw c-addr2         R: c-addr1
   DUP R@ - DUP >R           \ S: uw c-addr2 uf      R: c-addr1 uf
   ROT CHARS SWAP - 0 MAX    \ S: c-addr2 usp        R: c-addr1
   NIP DUP %SPACES           \ S: usp                R: c-addr1 uf
   R> R@ ROT                 \ S: uf c-addr1 usp     R: c-addr1
   DUP >R                    \ S: uf c-addr1 usp     R: c-addr1 usp
   OVER + ROT MOVE           \ S:                    R: c-addr1 usp
   R> R> SWAP BL FILL
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


: %FE (F r -- )
   \G Append string representation of floating point number r using engineering notation to the current formatted string.
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
      IF
         1 /STRING
         2>R
         DUP 3 MOD 1- 3 + 3 MOD
         DUP 2R@ NIP MIN
         BEGIN
            DUP 0>
         WHILE
            2R>
            OVER C@ %C
            1 /STRING
            2>R
            1-
         REPEAT
         DROP
         %DOT
         2R>
         %S
      ELSE
         2DROP
         %DOT
         0
      THEN
      [CHAR] E %C
      - 1- %N
   ELSE
      2DROP
      2R>
      %S
   THEN
;


: %FEL (S uw -- ) (F r -- )
   \G Append string representation of floating point number r using engineering notation to the current formatted string.
   \G The string representation is left justified in the field of minimum width uw.
   %CURR NIP + >R
   %FE
   %CURR NIP R> SWAP - 0 MAX %SPACES
;


: %FER (S uw -- ) (F r -- )
   \G Append string representation of floating point number r using engineering notation to the current formatted string.
   \G The string representation is right justified in the field of minimum width uw.
   %CURR CHARS + >R          \ S: uw                 R: c-addr1
   %FE
   %CURR CHARS +             \ S: uw c-addr2         R: c-addr1
   DUP R@ - DUP >R           \ S: uw c-addr2 uf      R: c-addr1 uf
   ROT CHARS SWAP - 0 MAX    \ S: c-addr2 usp        R: c-addr1
   NIP DUP %SPACES           \ S: usp                R: c-addr1 uf
   R> R@ ROT                 \ S: uf c-addr1 usp     R: c-addr1
   DUP >R                    \ S: uf c-addr1 usp     R: c-addr1 usp
   OVER + ROT MOVE           \ S:                    R: c-addr1 usp
   R> R> SWAP BL FILL
;


: FE. (F r -- ) \ 12.6.2.1513 FE.
   \G Display, with a trailing space, the top number on the floating-point stack using engineering notation,
   \G where the significand is greater than or equal to 1.0 and less than 1000.0 and the decimal exponent is a multiple of three.
   \G
   \G An ambiguous condition exists if the value of BASE is not (decimal) ten or if the character string representation exceeds
   \G the size of the pictured numeric output string buffer.
   <% %FE BL %C %> TYPE
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

\EOF

123.e    25 <% %CR '|' %c %fsl '|' %c %> type
123.e    25 <% %CR '|' %c %fsl '|' %c %> type
-123.e   25 <% %CR '|' %c %fsr '|' %c %> type
-123.e   25 <% %CR '|' %c %fsr '|' %c %> type
123.e    15 <% %CR '|' %c %fsl '|' %c %> type
123.e    15 <% %CR '|' %c %fsr '|' %c %> type
-123.e   15 <% %CR '|' %c %fsl '|' %c %> type
-123.e   15 <% %CR '|' %c %fsr '|' %c %> type
-123.e    0 <% %CR '|' %c %fsl '|' %c %> type
-123.e    0 <% %CR '|' %c %fsr '|' %c %> type
-123.e  -15 <% %CR '|' %c %fsl '|' %c %> type
-123.e  -15 <% %CR '|' %c %fsr '|' %c %> type

CR

12345.e       <% %CR '|' %c %fe  '|' %c %> type
12345.e    25 <% %CR '|' %c %fel '|' %c %> type
12345.e    25 <% %CR '|' %c %fel '|' %c %> type
-12345.e   25 <% %CR '|' %c %fer '|' %c %> type
-12345.e   25 <% %CR '|' %c %fer '|' %c %> type
12345.e    15 <% %CR '|' %c %fel '|' %c %> type
12345.e    15 <% %CR '|' %c %fer '|' %c %> type
-12345.e   15 <% %CR '|' %c %fel '|' %c %> type
-12345.e   15 <% %CR '|' %c %fer '|' %c %> type
-12345.e    0 <% %CR '|' %c %fel '|' %c %> type
-12345.e    0 <% %CR '|' %c %fer '|' %c %> type
-12345.e  -15 <% %CR '|' %c %fel '|' %c %> type
-12345.e  -15 <% %CR '|' %c %fer '|' %c %> type

CR
