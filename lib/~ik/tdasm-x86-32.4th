PURPOSE: Table-Driven Assembler for x86 32 bits
LICENSE: Unlicense since 1999 by Illya Kysil

\ Goals:
\ * compile x86 32 bits instructions
\ * self-hosting meta-compiler for IKForth
\ Non-goals:
\ * syntax compatibility with existing assemblers
\ * support for full set of instructions
\ References:
\ * Intel® 64 and IA-32 Architectures Software Developer’s Manual Volume 2D: Instruction Set Reference
\ Guidelines:
\ * all words ending with COMMA (,) compile to the dictionary

REPORT-NEW-NAME @
REPORT-NEW-NAME OFF

ONLY FORTH DEFINITIONS

VOCABULARY TDASM8632-PRIVATE

ALSO TDASM8632-PRIVATE DEFINITIONS

\ private definitions go here

\ All OP codes are represented in the same byte order as they are layed out in memory,
\ for example $8F41FF for POP DWORD [ECX-1]

\G Chop the LSB of x as x1 and remaining higher bits as x2
: /ASM8 (S x -- x1 x2 )
   DUP
   H# FF AND
   SWAP
   8 RSHIFT
;

\G Compile a 8-bits value (S x -- )
DEFER ASM8,

' C, IS ASM8,

: OP>CODE (S op-pfa -- opcode-addr )
   [ 1 CELLS ] LITERAL +
;

: OP>NAME (S op-pfa -- name-token )
   [ 2 CELLS ] LITERAL + @
;

\G Define a word compiling 8-bit opcode
: 8C:   (S opcode8 -- )
   CREATE
                 1 , \ opcode size in bytes
                   , \ opcode
      LATEST-NAME@ , \ mnemonic name token
                 0 , \ number of parameter sections
   DOES> (S addr -- )
      OP>CODE @
      /ASM8 DROP
      ASM8,
;

INCLUDE" lib/~ik/tdasm-x86-32/8b-opcode.4th"

ONLY FORTH DEFINITIONS ALSO TDASM8632-PRIVATE

\ public definitions go here
\ private definitions are available for use

ONLY FORTH DEFINITIONS

REPORT-NEW-NAME !
