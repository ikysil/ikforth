PURPOSE: INT/COMP: definitions
LICENSE: Unlicense since 1999 by Illya Kysil

\ -----------------------------------------------------------------------------
\  IS-INT/COMP? INT/COMP>INT INT/COMP>COMP INT/COMP:
\ -----------------------------------------------------------------------------

: IS-INT/COMP?
   \ S: xt -- flag
   CFA@ (DO-INT/COMP) =
;

: INT/COMP>INT
   \ S: xt -- xt-int
   \ Return xt of interpretation semantics of INT/COMP: word
   >BODY @
;

: INT/COMP>COMP
   \ S: xt -- xt-comp
   \ Return xt of compilation semantics of INT/COMP: word
   >BODY CELL+ @
;

: INT/COMP:
   \ S: xt-int xt-comp "<spaces>name" --
   \ Skip leading space delimiters. Parse name delimited by a space. Create a definition for name with the execution semantics defined below.
   \ name Execution
   \ S: i*x -- j*y
   \ Execute xt-int if in interpretation state.
   \ Execute xt-comp if in compilation state. name is an immediate word.
   (DO-INT/COMP) &IMMEDIATE PARSE-CHECK-HEADER, DROP SWAP , ,
;
