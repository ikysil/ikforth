\
\  dllintf.f
\
\  Copyright (C) 1999-2003 Illya Kysil
\
\  An interface to DLLs
\

CR .( Loading DLLINTF definitions )

CREATE-REPORT @
CREATE-REPORT OFF

BASE @ 

: (DLL.Init) (S lib-addr sliteral<DLL> -- )
  (LoadLibrary) GetLastError THROW SWAP ! ;

: (DLL.Done) (S lib-addr -- )
  @ FreeLibrary ;

: (DLL) (S 'Name' -- body-addr )
  CREATE HERE 0 , DOES> @ ;

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
  R> SHUTDOWN-CHAIN CHAIN.ADD ;

: (DLLEntry.Init) (S entry-addr xt<DLL> sliteral<DLLName> -- )
  ROT EXECUTE (GetProcAddress) GetLastError THROW SWAP ! ;

: DLLEntry.Init (S 'DLL' 'DLLName' -- )
  LATEST-HEAD@ HEAD> >BODY
  :NONAME >R
     POSTPONE LITERAL
   ' POSTPONE LITERAL
  BL WORD COUNT
     POSTPONE SLITERAL
     POSTPONE (DLLEntry.Init)
     POSTPONE ;
  R> DUP STARTUP-CHAIN CHAIN.ADD EXECUTE ;

HEX

: (VoidDLLEntry) (S 'Name' -- )
  CREATE 0 , 
  ;CODE
  83 C, ED C, 04 C, \ SUB     EBP,4
  89 C, 7D C, 00 C, \ MOV     [DWORD PTR EBP],EDI
  8B C, 58 C, 04 C, \ MOV     EBX,[DWORD PTR EAX+4]
  FF C, D3 C,       \ CALL    EBX
  8B C, 7D C, 00 C, \ MOV     EDI,[DWORD PTR EBP]
  83 C, C5 C, 04 C, \ ADD     EBP,4
  $NEXT

: VoidDLLEntry (S 'Name' 'DLL' 'DLLName' -- )
  (VoidDLLEntry) DLLEntry.Init ;

: (Int32DLLEntry) (S 'Name' -- )
  CREATE 0 , 
  ;CODE
  83 C, ED C, 04 C, \ SUB     EBP,4
  89 C, 7D C, 00 C, \ MOV     [DWORD PTR EBP],EDI
  8B C, 58 C, 04 C, \ MOV     EBX,[DWORD PTR EAX+4]
  FF C, D3 C,       \ CALL    EBX
  50 C,             \ PUSH    EAX
  8B C, 7D C, 00 C, \ MOV     EDI,[DWORD PTR EBP]
  83 C, C5 C, 04 C, \ ADD     EBP,4
  $NEXT

: Int32DLLEntry (S 'Name' 'DLL' 'DLLName' -- )
  (Int32DLLEntry) DLLEntry.Init ;

: (Int64DLLEntry) (S 'Name' -- )
  CREATE 0 ,
  ;CODE
  83 C, ED C, 04 C, \ SUB     EBP,4
  89 C, 7D C, 00 C, \ MOV     [DWORD PTR EBP],EDI
  8B C, 58 C, 04 C, \ MOV     EBX,[DWORD PTR EAX+4]
  FF C, D3 C,       \ CALL    EBX
  50 C,             \ PUSH    EAX
  52 C,             \ PUSH    EDX
  8B C, 7D C, 00 C, \ MOV     EDI,[DWORD PTR EBP]
  83 C, C5 C, 04 C, \ ADD     EBP,4
  $NEXT

: Int64DLLEntry (S 'Name' 'DLL' 'DLLName' -- )
  (Int64DLLEntry) DLLEntry.Init ;

BASE !

CREATE-REPORT !
