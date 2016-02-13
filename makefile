#
#  Makefile for IKForth.
#
#  Copyright (C) 1999-2016 Illya Kysil
#

asm = fasm
asm_opts =
asml = listing
link = wlink
make = wmake
wine = wineconsole

!ifdef __LINUX__
loader_makefile=makefile.linux
!else
loader_makefile=makefile
!endif

code_threading = -d CODE_THREADING=DTC

.BEFORE
        set wine=$(wine)
        set asm_opts=$(asm_opts)
        set code_threading=$(code_threading)
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
        rm -f  src/image/*.obj
        rm -rf src/image/target
        rm -f  src/FKernel.img
        rm -f  src/FKernel.exe
        rm -f  IKForth.exe IKForth.img
        cd  src/loader/win32
        $(make) -f $(loader_makefile) clean $(__MAKEOPTS__)
        cd  ../../..

run : .symbolic all
        $(%rtlauncher) IKForth.exe

test : .symbolic all
        $(%rtlauncher) IKForth.exe 'S" IKForth-test.4th" INCLUDED'

test-stdin : .symbolic all
        echo 'S" fine!" TYPE' | $(%rtlauncher) IKForth.exe 'S" test/stdin-test.4th" INCLUDED'

debug : .symbolic
        echo Setting DEBUG options
        set asm_opts=-d DEBUG=TRUE $(%asm_opts)

dtc : .symbolic
        echo CODE_THREADING=DTC
        set code_threading=-d CODE_THREADING=DTC

itc : .symbolic
        echo CODE_THREADING=ITC
        set code_threading=-d CODE_THREADING=ITC

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

compiler : .symbolic src/FKernel.img loader

loader : .symbolic src/FKernel.exe

src/FKernel.img : src/FKernel.exe src/image/*.asm src/image/*.inc
        echo Building $@
        cd  src/image
        mkdir -p target
        $(asm) $(%asm_opts) $(%code_threading) FKernel.asm -s target/FKernel.sym ../FKernel.img
        $(asml) target/FKernel.sym target/FKernel.lst
        cd  ../..

src/FKernel.exe : src/loader/*.cpp src/loader/*.hpp
        echo Building $@
        cd  src/loader/win32
        $(make) -f $(loader_makefile) $(__MAKEOPTS__)
        cp FKernel.exe ../../FKernel.exe > /dev/null
        cd  ../../..
