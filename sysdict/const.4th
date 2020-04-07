\
\  const.4th
\
\  Unlicense since 1999 by Illya Kysil
\

REPORT-NEW-NAME @
FALSE REPORT-NEW-NAME !

\ -----------------------------------------------------------------------------
\  Constants to speed-up parsing
\ -----------------------------------------------------------------------------

   -2 CONSTANT -2

   -1 CONSTANT -1

   1 CONSTANT  1

   2 CONSTANT  2

   3 CONSTANT  3

   4 CONSTANT  4

\   8 CONSTANT  8

\  10 CONSTANT 10

\  16 CONSTANT 16

\ -----------------------------------------------------------------------------
\  ANSI Forth exception codes
\ -----------------------------------------------------------------------------

  -1 CONSTANT EXC-ABORT                          \ ABORT
  -2 CONSTANT EXC-ABORT"                         \ ABORT"
  -3 CONSTANT EXC-STACK-OVERFLOW                 \ stack overflow
  -4 CONSTANT EXC-STACK-UNDERFLOW                \ stack underflow
  -5 CONSTANT EXC-RSTACK-OVERFLOW                \ return stack overflow
  -6 CONSTANT EXC-RSTACK-UNDERFLOW               \ return stack underflow
  -7 CONSTANT EXC-DO-LOOP-TOO-DEEP               \ do-loops nested too deeply during execution
  -8 CONSTANT EXC-DICTIONARY-OVERFLOW            \ dictionary overflow
  -9 CONSTANT EXC-INVALID-ADDRESS                \ invalid memory address
 -10 CONSTANT EXC-DIVISION-BY-ZERO               \ division by zero
 -11 CONSTANT EXC-OUT-OF-RANGE                   \ result out of range
 -12 CONSTANT EXC-TYPE-MISMATCH                  \ argument type mismatch
 -13 CONSTANT EXC-UNDEFINED                      \ undefined word
 -14 CONSTANT EXC-COMPILE-ONLY                   \ interpreting a compile-only word
 -15 CONSTANT EXC-INVALID-FORGET                 \ invalid FORGET
 -16 CONSTANT EXC-EMPTY-NAME                     \ attempt to use zero-length string as a name
 -17 CONSTANT EXC-HLD-OVERFLOW                   \ pictured numeric output string overflow
 -18 CONSTANT EXC-PARSE-OVERFLOW                 \ parsed string overflow
 -19 CONSTANT EXC-NAME-TOO-LONG                  \ definition name too long
 -20 CONSTANT EXC-READ-ONLY                      \ write to a read-only location
 -21 CONSTANT EXC-UNSUPPORTED                    \ unsupported operation
 -22 CONSTANT EXC-CONTROL-MISMATCH               \ control structure mismatch
 -23 CONSTANT EXC-ADDRESS-NOT-ALIGNED            \ address alignment exception
 -24 CONSTANT EXC-INVALID-NUM-ARGUMENT           \ invalid numeric argument
 -25 CONSTANT EXC-RSTACK-IMBALANCE               \ return stack imbalance
 -26 CONSTANT EXC-LOOP-NOT-AVAILABLE             \ loop parameters unavailable
 -27 CONSTANT EXC-INVALID-RECURSE                \ invalid recursion
 -28 CONSTANT EXC-USER-INTERRUPT                 \ user interrupt
 -29 CONSTANT EXC-COMPILER-NESTING               \ compiler nesting
 -30 CONSTANT EXC-OBSOLESCENT                    \ obsolescent feature
 -31 CONSTANT EXC-NOT-CREATED                    \ >BODY used on non-CREATEd definition
 -32 CONSTANT EXC-INVALID-NAME-ARGUMENT          \ invalid name argument (e.g., TO xxx)
 -33 CONSTANT EXC-BLOCK-READ                     \ block read exception
 -34 CONSTANT EXC-BLOCK-WRITE                    \ block write exception
 -35 CONSTANT EXC-BAD-BLOCK                      \ invalid block number
 -36 CONSTANT EXC-INVALID-FILE-POSITION          \ invalid file position
 -37 CONSTANT EXC-FILE-IO                        \ file I/O exception
 -38 CONSTANT EXC-FILE-NOT-EXISTS                \ non-existent file
 -39 CONSTANT EXC-UNEXPECTED-EOF                 \ unexpected end of file
 -40 CONSTANT EXC-INVALID-FLOAT-BASE             \ invalid BASE for floating point conversion
 -41 CONSTANT EXC-PRECISION-LOSS                 \ loss of precision
 -42 CONSTANT EXC-FLOAT-DIVISION-BY-ZERO         \ floating-point divide by zero
 -43 CONSTANT EXC-FLOAT-OUT-OF-RANGE             \ floating-point result out of range
 -44 CONSTANT EXC-FLOAT-STACK-OVERFLOW           \ floating-point stack overflow
 -45 CONSTANT EXC-FLOAT-STACK-UNDERFLOW          \ floating-point stack underflow
 -46 CONSTANT EXC-FLOAT-INVALID-ARGUMENT         \ floating-point invalid argument
 -47 CONSTANT EXC-WORDLIST-DELETED               \ compilation word list deleted
 -48 CONSTANT EXC-INVALID-POSTPONE               \ invalid POSTPONE
 -49 CONSTANT EXC-SEARCH-ORDER-OVERFLOW          \ search-order overflow
 -50 CONSTANT EXC-SEARCH-ORDER-UNDERFLOW         \ search-order underflow
 -51 CONSTANT EXC-WORDLIST-CHANGED               \ compilation word list changed
 -52 CONSTANT EXC-CSTACK-OVERFLOW                \ control-flow stack overflow
 -53 CONSTANT EXC-ESTACK-OVERFLOW                \ exception stack overflow
 -54 CONSTANT EXC-FLOAT-UNDERFLOW                \ floating-point underflow
 -55 CONSTANT EXC-FLOAT-FAULT                    \ floating-point unidentified fault
 -56 CONSTANT EXC-QUIT                           \ QUIT
 -57 CONSTANT EXC-COMMUNICATION                  \ exception in sending or receiving a character
 -58 CONSTANT EXC-[IF]                           \ [IF], [ELSE], or [THEN] exception
 -59 CONSTANT EXC-ALLOCATE
 -60 CONSTANT EXC-FREE
 -61 CONSTANT EXC-RESIZE
 -62 CONSTANT EXC-CLOSE-FILE
 -63 CONSTANT EXC-CREATE-FILE
 -64 CONSTANT EXC-DELETE-FILE
 -65 CONSTANT EXC-FILE-POSITION
 -66 CONSTANT EXC-FILE-SIZE
 -67 CONSTANT EXC-FILE-STATUS
 -68 CONSTANT EXC-FLUSH-FILE
 -69 CONSTANT EXC-OPEN-FILE
 -70 CONSTANT EXC-READ-FILE
 -71 CONSTANT EXC-READ-LINE
 -72 CONSTANT EXC-RENAME-FILE
 -73 CONSTANT EXC-REPOSITION-FILE
 -74 CONSTANT EXC-RESIZE-FILE
 -75 CONSTANT EXC-WRITE-FILE
 -76 CONSTANT EXC-WRITE-LINE
 -77 CONSTANT EXC-MALFORMED-XCHAR
 -78 CONSTANT EXC-SUBSTITUTE
 -79 CONSTANT EXC-REPLACES

\ The THROW values {-255...-1} shall be used only as assigned by this standard.
\ The values {-4095...-256} shall be used only as assigned by a system.
-256 CONSTANT EXC-INVALID-LITERAL                \ Invalid literal
-257 CONSTANT EXC-UNINITIALIZED-DEFER            \ Uninitialized DEFER
-258 CONSTANT EXC-INVALID-DEFER                  \ IS invoked on a non-DEFER
-259 CONSTANT EXC-INVALID-CONSTDICT              \ Invalid CONSTDICT
-260 CONSTANT EXC-CONSTDICT-OVERFLOW             \ CONSTDICT overflow

\ The first exception id allocated dynamically by word EXCEPTION
-1024 CONSTANT EXC-DYNAMIC-ID

 256 CONSTANT HLD-SIZE
1024 CONSTANT PAD-SIZE

REPORT-NEW-NAME !
