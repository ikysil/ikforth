\
\  dllintf.f
\
\  Copyright (C) 1999-2004 Illya Kysil
\
\  An interface to DLLs
\

CR .( Loading DLLINTF definitions )

REPORT-NEW-NAME @
REPORT-NEW-NAME OFF

BASE @ 

: (DLL.Init) (S lib-addr sliteral<DLL> -- )
  (LoadLibrary) GetLastError THROW SWAP !
;

: (DLL.Done) (S lib-addr -- )
  @ FreeLibrary
;

: (DLL) (S 'Name' -- body-addr )
  CREATE HERE 0 , DOES> @
;

: DLLImport (S DLL '"dllpath"' -- )
  (DLL) >R
  [CHAR] " PARSE 2DROP
  [CHAR] " PARSE R@
  :NONAME >R
     POSTPONE LITERAL
     POSTPONE SLITERAL
     POSTPONE (DLL.Init)
     POSTPONE ;
  R> DUP STARTUP-CHAIN CHAIN.ADD EXECUTE
  R>
  :NONAME >R
     POSTPONE LITERAL
     POSTPONE (DLL.Done)
     POSTPONE ;
  R> SHUTDOWN-CHAIN CHAIN.ADD
;

: (DLLEntry.Init) (S entry-addr xt<DLL> sliteral<DLLName> -- )
  ROT EXECUTE (GetProcAddress) GetLastError THROW SWAP !
;

: DLLEntry.Init (S 'DLL' 'DLLName' -- )
  LATEST-HEAD@ HEAD> >BODY
  :NONAME >R
     POSTPONE LITERAL
   ' POSTPONE LITERAL
  BL WORD COUNT
     POSTPONE SLITERAL
     POSTPONE (DLLEntry.Init)
     POSTPONE ;
  R> DUP STARTUP-CHAIN CHAIN.ADD EXECUTE
;

HEX

: (VoidDLLEntry) (S 'Name' -- )
  CREATE 0 , 
  ;CODE
  83 B, ED B, 04 B, \ SUB     EBP,4
  89 B, 7D B, 00 B, \ MOV     [DWORD PTR EBP],EDI
  8B B, 58 B, 04 B, \ MOV     EBX,[DWORD PTR EAX+4]
  FF B, D3 B,       \ CALL    EBX
  8B B, 7D B, 00 B, \ MOV     EDI,[DWORD PTR EBP]
  83 B, C5 B, 04 B, \ ADD     EBP,4
  $NEXT

: VoidDLLEntry (S 'Name' 'DLL' 'DLLName' -- )
  (VoidDLLEntry) DLLEntry.Init
;

: (Int32DLLEntry) (S 'Name' -- )
  CREATE 0 , 
  ;CODE
  83 B, ED B, 04 B, \ SUB     EBP,4
  89 B, 7D B, 00 B, \ MOV     [DWORD PTR EBP],EDI
  8B B, 58 B, 04 B, \ MOV     EBX,[DWORD PTR EAX+4]
  FF B, D3 B,       \ CALL    EBX
  50 B,             \ PUSH    EAX
  8B B, 7D B, 00 B, \ MOV     EDI,[DWORD PTR EBP]
  83 B, C5 B, 04 B, \ ADD     EBP,4
  $NEXT

: Int32DLLEntry (S 'Name' 'DLL' 'DLLName' -- )
  (Int32DLLEntry) DLLEntry.Init
;

: (Int64DLLEntry) (S 'Name' -- )
  CREATE 0 ,
  ;CODE
  83 B, ED B, 04 B, \ SUB     EBP,4
  89 B, 7D B, 00 B, \ MOV     [DWORD PTR EBP],EDI
  8B B, 58 B, 04 B, \ MOV     EBX,[DWORD PTR EAX+4]
  FF B, D3 B,       \ CALL    EBX
  50 B,             \ PUSH    EAX
  52 B,             \ PUSH    EDX
  8B B, 7D B, 00 B, \ MOV     EDI,[DWORD PTR EBP]
  83 B, C5 B, 04 B, \ ADD     EBP,4
  $NEXT

: Int64DLLEntry (S 'Name' 'DLL' 'DLLName' -- )
  (Int64DLLEntry) DLLEntry.Init
;

BASE !

REPORT-NEW-NAME !
