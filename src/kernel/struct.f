\
\  struct.f
\
\  Copyright (C) 1999-2004 Illya Kysil
\

CR .( Loading STRUCT definitions )

REPORT-NEW-NAME @
REPORT-NEW-NAME OFF

: STRUCT (S "name" -- addr offset[0] )
  CREATE HERE 0 DUP ,
;

: ENDSTRUCT (S addr offset -- )
  SWAP !
;

: STRUCT-SIZEOF (S struct_addr -- sizeof_struct )
  @
;

: STRUCT-FIELD (S offset size "name" -- offset+size )
  CREATE OVER , +
  DOES> @ +
;

: --
  STRUCT-FIELD
;

: CHARS:
  CHARS STRUCT-FIELD
;

: CHAR:
  1 CHARS:
;

: BYTES:
  STRUCT-FIELD
;

: BYTE:
  1 BYTES:
;

: WORDS:
  /WORDS STRUCT-FIELD
;

: WORD:
  1 WORDS:
;

: CELLS:
  CELLS STRUCT-FIELD
;

: CELL:
  1 CELLS:
;

: 2CELLS:
  2* CELLS STRUCT-FIELD
;

: 2CELL:
  1 2CELLS:
;

REPORT-NEW-NAME !
