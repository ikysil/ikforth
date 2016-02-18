wcl = wcl386
CLFLAGS = -bc -w4 -e25 -zq -os -5s -mf
CLFLAGS += -I"$(%WATCOM)/h" -I"$(%WATCOM)/h/nt"
CLFLAGS += -zq -oaxt -d0 -w4 -l=nt -k4k

FKernel.exe : ../*.cpp ../*.hpp
    $(wcl) $(CLFLAGS) -fe=FKernel.exe -fm=FKernel.map ../*.cpp

clean: .symbolic
!ifdef __LINUX__
    rm -f *.obj *.err *.exe *.lnk *.res *.rex *.lib *.sym *.map
    rm -f *.lk1 *.mk1 *.mk
!endif
!ifdef __WINDOWS__
    @erase *.obj
    @erase *.err
    @erase *.exe
    @erase *.lnk
    @erase *.res
    @erase *.rex
    @erase *.lib
    @erase *.map
!endif
