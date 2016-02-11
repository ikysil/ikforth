#!/usr/bin/env bash
echo Building IKForth
export WATCOM=~/bin/openwatcom-1.9
echo Using OpenWatcom at $WATCOM
. $WATCOM/owsetenv.sh
wmake -h -s $*
