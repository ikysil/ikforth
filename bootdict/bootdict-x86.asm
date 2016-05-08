;******************************************************************************
;
;  bootdict-x86.asm
;
;  Copyright (C) 1999-2016 Illya Kysil
;
;******************************************************************************
;
;  Minimal IKForth kernel, which supports compilation from files.
;
;******************************************************************************

                INCLUDE     "bootdict/tc/bootdict-header.asm"

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

                INCLUDE     "bootdict/tc/wordlist-def.asm"
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

                INCLUDE     "bootdict/x86/primitives.asm"
                INCLUDE     "bootdict/x86/fcontrol.asm"
                INCLUDE     "bootdict/tc/varconst.asm"
                INCLUDE     "bootdict/tc/paren-type-paren.asm"
                INCLUDE     "bootdict/x86/stack.asm"
                INCLUDE     "bootdict/x86/rstack.asm"
                INCLUDE     "bootdict/x86/math.asm"
                INCLUDE     "bootdict/x86/allot.asm"
                INCLUDE     "bootdict/x86/comma.asm"
                INCLUDE     "bootdict/x86/c-comma.asm"
                INCLUDE     "bootdict/x86/b-comma.asm"
                INCLUDE     "bootdict/x86/call-comma.asm"
                INCLUDE     "bootdict/tc/here.asm"
                INCLUDE     "bootdict/tc/literal.asm"
                INCLUDE     "bootdict/tc/compile-comma.asm"
                INCLUDE     "bootdict/tc/two-literal.asm"
                INCLUDE     "bootdict/x86/double.asm"
                INCLUDE     "bootdict/x86/compare.asm"
                INCLUDE     "bootdict/x86/memory.asm"
                INCLUDE     "bootdict/x86/string.asm"
                INCLUDE     "bootdict/x86/host.asm"
                INCLUDE     "bootdict/x86/wid-to-vt.asm"
                INCLUDE     "bootdict/tc/search.asm"
                INCLUDE     "bootdict/x86/s-to-d.asm"
                INCLUDE     "bootdict/x86/b-to-h.asm"
                INCLUDE     "bootdict/x86/split-8.asm"
                INCLUDE     "bootdict/x86/to-digit.asm"
                INCLUDE     "bootdict/x86/to-number.asm"
                INCLUDE     "bootdict/tc/digits.asm"
                INCLUDE     "bootdict/tc/h-dot-2.asm"
                INCLUDE     "bootdict/tc/h-dot-8.asm"
                INCLUDE     "bootdict/x86/excp-zero.asm"
                INCLUDE     "bootdict/tc/except.asm"
                INCLUDE     "bootdict/x86/source-id.asm"
                INCLUDE     "bootdict/x86/source-id-store.asm"
                INCLUDE     "bootdict/tc/source.asm"
                INCLUDE     "bootdict/tc/file.asm"
                INCLUDE     "bootdict/x86/paren-parse-paren.asm"
                INCLUDE     "bootdict/tc/parse.asm"
                INCLUDE_HEADER_TC
                INCLUDE     "bootdict/x86/latest-head-fetch.asm"
                INCLUDE     "bootdict/x86/latest-head-store.asm"
                INCLUDE     "bootdict/x86/to-head.asm"
                INCLUDE     "bootdict/x86/head-from.asm"
                INCLUDE     "bootdict/x86/sys-upcase.asm"
                INCLUDE     "bootdict/x86/paren-name-equals-paren.asm"
                INCLUDE     "bootdict/x86/search-headers.asm"
                INCLUDE     "bootdict/tc/header.asm"
                INCLUDE     "bootdict/tc/recognizer-core.asm"
                INCLUDE     "bootdict/tc/recognizer-word.asm"
                INCLUDE     "bootdict/tc/recognizer-num.asm"
                INCLUDE     "bootdict/tc/postpone.asm"
                INCLUDE     "bootdict/tc/interpret.asm"
                INCLUDE     "bootdict/tc/seh-handler.asm"
                INCLUDE     "bootdict/tc/sig-handler.asm"
                INCLUDE     "bootdict/x86/sysnt-thread.asm"
                INCLUDE     "bootdict/x86/syslinux-thread.asm"
                INCLUDE     "bootdict/x86/init-user.asm"
                INCLUDE     "bootdict/x86/call-ffl.asm"

                INCLUDE     "bootdict/x86/main-proc.asm"
                INCLUDE     "bootdict/tc/bootstrap-interpret.asm"
