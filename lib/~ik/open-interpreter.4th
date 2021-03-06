PURPOSE: OPEN INTERPRETER definitions
LICENSE: Unlicense since 1999 by Illya Kysil

REPORT-NEW-NAME @
REPORT-NEW-NAME OFF

: >TCODE (S xt -- acp )
  >BODY
;

: >RR (S cp -- ) (R -- cp )
  R> SWAP >R >R
; COMPILE-ONLY

: >RR< (S cp1 -- cp2 ) (R cp2 -- cp1 )
  R> R> ROT >R SWAP >R
; COMPILE-ONLY

: RR> (S -- cp ) (R cp -- )
  R> R> SWAP >R
; COMPILE-ONLY

: RR@ (S -- cp ) (R cp -- cp )
  R> R@ SWAP >R
; COMPILE-ONLY

: RRDROP (S -- ) (R cp -- )
  R> R> DROP >R
; COMPILE-ONLY

: RUSH (S i*x xt -- j*x )
  RRDROP >TCODE >RR
; COMPILE-ONLY

: COPY>RR (S cp -- cp ) (R -- cp )
  DUP >RR
;

: RADDR@ (S addr -- cp )
  @
;

: RADDR! (S cp addr -- )
  !
;

: RADDR+ (S addr1 -- addr2 )
  CELL+
;

: RADDR- (S addr1 -- addr2 )
  [ 1 CELLS ] LITERAL -
;

REPORT-NEW-NAME !
