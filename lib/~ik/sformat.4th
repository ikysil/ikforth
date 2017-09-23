\
\  sformat.4th
\
\  Copyright (C) 1999-2017 Illya Kysil
\

CR .( Loading SFORMAT definitions )

REPORT-NEW-NAME @
REPORT-NEW-NAME ON

ONLY FORTH DEFINITIONS

VOCABULARY SFORMAT-PRIVATE

\ ALSO SFORMAT-PRIVATE DEFINITIONS

\ private definitions go here

32768  CONSTANT  /BUFFER

USER %BUFFER /BUFFER CHARS USER-ALLOC

USER %LEN  1 CELLS USER-ALLOC

: %BUFPOS
   \G Create a word name and allocate storage to keep n pointers to %BUFFER.
   CREATE (S n "name" -- )
      HERE SWAP 2 * CELLS DUP ALLOT ERASE
   DOES>  (S index addr -- addr' )
      SWAP 2 * CELLS +
;

32  CONSTANT  /BUFPOS
/BUFPOS %BUFPOS %POS

USER %POSINDEX 1 CELLS USER-ALLOC

: %CURR (S -- c-addr len )
   \G Return address and length of the current buffer.
   %POSINDEX @
   DUP 0 /BUFPOS WITHIN  IF
      %POS 2@
   ELSE
      EXC-HLD-OVERFLOW THROW
   THEN
;

:NONAME
   \G Reset the % buffer.
   0 %LEN !
   -1 %POSINDEX !
;
DUP STARTUP-CHAIN CHAIN.ADD EXECUTE


ONLY FORTH DEFINITIONS ALSO SFORMAT-PRIVATE

\ public definitions go here
\ private definitions are available for use


: NOT-IMPLEMENTED
   TRUE ABORT" NOT IMPLEMENTED"
;


: <% (S -- )
   \G Initialize string formatting process.
   %POSINDEX @ 1+
   /BUFPOS OVER >  IF
      DUP %POSINDEX !
      %BUFFER %LEN @ + 0
      ROT %POS 2!
   ELSE
      EXC-HLD-OVERFLOW THROW
   THEN
;


: %> (S -- c-addr u )
   \G Finalize string formatting process. c-addr and u specify the resulting character string.
   \G A program may replace characters within the string.
   %CURR
   %POSINDEX @ 1- DUP %POSINDEX !
   0<  IF  0 %LEN !  THEN
;


: %C (S char -- )
   \G Append char to the current formatted string.
   %CURR ROT S"+CHAR
   %POSINDEX @ %POS 2!
   %LEN @ 1 CHARS + %LEN !
;


: %S (S c-addr u -- )
   \G Append the string represented by c-addr u to the current formatted string.
   \G An ambiguous condition exists if %S executes outside of a <% %> delimited formatting process.
   DUP >R
   %CURR 2DUP 2>R
   CHARS + SWAP
   \DEBUG 3DUP SPACE H.8 SPACE H.8 SPACE H.8
   MOVE
   2R> R@ CHARS +
   %POSINDEX @ %POS 2!
   %LEN @ R> CHARS + %LEN !
;


:NONAME
   \G Interpretation: Parse string delimited by quote and append it to the current formatted string.
   \G An ambiguous condition exists if %S" executes outside of a <% %> delimited formatting process.
   POSTPONE S"
   %S
;
:NONAME
   \G Compilation: Parse string delimited by quote and compile runtime behavior described below.
   \G Runtime: Append parsed string to the current formatted string.
   POSTPONE S"
   POSTPONE %S
;
INT/COMP: %S" (S chars" -- )


: %SPACES (S u -- )
   \G Append u spaces to the current formatted string.
   0  ?DO  BL %C  LOOP
;


: %ZEROES (S u -- )
   \G Append u zeroes to the current formatted string.
   0  ?DO  [CHAR] 0 %C  LOOP
;


: %SIGN (S n -- )
   \G Append character '-' (minus) to the current formatted string if n is negative.
   0<  IF  [CHAR] - %C  THEN
;


: %N (S n -- )
   \G Append string representation of signed number n to the current formatted string.
   NOT-IMPLEMENTED
;


: %NL (S n uw -- )
   \G Append string representation of signed number n to the current formatted string.
   \G The string representation is left justified in the field of minimum width uw.
   NOT-IMPLEMENTED
;


: %NR (S n uw -- )
   \G Append string representation of signed number n to the current formatted string.
   \G The string representation is right justified in the field of minimum width uw.
   NOT-IMPLEMENTED
;


: %N0R (S n uw -- )
   \G Append string representation of signed number n to the current formatted string.
   \G The string representation is right justified in the field of minimum width uw and padded using zeroes.
   NOT-IMPLEMENTED
;


: %U (S u -- )
   \G Append string representation of unsigned number u to the current formatted string.
   NOT-IMPLEMENTED
;


: %UL (S n uw -- )
   \G Append string representation of unsigned number n to the current formatted string.
   \G The string representation is left justified in the field of minimum width uw.
   NOT-IMPLEMENTED
;


: %UR (S n uw -- )
   \G Append string representation of unsigned number n to the current formatted string.
   \G The string representation is right justified in the field of minimum width uw.
   NOT-IMPLEMENTED
;


: %U0R (S n uw -- )
   \G Append string representation of unsigned number n to the current formatted string.
   \G The string representation is right justified in the field of minimum width uw and padded using zeroes.
   NOT-IMPLEMENTED
;


: %D (S d -- )
   \G Append string representation of signed double number d to the current formatted string.
   NOT-IMPLEMENTED
;


: %DL (S d uw -- )
   \G Append string representation of signed double number d to the current formatted string.
   \G The string representation is left justified in the field of minimum width uw.
   NOT-IMPLEMENTED
;


: %DR (S d uw -- )
   \G Append string representation of signed double number d to the current formatted string.
   \G The string representation is right justified in the field of minimum width uw.
   NOT-IMPLEMENTED
;


: %D0R (S d uw -- )
   \G Append string representation of signed double number d to the current formatted string.
   \G The string representation is right justified in the field of minimum width uw and padded using zeroes.
   NOT-IMPLEMENTED
;


: %DU (S ud -- )
   \G Append string representation of unsigned double number ud to the current formatted string.
   NOT-IMPLEMENTED
;


: %DUL (S d uw -- )
   \G Append string representation of unsigned double number ud to the current formatted string.
   \G The string representation is left justified in the field of minimum width uw.
   NOT-IMPLEMENTED
;


: %DUR (S d uw -- )
   \G Append string representation of unsigned double number ud to the current formatted string.
   \G The string representation is right justified in the field of minimum width uw.
   NOT-IMPLEMENTED
;


: %DU0R (S d uw -- )
   \G Append string representation of unsigned double number ud to the current formatted string.
   \G The string representation is right justified in the field of minimum width uw and padded using zeroes.
   NOT-IMPLEMENTED
;


ONLY FORTH DEFINITIONS

REPORT-NEW-NAME !

\EOF

CR <% %s" abc" <% char . %c %> %s %s" xyz" %>
CR DUMP
