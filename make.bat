@echo off
echo Building IKForth
set watcom=t:\openwatcom
call %watcom%\setvars.bat
wmake -h -s %1 %2 %3 %4 %5