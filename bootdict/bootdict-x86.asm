;******************************************************************************
;
;  bootdict-x86.asm
;
;  Unlicense since 1999 by Illya Kysil
;
;******************************************************************************
;
;  Minimal IKForth kernel, which supports compilation from files.
;
;******************************************************************************

                INCLUDE     "bootdict/x86/bootdict-header.asm"

;******************************************************************************
;  Include functions table
;******************************************************************************

                INCLUDE     "bootdict/tc/ftable.asm"

;******************************************************************************
;  Include user area variables. These variables are unique for each thread.
;******************************************************************************
                INCLUDE     "bootdict/tc/user.asm"

;******************************************************************************
;  Include Forth definitions.
;******************************************************************************
;                ALIGN       16

                INCLUDE     "bootdict/x86-wordlist/wordlist-def.asm"
                INCLUDE     "bootdict/tc/tc-def.asm"
                INCLUDE     "bootdict/tc/tc-trace.asm"
                INCLUDE     "bootdict/tc/forth-vm-notc.asm"
                INCLUDE     "bootdict/x86/forth-vm.asm"

                MATCH       =DTC, CODE_THREADING {
                INCLUDE     "bootdict/x86-dtc/forth-vm-dtc.asm"
                }

                MATCH       =ITC, CODE_THREADING {
                INCLUDE     "bootdict/x86-itc/forth-vm-itc.asm"
                }

                INCLUDE     "bootdict/x86-wordlist/forth-wordlist.asm"
                INCLUDE     "bootdict/x86-wordlist/included-wordlist.asm"

                $INCLUDED   "bootdict/x86/primitives.asm"
                $INCLUDED   "bootdict/x86/fcontrol.asm"
                $INCLUDED   "bootdict/tc/varconst.asm"
                $INCLUDED   "bootdict/tc/paren-type-paren.asm"
                $INCLUDED   "bootdict/x86/stack.asm"
                $INCLUDED   "bootdict/x86/rstack.asm"
                $INCLUDED   "bootdict/x86/math.asm"
                $INCLUDED   "bootdict/x86/allot.asm"
                $INCLUDED   "bootdict/x86/comma.asm"
                $INCLUDED   "bootdict/x86/c-comma.asm"
                $INCLUDED   "bootdict/x86/b-comma.asm"
                $INCLUDED   "bootdict/x86/call-comma.asm"
                $INCLUDED   "bootdict/tc/here.asm"
                $INCLUDED   "bootdict/tc/literal.asm"
                $INCLUDED   "bootdict/tc/compile-comma.asm"
                $INCLUDED   "bootdict/tc/two-literal.asm"
                $INCLUDED   "bootdict/x86/double.asm"
                $INCLUDED   "bootdict/x86/compare.asm"
                $INCLUDED   "bootdict/x86/memory.asm"
                $INCLUDED   "bootdict/x86/string.asm"
                $INCLUDED   "bootdict/x86/host.asm"
                $INCLUDED   "bootdict/x86-wordlist/wid-to-vt.asm"
                $INCLUDED   "bootdict/tc/search.asm"
                $INCLUDED   "bootdict/x86/s-to-d.asm"
                $INCLUDED   "bootdict/x86/b-to-h.asm"
                $INCLUDED   "bootdict/x86/split-8.asm"
                $INCLUDED   "bootdict/x86/to-digit.asm"
                $INCLUDED   "bootdict/x86/to-number.asm"
                $INCLUDED   "bootdict/tc/digits.asm"
                $INCLUDED   "bootdict/tc/h-dot-2.asm"
                $INCLUDED   "bootdict/tc/h-dot-8.asm"
                $INCLUDED   "bootdict/x86/excp-zero.asm"
                $INCLUDED   "bootdict/tc/except.asm"
                $INCLUDED   "bootdict/x86/source-id.asm"
                $INCLUDED   "bootdict/x86/source-id-store.asm"
                $INCLUDED   "bootdict/tc/source.asm"
                $INCLUDED   "bootdict/tc/file.asm"
                $INCLUDED   "bootdict/x86/paren-parse-paren.asm"
                $INCLUDED   "bootdict/tc/parse.asm"
                $INCLUDED   "bootdict/tc/purpose.asm"
                $INCLUDED   "bootdict/x86/sys-upcase.asm"
                $INCLUDED   "bootdict/x86/paren-name-equals-paren.asm"
                INCLUDE_HEADER_TC
                $INCLUDED   "bootdict/x86-wordlist/latest-head-fetch.asm"
                $INCLUDED   "bootdict/x86-wordlist/latest-head-store.asm"
                $INCLUDED   "bootdict/x86-wordlist/traverse-entry.asm"
                $INCLUDED   "bootdict/x86-wordlist/search-headers.asm"
                $INCLUDED   "bootdict/x86-wordlist/header.asm"
                $INCLUDED   "bootdict/tc/recognizer-core.asm"
                $INCLUDED   "bootdict/tc/recognizer-word.asm"
                $INCLUDED   "bootdict/tc/recognizer-num.asm"
                $INCLUDED   "bootdict/tc/postpone.asm"
                $INCLUDED   "bootdict/tc/interpret.asm"
                $INCLUDED   "bootdict/tc/seh-handler.asm"
                $INCLUDED   "bootdict/tc/sig-handler.asm"
                $INCLUDED   "bootdict/x86/sysnt-thread.asm"
                $INCLUDED   "bootdict/x86/syslinux-thread.asm"
                $INCLUDED   "bootdict/x86/init-user.asm"
                $INCLUDED   "bootdict/x86/call-ffl.asm"

                $INCLUDED   "bootdict/x86/main-proc.asm"
                $INCLUDED   "bootdict/tc/bootstrap-interpret.asm"
