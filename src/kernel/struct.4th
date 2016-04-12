\
\  struct.f
\
\  Copyright (C) 1999-2016 Illya Kysil
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

VARIABLE STRUCTURE-PAIRS

: BEGIN-STRUCTURE  \ -- addr STRUCTURE-PAIRS 0 ; -- size
   CREATE
      HERE STRUCTURE-PAIRS 0 0 ,      \ mark stack, lay dummy
   DOES> @         \ -- rec-len
;

: END-STRUCTURE   \ addr STRUCTURE-PAIRS len --
   SWAP STRUCTURE-PAIRS ?PAIRS
   SWAP !         \ set len
;

: +FIELD  \ n <"name"> -- ; Exec: addr -- 'addr
   CREATE OVER , +
   DOES> @ +
;


: FIELD:    (S n1 "name" -- n2 ; addr1 -- addr2 )
   1 CELLS +FIELD
;

: 2FIELD:    (S n1 "name" -- n2 ; addr1 -- addr2 )
   2 CELLS +FIELD
;

: CFIELD:   (S n1 "name" -- n2 ; addr1 -- addr2 )
   1 CHARS +FIELD
;

\ BFIELD:  1 byte (8 bit) field
: BFIELD:   (S n1 "name" -- n2 ; addr1 -- addr2 )
   1 +FIELD
;

\ WFIELD:  16 bit field
: WFIELD:   (S n1 "name" -- n2 ; addr1 -- addr2 )
   2 +FIELD
;

\ LFIELD:  32 bit field
SYNONYM LFIELD: FIELD:

\ XFIELD:  64 bit field
SYNONYM XFIELD: 2FIELD:

REPORT-NEW-NAME !
