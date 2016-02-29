#
#  Makefile for IKForth.
#
#  Copyright (C) 1999-2016 Illya Kysil
#

link = wlink
make = wmake
wine = wineconsole

code_threading_target = dtc
debug_target =

.BEFORE
        set wine=$(wine)
        set code_threading_target=$(code_threading_target)
        set debug_target=$(debug_target)
        set IKFORTH-TERMINIT=WINCONSOLE-INIT

launcher : .symbolic
!ifdef __LINUX__
        set WINEDEBUG=-all
        set btlauncher=wine
        set rtlauncher=$(%wine)
!else
        set btlauncher=
        set rtlauncher=
!endif

all : .symbolic compiler IKForth.exe launcher IKForth.img

clean : .symbolic
        scons -u -c
        rm -f  src/image/*.obj
        rm -rf src/image/target
        rm -f  src/FKernel.img
        rm -f  src/FKernel.exe
        rm -f  IKForth.exe IKForth.img
        rm -rf build

run : .symbolic all
        $(%rtlauncher) IKForth.exe

test : .symbolic all
        $(%rtlauncher) IKForth.exe 'S" IKForth-test.4th" INCLUDED'

test-stdin : .symbolic all
        echo 'S" fine!" TYPE' | $(%rtlauncher) IKForth.exe 'S" test/stdin-test.4th" INCLUDED'

debug : .symbolic
        echo Setting DEBUG options
        set debug_target=debug

dtc : .symbolic
        echo CODE_THREADING=DTC
        set code_threading_target=dtc

itc : .symbolic
        echo CODE_THREADING=ITC
        set code_threading_target=itc

term : .symbolic
!ifdef __LINUX__
        set IKFORTH-TERMINIT=ANSITERM-INIT
!endif
!ifdef __WINDOWS__
        set IKFORTH-TERMINIT=WINCONSOLE-INIT
!endif
        set wine=wine

IKForth.exe : loader
        echo Building $@
        cp src/FKernel.exe IKForth.exe > /dev/null

IKForth.img : compiler &
              src/*.f src/kernel/*.f src/kernel.0/*.f lib/win32/*.f &
              src/*.4th src/kernel/*.4th src/kernel.0/*.4th lib/win32/*.4th &
              lib/ansi/*.f lib/~ik/*.f lib/~js/486asm/*.F &
              lib/ansi/*.4th lib/~ik/*.4th lib/~js/486asm/*.4th
        echo Building $@
#        WINEDEBUG=-all winedbg src/FKernel.exe
#        WINEDEBUG=-all winedbg --file src/loader/FKernel.winedbg src/FKernel.exe
        $(%btlauncher) src/FKernel.exe

compiler : .symbolic image loader

loader : .symbolic src/FKernel.exe

image : .symbolic src/FKernel.img

src/FKernel.img : .symbolic
        echo Building $@
        scons -u $(%code_threading_target) $(%debug_target) image
        cp build/image/FKernel.img src/FKernel.img

src/FKernel.exe : .symbolic
        echo Building $@
        scons -u $(%debug_target) loader
        cp build/loader/FKernel.exe src/FKernel.exe
