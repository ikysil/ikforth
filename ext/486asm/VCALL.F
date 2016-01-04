( vcall.f )
( a virtual call and return mechanism to allow execution of a FORTH word from )
( assembly language, for Win32FORTH by Andrew McKewan & Tom Zimmer )
( copyright [c] 1994, by Jim Schneider )

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

also assembler current @ definitions base @ hex
code vreturn ( the virtual return, FORTH's IP is pointed here )
        forth here cell+ , assembler ( need to create a virtual CFA )
        mov esi, [ebp]
        mov ecx, 4 [ebp]
        add ebp, # 8
        jmp ecx
end-code

subr: vcall ( the virtual call function, stack-> return addr, eax-> xt )
        sub ebp, # 8
        pop ecx
        mov [ebp], esi
        mov 4 [ebp], ecx
        mov esi, # ' vreturn rel>abs
        exec
end-code

macro: fcall ( a macro to assemble a call to vcall )
        set-postfix >r
        mov eax, # '
        call vcall
        r> reset-syntax
endm
base ! current ! previous
