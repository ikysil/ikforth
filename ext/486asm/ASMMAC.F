( Miscellaneous macros for Win32FORTH 486ASM version 1.26 )
( copyright [c] 1994 by Jim Schneider )
( This file version 1.21 )

(    This program is free software; you can redistribute it and/or modify )
(    it under the terms of the GNU General Public License as published by )
(    the Free Software Foundation; either version 2 of the License, or    )
(    <at your option> any later version.                                  )
(                                                                         )
(    This program is distributed in the hope that it will be useful,      )
(    but WITHOUT ANY WARRANTY; without even the implied warranty of       )
(    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the        )
(    GNU General Public License for more details.                         )
(                                                                         )
(    You should have received a copy of the GNU General Public License    )
(    along with this program; if not, write to the Free Software          )
(    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.            )

macro: ;m postpone ;macro endm immediate
macro: al, al , ;m
macro: cl, cl , ;m
macro: dl, dl , ;m
macro: bl, bl , ;m
macro: ah, ah , ;m
macro: ch, ch , ;m
macro: dh, dh , ;m
macro: bh, bh , ;m
macro: ax, ax , ;m
macro: cx, cx , ;m
macro: dx, dx , ;m
macro: bx, bx , ;m
macro: sp, sp , ;m
macro: bp, bp , ;m
macro: si, si , ;m
macro: di, di , ;m
macro: eax, eax , ;m
macro: ecx, ecx , ;m
macro: edx, edx , ;m
macro: ebx, ebx , ;m
macro: esp, esp , ;m
macro: ebp, ebp , ;m
macro: esi, esi , ;m
macro: edi, edi , ;m
macro: [bx+si], [bx+si] , ;m
macro: [bx+di], [bx+di] , ;m
macro: [bp+si], [bp+si] , ;m
macro: [bp+di], [bp+di] , ;m
macro: [si], [si] , ;m
macro: [di], [di] , ;m
macro: [bp], [bp] , ;m
macro: [bx], [bx] , ;m
macro: [eax], [eax] , ;m
macro: [ecx], [ecx] , ;m
macro: [edx], [edx] , ;m
macro: [ebx], [ebx] , ;m
macro: [esp], [esp] , ;m
macro: [ebp], [ebp] , ;m
macro: [esi], [esi] , ;m
macro: [edi], [edi] , ;m
macro: [eax*2], [eax*2] , ;m
macro: [ecx*2], [ecx*2] , ;m
macro: [edx*2], [edx*2] , ;m
macro: [ebx*2], [ebx*2] , ;m
macro: [ebp*2], [ebp*2] , ;m
macro: [esi*2], [esi*2] , ;m
macro: [edi*2], [edi*2] , ;m
macro: [eax*4], [eax*4] , ;m
macro: [ecx*4], [ecx*4] , ;m
macro: [edx*4], [edx*4] , ;m
macro: [ebx*4], [ebx*4] , ;m
macro: [ebp*4], [ebp*4] , ;m
macro: [esi*4], [esi*4] , ;m
macro: [edi*4], [edi*4] , ;m
macro: [eax*8], [eax*8] , ;m
macro: [ecx*8], [ecx*8] , ;m
macro: [edx*8], [edx*8] , ;m
macro: [ebx*8], [ebx*8] , ;m
macro: [ebp*8], [ebp*8] , ;m
macro: [esi*8], [esi*8] , ;m
macro: [edi*8], [edi*8] , ;m
macro: es, es , ;m
macro: cs, cs , ;m
macro: ss, ss , ;m
macro: ds, ds , ;m
macro: fs, fs , ;m
macro: gs, gs , ;m
macro: cr0, cr0 , ;m
macro: cr2, cr2 , ;m
macro: cr3, cr3 , ;m
macro: cr4, cr4 , ;m
macro: dr0, dr0 , ;m
macro: dr1, dr1 , ;m
macro: dr2, dr2 , ;m
macro: dr3, dr3 , ;m
macro: dr6, dr6 , ;m
macro: dr7, dr7 , ;m
macro: tr3, tr3 , ;m
macro: tr4, tr4 , ;m
macro: tr5, tr5 , ;m
macro: tr6, tr6 , ;m
macro: tr7, tr7 , ;m
macro: st, st , ;m
macro: st(0), st(0) , ;m
macro: st(1), st(1) , ;m
macro: st(2), st(2) , ;m
macro: st(3), st(3) , ;m
macro: st(4), st(4) , ;m
macro: st(5), st(5) , ;m
macro: st(6), st(6) , ;m
macro: st(7), st(7) , ;m

