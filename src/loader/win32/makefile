platform = Win32
CC = wpp386
CFLAGS = -bt=nt -w4 -e25 -zq -os -5r -mf

name = FKernel
LNK = $(name).lnk
lnk_dependencies = makefile master.mif

OBJS = FKernel.obj IKFunc.obj IKFUtils.obj

!include master.mif

linkit : .PROCEDURE
    @%append $(LNK) system nt
    @%append $(LNK) option stack=64k
