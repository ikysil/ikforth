\
\  sformat.4th
\
\  Unlicense since 1999 by Illya Kysil
\

CR .( Loading SFORMAT definitions )

REPORT-NEW-NAME @
REPORT-NEW-NAME OFF

ONLY FORTH DEFINITIONS

VOCABULARY SFORMAT-PRIVATE

ALSO SFORMAT-PRIVATE DEFINITIONS

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

: INIT-SFORMAT
   \G Reset the % buffer.
   0 %LEN !
   -1 %POSINDEX !
;
' INIT-SFORMAT DUP STARTUP-CHAIN CHAIN.ADD EXECUTE


ONLY FORTH DEFINITIONS ALSO SFORMAT-PRIVATE

\ public definitions go here
\ private definitions are available for use

SYNONYM %CURR %CURR

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
   \DEBUG 2DUP SPACE H.8 SPACE H.8 SPACE 2>R DUP H.8 2R>
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


: %EXECUTE-JL (S uw xt -- )
   \G Execute xt and append string representation produced by the execution of xt to the current formatted string.
   \G xt is expected to produce the output to the current formatted string.
   \G The string representation is left justified in the field of minimum width uw.
   SWAP
   %CURR NIP + >R
   EXECUTE
   %CURR NIP R> SWAP - 0 MAX %SPACES
;


: %EXECUTE-JR (S uw xt -- )
   \G Execute xt and append string representation produced by the execution of xt to the current formatted string.
   \G xt is expected to produce the output to the current formatted string.
   \G The string representation is right justified in the field of minimum width uw.
   %CURR CHARS + >R          \ S: uw xt              R: c-addr1
   EXECUTE
   %CURR CHARS +             \ S: uw c-addr2         R: c-addr1
   DUP R@ - DUP >R           \ S: uw c-addr2 uf      R: c-addr1 uf
   ROT CHARS SWAP - 0 MAX    \ S: c-addr2 usp        R: c-addr1
   NIP DUP %SPACES           \ S: usp                R: c-addr1 uf
   R> R@ ROT                 \ S: uf c-addr1 usp     R: c-addr1
   DUP >R                    \ S: uf c-addr1 usp     R: c-addr1 usp
   OVER + ROT MOVE           \ S:                    R: c-addr1 usp
   R> R> SWAP BL FILL
;


: %SIGN (S n -- )
   \G Append character '-' (minus) to the current formatted string if n is negative.
   0<  IF  [CHAR] - %C  THEN
;


: %DOT (S -- )
   \G Append character '.' (dot) to the current formatted string.
   [CHAR] . %C
;


: %CR (S -- )
   \G Append characters to the current formatted string so that the characters which follow will appeara t the beginning of the next line of output.
   13 %C 10 %C
;


: (%UD) (S ud -- c-addr u )
   \G Format unsigned double ud and return string address and length.
   <# #S #>
;


: (%D) (S d -- c-addr u )
   \G Format signed double d and return string address and length.
   <#
   DUP >R
   DUP 0<  IF  DABS  THEN
   #S
   R> SIGN
   #>
;


: %D (S d -- )
   \G Append string representation of signed double number d to the current formatted string.
   (%D) %S %DOT
;


: %DL (S d uw -- )
   \G Append string representation of signed double number d to the current formatted string.
   \G The string representation is left justified in the field of minimum width uw.
   1- >R
   (%D)
   DUP >R
   %S %DOT
   R> R> SWAP - 0 MAX %SPACES
;


: %DR (S d uw -- )
   \G Append string representation of signed double number d to the current formatted string.
   \G The string representation is right justified in the field of minimum width uw.
   1- >R
   (%D)
   DUP R> SWAP - 0 MAX %SPACES
   %S %DOT
;


: %D0R (S d uw -- )
   \G Append string representation of signed double number d to the current formatted string.
   \G The string representation is right justified in the field of minimum width uw and padded using zeroes.
   1- >R
   DUP %SIGN
   DUP 0<  IF  DABS R> 1- >R  THEN
   (%UD)
   DUP R> SWAP - 0 MAX %ZEROES
   %S %DOT
;


: %DU (S ud -- )
   \G Append string representation of unsigned double number ud to the current formatted string.
   (%UD) %S %DOT
;


: %DUL (S ud uw -- )
   \G Append string representation of unsigned double number ud to the current formatted string.
   \G The string representation is left justified in the field of minimum width uw.
   1- >R
   (%UD)
   DUP >R
   %S %DOT
   R> R> SWAP - 0 MAX %SPACES
;


: %DUR (S ud uw -- )
   \G Append string representation of unsigned double number ud to the current formatted string.
   \G The string representation is right justified in the field of minimum width uw.
   1- >R
   (%UD)
   DUP R> SWAP - 0 MAX %SPACES
   %S %DOT
;


: %DU0R (S ud uw -- )
   \G Append string representation of unsigned double number ud to the current formatted string.
   \G The string representation is right justified in the field of minimum width uw and padded using zeroes.
   1- >R
   (%UD)
   DUP R> SWAP - 0 MAX %ZEROES
   %S %DOT
;


: %N (S n -- )
   \G Append string representation of signed number n to the current formatted string.
   S>D (%D) %S
;


: %NL (S n uw -- )
   \G Append string representation of signed number n to the current formatted string.
   \G The string representation is left justified in the field of minimum width uw.
   >R
   S>D (%D)
   DUP >R
   %S
   R> R> SWAP - 0 MAX %SPACES
;


: %NR (S n uw -- )
   \G Append string representation of signed number n to the current formatted string.
   \G The string representation is right justified in the field of minimum width uw.
   >R
   S>D (%D)
   DUP R> SWAP - 0 MAX %SPACES
   %S
;


: %N0R (S n uw -- )
   \G Append string representation of signed number n to the current formatted string.
   \G The string representation is right justified in the field of minimum width uw and padded using zeroes.
   >R
   S>D
   DUP %SIGN
   DUP 0<  IF  DABS R> 1- >R  THEN
   (%UD)
   DUP R> SWAP - 0 MAX %ZEROES
   %S
;


: %U (S u -- )
   \G Append string representation of unsigned number u to the current formatted string.
   0 (%UD) %S
;


: %UL (S n uw -- )
   \G Append string representation of unsigned number n to the current formatted string.
   \G The string representation is left justified in the field of minimum width uw.
   >R
   0 (%UD)
   DUP >R
   %S
   R> R> SWAP - 0 MAX %SPACES
;


: %UR (S n uw -- )
   \G Append string representation of unsigned number n to the current formatted string.
   \G The string representation is right justified in the field of minimum width uw.
   >R
   0 (%UD)
   DUP R> SWAP - 0 MAX %SPACES
   %S
;


: %U0R (S n uw -- )
   \G Append string representation of unsigned number n to the current formatted string.
   \G The string representation is right justified in the field of minimum width uw and padded using zeroes.
   >R
   0 (%UD)
   DUP R> SWAP - 0 MAX %ZEROES
   %S
;


ONLY FORTH DEFINITIONS

REPORT-NEW-NAME !

\EOF

CR <% %s" abc" <% char . %c %> %s %s" xyz" %>
CR DUMP

CR H.S

CR -10. <% %S" | " %D %S"  |" %>
64 MIN TYPE
CR -10. <% %S" | " D# 24 %DL %S"  |" %>
64 MIN TYPE
CR -10. <% %S" | " D# 24 %DR %S"  |" %>
64 MIN TYPE
CR -10. <% %S" | " D# 24 %D0R %S"  |" %>
64 MIN TYPE
CR -10. <% %S" | " D# 14 %DL %S"  |" %>
64 MIN TYPE
CR -10. <% %S" | " D# 14 %DR %S"  |" %>
64 MIN TYPE
CR -10. <% %S" | " D# 14 %D0R %S"  |" %>
64 MIN TYPE

CR -10. <% %S" | " %DU %S"  |" %>
64 MIN TYPE
CR -10. <% %S" | " D# 24 %DUL %S"  |" %>
64 MIN TYPE
CR -10. <% %S" | " D# 24 %DUR %S"  |" %>
64 MIN TYPE
CR -10. <% %S" | " D# 24 %DU0R %S"  |" %>
64 MIN TYPE
CR -10. <% %S" | " D# 14 %DUL %S"  |" %>
64 MIN TYPE
CR -10. <% %S" | " D# 14 %DUR %S"  |" %>
64 MIN TYPE
CR -10. <% %S" | " D# 14 %DU0R %S"  |" %>
64 MIN TYPE

CR -10 <% %S" | " %N %S"  |" %>
64 MIN TYPE
CR -10 <% %S" | " D# 24 %NL %S"  |" %>
64 MIN TYPE
CR -10 <% %S" | " D# 24 %NR %S"  |" %>
64 MIN TYPE
CR -10 <% %S" | " D# 24 %N0R %S"  |" %>
64 MIN TYPE
CR -10 <% %S" | " D# 14 %NL %S"  |" %>
64 MIN TYPE
CR -10 <% %S" | " D# 14 %NR %S"  |" %>
64 MIN TYPE
CR -10 <% %S" | " D# 14 %N0R %S"  |" %>
64 MIN TYPE

CR -10 <% %S" | " %U %S"  |" %>
64 MIN TYPE
CR -10 <% %S" | " D# 24 %UL %S"  |" %>
64 MIN TYPE
CR -10 <% %S" | " D# 24 %UR %S"  |" %>
64 MIN TYPE
CR -10 <% %S" | " D# 24 %U0R %S"  |" %>
64 MIN TYPE
CR -10 <% %S" | " D# 14 %UL %S"  |" %>
64 MIN TYPE
CR -10 <% %S" | " D# 14 %UR %S"  |" %>
64 MIN TYPE
CR -10 <% %S" | " D# 14 %U0R %S"  |" %>
64 MIN TYPE

CR H.S
