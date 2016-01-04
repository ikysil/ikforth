\
\  quit.f
\
\  Copyright (C) 1999-2001 Illya Kysil
\

CR .( Loading QUIT definitions )

CREATE-REPORT @
CREATE-REPORT OFF

DEFER QUIT

S" ABORTed"
EXC-ABORT (EXCEPTION)

:NONAME ABORT"-MESSAGE 2@ TYPE ;
EXC-ABORT" (EXCEPTION-XT)

S" Stack underflow"
EXC-STACK-UNDERFLOW (EXCEPTION)

S" Stack overflow"
EXC-STACK-OVERFLOW (EXCEPTION)

S" Return stack overflow"
EXC-RSTACK-OVERFLOW (EXCEPTION)

S" Return stack underflow"
EXC-RSTACK-UNDERFLOW (EXCEPTION)

\  -7 CONSTANT EXC-DO-LOOP-TOO-DEEP               \ do-loops nested too deeply during execution
\  -8 CONSTANT EXC-DICTIONARY-OVERFLOW            \ dictionary overflow
\  -9 CONSTANT EXC-INVALID-ADDRESS                \ invalid memory address
\ -10 CONSTANT EXC-DIVISION-BY-ZERO               \ division by zero
\ -11 CONSTANT EXC-OUT-OF-RANGE                   \ result out of range
\ -12 CONSTANT EXC-TYPE-MISMATCH                  \ argument type mismatch

:NONAME ." Undefined word " POCKET COUNT TYPE ;
EXC-UNDEFINED (EXCEPTION-XT)

:NONAME ." Interpreting a compile-only word " POCKET COUNT TYPE ;
EXC-COMPILE-ONLY (EXCEPTION-XT)

\ -15 CONSTANT EXC-INVALID-FORGET                 \ invalid FORGET

S" Attempt to use zero-length string as a name"
EXC-EMPTY-NAME (EXCEPTION)
         
\ -17 CONSTANT EXC-HLD-OVERFLOW                   \ pictured numeric output string overflow
\ -18 CONSTANT EXC-PARSE-OVERFLOW                 \ parsed string overflow

:NONAME ." Definition name too long, only " MAX-NAME-LENGTH @ .
        ." chars allowed" ;
EXC-NAME-TOO-LONG (EXCEPTION-XT)

\ -20 CONSTANT EXC-READ-ONLY                      \ write to a read-only location

S" Unsupported operation"
EXC-UNSUPPORTED (EXCEPTION)

S" Control structure mismatch"
EXC-CONTROL-MISMATCH (EXCEPTION)

\ -23 CONSTANT EXC-ADDRESS-NOT-ALIGNED            \ address alignment exception

S" Invalid numeric argument"
EXC-INVALID-NUM-ARGUMENT (EXCEPTION)

\ -25 CONSTANT EXC-RSTACK-IMBALANCE               \ return stack imbalance
\ -26 CONSTANT EXC-LOOP-NOT-AVAILABLE             \ loop parameters unavailable
\ -27 CONSTANT EXC-INVALID-RECURSE                \ invalid recursion
\ -28 CONSTANT EXC-USER-INTERRUPT                 \ user interrupt
\ -29 CONSTANT EXC-COMPILER-NESTING               \ compiler nesting
\ -30 CONSTANT EXC-OBSOLESCENT                    \ obsolescent feature
\ -31 CONSTANT EXC-NOT-CREATED                    \ >BODY used on non-CREATEd definition
\ -32 CONSTANT EXC-INVALID-NAME-ARGUMENT          \ invalid name argument (e.g., TO xxx)
\ -33 CONSTANT EXC-BLOCK-READ                     \ block read exception
\ -34 CONSTANT EXC-BLOCK-WRITE                    \ block write exception

S" Invalid block number"
EXC-BAD-BLOCK (EXCEPTION)

\ -36 CONSTANT EXC-INVALID-FILE-POSITION          \ invalid file position
\ -37 CONSTANT EXC-FILE-IO                        \ file I/O exception
\ -38 CONSTANT EXC-FILE-NOT-EXISTS                \ non-existent file
\ -39 CONSTANT EXC-UNEXPECTED-EOF                 \ unexpected end of file
\ -40 CONSTANT EXC-INVALID-FLOAT-BASE             \ invalid BASE for floating point conversion
\ -41 CONSTANT EXC-PRECISION-LOSS                 \ loss of precision
\ -42 CONSTANT EXC-FLOAT-DIVISION-BE-ZERO         \ floating-point divide by zero
\ -43 CONSTANT EXC-FLOAT-OUT-OF-RANGE             \ floating-point result out of range
\ -44 CONSTANT EXC-FLOAT-STACK-OVERFLOW           \ floating-point stack overflow
\ -45 CONSTANT EXC-FLOAT-STACK-UNDERFLOW          \ floating-point stack underflow
\ -46 CONSTANT EXC-FLOAT-INVALID-ARGUMENT         \ floating-point invalid argument
\ -47 CONSTANT EXC-WORDLIST-DELETED               \ compilation word list deleted
\ -48 CONSTANT EXC-INVALID-POSTPONE               \ invalid POSTPONE

S" Search-order overflow"
EXC-SEARCH-ORDER-OVERFLOW  (EXCEPTION)

S" Search-order underflow"
EXC-SEARCH-ORDER-UNDERFLOW (EXCEPTION)

\ -51 CONSTANT EXC-WORDLIST-CHANGED               \ compilation word list changed
\ -52 CONSTANT EXC-CSTACK-OVERFLOW                \ control-flow stack overflow
\ -53 CONSTANT EXC-ESTACK-VERFLOW                 \ exception stack overflow
\ -54 CONSTANT EXC-FLOAT-UNDERFLOW                \ floating-point underflow
\ -55 CONSTANT EXC-FLOAT-FAULT                    \ floating-point unidentified fault

:NONAME DROP QUIT ;
EXC-QUIT (EXCEPTION-XT)

\ -57 CONSTANT EXC-COMMUNICATION                  \ exception in sending or receiving a character
\ -58 CONSTANT EXC-[IF]                           \ [IF], [ELSE], or [THEN] exception

: CHECK-STACK
  DEPTH 1 < IF SP0 SP! EXC-STACK-UNDERFLOW THEN ;

: .INPUT-PROMPT
  DEPTH . ." > " ;

: .OK STATE @ INVERT IF ."  OK" THEN ;

: (QUIT) POSTPONE [
  0 BLK ! 0 SOURCE-ID! RP0 RP!
  BEGIN STATE @ INVERT IF CR .INPUT-PROMPT THEN REFILL CR
  WHILE
    ['] INTERPRET CATCH
    CHECK-STACK
    ?DUP
    IF
      .EXCEPTION POSTPONE [
    ELSE
      .OK
    THEN
  REPEAT ;

' (QUIT) IS QUIT

CREATE-REPORT !
