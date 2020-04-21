PURPOSE: Forth-Assisted Assembler for x86 32 bits and 16 bits mode
LICENSE: Unlicense since 1999 by Illya Kysil

\ Goals:
\ * begin able to compile x86 32 bits instructions
\ * self-hosting meta-compiler for IKForth
\ Non-goals:
\ * syntax compatibility with existing assemblers
\ * support for full set of instructions
\ References:
\ * Intel® 64 and IA-32 Architectures Software Developer’s Manual Volume 2D: Instruction Set Reference

REPORT-NEW-NAME @
REPORT-NEW-NAME OFF

ONLY FORTH DEFINITIONS

VOCABULARY FAASM8632-PRIVATE

ALSO FAASM8632-PRIVATE DEFINITIONS

\ private definitions go here

\G Compile a 8-bits value (S x -- )
DEFER asm8,

' C, IS asm8,

\G Compile a 16-bits value - always LSB first (S x -- )
\G Uses asm8, for actual compilation.
: asm16,
   SPLIT-8
   2DROP
   SWAP
   asm8, asm8,
;

\G Compile a 32-bits value - always LSB first (S x -- )
\G Uses asm8, for actual compilation.
: asm32,
   SPLIT-8
   2SWAP
   SWAP asm8, asm8,
   SWAP asm8, asm8,
;

ONLY FORTH DEFINITIONS ALSO FAASM8632-PRIVATE

\ public definitions go here
\ private definitions are available for use

ONLY FORTH DEFINITIONS

REPORT-NEW-NAME !
