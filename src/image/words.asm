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
                INCLUDE     "data.asm"
                INCLUDE     "double.asm"
                INCLUDE     "bootdict/x86/compare.asm"
                INCLUDE     "bootdict/x86/memory.asm"
                INCLUDE     "bootdict/x86/string.asm"
                INCLUDE     "host.asm"
                INCLUDE     "search.asm"
                INCLUDE     "convert.asm"
                INCLUDE     "except.asm"
                INCLUDE     "source.asm"
                INCLUDE     "bootdict/tc/file.asm"
                INCLUDE     "parse.asm"
                INCLUDE_HEADER_TC
                INCLUDE     "header.asm"
                INCLUDE     "bootdict/tc/recognizer-core.asm"
                INCLUDE     "bootdict/tc/recognizer-word.asm"
                INCLUDE     "bootdict/tc/recognizer-num.asm"
                INCLUDE     "interpret.asm"
                INCLUDE     "sysnt-thread.asm"
                INCLUDE     "syslinux-thread.asm"
                INCLUDE     "bootdict/x86/ik.asm"
                INCLUDE     "bootdict/x86/call-ffl.asm"
