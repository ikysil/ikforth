\ DEBUG-ON
: F0< (S -- flag ) (F r -- ) \ 12.6.1.1440 F0<
   (G flag is true if and only if r is less than zero.)
   1 ?FPSTACK-UNDERFLOW
   ?FPX-NAN   IF  FDROP FALSE EXIT  THEN
   ?FPX-SUBN  IF  FDROP FALSE EXIT  THEN
   ?FPX0< FDROP
;

: F0= (S -- flag ) (F r -- ) \ 12.6.1.1450 F0=
   (G flag is true if and only if r is equal to zero.)
   1 ?FPSTACK-UNDERFLOW
   ?FPX-NAN   IF  FDROP FALSE EXIT  THEN
   ?FPX-SUBN  IF  FDROP TRUE  EXIT  THEN
   ?FPX0= FDROP
;
\DEBUG-OFF
