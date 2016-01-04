\ include" win\conio.f"

: WT S" TEST\WORDSTEST.F" INCLUDED ;

: a >r rp@ 1 type r> drop ;

USER TYPE-RESULT 1 CELLS USER-ALLOC

: type (s c-addr len - )
  >R >R
  0
  TYPE-RESULT
  R> R> SWAP
  STDOUT
  WriteConsole \ ( hOut, PChar( S ), Length( S ), Result, nil );
;

