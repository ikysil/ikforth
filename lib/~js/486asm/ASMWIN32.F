\ ASMWIN32.F      486ASM/Win32Forth Interface File

\ WARNING!!  THIS FILE IS A SUBSTANTIALLY MODIFIED VERSON OF THE FILE
\ OF THE SAME NAME THAT WAS DISTRIBUTED WITH JIM SCHNIEDER'S 486ASM
\ ASSEMBLER.  IF YOU UPDATE YOUR 486ASM SOURCE FILE WITH A MORE CURRENT
\ COPY IF JIM'S ASSEMBLER, BE SURE NOT TO UPDATE THIS FILE FROM HIS
\ 486ASM.ZIP ARCHIVE. August 2nd, 1996 Tom Zimmer

( FORTH for Windows 95 and NT specific macros )
( These macros are derived from code in Andrew McKewan and Tom Zimmer's )
( FORTH for Windows 95 and NT.  This file is public domain )
( This software is distributed as is, with no warranty whatsoever )
( This file version 1.1, first distributed with 486asm, version 1.1 )

macro: exec ( assemble code to execute the cfa in eax )
                ( -- )
                /set-prefix >r
                mov ecx , [eax] [edi]
                add ecx , edi
                jmp ecx
                r> reset-syntax
endm

also assembler also asm-hidden

: resolve-ofa   ( -- )          \ resolve OFA to contain code length in bytes
                ofa-last
                if      ofa-last code-d@ -1 <>
                        if      a;              \ save size of code definition
                                code-here ofa-last code-d@ - ofa-last code-d!
                        then
                then    0 to ofa-last ;         \ reset ofa pointer

: _opt-code     ( -<name>- )    \ redefine to resolve code length in bytes
                _code code-here ofa-last code-d! ;
                                                \ init OFA with start of definition

' _opt-code is code

previous previous

macro: next ( assemble the code to do a next )
                ( -- )
                /set-prefix >r
                a; resolve-ofa          \ resolve the optimizer field address
                mov eax, [esi]          \ faster version of NEXT, uses 9 more
                add esi, # 4            \ bytes per occurance
\               lodsd                   \ slower smaller replacement for above
                exec
                r> reset-syntax
endm

macro: next,    ( -- )          \ an alias name for next
        next
endm

macro: ptr      ( -- )          \ does nothing in this assembler

endm

macro: c;       ( -- )          \ alias for ;c and end-code
                end-code
endm

macro: [up]     ( n1 -- )       \ calculate offset for [edx]
                FOLLOWER - [edx]
endm

macro: [up],    ( n1 -- )       \ calculate offset for [edx]
                FOLLOWER - [edx],
endm

also assembler also asm-hidden current @ also forth definitions nostack1

: macro[ ( create a macro in the assembler vocabulary )
        save-current also assembler definitions
        postpone enter-macro
        postpone a; ; immediate

: ]macro ( end a macro definition )
        postpone a;
        postpone leave-macro
        previous restore-current ; immediate

current ! previous previous previous

\ Everything below this line was added to support Tom Zimmer
\ It was diked out of 486asm.f and put here because it could make it
\ difficult to load the assembler as a cross assembler
\ 12/21/94 09:45 tjz added for Win32Forth
also assembler current @ definitions also asm-hidden nostack1

: _enter-assembler      ( -- )
               hide !csp init-asm ( code-here ofa-last code-d! ) ;

' _enter-assembler is enter-assembler

: _exit-assembler       ( -- )
                semicolon-chain do-chain ;

' _exit-assembler is exit-assembler

current ! previous previous

