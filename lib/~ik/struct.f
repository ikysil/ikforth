\
\  struct.f
\
\  Copyright (C) 1999-2003 Illya Kysil
\

CR .( Loading STRUCT definitions )

REPORT-NEW-NAME @
REPORT-NEW-NAME OFF

: STRUCTURE (S "name" -- addr offset[0] )
  CREATE HERE 0 DUP ,
  DOES> @
;

: ENDSTRUCTURE (S addr offset -- )
  SWAP !
;

:NONAME ' >BODY @ ;
:NONAME ' >BODY @ POSTPONE LITERAL ;
INT/COMP: SIZEOF (S "name" -- size-of )

: FIELD (S offset size "name" -- offset+size )
  CREATE OVER , +
  DOES> @ +
;

: --
  FIELD
;

: CHARS:
  CHARS FIELD
;

: CHAR:
  1 CHARS:
;

: BYTES:
  FIELD
;

: BYTE:
  1 BYTES:
;

: WORDS:
  /WORDS FIELD
;

: WORD:
  1 WORDS:
;

: CELLS:
  CELLS FIELD
;

: CELL:
  1 CELLS:
;

: 2CELLS:
  2* CELLS FIELD
;

: 2CELL:
  1 2CELLS:
;

REPORT-NEW-NAME !
