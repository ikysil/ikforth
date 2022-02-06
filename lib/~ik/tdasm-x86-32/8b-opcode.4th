PURPOSE: 8bit x86 opcodes
LICENSE: Unlicense since 1999 by Illya Kysil

\ Maintenance note: keep sorted by the opcode

\ Registers
\ - EAX, ECX, EDX, EBX, ESP, EBP, ESI, EDI
\ - ES, CS, SS, DS, GS, FS

H# 06 8C: push.es
H# 07 8C: pop.es
H# 0E 8C: push.cs

H# 16 8C: push.ss
H# 17 8C: pop.ss
H# 1E 8C: push.ds
H# 1F 8C: pop.ds

H# 40 8C: inc.eax
H# 41 8C: inc.ecx
H# 42 8C: inc.edx
H# 43 8C: inc.ebx
H# 44 8C: inc.esp
H# 45 8C: inc.ebp
H# 46 8C: inc.esi
H# 47 8C: inc.edi

H# 48 8C: dec.eax
H# 49 8C: dec.ecx
H# 4A 8C: dec.edx
H# 4B 8C: dec.ebx
H# 4C 8C: dec.esp
H# 4D 8C: dec.ebp
H# 4E 8C: dec.esi
H# 4F 8C: dec.edi

H# 50 8C: push.eax
H# 51 8C: push.ecx
H# 52 8C: push.edx
H# 53 8C: push.ebx
H# 54 8C: push.esp
H# 55 8C: push.ebp
H# 56 8C: push.esi
H# 57 8C: push.edi

H# 58 8C: pop.eax
H# 59 8C: pop.ecx
H# 5A 8C: pop.edx
H# 5B 8C: pop.ebx
H# 5C 8C: pop.esp
H# 5D 8C: pop.ebp
H# 5E 8C: pop.esi
H# 5F 8C: pop.edi

H# 90 8C: nop
H# 9C 8C: pushf
H# 9D 8C: popf

H# A5 8C: movsd
H# AB 8C: stosd
H# AD 8C: lodsd
H# AF 8C: scasd

H# C3 8C: ret

H# F2 8C: repnz
H# F3 8C: repz
H# F4 8C: hlt
H# FA 8C: cli
H# FB 8C: sti
H# FC 8C: cld
H# FD 8C: std
