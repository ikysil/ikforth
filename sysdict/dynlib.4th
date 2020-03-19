\
\  dynlib.4th
\
\  Unlicense since 1999 by Illya Kysil
\
\  Interface to dynamic libraries.
\

CR .( Loading DYNLIB definitions )

REPORT-NEW-NAME @
REPORT-NEW-NAME OFF

BASE @

\ DYNLIB structure:
\ +0  xt of word returning dynamic library path string (S -- c-addr u )
\ +4  library id (handle)

: DYNLIB-PATH@ (S lib-addr -- c-addr u )
   @ EXECUTE
;

: DYNLIB-ID@ (S lib-addr -- lib-id )
   CELL+ @
;

: DYNLIB-ID! (S lib-id lib-addr -- )
   CELL+ !
;

\ Print library path and id
: .DYNLIB (S lib-addr -- )
   DUP DYNLIB-PATH@ TYPE
   [CHAR] @ EMIT
   DYNLIB-ID@ H.8
;

\ Check for errors after loading of dynamic library
DEFER DYNLIB-INIT-CHECK (S lib-addr lib-id -- )

:NONAME
   0=  IF
      CR ." Failed to load: "
      DYNLIB-PATH@ TYPE CR
      GetLastError THROW
   ELSE
      DROP
   THEN
; IS DYNLIB-INIT-CHECK

: DYNLIB-INIT (S lib-addr -- )
   0 OVER DYNLIB-ID!
   DUP DYNLIB-PATH@ (LoadLibrary)
   2DUP DYNLIB-INIT-CHECK
   SWAP DYNLIB-ID!
;

: DYNLIB-DONE (S lib-addr -- )
   DYNLIB-ID@ FreeLibrary
;

: DYNLIB-ADD-INIT (S lib-addr -- )
   :NONAME >R
      POSTPONE LITERAL
      POSTPONE DYNLIB-INIT
      POSTPONE ;
   R> DUP STARTUP-CHAIN CHAIN.ADD EXECUTE
;

: DYNLIB-ADD-DONE (S lib-addr -- )
   :NONAME >R
      POSTPONE LITERAL
      POSTPONE DYNLIB-DONE
      POSTPONE ;
   R> SHUTDOWN-CHAIN CHAIN.ADD
;

: DYNLIB
   (S c-addr u '<name>' -- ) \ compilation
   (S -- lib-addr ) \ execution
   (G Define word name returning address of DYNLIB structure )
   :NONAME >R
      POSTPONE SLITERAL
      POSTPONE ;
   CREATE HERE R> , 0 ,
   DUP DYNLIB-ADD-INIT
   DUP DYNLIB-ADD-DONE
   DROP
;

: DYNLIB-SYMBOL-INIT
   (S sym-addr c-addr u lib-addr -- )
   DYNLIB-ID@ (GetProcAddress)
   >R 0 OVER ! R>
   GetLastError THROW
   SWAP !
;

: DYNLIB-SYMBOL
   (S lib-addr c-addr u -- sym-addr ) \ compilation
   HERE >R 0 ,
   R@
   :NONAME >R
      POSTPONE LITERAL
      POSTPONE SLITERAL
      POSTPONE LITERAL
      POSTPONE DYNLIB-SYMBOL-INIT
      POSTPONE ;
   R> DUP STARTUP-CHAIN CHAIN.ADD EXECUTE
   R>
;

: STDCALL-CREATE (S sym-addr '<name>' -- ) \ compilation
   CREATE ,
;

: STDCALL-EXTRACT (S stdcall-addr -- addr )
   (G Extract function address addr from STDCALL body )
   @ @
;

: STDCALL-C0 (S sym-addr '<name>' -- ) \ compilation
   STDCALL-CREATE
   DOES> STDCALL-EXTRACT CALL-STDCALL-C0
;

: STDCALL-C1 (S sym-addr '<name>' -- ) \ compilation
   STDCALL-CREATE
   DOES> STDCALL-EXTRACT CALL-STDCALL-C1
;

: STDCALL-C2 (S sym-addr '<name>' -- ) \ compilation
   STDCALL-CREATE
   DOES> STDCALL-EXTRACT CALL-STDCALL-C2
;

: CDECL-CREATE (S sym-addr n '<name>' -- ) \ compilation
   DUP 0 256 WITHIN INVERT IF   EXC-INVALID-NUM-ARGUMENT THROW   THEN
   CREATE C, ,
;

: CDECL-EXTRACT (S cdecl-addr -- n addr )
   (G Extract number of arguments n and function address addr from CDECL body )
   C@+ SWAP @ @
;

: CDECL-C0 (S sym-addr n '<name>' -- ) \ compilation
   CDECL-CREATE
   DOES> CDECL-EXTRACT CALL-CDECL-C0
;

: CDECL-C1 (S sym-addr n '<name>' -- ) \ compilation
   CDECL-CREATE
   DOES> CDECL-EXTRACT CALL-CDECL-C1
;

: CDECL-C2 (S sym-addr n '<name>' -- ) \ compilation
   CDECL-CREATE
   DOES> CDECL-EXTRACT CALL-CDECL-C2
;

: CDECL-VA-CREATE (S sym-addr '<name>' -- ) \ compilation
   CREATE ,
;

: CDECL-VA-EXTRACT (S cdecl-addr -- addr )
   (G Extract function address addr from CDECL-VA body )
   @ @
;

: CDECL-VA-C0 (S sym-addr '<name>' -- ) \ compilation
   CDECL-VA-CREATE
   DOES> CDECL-VA-EXTRACT CALL-CDECL-C0
;

: CDECL-VA-C1 (S sym-addr '<name>' -- ) \ compilation
   CDECL-VA-CREATE
   DOES> CDECL-VA-EXTRACT CALL-CDECL-C1
;

: CDECL-VA-C2 (S sym-addr '<name>' -- ) \ compilation
   CDECL-VA-CREATE
   DOES> CDECL-VA-EXTRACT CALL-CDECL-C2
;

BASE !

REPORT-NEW-NAME !
