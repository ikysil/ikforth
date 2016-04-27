;******************************************************************************
;
;  words.asm
;  IKForth
;
;  Copyright (C) 1999-2016 Illya Kysil
;
;******************************************************************************

                INCLUDE     "bootdict/x86/primitives.asm"
                INCLUDE     "bootdict/x86/fcontrol.asm"
                INCLUDE     "bootdict/tc/varconst.asm"
                INCLUDE     "bootdict/x86/stack.asm"
                INCLUDE     "bootdict/x86/rstack.asm"
                INCLUDE     "bootdict/x86/math.asm"
                INCLUDE     "bootdict/x86/data.asm"
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
                INCLUDE     "bootdict/x86/convert.asm"
                INCLUDE     "bootdict/tc/digits.asm"
                INCLUDE     "bootdict/tc/h-dot-2.asm"
                INCLUDE     "bootdict/tc/h-dot-8.asm"
                INCLUDE     "except.asm"
                INCLUDE     "source.asm"
                INCLUDE     "bootdict/tc/file.asm"
                INCLUDE     "bootdict/x86/paren-parse-paren.asm"
                INCLUDE     "bootdict/tc/parse.asm"
                INCLUDE_HEADER_TC
                INCLUDE     "header.asm"
                INCLUDE     "bootdict/tc/recognizer-core.asm"
                INCLUDE     "bootdict/tc/recognizer-word.asm"
                INCLUDE     "bootdict/tc/recognizer-num.asm"
                INCLUDE     "bootdict/tc/interpret.asm"
                INCLUDE     "sysnt-thread.asm"
                INCLUDE     "syslinux-thread.asm"
                INCLUDE     "bootdict/x86/ik.asm"
                INCLUDE     "bootdict/x86/call-ffl.asm"
