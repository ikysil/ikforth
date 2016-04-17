\
\  locate.4th
\
\  Copyright (C) 2016 Illya Kysil
\

REQUIRE-NAME INCLUDED-WORDLIST src/kernel/required.4th

CR .( Loading LOCATE definitions )

REPORT-NEW-NAME @
REPORT-NEW-NAME OFF

ONLY FORTH DEFINITIONS

VOCABULARY LOCATE-PRIVATE

ALSO LOCATE-PRIVATE DEFINITIONS

\ private definitions go here

: LOCATE@ \ S: h-id -- include-mark position line-number
  DUP H>#NAME >R DROP
  [ 3 CELLS ] LITERAL -  \ S: locate-addr1 R: name-len
  @+ SWAP                \ S: include-mark locate-addr2
  @+ R> - SWAP           \ S: include-mark position locate-addr3
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
  ' >HEAD DUP HFLAGS@ &LOCATE AND 0=
  IF ." No LOCATE information available" DROP EXIT THEN
  LOCATE@ 4 .R 4 .R 3 SPACES
  ?DUP IF   @ >HEAD H>#NAME TYPE   ELSE   ." <unknown>"   THEN
;

ONLY FORTH DEFINITIONS

REPORT-NEW-NAME !
