( 486 and Pentium assembler for Windows 32bit FORTH, version 1.26 )
( copyright [c] 1994, 1995, by Jim Schneider )

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

( declare the vocabularies needed )
only forth definitions ( vocabulary assembler ) also assembler definitions
vocabulary asm-hidden also asm-hidden definitions also assembler
( the also assembler is strictly to turn off stack warnings )

( words to manipulate the vocabulary search order )
: in-asm ( all later words are defined in the assembler vocabulary )
        only forth also asm-hidden also assembler definitions ;
: in-hidden ( all later words are defined in the hidden vocabulary )
        only forth also asm-hidden definitions also assembler ;
: in-forth ( all later words are defined in the forth vocabulary )
        only forth definitions also asm-hidden also assembler ;
in-hidden

( miscellaneous housekeeping )
base @ decimal ( save the base because I hate gratuitous base bashing )
: cell- [ 1 cells ] literal - ;
: cell/ [ 1 cells ] literal / ;
: 8* 8 * ;
: 8/ 8 / ;
: 8+ 8 + ;
: 8- 8 - ;
: 4+ 4 + ;
: 2+ 2 + ;
: 2- 2 - ;
: 8*+ 8* + ;
: 16*+ 16 * + ;
: 16/mod 16 /mod ;
hex
: c0-8* 0c0 - 8* ;
: c0+ 0c0 + ;
: c0- 0c0 - ;

( defer some words for ease in porting to a cross assembler )
defer     code-c, '     c, is     code-c, ( x -- )
defer     code-w, '     w, is     code-w, ( x -- )
defer     code-d, '      , is     code-d, ( x -- )
defer      data-, '      , is      data-, ( x -- )
defer     code-c! '     c! is     code-c! ( x \ a -- )
defer     code-w! '     w! is     code-w! ( x \ a -- )
defer     code-d! '      ! is     code-d! ( x \ a -- )
defer      data-! '      ! is      data-! ( x \ a -- )
defer     data-+! '     +! is     data-+! ( x \ a -- )
defer     code-c@ '     c@ is     code-c@ ( a -- x )
defer     code-w@ '     w@ is     code-w@ ( a -- x )
defer     code-d@ '      @ is     code-d@ ( a -- x )
defer      data-@ '      @ is      data-@ ( a -- x )
defer   data-here '   here is   data-here ( -- a )
defer   code-here '   here is   code-here ( -- a )
defer  code-align '  align is  code-align ( -- )
defer code-header ' header is code-header ( -- )

( register out of scope forward references, for use by a cross-compiler )
defer register-ref ' drop is register-ref ( address \ type -- address )
( register actual code creation, for use in optomizers, debuggers, etc. )
defer register-asm ' noop is register-asm ( data \ xt -- data \ xt )

in-forth
( set up the registration callback functions )
: set-register-ref is register-ref ;
: set-register-asm is register-asm ;
in-hidden

( constants for the type argument )
1 constant  8b-abs      (  8 bit absolute addressing )
2 constant 16b-abs      ( 16 bit absolute addressing )
3 constant 32b-abs      ( 32 bit absolute addressing )
5 constant  8b-rel      (  8 bit relative addressing )
6 constant 16b-rel      ( 16 bit relative addressing )
7 constant 32b-rel      ( 32 bit relative addressing )

( defer the error handler words so they can be individually turned off )
( defer them here so they can be used before they are actually defined )
: def-err-hand ( the default error handler for uninitialized error handlers )
        ( x*i -- x*j )
        -1 abort" No error handler installed" ;
' def-err-hand constant deh-xt

defer ?params deh-xt is ?params ( -- ) \ are there parameters?
defer ?seg deh-xt is ?seg ( -- ) \ is there a seg override?
defer ?lock deh-xt is ?lock ( -- ) \ is there a LOCK prefix?
defer ?rep deh-xt is ?rep ( -- ) \ is there a REP type prefix?
defer ?inst-pre deh-xt is ?inst-pre ( -- ) \ is there an inst prefix?
defer ?operands deh-xt is ?operands ( -- ) \ are there operands?
defer ?opsize deh-xt is ?opsize ( n -- ) \ is the operand size mismatched?
defer ?adsize deh-xt is ?adsize ( n -- ) \ is the address size mismatched?
defer ?short deh-xt is ?short ( -- ) \ is there an illegal SHORT?
defer ?toofar deh-xt is ?toofar ( flag -- ) \ is the dest of a branch to big?
defer ?unres deh-xt is ?unres ( -- ) \ is there an unresolved forward reference?
defer ?noadsize deh-xt is ?noadsize ( -- ) \ is the fwd ref addr size unknown?
defer ?toomanyops deh-xt is ?toomanyops ( n -- ) \ are there too many operands?
defer ?nofar deh-xt is ?nofar ( -- ) \ is there a far reference?
defer ?match deh-xt is ?match ( x1 \ x2 -- ) \ error if x1==x2
defer ?nomatch deh-xt is ?nomatch ( x1 \ x2 -- ) \ error if x1!=x2
defer ?finished deh-xt is ?finished ( -- ) \ are there operands left over?
defer ?badtype deh-xt is ?badtype ( max type val -- ) \ is the type unallowed?
defer ?badcombine deh-xt is ?badcombine ( flag -- ) \ can the types be combined?
defer ?notenough deh-xt is ?notenough ( n -- ) \ are there too few operands?
defer ?noimmed deh-xt is ?noimmed ( -- ) \ is there an illegal immediate op?
defer ?badmode deh-xt is ?badmode ( flag -- ) \ is the address mode illegal?
defer ?reg,r/m deh-xt is ?reg,r/m ( -- ) \ is the dest a reg?
defer ?r/m,reg deh-xt is ?r/m,reg ( -- ) \ is the source a reg?
defer ?mem deh-xt is ?mem ( -- ) \ do we have an illegal register operand?
defer ?reg deh-xt is ?reg ( -- ) \ do we have an illegal memory operand?

( defer the word that calls the words that create the code )
( it comes in two flavors -- prefix and postfix )
( it's deferred here so I can use it now )
: no-opcode-handler -1 abort" no opcode creator installed" ;
defer do-opcode ' no-opcode-handler is do-opcode ( x? \ x? \ 0|addr -- )
        \ postfix mode: this actually saves the current instruction and
        \ does the previous one.

in-asm
: a; ( finish the assembly of the previous instruction )
        ( -- )
        0 do-opcode ;

( address and data sizes )
in-hidden
0 constant unknown              ( also, operand type and number )
1 constant 8bit
2 constant 16bit
3 constant 32bit
4 constant 64bit
5 constant 80bit

( determine what size code to generate )
32bit value default-size   ( the default use size )
: !default-size ( not the default size, eg. change 16bit to 32bit )
        ( -- size )
        default-size 16bit = if 32bit else 16bit then ;
in-asm
: use16 ( generate 16 bit code by default )
        16bit to default-size ;
: use32 ( generate 32 bit code by default )
        32bit to default-size ;

( create a stack for operands )
in-hidden
7 constant max-operands         ( maximum number of operands on the opstack )
create opstack max-operands 1+ cells allot here constant opstack-end
: clr-opstack opstack dup cell+ swap data-! ;
clr-opstack ( initialize the opstack )
: ?clr-opstack ( clear the operand stack when the flag is non-zero )
        ( f -- )
        if clr-opstack then ;
in-asm
: push-op ( move a parameter stack item to the opstack )
        ( x -- )
        opstack data-@ opstack-end = dup ?clr-opstack
        abort" OPSTACK overflow" opstack dup data-@ dup cell+ rot data-!
        data-! ;
: pop-op ( move an item from the operand stack to the parameter stack )
        ( -- x )
        opstack dup data-@ swap cell+ = dup ?clr-opstack
        abort" OPSTACK underflow" opstack dup data-@ cell- dup rot
        data-! data-@ ;
in-hidden
: op-depth ( check the depth of the operand stack )
        opstack dup data-@ swap - cell- cell/ ;

( words to support forward referenced local labels )
100 constant frmax      ( max number of unresolved forward references )
140 constant lbmax      ( max number of local labels )
create frtable frmax 2* cells allot ( holds unresolved forward references )
create lbtable lbmax cells allot ( holds local label bindings )
: addref ( add a forward reference at code-here )
        ( ref# -- ref# )
        frtable [ frmax 1+ ] literal 0 do
                frmax i = dup ?clr-opstack
                abort" too many unresolved forward references"
                dup data-@ if
                        cell+ cell+ else 2dup data-! code-here over cell+
                        data-! leave
                then
        loop drop ;
: backpatch ( backpatch a forward reference to here )
        ( address \ size -- )
        case   8bit of
                code-here over 1+ - dup abs 7f > ?toofar swap code-c!
        endof 16bit of
                code-here over 2+ - dup abs 7fff > ?toofar swap code-w!
        endof 32bit of
                code-here over 4+ - swap code-d!
        endof ?noadsize drop endcase ;
: refsize ( determine the size of a bound reference )
        ( addr of instr -- addr of operand \ size )
        dup code-c@ 67 ( addr size override prefix ) = if
                1+ !default-size
        else
                default-size
        then
        ( stack: address of actual instruction \ provisional size )
        >r dup code-c@ case
        0f of ( a near conditional branch )
                1+ ( adjust for the first byte of the opcode )
        endof 0e9 of ( a jmp near, don't need to do anything )
        endof 0e8 of ( a near call, don't need to do anything )
        endof ( if we get to here, it must be 8 bit )
                r> drop 8bit >r
        endcase 1+ r> ;
: resolve ( resolve a forward reference to code-here )
        ( ref# -- ref# )
        frtable frmax 0 do
                2dup data-@ = if
                        dup cell+ data-@ refsize backpatch 0 over data-!
                then
                cell+ cell+
        loop
        drop ;
: !label ( bind a label to code-here )
        ( ref# -- )
        resolve code-here swap cells lbtable + data-! ;
: @label ( fetch the binding of a label, or return a pseudo address if not )
        ( yet bound to an address )
        ( ref# -- addr )
        dup cells lbtable + data-@ ?dup if swap drop else addref drop
        code-here then ;
: create-ref ( create words to reference local labels )
        ( c:: index -- )
        ( r:: -- addr )
        create data-, does> data-@ @label ;
: create-bind ( create words to bind local labels )
        ( c:: index -- )
        ( r:: -- )
        create data-, does> >r a; r> data-@ !label ;

( These references and bindings are named for general use.  Do not use them )
( in macros )
in-asm
1 create-ref @@1  1 create-bind @@1:
2 create-ref @@2  2 create-bind @@2:
3 create-ref @@3  3 create-bind @@3:
4 create-ref @@4  4 create-bind @@4:
5 create-ref @@5  5 create-bind @@5:
6 create-ref @@6  6 create-bind @@6:
7 create-ref @@7  7 create-bind @@7:
8 create-ref @@8  8 create-bind @@8:
9 create-ref @@9  9 create-bind @@9:

in-hidden
0 value in-macro? ( a semaphore to tell if we're in execution of a macro )
0a value macro-labels ( the first label used for macros )
variable macro-label-level ( for labels to use in macros )
: in-macro ( flag the fact that we are in a macro )
        ( -- )
        1 +to in-macro? ;
: !in-macro ( flag the fact that we've left a macro )
        ( -- )
        -1 +to in-macro? ;
: +macro ( get an index into the label table from an offset )
        ( offset -- index )
        macro-label-level data-@ + dup lbmax >
        abort" Too many local labels in macros" ;
: +macro-ref ( reference a label offset from the macro level )
        ( offset -- addr )
        +macro @label ;
: +macro-bind ( bind a label offset from the macro level )
        ( offset -- )
        +macro !label ;
: enter-macro ( set up macro relative local labels )
        ( -- )
        macro-labels macro-label-level dup data-@ rot + dup rot data-! cells
        lbtable + macro-labels cells erase in-macro ;
: leave-macro ( go back to the old regime )
        ( old macro label level -- )
        macro-labels macro-label-level dup data-@ rot - swap data-! !in-macro ;
: create-macro-ref ( create macro-safe local label references )
        ( c:: label offset -- )
        ( r:: -- addr )
        create data-, does> data-@ +macro-ref ;
: create-macro-bind ( create macro-safe local label bindings )
        ( c:: label offset -- )
        ( r:: -- )
        create data-, does> >r a; r> data-@ +macro-bind ;
: loc-init ( initialize the tables and variables )
        ( -- )
        frtable [ frmax 2* cells ] literal erase lbtable [ lbmax cells ]
        literal erase macro-labels macro-label-level data-! ;

( macro safe local labels )
in-asm
0 create-macro-ref @@m0 0 create-macro-bind @@m0:
1 create-macro-ref @@m1 1 create-macro-bind @@m1:
2 create-macro-ref @@m2 2 create-macro-bind @@m2:
3 create-macro-ref @@m3 3 create-macro-bind @@m3:
4 create-macro-ref @@m4 4 create-macro-bind @@m4:
5 create-macro-ref @@m5 5 create-macro-bind @@m5:
6 create-macro-ref @@m6 6 create-macro-bind @@m6:
7 create-macro-ref @@m7 7 create-macro-bind @@m7:
8 create-macro-ref @@m8 8 create-macro-bind @@m8:
9 create-macro-ref @@m9 9 create-macro-bind @@m9:
( Create alternative label reference and binding names for Tom )
0 create-macro-ref l$0  0 create-macro-bind l$0:
1 create-macro-ref l$1  1 create-macro-bind l$1:
2 create-macro-ref l$2  2 create-macro-bind l$2:
3 create-macro-ref l$3  3 create-macro-bind l$3:
4 create-macro-ref l$4  4 create-macro-bind l$4:
5 create-macro-ref l$5  5 create-macro-bind l$5:
6 create-macro-ref l$6  6 create-macro-bind l$6:
7 create-macro-ref l$7  7 create-macro-bind l$7:
8 create-macro-ref l$8  8 create-macro-bind l$8:
9 create-macro-ref l$9  9 create-macro-bind l$9:

( constants for operand typing )
( operand types )
in-hidden
 1 constant indirect    ( 16 bit register indirect )
 2 constant based       ( 32 bit register indirect or scaled index/base )
 3 constant index       ( 32 bit scaled index )
 4 constant immediate   ( an immediate operand )
 5 constant register    ( a general purpose machine register )
 6 constant sreg        ( a segment register )
 7 constant creg        ( a control register )
 8 constant dreg        ( a debug register )
 9 constant treg        ( a test register )
0a constant freg        ( a floating point register )

( encode and decode register representations )
( register encoding: )
        ( bits  use )
        ( 0-3   data size )
        ( 4-7   address size )
        ( 8-11  type )
        ( 12-13 r/m or s-i-b )
: <enc-reg> ( encode the single cell operand representation from the values )
        ( on the stack )
        ( data size \ addr size \ type \ r/m or s-i-b -- reg val )
        16*+ 16*+ 16*+ ;
: <dec-reg> ( decode the single cell operand representation to its )
        ( constituent parts )
        ( reg val -- data size \ addr size \ type \ r/m or s-i-b )
        16/mod 16/mod 16/mod ;
: asm-op ( create the assembler operands from operand descriptions )
        ( c:: data size \ addr size \ type \ r/m or s-i-b -- )
        ( r:: -- )
        ( r::os: -- x )
        create <enc-reg> data-, does> data-@ push-op ;

( the assembler operands )
in-asm
   8bit unknown  register       0 asm-op       al
   8bit unknown  register       1 asm-op       cl
   8bit unknown  register       2 asm-op       dl
   8bit unknown  register       3 asm-op       bl
   8bit unknown  register       4 asm-op       ah
   8bit unknown  register       5 asm-op       ch
   8bit unknown  register       6 asm-op       dh
   8bit unknown  register       7 asm-op       bh
  16bit unknown  register       0 asm-op       ax
  16bit unknown  register       1 asm-op       cx
  16bit unknown  register       2 asm-op       dx
  16bit unknown  register       3 asm-op       bx
  16bit unknown  register       4 asm-op       sp
  16bit unknown  register       5 asm-op       bp
  16bit unknown  register       6 asm-op       si
  16bit unknown  register       7 asm-op       di
  32bit unknown  register       0 asm-op      eax
  32bit unknown  register       1 asm-op      ecx
  32bit unknown  register       2 asm-op      edx
  32bit unknown  register       3 asm-op      ebx
  32bit unknown  register       4 asm-op      esp
  32bit unknown  register       5 asm-op      ebp
  32bit unknown  register       6 asm-op      esi
  32bit unknown  register       7 asm-op      edi
unknown   16bit  indirect       0 asm-op  [bx+si]
unknown   16bit  indirect       1 asm-op  [bx+di]
unknown   16bit  indirect       2 asm-op  [bp+si]
unknown   16bit  indirect       3 asm-op  [bp+di]
unknown   16bit  indirect       4 asm-op     [si]
unknown   16bit  indirect       5 asm-op     [di]
unknown   16bit  indirect       6 asm-op     [bp]
unknown   16bit  indirect       7 asm-op     [bx]
unknown   32bit     based       0 asm-op    [eax]
unknown   32bit     based       1 asm-op    [ecx]
unknown   32bit     based       2 asm-op    [edx]
unknown   32bit     based       3 asm-op    [ebx]
unknown   32bit     based       4 asm-op    [esp]
unknown   32bit     based       5 asm-op    [ebp]
unknown   32bit     based       6 asm-op    [esi]
unknown   32bit     based       7 asm-op    [edi]
unknown   32bit     index       8 asm-op  [eax*2]
unknown   32bit     index       9 asm-op  [ecx*2]
unknown   32bit     index      0a asm-op  [edx*2]
unknown   32bit     index      0b asm-op  [ebx*2]
unknown   32bit     index      0c asm-op  [esp*2]
unknown   32bit     index      0d asm-op  [ebp*2]
unknown   32bit     index      0e asm-op  [esi*2]
unknown   32bit     index      0f asm-op  [edi*2]
unknown   32bit     index      10 asm-op  [eax*4]
unknown   32bit     index      11 asm-op  [ecx*4]
unknown   32bit     index      12 asm-op  [edx*4]
unknown   32bit     index      13 asm-op  [ebx*4]
unknown   32bit     index      14 asm-op  [esp*4]
unknown   32bit     index      15 asm-op  [ebp*4]
unknown   32bit     index      16 asm-op  [esi*4]
unknown   32bit     index      17 asm-op  [edi*4]
unknown   32bit     index      18 asm-op  [eax*8]
unknown   32bit     index      19 asm-op  [ecx*8]
unknown   32bit     index      1a asm-op  [edx*8]
unknown   32bit     index      1b asm-op  [ebx*8]
unknown   32bit     index      1c asm-op  [esp*8]
unknown   32bit     index      1d asm-op  [ebp*8]
unknown   32bit     index      1e asm-op  [esi*8]
unknown   32bit     index      1f asm-op  [edi*8]
  16bit unknown      sreg       0 asm-op       es
  16bit unknown      sreg       1 asm-op       cs
  16bit unknown      sreg       2 asm-op       ss
  16bit unknown      sreg       3 asm-op       ds
  16bit unknown      sreg       4 asm-op       fs
  16bit unknown      sreg       5 asm-op       gs
  32bit unknown      creg       0 asm-op      cr0
  32bit unknown      creg       2 asm-op      cr2
  32bit unknown      creg       3 asm-op      cr3
  32bit unknown      creg       4 asm-op      cr4
  32bit unknown      dreg       0 asm-op      dr0
  32bit unknown      dreg       1 asm-op      dr1
  32bit unknown      dreg       2 asm-op      dr2
  32bit unknown      dreg       3 asm-op      dr3
  32bit unknown      dreg       6 asm-op      dr6
  32bit unknown      dreg       7 asm-op      dr7
  32bit unknown      treg       3 asm-op      tr3
  32bit unknown      treg       4 asm-op      tr4
  32bit unknown      treg       5 asm-op      tr5
  32bit unknown      treg       6 asm-op      tr6
  32bit unknown      treg       7 asm-op      tr7
unknown unknown      freg       0 asm-op       st
unknown unknown      freg       0 asm-op    st(0)
unknown unknown      freg       1 asm-op    st(1)
unknown unknown      freg       2 asm-op    st(2)
unknown unknown      freg       3 asm-op    st(3)
unknown unknown      freg       4 asm-op    st(4)
unknown unknown      freg       5 asm-op    st(5)
unknown unknown      freg       6 asm-op    st(6)
unknown unknown      freg       7 asm-op    st(7)
   8bit unknown   unknown unknown asm-op     byte
  16bit unknown   unknown unknown asm-op     word
  32bit unknown   unknown unknown asm-op    dword
  64bit unknown   unknown unknown asm-op    qword
  32bit unknown   unknown unknown asm-op    float
  64bit unknown   unknown unknown asm-op   double
  80bit unknown   unknown unknown asm-op     long
  80bit unknown   unknown unknown asm-op extended
  80bit unknown   unknown unknown asm-op    tbyte
unknown    8bit   unknown unknown asm-op    short
unknown   16bit   unknown unknown asm-op     near
unknown   32bit   unknown unknown asm-op      far
unknown unknown immediate unknown asm-op        #
unknown unknown   unknown unknown asm-op        ,

( variables used for instruction coding )
in-hidden
variable inst-prefix    ( instruction prefixes )
variable addr-prefix    ( address size prefix )
variable data-prefix    ( data size prefix )
variable seg-prefix     ( segment override prefix )
variable sv-inst-prefix ( the saved instruction prefix )
variable inst-save      ( the previously executed instruction )
variable sp-save        ( the stack pointer )
variable offset-sv      ( save the offset part )
variable immed-sv       ( save the immediate part )
variable dt-size        ( data item size )
variable ad-size        ( address size )
variable rtype          ( the working register type )
variable maxtype        ( the maximum numerical type value encountered )
variable mod-r/m        ( the working area for the mod-r/m byte )
variable s-i-b          ( the working area for the s-i-b byte )
variable addmode        ( addressing mode flags )

: reset-vars ( store 0 into all instruction coding variables )
        0 inst-prefix data-! 0 addr-prefix data-! 0 data-prefix data-!
        0 seg-prefix data-! 0 sv-inst-prefix data-! 0 inst-save data-!
        0 sp-save data-! 0 offset-sv data-! 0 immed-sv data-! 0 dt-size data-!
        0 ad-size data-! 0 rtype data-! 0 maxtype data-! 0 mod-r/m data-!
        0 s-i-b data-! 0 addmode data-! ;

: reset-for-next-instr ( store a 0 into intermediate coding variables )
        0 offset-sv data-! 0 immed-sv data-! 0 dt-size data-!
        0 ad-size data-! 0 rtype data-! 0 maxtype data-! 0 mod-r/m data-!
        0 s-i-b data-! 0 addmode data-! ;

( set/reset mode bits )
  1 constant immed-bit           ( flag an immediate operand )
  2 constant direct-bit          ( flag the direction )
  4 constant mod-r/m-bit         ( flag that we've started the mod-r/m )
  8 constant s-i-b-bit           ( flag the beginning of s-i-b creation )
 10 constant full-off-bit        ( flag a full offset )
 20 constant based-bit           ( flag that we've seen a base )
 40 constant offset-bit          ( flag an offset )
 80 constant short-bit           ( flag short )
100 constant near-bit            ( flag near )
200 constant far-bit             ( flag far )
400 constant do-1op-bit          ( flag we've been through do-1op once )
800 constant maybe-offset-bit    ( flag that maybe we've got an offset )
immed-bit
direct-bit or
mod-r/m-bit or
s-i-b-bit or
full-off-bit or
based-bit or
offset-bit or
short-bit or
near-bit or
far-bit or
do-1op-bit or
maybe-offset-bit or
constant mode-mask      ( all mode bits set )

: 1mode-bit! ( set a mode bit )
        ( bit constant -- )
        addmode swap over data-@ or swap data-! ;
: 0mode-bit! ( clear a mode bit )
        ( bit constant -- )
        mode-mask xor addmode swap over data-@ and swap data-! ;
: mode-bit@ ( fetch a mode bit )
        ( bit mask -- flag )
        addmode data-@ and 0<> ;
: has-immed ( flag an immediate operand )
        ( -- )
        immed-bit 1mode-bit! ;
: has-immed? ( do we have an immediate operand? )
        ( -- flag )
        immed-bit mode-bit@ ;
: has-mod-r/m ( we've seen at least one operand )
        ( -- )
        mod-r/m-bit 1mode-bit! ;
: has-mod-r/m? ( have we seen an operand? )
        ( -- flag )
        mod-r/m-bit mode-bit@ ;
: has-s-i-b ( we've started work on the s-i-b )
        ( -- )
        s-i-b-bit 1mode-bit! ;
: has-s-i-b? ( have we started work on the s-i-b )
        ( -- flag )
        s-i-b-bit mode-bit@ ;
: reg,r/m ( addressing mode is register, register/memory )
        ( -- )
        direct-bit 1mode-bit! ;
: r/m,reg ( addressing mode is register/memory, register )
        ( -- )
        direct-bit 0mode-bit! ;
: direction? ( is the destination a register? )
        ( -- flag )
        direct-bit mode-bit@ ;
: has-full-off ( must generate a full offset )
        ( -- )
        full-off-bit 1mode-bit! ;
: has-full-off? ( do we need a full offset? )
        ( -- flag )
        full-off-bit mode-bit@ ;
: has-base ( we have a base )
        ( -- )
        based-bit 1mode-bit! ;
: has-base? ( do we have a base? )
        ( -- flag )
        based-bit mode-bit@ ;
: maybe-s-i-b? ( do we have a possible s-i-b? )
        ( -- flag )
        based-bit mode-bit@ s-i-b-bit mode-bit@ or ;
: has-offset ( flag that we do have an offset )
        ( -- )
        offset-bit 1mode-bit! ;
: has-offset? ( do we have an offset? )
        ( -- flag )
        offset-bit mode-bit@ full-off-bit mode-bit@ or ;
: is-short ( we have a short displacement )
        ( -- )
        short-bit 1mode-bit! ;
: is-short? ( is the displacement short? )
        ( -- flag )
        short-bit mode-bit@ ;
: is-near ( we have a near displacement )
        ( -- )
        near-bit 1mode-bit! ;
: is-near? ( do we have a near displacement? )
        ( -- flag )
        near-bit mode-bit@ far-bit mode-bit@ 0= or ;
: is-far ( we have a far pointer )
        ( -- )
        far-bit 1mode-bit! ;
: is-far? ( do we have a far displacement? )
        ( -- flag )
        far-bit mode-bit@ ;
: do-1op-exed ( we've exec'd do-1op )
        ( -- )
        do-1op-bit 1mode-bit! ;
( Note: when we start to assemble an opcode, all flags are off )
: do-1op-exed? ( have we exec'd do-1op? )
        ( -- flag )
        do-1op-bit mode-bit@ ;
: maybe-has-offset ( flag that we've picked something up from the stack )
        ( -- )
        maybe-offset-bit 1mode-bit! ;
: maybe-has-offset? ( have we picked up something from the stack? )
        ( -- flag )
        maybe-offset-bit mode-bit@ ;

( test for error conditions )
: _?params ( are there parameters on the stack? )
        sp@ sp-save data-@ - dup ?clr-opstack
        abort" offset or immediate operand not allowed with this instruction" ;
' _?params is ?params

: _?seg ( is there a segment override? )
        seg-prefix data-@ dup ?clr-opstack
        abort" segment override not allowed with this instruction" ;
' _?seg is ?seg

: _?lock ( is there a LOCK prefix? )
        inst-prefix data-@ 0f0 = dup ?clr-opstack
        abort" LOCK prefix not allowed with this instruction" ;
' _?lock is ?lock

: _?rep ( is there a repeat prefix? )
        inst-prefix data-@ 0f3 over = 0f2 rot = or dup ?clr-opstack
        abort" REP, etc. not allowed with this instruction" ;
' _?rep is ?rep

: _?inst-pre ( is there any instruction prefix? )
        inst-prefix data-@ dup ?clr-opstack
        abort" Instruction prefixes not allowed with this instruction" ;
' _?inst-pre is ?inst-pre

: _?operands ( are there any operands? )
        op-depth dup ?clr-opstack
        abort" operands not allowed with this instruction" ;
' _?operands is ?operands

: _?opsize1 ( is the operand size mismatched? )
        ( n -- )
        ?dup if dt-size data-@ ?dup if - dup ?clr-opstack
        abort" operand size mismatched" else dt-size data-! then then ;
: _?opsize2 ( just store the operand size )
        ( n -- )
        ?dup if dt-size data-! then ;
' _?opsize1 is ?opsize

: _?adsize1 ( is the address size mismatched? )
        ( n -- )
        ?dup if ad-size data-@ ?dup if - dup ?clr-opstack
        abort" address size mismatched" else ad-size data-! then then ;
: _?adsize2 ( just store the address size )
        ( n -- )
        ?dup if ad-size data-! then ;
' _?adsize1 is ?adsize

: _?short ( is the address short? )
        ( -- )
        ad-size data-@ 8bit = dup ?clr-opstack
        abort" SHORT not allowed with this instruction" ;
' _?short is ?short

: ?noshort ( do we have an illegal short? )
        ( -- )
        is-short? if 8bit ad-size data-! ?short then ;

: _?toofar ( is the branch offset to far? )
        ( flag -- )
        dup ?clr-opstack
        abort" branch offset too big to fit specified width" ;
' _?toofar is ?toofar

: _?unres ( are there any unresolved forward reference labels? )
        ( -- )
        frtable frmax 0 do dup data-@ dup ?clr-opstack
        abort" unresolved forward reference" cell+ cell+ loop drop ;
' _?unres is ?unres

: _?noadsize ( no or unknown address size )
        ( -- )
        clr-opstack -1
        abort" no or unknown address size" ;
' _?noadsize is ?noadsize

: _?toomanyops ( are there too many operands? )
        ( max allowed operands -- )
        op-depth < dup ?clr-opstack
        abort" too many operands" ;
' _?toomanyops is ?toomanyops

: _?nofar ( is there an unallowed far reference? )
        ( -- )
        ad-size data-@ 32bit = dup ?clr-opstack
        abort" FAR references not allowed with this instruction" ;
' _?nofar is ?nofar

: <_?match> ( the error action for ?match and ?nomatch )
        ( flag -- )
        dup ?clr-opstack
        abort" operand mismatch" ;

: _?match ( error if the parameters match )
        ( x1 \ x2 -- )
        = <_?match> ;
' _?match is ?match

: _?nomatch ( error if the parameters don't match )
        ( x1 \ x2 -- )
        - <_?match> ;
' _?nomatch is ?nomatch

: _?finished ( are there operands left? )
        ( -- )
        op-depth dup ?clr-opstack
        abort" unconsumed operands" ;
' _?finished is ?finished

: _?badtype ( is the operand type allowed? )
        ( max type allowed -- )
        maxtype data-@ < dup ?clr-opstack
        abort" addressing mode not allowed" ;
' _?badtype is ?badtype

: _?badcombine ( can the operand types be combined? )
        ( flag -- )
        dup ?clr-opstack
        abort" illegal operand combination" ;
' _?badcombine is ?badcombine

: _?notenough ( are there not enough operands? )
        ( n -- )
        op-depth > dup ?clr-opstack
        abort" not enough operands" ;
' _?notenough is ?notenough

: _?noimmed ( is there an illegal immediate operand? )
        ( -- ) has-immed? dup ?clr-opstack
        abort" immediate operands not allowed with this instruction" ;
' _?noimmed is ?noimmed

: _?badmode ( is the address mode illegal? )
        ( flag -- )
        dup ?clr-opstack
        abort" illegal address mode" ;
' _?badmode is ?badmode

: _?reg,r/m ( is the destination a register? )
        ( -- )
        direction? 0= mod-r/m data-@ 0c0 < and dup ?clr-opstack
        abort" destination must be a register" ;
' _?reg,r/m is ?reg,r/m

: _?r/m,reg ( is the source a register? )
        ( -- )
        direction? mod-r/m data-@ 0c0 < and dup ?clr-opstack
        abort" source must be a register" ;
' _?r/m,reg is ?r/m,reg

: _?mem ( is one of the operands in memory? )
        ( -- )
        mod-r/m data-@ 0bf > maybe-has-offset? 0= and dup ?clr-opstack
        abort" instruction requires a memory operand" ;
' _?mem is ?mem

: _?reg ( are all of the operands register? )
        ( -- )
        mod-r/m data-@ 0c0 < has-offset? or dup ?clr-opstack
        abort" this instruction may only use registers" ;
' _?reg is ?reg

: ?mem,reg ( is the instruction coded as memory,register? )
        ( -- )
        ?r/m,reg ?mem ;

: ?reg,mem ( is the instruction coded as register,memory? )
        ( -- )
        ?reg,r/m ?mem ;

: ?regexclus ( is the addressing mode exclusive? )
        ( -- )
        rtype data-@ 0 ?nomatch ;

in-asm
: report-errors ( turn on error reporting )
        [']     _?params is     ?params
        [']        _?seg is        ?seg
        [']       _?lock is       ?lock
        [']        _?rep is        ?rep
        [']   _?inst-pre is   ?inst-pre
        [']   _?operands is   ?operands
        [']    _?opsize1 is     ?opsize
        [']    _?adsize1 is     ?adsize
        [']      _?short is      ?short
        [']     _?toofar is     ?toofar
        [']      _?unres is      ?unres
        [']   _?noadsize is   ?noadsize
        ['] _?toomanyops is ?toomanyops
        [']      _?nofar is      ?nofar
        [']      _?match is      ?match
        [']    _?nomatch is    ?nomatch
        [']   _?finished is   ?finished
        [']    _?badtype is    ?badtype
        ['] _?badcombine is ?badcombine
        [']  _?notenough is  ?notenough
        [']    _?noimmed is    ?noimmed
        [']    _?badmode is    ?badmode
        [']    _?reg,r/m is    ?reg,r/m
        [']    _?r/m,reg is    ?r/m,reg
        [']        _?mem is        ?mem
        [']        _?reg is        ?reg ;

: no-errors ( turn off error reporting )
        [']      noop is     ?params
        [']      noop is        ?seg
        [']      noop is       ?lock
        [']      noop is        ?rep
        [']      noop is   ?inst-pre
        [']      noop is   ?operands
        ['] _?opsize2 is     ?opsize
        ['] _?adsize2 is     ?adsize
        [']      noop is      ?short
        [']      drop is     ?toofar
        [']      noop is      ?unres
        [']      noop is   ?noadsize
        [']      drop is ?toomanyops
        [']      noop is      ?nofar
        [']     2drop is      ?match
        [']     2drop is    ?nomatch
        [']      noop is   ?finished
        [']      drop is    ?badtype
        [']      drop is ?badcombine
        [']      drop is  ?notenough
        [']      noop is    ?noimmed
        [']      drop is    ?badmode
        [']      noop is    ?reg,r/m
        [']      noop is    ?r/m,reg
        [']      noop is        ?mem
        [']      noop is        ?reg ;

( generate prefix sequences )
in-hidden
: inst, ( generate a necessary instruction prefix )
        ( -- )
        inst-prefix data-@ ?dup if code-c, 0 inst-prefix data-! then ;
: addr, ( generate a necessary address size prefix )
        ( -- )
        addr-prefix data-@   if 67 code-c, 0 addr-prefix data-! then ;
: data, ( generate a necessary data size prefix )
        ( -- )
        data-prefix data-@   if 66 code-c, 0 data-prefix data-! then ;
: seg, ( generate a necessary segment override prefix )
        ( -- )
        seg-prefix data-@ ?dup if code-c, 0  seg-prefix data-! then ;

: generate-prefixes ( generate necessary prefixes )
        ( -- )
        inst, addr, data, seg, ;

( the prefixes )
: seg-pre create data-, does> data-@ seg-prefix data-! ;
: inst-pre create data-, does> data-@ inst-prefix data-! ;
in-asm
 2e  seg-pre   cs:
 36  seg-pre   ss:
 3e  seg-pre   ds:
 26  seg-pre   es:
 64  seg-pre   fs:
 65  seg-pre   gs:
0f3 inst-pre   rep
0f3 inst-pre  repe
0f3 inst-pre  repz
0f2 inst-pre repne
0f2 inst-pre repnz
0f0 inst-pre  lock

( save the p-stack depth )
in-hidden
: save-depth ( -- )
        sp@ sp-save data-! ;
: depth-change ( report on a change of depth )
        sp@ sp-save data-@ swap - cell/ ;

( create an assembly mnemonic )
: compile-opcode ( compile the bytes in an opcode )
        ( 0 -- | a -- | x \ a -- | x \ x' \ a -- )
        ( os: x ... -- )
        ( a is the address of a two cell data structure: )
        ( offset 0 -- xt of the actual routine to compile the code )
        ( offset 1 -- parameter used to generate the code )
        ?dup if
                dup cell+ data-@ swap data-@ register-asm execute
        then ;

defer save-inst ( save the current instruction -- used in postfix mode )
: _save-inst ( save the current instruction, and fetch the previous one )
        ( also swaps instruction prefixes )
        ( a -- a' )
        inst-save dup data-@ >r data-! r> inst-prefix sv-inst-prefix
        2dup data-@ swap data-@ rot data-! swap data-! ;
' _save-inst is save-inst

in-asm
: postfix ['] _save-inst is save-inst ;
: prefix ['] noop is save-inst ;

in-hidden
: _do-opcode ( create the actual opcode, or at least call the functions )
        ( that do ... )
        ( x? \ x? \ 0|addr -- )
        save-inst compile-opcode reset-for-next-instr save-depth ;
' _do-opcode is do-opcode

: opcode ( c:: parameter \ xt -- )
        ( r:: -- | x -- | x \ x' -- )
        ( r::os: x ... -- )
        create data-, data-, does> do-opcode ;

( support routines for creating assembly code )
: all-except ( process all operands except one in particular )
        ( x \ n -- type \ mod-r/m {x!=n} | -- 0 \ 0 )
        over = if drop 0 0 else <dec-reg> >r >r ?adsize ?opsize r> r> then ;

: offset8, ( create an 8 bit code-here relative offset )
        ( addr -- )
        8b-rel register-ref code-here 1+ - dup abs 7f > ?toofar code-c, ;
: offset16, ( create a 16 bit code-here relative offset )
        ( addr -- )
        16b-rel register-ref code-here 2+ - dup abs 7fff > ?toofar code-w, ;
: offset32, ( create a 32 bit code-here relative offset )
        ( addr -- )
        32b-rel register-ref code-here 4+ - code-d, ;
: offset16/32, ( create a 16 or 32 bit code-here relative offset )
        ( addr \ 16bit? -- )
        if offset16, else offset32, then ;

: flag-for-size-prefix ( do we need a size prefix? )
        ( size -- flag )
        dup if dup 8bit - if default-size - else drop 0 then then ;
: check-ad-size ( check the address size )
        ( -- )
        ad-size data-@ flag-for-size-prefix addr-prefix data-! ;
: check-dt-size ( check the operand size )
        ( -- )
        dt-size data-@ flag-for-size-prefix data-prefix data-! ;
: check-sizes ( check the address and operand sizes )
        ( -- )
        check-ad-size check-dt-size ;
: rtype! ( store the addressing mode type and update maxtype )
        ( type -- )
        dup rtype data-! maxtype data-@ over < if maxtype data-! else
        drop then ;
: special-process? ( do we need to specially process this register? )
        ( -- flag )
        maxtype data-@ dup register > swap freg < and ;
: special-register? ( is this a special register? )
        ( -- flag )
        rtype data-@ dup register > swap freg < and ;
: do-reg ( do any register addressing mode translation )
        ( reg \ type -- )
        ?regexclus rtype! do-1op-exed? if
                has-mod-r/m? if
                        mod-r/m data-@ swap special-process? if
                                special-register? if
                                        8*+ reg,r/m
                                else
                                        maxtype data-@ sreg = if
                                                c0+ swap c0-8* +
                                        else
                                                c0+ +
                                        then r/m,reg
                                then
                        else
                                8*+ reg,r/m
                        then
                else    ( *MUST* be reg,disp or reg,immed )
                        c0+ reg,r/m has-mod-r/m has-immed? 0= if
                                has-offset
                        then
                then
        else    ( first time through do-1op )
                special-register? rtype data-@ sreg <> and if
                        8*
                else    ( either a general or segment register )
                        c0+
                then has-mod-r/m r/m,reg
        then mod-r/m data-! ;
: do-immed ( do an immediate addressing mode operand )
        ( x \ 0 -- )
        drop immed-sv data-! has-immed immediate rtype! ;
: do-indire ( do an indirect addressing mode operand )
        ( reg -- )
        has-mod-r/m? if
                mod-r/m data-@ dup 0bf > if
                        c0-8* +
                else
                        +
                then
        else
                has-mod-r/m
        then mod-r/m data-! has-base ;
: do-index ( do a scaled index addressing mode )
        ( reg -- )
        has-s-i-b 8* s-i-b data-@ 8/ + s-i-b data-! has-mod-r/m? if
                mod-r/m data-@ dup 0bf > if
                        c0-8* 4+
                else
                        [ 7 -1 xor ] literal and 4+
                then
        else
                4 has-mod-r/m
        then mod-r/m data-! ;
: do-based ( do a base register addressing mode )
        ( reg -- )
        has-mod-r/m? if
                mod-r/m data-@ dup 0bf > if
                        c0-8* over 8* s-i-b data-! +
                else
                        maybe-s-i-b? if
                                has-s-i-b s-i-b rot over data-@ + swap
                                data-! [ 7 -1 xor ] literal and 4+
                        else
                                over 8* s-i-b data-! +
                        then
                then
        else
                dup 8*  s-i-b data-! has-mod-r/m
        then mod-r/m data-! has-base ;

: operand-cases ( process an operand based on its type )
        ( reg \ type -- | x \ reg \ type -- )
        case unknown of
                drop
        endof immediate of
                do-immed
        endof indirect of
                ?regexclus indirect rtype! do-indire
        endof index of
                rtype data-@ ?dup if based ?nomatch then index rtype! do-index
        endof based of
                rtype data-@ ?dup if based over = index rot = or 0= ?badcombine
                then based rtype! do-based
        endof ( must be a register type ) do-reg dup ( so endcase has )
        ( something to discard ) endcase ;
: save-offset ( save the offset, if it's present )
        ( x -- | -- )
        depth-change if maybe-has-offset ?dup if offset-sv data-! has-offset
        then then ;
: do-1op ( process a single operand )
        ( -- | x -- | x \ x' -- )
        0 rtype data-! begin op-depth if pop-op else false then ?dup while
        0 all-except swap operand-cases repeat save-offset do-1op-exed ;
: lit-op ( instert the literal value of an operand into code )
        ( C:: -- )
        ( R:: -- x )
        ' >body data-@ postpone literal ; also forth immediate in-hidden
: parse-call/jmp-operands ( parse the operands for calls and jumps )
        ( -- | x -- )
        0 rtype data-! begin op-depth while pop-op dup lit-op short = over
        lit-op near = or over lit-op far = or if case lit-op short of
        is-short endof lit-op near of is-near endof is-far endcase else
        0 all-except swap operand-cases then repeat ?noimmed save-offset ;
: do-2ops ( do two operands and set size prefixes )
        ( -- | x -- | x \ x -- )
        do-1op do-1op check-sizes ;
: install-/r ( install the /r field in a mod-r/m byte )
        ( /r value -- )
        8* mod-r/m data-@ [ 7 8* -1 xor ] literal and or mod-r/m data-! ;

: disp, ( compile the displacement )
        ( -- )
        has-offset? if offset-sv data-@ dup abs 7f > has-full-off? or
        if ad-size data-@ 16bit = if 16b-abs register-ref code-w, else 32b-abs
        register-ref code-d, then else 8b-abs register-ref code-c, then then ;

: default-8bit ( change a zero size to 8bit )
        ( size -- size' )
        ?dup 0= if 8bit then ;
: >default-size ( change a zero size to the default size )
        ( size -- size' )
        ?dup 0= if default-size then ;
: get-dt-size ( get the current data size, default is 8 bit )
        ( -- data size )
        dt-size data-@ default-8bit ;
: get-ad-size ( get the current address size, default is default-size )
        ( -- address size )
        ad-size data-@ >default-size ;
: get-fp-size ( get the size of fp operand, default is default-size )
        dt-size data-@ >default-size ;

: immed, ( compile the immediate operand )
        ( -- )
        has-immed? if
            immed-sv data-@ get-dt-size case
                8bit  of  8b-abs register-ref code-c, endof
                16bit of 16b-abs register-ref code-w, endof
                32bit of 32b-abs register-ref code-d, endof
                ?noadsize drop
            endcase
        then ;

: 8bit? ( is the operation 8 bits wide? )
        ( -- flag )
        get-dt-size 8bit = ;
: a16bit? ( is the address size 16 bits? )
        ( -- flag )
        get-ad-size 16bit = ;
: a32bit? ( is the address size 32 bits? )
        ( -- flag )
        get-ad-size 32bit = ;

: s-i-b, ( compile the s-i-b byte )
        ( -- )
        has-s-i-b? a32bit? and if s-i-b data-@ code-c, then ;

: +size-bit ( adjust an opcode for the size of the operation )
        ( op-code -- op-code' )
        8bit? 0= if 1+ then ;
: +direct-bit ( adjust an opcode for the direction of the operands )
        ( op-code -- op-code' )
        direction? if 2+ then ;

: match-r/m? ( does the value match the r/m field of the mod-r/m? )
        ( value -- flag )
        mod-r/m data-@ 7 and = ;
: pure-reg? ( is the mod field of the mod-r/m = 3? )
        ( -- flag )
        mod-r/m data-@ 0bf > ;
: displacement? ( does the address mode have a pure displacement? )
        ( -- flag )
        has-mod-r/m? if pure-reg? maybe-has-offset? and else true then ;
: [(e)bp]? ( does the address mode have either [bp] or [ebp] alone? )
        ( -- flag )
        a16bit? 6 match-r/m? and a32bit? 5 match-r/m? and or mod-r/m
        data-@ 40 < and ;
: [reg*n]? ( does it have only an index register? )
        ( -- flag )
        has-s-i-b? has-base? 0= and ;
: [esp][reg]? ( does it have esp as an index register? )
        ( -- flag )
        s-i-b data-@ 8/ 4 = ;
: [esp]? ( does it have only a base of esp? )
        ( -- flag )
        a32bit? has-base? has-s-i-b? 0= 4 match-r/m? and and and ;

: do-[(e)bp] ( do a naked [bp] or [ebp] )
        ( -- )
        [(e)bp]? if has-offset then ;
: do-disp ( process a displacement )
        ( -- )
        mod-r/m data-@ dup 0bf > if c0-8* then 5 + a16bit? if 1+ then
        code-c, has-full-off ;
: do-[reg*n] ( process a naked index )
        ( -- )
        [reg*n]? if has-full-off 5 s-i-b data-+! -80 mod-r/m data-+! then ;
: do-[esp][reg] ( swap index and base registers in s-i-b )
        ( -- )
        [esp][reg]? if s-i-b data-@ 7 and 8* 4+ s-i-b data-! then ;
: do-[esp] ( do [esp] only )
        ( -- )
        [esp]? if 24 s-i-b data-! has-s-i-b then ;
: mod-r/m, ( compile the mod-r/m field )
        ( -- )
        displacement? if do-disp else do-[(e)bp] do-[esp][reg] do-[reg*n]
        do-[esp] mod-r/m data-@ has-offset? if offset-sv data-@ abs
        7f > has-full-off? or if 80 else 40 then + then code-c, then ;
: compile-fields ( compile the mod-r/m, s-i-b, displacement, and immed fields )
        ( -- )
        mod-r/m, s-i-b, disp, immed, ;
: generic-entry2 ( generic entry sequence for two operand instructions )
        ( param \ max type -- )
        ( | x \ param \ max type -- )
        ( | x \ x' \ param \ max type -- )
        2>r do-2ops ?finished 2r> ?badtype generate-prefixes ;
: +fp-size ( add 4 if the operation size is 64bit: ie., default float )
        ( n -- n' )
        dt-size data-@ 64bit = if 4+ then ;
: /r&freg>mod-r/m ( turn /r and fp reg into the rqd mod-r/m )
        ( /r \ freg -- mod-r/m )
        swap 8*+ c0+ ;
: swap-regs ( swap the order of registers in the mod-r/m byte )
        ( -- )
        mod-r/m data-@ dup 0bf > if 3f and 8 /mod /r&freg>mod-r/m then mod-r/m
        data-! ;
: parse-fp-ops ( parse floating point instruction operands )
        ( -- n | x -- n )
        depth-change 0<> op-depth 0<> or if do-1op op-depth if do-1op 2 else
        1 then else 0 then ?noimmed ?finished check-sizes ;
: mod-r/m>freg ( convert mod-r/m byte into an fp register number )
        ( -- n )
        mod-r/m data-@ c0- dup 7 > if 8/ then ;
: fp-direction? ( which direction is the floating point data going? )
        ( -- flag )
        mod-r/m data-@ 0c7 > ;
: +fp-direct-bit ( add 4, depending on the direction of the operands )
        ( x -- x' )
        fp-direction? if 4+ then ;
: fp-generic-assemble ( generic assembly of floating point instructions )
        ( opcode \ /r field -- )
        install-/r addr, seg, code-c, compile-fields ;
: save-immed ( save immediate operands for double-shift )
        ( x \ param -- param )
        swap immed-sv data-! has-immed ;
: next-is-, ( make sure the next operand is a comma )
        ( -- )
        pop-op lit-op , - ?badmode ;

( The assembly engine words -- actually do the assembly )
( simple assembly instructions -- no-brainers )
: 1byte ( compile a single byte, no operand, no override opcode )
        ( param -- )
        >r ?params r> ?seg ?inst-pre ?operands code-c, ;
: 2byte ( compile a two byte, no operand, no override opcode )
        ( param -- )
        >r ?params r> ?seg ?inst-pre ?operands code-w, ;
: 3byte ( compile a three byte, no operand, no override opcode )
        ( param -- )
        >r ?params r> ?seg ?inst-pre ?operands 10000 /mod swap code-w,
        code-c, ;
: size-cond-comp ( compile a size conditional assembly sequence )
        ( param -- )
        >r ?params r> ?seg ?inst-pre ?operands 100 /mod default-size - if
        66 code-c, then code-c, ;

( string instructions )
: str-entry ( check for entry error conditions )
        ( param -- param )
        >r ?params r> ?lock seg-prefix data-@ ?dup if 3e over - 0<>
        26 rot - 0<> and if ?seg then 0 seg-prefix data-! then ;
: str-operands ( process operands for string instructions )
        ( -- )
        begin op-depth while pop-op lit-op dx all-except 2drop repeat ;
: str-inst ( the engine to create string instructions )
        ( param -- )
        str-entry str-operands ?short check-sizes
        dt-size data-@ dup 0= 8bit rot = or 0= if 1+ then
        generate-prefixes code-c, ;
: byte-str-inst ( byte string instructions )
        ( param -- )
        byte str-inst ;
: word-str-inst ( word string instructions )
        ( param -- )
        word str-inst ;
: dword-str-inst ( dword string instructions )
        ( param -- )
        dword str-inst ;

( conditional branch instructions )
: jcc-entry ( the entry sequence for conditional branch instructions )
        ( -- )
        ?seg ?inst-pre 1 ?toomanyops op-depth if pop-op 0 all-except
        2drop ?nofar ad-size data-@ 16bit = if default-size ad-size data-!
        then dt-size data-@ ?dup if ad-size data-! then then ;
: jcc-8bit ( compile an 8 bit conditional branch )
        ( addr \ param -- )
        code-c, offset8, ;
: jcc-16/32bit ( compile a 16 or 32bit conditional branch )
        ( addr \ param \ size -- )
        dup >r flag-for-size-prefix if 67 ( address size prefix ) code-c,
        then 0f code-c, 10 + code-c, r> 16bit = offset16/32, ;
: jcc-unknown ( compile a conditional branch with an unknown size )
        ( addr \ param -- )
        over code-here = if ( unresolved forward reference )
                default-size jcc-16/32bit
        else
                over code-here 2+ swap - abs 7f > if ( can't be SHORT )
                        default-size jcc-16/32bit
                else                              ( it can be SHORT )
                        jcc-8bit
                then
        then ;
: jcc-compile ( compile a conditional branch )
        ( addr \ param -- )
        jcc-entry ad-size data-@ case
                unknown of       jcc-unknown  endof
                   8bit of       jcc-8bit     endof
                  16bit of 16bit jcc-16/32bit endof
                  32bit of 32bit jcc-16/32bit endof
                ?noadsize 2drop endcase ;

( loop instructions )
: loop-entry ( the entry sequence for loop instructions )
        ( -- )
        ?seg ?inst-pre 2 ?toomanyops op-depth if pop-op ?dup 0= if pop-op
        then 0 all-except op-depth if pop-op drop then 1 ?nomatch
        register ?nomatch dt-size data-@ dup 8bit ?match else default-size
        then ad-size data-! ;
: loop-compile ( compile a loop instruction )
        ( address \ param -- )
        loop-entry ad-size data-@ flag-for-size-prefix if 67 code-c, then
        jcc-8bit ;

( jcxz/jecxz )
: jcxz-compile ( compile jcxz )
        ( address \ param -- )
        cx loop-compile ;
: jecxz-compile ( compile jecxz )
        ( address \ param -- )
        ecx loop-compile ;

( group 1 instructions -- ADD, etc. )
: group1-compile ( compile group 1 instructions )
        ( param -- | x \ param -- | x \ x \ param -- )
        ?rep register generic-entry2 has-immed? if 80 +size-bit immed-sv
        data-@ 80 over > -81 rot < and get-dt-size 8bit <> and if 2+ 8bit
        dt-size data-! then swap install-/r else 8* +size-bit +direct-bit
        then generate-prefixes code-c, compile-fields ;

( group 2 instructions -- RCL, etc. )
: group2-compile ( compile group 2 instructions )
        ( param -- | x \ param -- | x \ x \ param -- )
        ?inst-pre 1 ?notenough >r pop-op case
                lit-op  , of 0 save-immed drop           endof
                lit-op  # of 0 save-immed drop next-is-, endof
                lit-op cl of                   next-is-, endof
                        dup push-op 1 0 save-immed drop
        endcase do-1op check-sizes register ?badtype has-immed? if 0c0
        else 0d2 then +size-bit generate-prefixes code-c, r> install-/r
        mod-r/m, s-i-b, disp, 8bit dt-size data-! immed, ;

( group 3 instructions -- DIV, etc. )
: group3-compile ( compile group 3 instructions )
        ( param -- | x \ param -- )
        ?rep >r do-1op begin op-depth while pop-op 0 all-except 2drop repeat
        ?noimmed register ?badtype check-sizes generate-prefixes r> install-/r
        0f6 +size-bit code-c, compile-fields ;
: test-compile ( compile the test instruction, which is a special group3 ins )
        ( param -- | x \ param -- | x \ x' \ param -- )
        ?inst-pre register generic-entry2 drop has-immed? if 0f6 0 install-/r
        else 84 then +size-bit code-c, compile-fields ;

( INC and DEC )
: inc-dec-compile ( compile an INC or DEC )
        ( param -- | x \ param -- )
        ?rep >r do-1op r> check-sizes ?finished register ?badtype
        generate-prefixes 0fe +size-bit code-c, install-/r compile-fields ;

( group 6 and 7 instructions -- SLDT, SGDT, etc. )
: group6&7-compile ( compile a group 6 or 7 instruction )
        ( param -- | x \ param -- )
        ?inst-pre >r do-1op r> ?finished dup 100 > over 0ff and 4 <> and
        if ?mem then check-sizes addr, seg, 0f code-c, 100 /mod code-c,
        install-/r compile-fields ;

( group 8 instructions -- BT, etc. )
: group8-compile ( compile a group 8 instruction )
        ( param -- | x \ param -- | x \ x' \ param -- )
        ?rep register generic-entry2 0f code-c, has-immed? if install-/r ba
        else 8* 83 + ?r/m,reg then code-c, mod-r/m, s-i-b, disp, 8bit dt-size
        data-! immed, ;

( enter )
: enter-compile ( compile the enter instruction )
        ( x \ x' \ param -- )
        3 ?toomanyops ?inst-pre ?seg clr-opstack drop 0c8 code-c, swap
        code-w, code-c, ;

( arpl )
: arpl-compile ( compile the arpl instruction )
        ( param -- | x \ param -- )
        ?inst-pre drop do-2ops ?finished register ?badtype ?r/m,reg ?noimmed
        addr, seg, 63 code-c, swap-regs compile-fields ;

( echange & alu instructions -- CMPXCHG, XADD )
: xchg&alu-compile ( compile CMPXCHG or XADD )
        ( param -- | x \ param -- )
        ?rep register generic-entry2 ?r/m,reg ?noimmed 0f code-c, +size-bit
        code-c, swap-regs compile-fields ;

( cmpxchg8b -- pentium instruction set )
: cmpxchg8b-comp ( assemble CMPXCHG8B )
        ( param -- )
        ?rep drop ?params do-1op check-ad-size dt-size data-@ ?dup if 64bit <>
        ?badmode then ?mem ?noimmed generate-prefixes 0c70f code-w,
        compile-fields ;

( bound checking )
: bound-compile ( compile the bound instruction )
        ( param -- | x \ param -- )
        ?inst-pre register generic-entry2 ?reg,mem ?noimmed drop 62 code-c,
        compile-fields ;

( BSWAP )
: bswap-compile ( compile BSWAP )
        ( param -- )
        ?inst-pre ?seg drop ?params 1 ?toomanyops pop-op 0 all-except swap
        register ?nomatch 0f code-c, 0c8 + code-c, ;

( PUSH and POP )
: push/pop-entry ( entry sequence for push and pop compilers )
        ( param -- )
        ?inst-pre drop do-1op ?finished sreg ?badtype check-sizes
        sreg maxtype data-@ - if generate-prefixes then maxtype data-@ ;

: push-compile ( compile PUSH )
        ( param -- | x \ param -- )
        push/pop-entry case
                unknown of a16bit? if 6 else 5 then mod-r/m data-! 6
                        install-/r 0ff code-c, mod-r/m data-@ code-c,
                        has-full-off disp,
                endof register of mod-r/m data-@ [ 50 c0- ] literal +
                        code-c,
                endof sreg of mod-r/m data-@ c0-8* 6 + dup 1e > if 0f code-c,
                        [ 0a0 26 - ] literal + then code-c,
                endof immediate of immed-sv data-@ abs 7f > if 68 get-fp-size
                        dt-size data-! else 6a 8bit dt-size data-! then
                        code-c, immed,
                endof 0ff code-c, 6 install-/r compile-fields
        endcase ;

: pop-compile ( compile POP )
        ( param -- | x \ param -- )
        push/pop-entry ?noimmed case
                unknown of a16bit? if 6 else 5 then mod-r/m data-! 0
                        install-/r 8f code-c, mod-r/m data-@ code-c,
                        has-full-off disp,
                endof register of mod-r/m data-@ [ 58 c0- ] literal +
                        code-c,
                endof sreg of mod-r/m data-@ c0-8* 7 + dup 1f > if 0f code-c,
                        [ 0a1 27 - ] literal + then code-c,
                endof 8f code-c, 0 install-/r compile-fields
        endcase ;

( CALL and JMP )
: call/jmp-entry ( entry for call and jump )
        ( param -- )
        drop ?inst-pre parse-call/jmp-operands register ?badtype check-sizes ;
: call-compile ( compile CALL )
        ( param -- | x \ param -- )
        call/jmp-entry ?noshort generate-prefixes is-near? if has-mod-r/m?
        if 0ff code-c, 2 install-/r compile-fields else 0e8 code-c, offset-sv
        data-@ a16bit? offset16/32, then else has-mod-r/m? if 0ff code-c, 3
        install-/r compile-fields else 9a code-c, offset-sv data-@ a16bit?
        if code-w, else code-d, then code-w, then then ;
: jmp-compile ( compile JMP )
        ( param -- | x \ param -- )
        call/jmp-entry generate-prefixes is-short? if offset-sv data-@ 0eb
        code-c, offset8, else is-near? if has-mod-r/m? if 0ff code-c, 4
        install-/r compile-fields else 0e9 code-c, offset-sv data-@ a16bit?
        offset16/32, then else has-mod-r/m? if 0ff code-c, 5 install-/r
        compile-fields else 0ea code-c, offset-sv data-@ a16bit? if code-w,
        else code-d, then code-w, then then then ;

( i/o instructions )
: i/o-compile ( compile an IN or OUT )
        ( param -- | x \ param -- )
        ?inst-pre ?seg 3 ?toomanyops >r depth-change if immed-sv data-!
        has-immed then r> begin op-depth while pop-op case
                lit-op     , of ( discard it ) endof
                lit-op    dx of ( discard it ) endof
                lit-op     # of ( discard it ) endof
                lit-op    al of  8bit ?opsize  endof
                lit-op  byte of  8bit ?opsize  endof
                lit-op    ax of 16bit ?opsize  endof
                lit-op  word of 16bit ?opsize  endof
                lit-op   eax of 32bit ?opsize  endof
                lit-op dword of 32bit ?opsize  endof
                -1 ?badmode
        endcase repeat check-dt-size data, +size-bit has-immed?
        if code-c, immed-sv data-@ code-c, else 8+ code-c, then ;

( bit scan instructions )
: bs-compile ( compile a bit scan instruction, and also selector validation )
        ( param -- | x \ param -- )
        ?inst-pre register generic-entry2 ?noimmed ?reg,r/m 0f code-c, code-c,
        compile-fields ;

( mov instruction )
: mov-compile ( compile a mov instruction )
        ( param -- | x \ param -- | x \ x' \ param -- )
        ?rep treg generic-entry2 drop has-immed? if 0c6 +size-bit else
        maxtype data-@ case
                register of                 88 +size-bit endof
                sreg     of                 8c           endof
                creg     of ?reg 0f code-c, 20           endof
                dreg     of ?reg 0f code-c, 21           endof
                treg     of ?reg 0f code-c, 24           endof
                -1 ?badmode 0
        endcase +direct-bit then code-c, compile-fields ;

( xchg instruction )
: xchg-compile ( compile the XCHG instruction )
        ( param -- | x \ param -- )
        ?rep register generic-entry2 ?noimmed +size-bit code-c,
        compile-fields ;

( ret instruction )
: retf? ( adjust opcode for far return )
        ( x -- x' )
        is-far? if 8+ then ;
: ret-compile ( compile the RET instruction )
        ( param -- | x \ param -- )
        ?inst-pre 2 ?toomanyops drop depth-change if immed-sv data-! has-immed
        then begin op-depth while pop-op case
                lit-op near of is-near endof
                lit-op  far of  is-far endof
                lit-op    # of         endof
                        -1 ?badmode
        endcase repeat has-immed? if 0c2 retf? code-c, immed-sv data-@ code-w,
        else 0c3 retf? code-c, then ;

: retf-compile ( compile RETF )
        ( param -- | x \ param -- )
        far ret-compile ;

( int instruction )
: int-compile ( compile the INT instruction )
        ( x \ param -- )
        ?inst-pre drop 0 ?toomanyops depth-change 0= if 2 ?notenough then
        dup 3 = if drop 0cc else 0cd code-c, then code-c, ;

( setcc instructions )
: setcc-compile ( compile SETcc instructions )
        ( param -- | x \ param -- )
        ?inst-pre >r do-1op ?finished ?noimmed register ?badtype check-sizes
        generate-prefixes 0f code-c, r> code-c, compile-fields ;

( xlat/xlatb )
: xlat-compile ( compile XLAT )
        ( param -- )
        ?inst-pre drop ?params 3 ?toomanyops begin op-depth while pop-op case
                lit-op    al of               endof
                lit-op  [bx] of 16bit ?opsize endof
                lit-op [ebx] of 32bit ?opsize endof
                        -1 ?badmode
        endcase repeat check-sizes generate-prefixes 0d7 code-c, ;

: xlatb-compile ( compile XLATB )
        ( param -- )
        ?seg ?operands default-size 16bit = if [bx] else [ebx] then
        xlat-compile ;

( double precision shift instructions )
: double-shift ( compile SHLD, SHRD )
        ( param -- | x \ param -- | x \ x' \ param -- )
        ?inst-pre pop-op case lit-op , of save-immed endof lit-op # of
        save-immed next-is-, endof lit-op cl of 1+ next-is-, endof -1
        ?badmode endcase register generic-entry2 0f code-c, code-c, mod-r/m,
        s-i-b, disp, 8bit dt-size data-! immed, ;

( pointer loading instructions )
: load-ptr-comp ( compile a pointer load instruction )
        ( param -- | x \ param -- )
        ?inst-pre register generic-entry2 ?noimmed ?reg,r/m ?mem dup 100 >
        if code-w, else code-c, then compile-fields ;

( extended mov instructions )
: movx-compile ( compile MOVSX/MOVZX )
        ( param -- | x \ param -- )
        ?inst-pre >r do-1op r> +size-bit 0 dt-size data-! >r do-1op r>
        ?finished ?noimmed ?reg,r/m check-sizes generate-prefixes 0f code-c,
        code-c, compile-fields ;

( fadd & fmul )
: fad/fmul-compile ( compile FADD and FMUL )
        ( param -- | x \ param -- )
        ?inst-pre >r parse-fp-ops r> swap case
                0 of 1 /r&freg>mod-r/m ?seg 0de code-c, code-c, endof
                1 of 0d8 +fp-size swap fp-generic-assemble endof
                2 of ?seg 0d8 +fp-direct-bit code-c, mod-r/m>freg
                        /r&freg>mod-r/m code-c, endof
        endcase ;

( fst & fstp )
: fst-compile ( compile FST and FSTP )
        ( param -- | x \ param -- )
        ?inst-pre >r do-1op r> ?finished ?noimmed maxtype data-@ freg = if
                ?seg 0dd code-c, mod-r/m>freg /r&freg>mod-r/m code-c,
        else
                register ?badtype ?mem check-sizes dt-size data-@
                case
                        unknown of ( float by default ) 0d9 endof
                          32bit of                      0d9 endof
                          64bit of                      0dd endof
                          80bit of 4+                   0db endof
                        -1 ?badmode 0
                endcase swap fp-generic-assemble
        then ;

( integer/floating point operations )
: fix-compile ( compile FIx instructions )
        ( param -- | x \ param -- )
        ?inst-pre >r do-1op ?finished register ?badtype ?noimmed ?mem
        check-sizes 0da dt-size data-@ 16bit = if 4+ then r>
        fp-generic-assemble ;

( float ops that pop the stack )
: fxp-compile ( compile FxP instructions )
        ( param -- )
        ?inst-pre ?seg >r parse-fp-ops 2- ?badmode r> 0de code-c,
        mod-r/m>freg + code-c, ;

( fcom )
: fcom-compile ( compile FCOM and FCOMP )
        ( param -- | x \ param -- )
        ?inst-pre >r parse-fp-ops r> swap case
                0 of 0d8 code-c, 1 /r&freg>mod-r/m code-c, endof
                1 of maxtype data-@ freg = if
                        0d8 code-c, mod-r/m>freg /r&freg>mod-r/m code-c,
                else
                        register ?badtype ?mem 0d8 +fp-size swap
                        fp-generic-assemble
                then endof
                        -1 ?badmode drop
        endcase ;

( miscellaneous floating point instructions )
: fmisc-compile ( compile miscellaneous fp instructions )
        ( param -- )
        ?inst-pre ?seg >r ?params parse-fp-ops r> 100 /mod rot case
                0 of 1+ endof
                1 of maxtype data-@ freg - ?badmode mod-r/m>freg + endof
                -1 ?badmode
        endcase swap code-c, code-c, ;

( fbld & fbstp, and load and store control word, environment, etc. )
: generic-fp-entry1 ( generic entry sequence for fp inst that take one memory )
        ( operand )
        ( param -- param | x \ param -- param )
        ?inst-pre >r parse-fp-ops 1- ?badmode r> register ?badtype ?mem ;
: fbld/stp-compile ( compile FBLD & FBSTP )
        ( param -- | x \ param -- )
        generic-fp-entry1 100 /mod dup 7 > if 8- 9b code-c, then
        fp-generic-assemble ;

( fist )
: fist-compile ( compile FIST & FISTP )
        ( param -- | x \ param -- )
        generic-fp-entry1 get-fp-size case
                16bit of    0df endof
                32bit of    0db endof
                64bit of 4+ 0df endof
                        -1 ?badmode 0
        endcase swap fp-generic-assemble ;

( fstsw )
: fstsw-compile ( compile FSTSW & FNSTSW )
        ( param -- | x \ param -- )
        ?inst-pre >r parse-fp-ops dup 1 > ?badmode register ?badtype r> if
        9b code-c, then case
                 0 of ?seg 0e0df code-w, endof
                 1 of maxtype data-@ register = if
                        mod-r/m data-@ c0- ?badmode ?seg 0e0df code-w,
                 else
                        0dd 7 fp-generic-assemble
                 then endof
        endcase ;

( fild )
: fild-compile ( compile FILD )
        ( param -- | x \ param -- )
        generic-fp-entry1 drop get-fp-size case
                 16bit of 0df 0 endof
                 32bit of 0db 0 endof
                 64bit of 0df 5 endof
                        -1 ?badmode 0 0
        endcase fp-generic-assemble ;

( fld compile )
: fld-compile ( compile FLD )
        ( param -- | x \ param -- )
        ?inst-pre drop parse-fp-ops 1- ?badmode maxtype data-@ freg = if
                ?seg 0d9 code-c, mod-r/m>freg c0+ code-c,
        else
                register ?badtype ?mem dt-size data-@ case
                        unknown of ( assume float ) 0d9 0 endof
                          32bit of                  0d9 0 endof
                          64bit of                  0dd 0 endof
                          80bit of                  0db 5 endof
                                  -1 ?badmode 0 0
                endcase fp-generic-assemble
        then ;

( fdiv, fdivr, fsub, fsubr )
: fdiv/sub-compile ( compile FDIV, FDIVR, FSUB, & FSUBR )
        ( param -- | x \ param -- )
        ?inst-pre >r parse-fp-ops r> swap case
                0 of ?seg 1 xor 0de code-c, 1 /r&freg>mod-r/m code-c, endof
                1 of ?mem 0d8 +fp-size swap fp-generic-assemble endof
                2 of ?seg maxtype data-@ freg ?nomatch 0d8 +fp-direct-bit
                        code-c, fp-direction? if 1 xor then mod-r/m>freg
                        /r&freg>mod-r/m code-c, endof
        endcase ;

( the instructions )
in-asm
     37 '            1byte opcode aaa
   0ad5 '            2byte opcode aad
   0ad4 '            2byte opcode aam
     3f '            1byte opcode aas
     02 '   group1-compile opcode adc
     00 '   group1-compile opcode add
     04 '   group1-compile opcode and
      0 '     arpl-compile opcode arpl
      0 '    bound-compile opcode bound
    0bc '       bs-compile opcode bsf
    0bd '       bs-compile opcode bsr
      0 '    bswap-compile opcode bswap
     04 '   group8-compile opcode bt
     07 '   group8-compile opcode btc
     06 '   group8-compile opcode btr
     05 '   group8-compile opcode bts
      0 '     call-compile opcode call
    298 '   size-cond-comp opcode cbw
    399 '   size-cond-comp opcode cdq
    0f8 '            1byte opcode clc
    0fc '            1byte opcode cld
    0fa '            1byte opcode cli
   060f '            2byte opcode clts
    0f5 '            1byte opcode cmc
     07 '   group1-compile opcode cmp
    0a6 '         str-inst opcode cmps
    0a6 '    byte-str-inst opcode cmpsb
    0a6 '   dword-str-inst opcode cmpsd
    0a6 '    word-str-inst opcode cmpsw
    0bc ' xchg&alu-compile opcode cmpxchg
      0 '   cmpxchg8b-comp opcode cmpxchg8b
  0a20f '            2byte opcode cpuid
    299 '   size-cond-comp opcode cwd
    398 '   size-cond-comp opcode cwde
     27 '            1byte opcode daa
     2f '            1byte opcode das
     01 '  inc-dec-compile opcode dec
     06 '   group3-compile opcode div
      0 '    enter-compile opcode enter
  0f0d9 '            2byte opcode f2xm1
  0e1d9 '            2byte opcode fabs
     00 ' fad/fmul-compile opcode fadd
    0c0 '      fxp-compile opcode faddp
    4df ' fbld/stp-compile opcode fbld
    6df ' fbld/stp-compile opcode fbstp
  0e0d9 '            2byte opcode fchs
0e2db9b '            3byte opcode fclex
     02 '     fcom-compile opcode fcom
     03 '     fcom-compile opcode fcomp
  0d9de '            2byte opcode fcompp
  0ffd9 '            2byte opcode fcos
  0f6d9 '            2byte opcode fdecstp
     06 ' fdiv/sub-compile opcode fdiv
    0f8 '      fxp-compile opcode fdivp
     07 ' fdiv/sub-compile opcode fdivr
    0f0 '      fxp-compile opcode fdivpr
  0c0dd '    fmisc-compile opcode ffree
     00 '      fix-compile opcode fiadd
     02 '      fix-compile opcode ficom
     03 '      fix-compile opcode ficomp
     06 '      fix-compile opcode fidiv
     07 '      fix-compile opcode fidivr
      0 '     fild-compile opcode fild
     01 '      fix-compile opcode fimul
  0f7d9 '            2byte opcode fincstp
0e3db9b '            3byte opcode finit
     04 '      fix-compile opcode fisub
     05 '      fix-compile opcode fisubr
     02 '     fist-compile opcode fist
     03 '     fist-compile opcode fistp
      0 '      fld-compile opcode fld
  0e8d9 '            2byte opcode fld1
    5d9 ' fbld/stp-compile opcode fldcw
    4d9 ' fbld/stp-compile opcode fldenv
  0e9d9 '            2byte opcode fldl2t
  0ead9 '            2byte opcode fldl2e
  0ebd9 '            2byte opcode fldpi
  0ecd9 '            2byte opcode fldlg2
  0edd9 '            2byte opcode fldln2
  0eed9 '            2byte opcode fldz
     01 ' fad/fmul-compile opcode fmul
    0c8 '      fxp-compile opcode fmulp
  0e2db '            2byte opcode fnclex
  0e3db '            2byte opcode fninit
  0d0d9 '            2byte opcode fnop
    6dd ' fbld/stp-compile opcode fnsave
    7d9 ' fbld/stp-compile opcode fnstcw
     00 '    fstsw-compile opcode fnstsw
    6d9 ' fbld/stp-compile opcode fnstenv
  0f3d9 '            2byte opcode fpatan
  0f8d9 '            2byte opcode fprem
  0f5d9 '            2byte opcode fprem1
  0f2d9 '            2byte opcode fptan
  0fcd9 '            2byte opcode frndint
    4dd ' fbld/stp-compile opcode frstor
   0edd ' fbld/stp-compile opcode fsave
  0fdd9 '            2byte opcode fscale
  0fed9 '            2byte opcode fsin
  0fbd9 '            2byte opcode fsincos
  0fad9 '            2byte opcode fsqrt
     02 '      fst-compile opcode fst
   0fd9 ' fbld/stp-compile opcode fstcw
   0ed9 ' fbld/stp-compile opcode fstenv
     03 '      fst-compile opcode fstp
     01 '    fstsw-compile opcode fstsw
     04 ' fdiv/sub-compile opcode fsub
    0e8 '      fxp-compile opcode fsubp
    0e0 '      fxp-compile opcode fsubpr
     05 ' fdiv/sub-compile opcode fsubr
  0e4d9 '            2byte opcode ftst
  0e0dd '    fmisc-compile opcode fucom
  0e8dd '    fmisc-compile opcode fucomp
  0e9da '            2byte opcode fucompp
     9b '            1byte opcode fwait
  0e5d9 '            2byte opcode fxam
  0c8d9 '    fmisc-compile opcode fxch
  0f4d9 '            2byte opcode fxtract
  0f1d9 '            2byte opcode fyl2x
  0f9d9 '            2byte opcode fyl2xp1
    0f4 '            1byte opcode hlt
     07 '   group3-compile opcode idiv
     05 '   group3-compile opcode imul
    0e4 '      i/o-compile opcode in
     00 '  inc-dec-compile opcode inc
     6c '         str-inst opcode ins
     6c '    byte-str-inst opcode insb
     6c '   dword-str-inst opcode insd
     6c '    word-str-inst opcode insw
      0 '      int-compile opcode int
    0c3 '            1byte opcode into
   080f '            2byte opcode invd
    107 ' group6&7-compile opcode invlpg
    2cf '   size-cond-comp opcode iret
    3cf '   size-cond-comp opcode iretd
     77 '      jcc-compile opcode ja
     73 '      jcc-compile opcode jae
     72 '      jcc-compile opcode jb
     76 '      jcc-compile opcode jbe
     72 '      jcc-compile opcode jc
    0e3 '     jcxz-compile opcode jcxz
    0e3 '    jecxz-compile opcode jecxz
     74 '      jcc-compile opcode je
     7f '      jcc-compile opcode jg
     7d '      jcc-compile opcode jge
     7c '      jcc-compile opcode jl
     7e '      jcc-compile opcode jle
      0 '      jmp-compile opcode jmp
     76 '      jcc-compile opcode jna
     72 '      jcc-compile opcode jnae
     73 '      jcc-compile opcode jnb
     77 '      jcc-compile opcode jnbe
     73 '      jcc-compile opcode jnc
     75 '      jcc-compile opcode jne
     7e '      jcc-compile opcode jng
     7c '      jcc-compile opcode jnge
     7d '      jcc-compile opcode jnl
     7f '      jcc-compile opcode jnle
     71 '      jcc-compile opcode jno
     7b '      jcc-compile opcode jnp
     79 '      jcc-compile opcode jns
     75 '      jcc-compile opcode jnz
     70 '      jcc-compile opcode jo
     7a '      jcc-compile opcode jp
     7a '      jcc-compile opcode jpe
     7b '      jcc-compile opcode jpo
     78 '      jcc-compile opcode js
     74 '      jcc-compile opcode jz
     9f '            1byte opcode lahf
     02 '       bs-compile opcode lar
    0c5 '    load-ptr-comp opcode lds
     8d '    load-ptr-comp opcode lea
    0c9 '            1byte opcode leave
    0c4 '    load-ptr-comp opcode les
  0b40f '    load-ptr-comp opcode lfs
  0b50f '    load-ptr-comp opcode lgs
     03 '       bs-compile opcode lsl
  0b20f '    load-ptr-comp opcode lss
    102 ' group6&7-compile opcode lgdt
    103 ' group6&7-compile opcode lidt
     02 ' group6&7-compile opcode lldt
    106 ' group6&7-compile opcode lmsw
    0ac '         str-inst opcode lods
    0ac '    byte-str-inst opcode lodsb
    0ac '   dword-str-inst opcode lodsd
    0ac '    word-str-inst opcode lodsw
    0e2 '     loop-compile opcode loop
    0e1 '     loop-compile opcode loope
    0e0 '     loop-compile opcode loopne
    0e0 '     loop-compile opcode loopnz
    0e1 '     loop-compile opcode loopz
     03 ' group6&7-compile opcode ltr
      0 '      mov-compile opcode mov
    0a4 '         str-inst opcode movs
    0be '     movx-compile opcode movsx
    0a4 '    byte-str-inst opcode movsb
    0a4 '   dword-str-inst opcode movsd
    0a4 '    word-str-inst opcode movsw
    0b6 '     movx-compile opcode movzx
     04 '   group3-compile opcode mul
     03 '   group3-compile opcode neg
     90 '            1byte opcode nop
     02 '   group3-compile opcode not
     01 '   group1-compile opcode or
    0e6 '      i/o-compile opcode out
     6e '         str-inst opcode outs
     6e '    byte-str-inst opcode outsb
     6e '   dword-str-inst opcode outsd
     6e '    word-str-inst opcode outsw
      0 '      pop-compile opcode pop
    261 '   size-cond-comp opcode popa
    361 '   size-cond-comp opcode popad
    29d '   size-cond-comp opcode popf
    39d '   size-cond-comp opcode popfd
      0 '     push-compile opcode push
    260 '   size-cond-comp opcode pusha
    360 '   size-cond-comp opcode pushad
    29c '   size-cond-comp opcode pushf
    39c '   size-cond-comp opcode pushfd
     02 '   group2-compile opcode rcl
     03 '   group2-compile opcode rcr
   320f '            2byte opcode rdmsr
   310f '            2byte opcode rdtsc
      0 '      ret-compile opcode ret
      0 '     retf-compile opcode retf
     00 '   group2-compile opcode rol
     01 '   group2-compile opcode ror
  0aa0f '            2byte opcode rsm
     9e '            1byte opcode sahf
     04 '   group2-compile opcode sal
     07 '   group2-compile opcode sar
     03 '   group1-compile opcode sbb
    0ae '         str-inst opcode scas
    0ae '    byte-str-inst opcode scasb
    0ae '   dword-str-inst opcode scasd
    0ae '    word-str-inst opcode scasw
     97 '    setcc-compile opcode seta
     93 '    setcc-compile opcode setae
     92 '    setcc-compile opcode setb
     96 '    setcc-compile opcode setbe
     92 '    setcc-compile opcode setc
     94 '    setcc-compile opcode sete
     9f '    setcc-compile opcode setg
     9d '    setcc-compile opcode setge
     9c '    setcc-compile opcode setl
     9e '    setcc-compile opcode setle
     96 '    setcc-compile opcode setna
     92 '    setcc-compile opcode setnae
     93 '    setcc-compile opcode setnb
     97 '    setcc-compile opcode setnbe
     93 '    setcc-compile opcode setnc
     95 '    setcc-compile opcode setne
     9e '    setcc-compile opcode setng
     9c '    setcc-compile opcode setnge
     9d '    setcc-compile opcode setnl
     9f '    setcc-compile opcode setnle
     91 '    setcc-compile opcode setno
     9b '    setcc-compile opcode setnp
     99 '    setcc-compile opcode setns
     95 '    setcc-compile opcode setnz
     90 '    setcc-compile opcode seto
     9a '    setcc-compile opcode setp
     9a '    setcc-compile opcode setpe
     9b '    setcc-compile opcode setpo
     98 '    setcc-compile opcode sets
     94 '    setcc-compile opcode setz
    100 ' group6&7-compile opcode sgdt
     04 '   group2-compile opcode shl
    0a4 '     double-shift opcode shld
     05 '   group2-compile opcode shr
    0ac '     double-shift opcode shrd
    101 ' group6&7-compile opcode sidt
     00 ' group6&7-compile opcode sldt
    104 ' group6&7-compile opcode smsw
    0f9 '            1byte opcode stc
    0fd '            1byte opcode std
    0fb '            1byte opcode sti
    0aa '         str-inst opcode stos
    0aa '    byte-str-inst opcode stosb
    0aa '   dword-str-inst opcode stosd
    0aa '    word-str-inst opcode stosw
     01 ' group6&7-compile opcode str
     05 '   group1-compile opcode sub
      0 '     test-compile opcode test
     04 ' group6&7-compile opcode verr
     05 ' group6&7-compile opcode verw
     9b '            1byte opcode wait
   090f '            2byte opcode wbinvd
   300f '            2byte opcode wrmsr
    0c0 ' xchg&alu-compile opcode xadd
     86 '     xchg-compile opcode xchg
      0 '     xlat-compile opcode xlat
      0 '    xlatb-compile opcode xlatb
     06 '   group1-compile opcode xor

( create code definitions )
in-hidden
variable current-sv ( needed for stashing the current vocabulary )
: save-current ( save the current vocabulary linkage )
        ( -- )
        current data-@ current-sv data-! ;

: unsave-current ( reset current-sv )
        ( -- )
        0 current-sv data-! ;

: restore-current ( restore current to its previously saved value )
        ( -- )
        current-sv data-@ ?dup if current data-! unsave-current then ;

( debugging )
: reset-asm reset-vars clr-opstack loc-init save-depth ;

in-asm
: init-asm ( initalize assembly )
        ( -- )
        also assembler reset-asm ;

( FORTH header creation words )
in-hidden
: _code ( start a native code definition )
        code-header code-here cell+ code-d, hide !csp init-asm ;

: _;code ( create the [;code] part of a low level defining word )
        ?csp !csp compile (;code) postpone [ init-asm ;

in-forth
defer code ' _code is code
defer ;code ' _;code is ;code
also forth immediate previous ( necessary because of ASM-HIDDEN IMMEDIATE )

: subr: ( create a subroutine in the assembler vocabulary )
        save-current init-asm definitions !csp create hide data-here 0
        data-, code-align code-here swap data-! does> data-@ ;

: macro: ( create a macro in the assembler vocabulary )
        save-current also assembler definitions : postpone enter-macro ;

( end code definitions )
in-asm
: end-asm a; previous ;

in-hidden
: _end-code ( end a code definition )
        end-asm ?finished ?unres ?csp reveal restore-current code-align
        exit-assembler ;

in-asm
defer end-code ' _end-code is end-code
defer       ;c ' _end-code is       ;c

: endm ( end a macro definition )
        postpone leave-macro postpone ; previous restore-current ;
also forth immediate previous

: ;macro ( end a macro definition )
        postpone endm ; also forth immediate previous

\ : exit ( redefine exit to take care of macros )
\        in-macro? if leave-macro then r> drop ;
( redefine exit to be closer to standard )
: ?leave-macro ( conditionally unnest a macro )
        in-macro? if leave-macro then ;

: exit ( redefine exit to take care of macros )
        state @ if postpone ?leave-macro postpone exit else
        ?leave-macro exit then ; also forth immediate previous

( utility words )
: prefix? ( are we in prefix mode? )
        ( -- flag )
        defer@ save-inst ['] noop = ;

: postfix? ( are we in postfix mode? )
        ( -- flag )
        prefix? 0= ;

( setting and restoring the assembler syntax )
: set-postfix ( set the assembler to postfix mode, leave a mode flag )
        ( -- prev. mode==prefix )
        prefix? dup if >r a; postfix r> then ;

: set-prefix ( set the assembler to prefix mode, leave a mode flag )
        ( -- prev. mode==prefix )
        prefix? dup 0= if >r a; prefix r> then ;

: reset-syntax ( reset the assembler to the previously flagged syntax )
        ( prev. mode==prefix -- )
        if a; prefix else a; postfix then ;

only forth definitions base !
