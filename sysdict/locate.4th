PURPOSE: LOCATE definitions
LICENSE: Unlicense since 1999 by Illya Kysil

REQUIRE-NAME INCLUDED-WORDLIST sysdict/required.4th

REPORT-NEW-NAME @
REPORT-NEW-NAME OFF

ONLY FORTH DEFINITIONS

VOCABULARY LOCATE-PRIVATE

ALSO LOCATE-PRIVATE DEFINITIONS

\ private definitions go here

: LOCATE@ \ S: locate-addr -- include-mark position line-number
   @+ SWAP                \ S: include-mark locate-addr2
   @+ SWAP                \ S: include-mark position locate-addr3
   @                      \ S: include-mark position line-number
;

ONLY FORTH DEFINITIONS ALSO LOCATE-PRIVATE

\ public definitions go here
\ private definitions are available for use

\ -----------------------------------------------------------------------------
\  LOCATE
\ -----------------------------------------------------------------------------

: LOCATE \ S: "name" --
   \ Parse name and print the information on the source location
   ' CODE>NAME NAME>LOCATE DUP 0=
   IF   ." No LOCATE information available" 2DROP EXIT   THEN
   LOCATE@ 4 .R 4 .R 3 SPACES
   ?DUP IF   @ CODE>NAME NAME>STRING   ELSE   S" <unknown>"   THEN
   TYPE
;

ONLY FORTH DEFINITIONS

REPORT-NEW-NAME !
