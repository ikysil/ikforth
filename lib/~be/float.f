\ Floating Point Emulation Package for ANS Forth
\ Rev 5. See bottom for rev history.

\ Author: Brad Eckert                                   brad@tinyboot.com

\ This package provides basic floating point number support and functions such
\ as +, -, *, / and SQRT. Mantissas are double-cell unsigned. Exponents contain
\ the mantissa's sign and a signed exponent.
\ Range and digits of precision versus cell width are:

\ Cell_width    Digits_of_precision     Range
\ 16            9                       10^-4920 to 10^4920
\ 32            19                      10^-323196269 to 10^323196269
\ n             int(n*0.602)            10^+/-(2^(n-1)-2n)*0.301

\ A good speed-up can be had by coding the low level math operators in assembly.
\ CODE words can take advantage of the carry flag to quickly do multiple
\ precision arithmetic. ANS Forth doesn't accommodate carries so easily.

\ Floating point arithmetic is easy to use, but be careful to watch where your
\ inaccuracies are coming from. Floating point numbers are approximations. You
\ can lose up to half a bit in each operation. Differences between large numbers
\ can be trouble spots. For example, 1000001 - 1000000 is 1. But, the precision
\ of the result with 16-bit cells is only three digits. Six of the nine
\ available digits of precision were used up representing the big operands.

\ If you need transcendental functions, they can often be done in integer
\ arithmetic since you don't need floating point's run-time auto-scaling. See
\ my work on cubic interpolation of lookup tables.

\ ------------------------------------------------------------------------------

\ ANS Forth using CORE, CORE EXT, DOUBLE and DOUBLE EXT wordsets.

\ Floating point representation on floating point stack:
\ 0 upper mantissa
\ 1 lower mantissa
\ 2 exponent: MSB = sign of mantissa, others = signed exponent

8 CONSTANT maxdepth
3 CELLS CONSTANT b/float
b/float negate CONSTANT -b/float
VARIABLE sigdigits                      \ # of digits to display after decimal
VARIABLE fsp                            \ stack pointer
CREATE fstak  maxdepth b/float * ALLOT  \ floating point stack
CREATE ftemp  6 CELLS ALLOT             \ temporary float variable
HEX
10000 0<> 10 AND 10 + CONSTANT bits/cell \ 16-bit or 32-bit Forth
DECIMAL
bits/cell 1- 602 1000 */ CONSTANT maxdig \ max decimal digits that fit in double

-1 1 RSHIFT DUP CONSTANT &unsign  INVERT CONSTANT &sign  \ 7F... 80...
&sign  1 RSHIFT CONSTANT &esign                          \ 40...

\ Run-time error codes:
\ 0 = no error
\ 1 = F>D overflow
\ 2 = division by zero
\ 3 = sqrt of negative

VARIABLE ferror                         \ last seen error

\ The M[ ]M structure does something 0 or more times. You should extend your
\ compiler to encode this. The result has much less overhead than DO. The high
\ level Forth presented here will work for testing. Or, globally search and
\ replace M[ with 0 ?DO and ]M with LOOP. But, my future Forths will be
\ compatible with the following:

: M[    ( -- )
        postpone >R
        postpone BEGIN
        postpone R>  postpone 1-  postpone DUP  postpone >R
        postpone 0<  postpone 0=
        postpone WHILE ; immediate
: ]M    ( -- )
        postpone REPEAT
        postpone R>
        postpone DROP ; immediate

\ ------------------------------------------------------------------------------
\ Low level math you could CODE for better speed

\ : DU<   ( u_1 . u_2 . -- flag )
\   ROT 2DUP = IF 2DROP U< ELSE U> NIP NIP THEN ;

: ud2/          ( d -- d' )
                D2/ &unsign AND ;

: frshift       ( count 'man -- )               \ right shift mantissa
                SWAP 0 MAX bits/cell 2* MIN
                >R DUP 2@ R> M[ ud2/ ]M ROT 2! ;

: exp>sign      ( exp -- exp' sign )
                DUP &unsign AND                 \ mask off exponent
                DUP &esign AND 2* OR            \ sign extend exponent
                SWAP &sign AND ;                \ get sign of mantissa

: sign>exp      ( exp sign -- exp' )
                SWAP &unsign AND OR ;

: t2*           ( triple -- triple' )
                D2* ROT DUP 0< 1 AND >R 2* ROT ROT R> 0 D+ ;

: t2/           ( triple -- triple' )
                OVER 1 AND 0<> &sign AND >R D2/ ROT       \ MHL|C
                1 RSHIFT R> OR ROT ROT ;

: t+            ( t1 t2 -- t3 )
                2>R >R ROT 0 R> 0 D+ 0 2R> D+
                ROT >R D+ R> ROT ROT ;

: lstemp        ( -- )                          \ 6-cell left shift FTEMP
                ftemp 6 CELLS + 0               ( *LSB carry . . )
      6 M[      >R -1 CELLS +                   \ LSB in high memory
                DUP @ 0 D2* SWAP R> +           ( a co n ) \ ROL
                ROT TUCK ! SWAP                 \ a carry
        ]M      2DROP ;

: *norm         ( triple exp -- double exp' )   \ normalize triple
     >R BEGIN   DUP 0< 0=
        WHILE   t2* R> 1- >R
        REPEAT  &sign 0 0 t+                    \ round
                ROT DROP R> ;

: longdiv       ( DA DB -- DA/DB )              \ fractional divide
                0 0 ftemp 2!                    
                bits/cell 2* 1+                 \ long division
        M[      2OVER 2OVER DU<                 \ double/double
                IF   0
                ELSE 2DUP 2>R D- 2R> 1          \ a b --> a-b b
                THEN 0 ftemp 2@ D2* D+ ftemp 2!
                2SWAP D2* 2SWAP
        ]M    DU< 0= 1 AND 0                  \ round
                ftemp 2@ D+ ;

\ ------------------------------------------------------------------------------
\ Parameter indicies

: 'm1           ( -- addr )      fsp @ 3 cells - ; \ -> 1st stack mantissa
: 'm2           ( -- addr )      fsp @ 6 cells - ; \ -> 2nd stack mantissa
: 'm3           ( -- addr )      fsp @ 9 cells - ; \ -> 3rd stack mantissa
: 'e1           ( -- addr )      fsp @ 1 cells - ; \ -> 1st stack exponent
: 'e2           ( -- addr )      fsp @ 4 cells - ; \ -> 2nd stack exponent
: fmove         ( a1 a2 -- )     b/float MOVE ;
: m1get         ( addr -- )      'm1 fmove ;      \ move to M1
: m1sto         ( addr -- )      'm1 SWAP fmove ; \ move from M1
: expx1         ( -- exp sign )  'e1 @ exp>sign ;
: expx2         ( -- exp sign )  'e2 @ exp>sign ;
: ftemp'        ( -- addr )      ftemp 2 CELLS + ;
: >exp1         ( exp sign -- )  sign>exp 'e1 ! ;
: fshift        ( n -- )         expx1 >R + R> >exp1 ; \ F = F * 2^n

\ A normalized float has an unsigned mantissa with its MSB = 1

: normalize     ( -- )
                'm1 2@ 2DUP OR 0=
       IF       2DROP                           \ Zero is a special case.
       ELSE     0 -ROT expx1 >R *norm
                R> >exp1 'm1 2!
       THEN     ;

\ ------------------------------------------------------------------------------
\ Floating Point Words

: F2*           ( fs: r1 -- r3 )  1 fshift ;
: F2/           ( fs: r1 -- r3 ) -1 fshift ;
: PRECISION     ( -- n )         sigdigits @ ;
: SET-PRECISION ( n -- )         maxdig MIN sigdigits ! ;
: FCLEAR        ( -- )           fstak fsp ! 0 ferror ! ;
: FDEPTH        ( -- )           fsp @ fstak - b/float / ;
: FDUP          ( fs: r -- r r ) b/float fsp +! 'm2 m1get ;
: FDROP         ( fs: r -- )    -b/float fsp +! ;
: FNEGATE       ( fs: r1 -- r3 ) 'e1 @ &sign XOR 'e1 ! ;
: D>F           ( d -- | -- r )  FDUP DUP 0< IF DNEGATE &sign ELSE 0 THEN
                                 'e1 ! 'm1 2!  normalize ;
: F>D           ( -- d | r -- )  expx1 >R DUP 1- 0<
        IF      NEGATE &unsign AND 'm1 frshift 'm1 2@ R> IF DNEGATE THEN
        ELSE    R> 2DROP -1 &unsign  1 ferror !   \ overflow: return maxdint
        THEN    FDROP ;
: S>F           ( n -- | -- r )  S>D D>F ;
: FLOAT+        ( n1 -- n2 )     b/float + ;
: FLOATS        ( n1 -- n2 )     b/float * ;
: F@            ( a -- | -- r )  FDUP m1get ;
: F!            ( a -- | r -- )  m1sto FDROP ;
: F0=           ( -- t | r -- )  'm1 2@ OR 0= FDROP ;
: F0<           ( -- t | r -- )  'e1 @ 0< FDROP ;
: FLOOR         ( fs: r1 -- r2 ) F>D DUP 0< IF -1 S>D D+ THEN D>F ;
: FABS          ( fs: r1 -- r3 ) 'e1 @ 0< IF FNEGATE THEN ;
: FALIGN        ( -- )           ALIGN ;
: FALIGNED      ( addr -- addr ) ALIGNED ;
: FSWAP         ( fs: r1 r2 -- r2 r1 )
                'm1 ftemp fmove 'm2 m1get ftemp 'm2 fmove ;
: FOVER         ( fs: r1 r2 -- r1 r2 r3 )
                b/float fsp +! 'm3 m1get ;
: FPICK         ( n -- ) ( fs: -- r )
                b/float fsp +! 2 + -b/float * fsp @ + m1get ;
: FNIP          ( fs: r1 r2 -- r2 ) FSWAP FDROP ;

: FROT          ( fs: r1 r2 r3 -- r2 r3 r1 )
                'm3 ftemp fmove  'm2 'm3 b/float 2* MOVE  ftemp m1get ;

: F+            ( fs: r1 r2 -- r3 )
       FDUP F0= IF FDROP EXIT THEN                      \ r2 = 0
      FOVER F0= IF FNIP 'e1 @ 0< IF FNEGATE THEN EXIT THEN \ r1 = 0
                expx1 >R expx2 >R -  DUP 0<
        IF      NEGATE 'm1 frshift 0                    \ align exponents
        ELSE    DUP    'm2 frshift
        THEN    'e2 @ +
                'm2 2@ R> IF DNEGATE -1 ELSE 0 THEN
                'm1 2@ R> IF DNEGATE -1 ELSE 0 THEN
                t+ DUP >R                               ( exp L M H | sign )
    DUP IF      t2/ IF DNEGATE THEN 'm2 2! 1+
        ELSE    DROP 'm2 2!
        THEN    R> &sign AND sign>exp 'e2 !
                FDROP normalize ;

: F-            ( fs: r1 r2 -- r3 )      FNEGATE F+ ;
: F<            ( -- t ) ( F: r1 r2 -- ) FOVER FOVER F- F0< ;

: FROUND        ( fs: r1 -- r2 )
                expx1 >R NEGATE 1- 'm1 frshift          \ convert to half steps
                'm1 2@ 1 0 D+  SWAP -2 AND SWAP         \ round
                'm1 2! -1 R> >exp1 normalize ;          \ re-float

: FMIN          ( F: r1 r2 -- rmin ) FOVER FOVER F<
                IF FDROP ELSE FNIP THEN ;

: FMAX          ( F: r1 r2 -- rmax ) FOVER FOVER F<
                IF FNIP ELSE FDROP THEN ;

: F*            ( fs: r1 r2 -- r3 )
                'm1 2@ 'm2 2@
                OVER >R ftemp' 2!
                OVER >R ftemp  2!
                R> R> OR                                \ need long multiply?
        IF      FTEMP CELL+ @ FTEMP' CELL+ @ UM* &sign 0 D+ NIP \ round
                FTEMP @       FTEMP' @       UM*
                FTEMP CELL+ @ FTEMP' @       UM* 0 t+
                FTEMP @       FTEMP' CELL+ @ UM* 0 t+
        ELSE    0 ftemp @ ftemp' @ UM*                  \ lower parts are 0
        THEN    2DUP OR 3 PICK OR                       \ zero?
        IF      expx1 >R expx2 >R + bits/cell 2* + *norm
                R> R> XOR sign>exp 'e2 !
        ELSE    DROP                                    \ zero result
        THEN    'm2 2! FDROP ;

: F/            ( fs: r1 r2 -- r3 )
                FDUP F0=
        IF      FDROP -1 -1 'm1 2!  2 ferror !          \ div by 0, man= umaxint
                'e1 @ &sign AND &sign 2/ 1- OR 'e1 !    \   exponent = maxint/2
        ELSE    'm1 2@ 'm2 2@ DU< IF 1 'm2 frshift THEN \ divisor <= dividend
                'm1 CELL+ @
           IF   'm2 2@ ud2/ 'm1 2@ ud2/  longdiv        \ max divisor = dmaxint
           ELSE 0 'm2 2@ 'm1 @ DUP >R UM/MOD            \ 0 rem quot | divisor
                -ROT R@ UM/MOD -ROT R> 1 RSHIFT U> IF 1 0 D+ THEN \ round
           THEN expx2 >R expx1 >R - bits/cell 2* -
                >R 'm2 2! R> R> R> XOR sign>exp 'E2 !
                FDROP
        THEN    ;

: F~            ( f: r1 r2 r3 -- ) ( -- flag )          \ f-proximate
                FDUP F0<                                \ Win32forth version
        IF      FABS FOVER FABS 3 FPICK FABS F+ F*      \ r1 r2 r3*(r1+r2)
                FROT FROT F- FABS FSWAP F<
        ELSE    FDUP F0=
                IF      FDROP F- F0=
                ELSE    FROT FROT F- FABS FSWAP F<
                THEN
        THEN ;

: FSQRT         ( fs: r -- r' )
                expx1 IF 3 FERROR ! EXIT THEN   \ error: sqrt of negative
                2/ bits/cell - 0 >exp1
                ftemp 6 CELLS ERASE  'm1 2@     \ x
                ftemp 2 CELLS + 2!              \ x*2^(2*bits/cell)
                0 0  bits/cell 2*               \ p = 0
        M[      lstemp lstemp                   \ shift left x into a 2 places
                D2*                             \ shift left p one place
                2DUP D2* ftemp 2@ D<
                IF      ftemp 2@ 2OVER D2* 1 0 D+ D-
                        ftemp 2!                \ a:=a-(2*p+1)
                        1 0 D+                  \ p:=p+1
                THEN
        ]M    'm1 2! normalize ;


\ For fixed-width fields, it makes sense to use these words for output:
\ fsplit        ( F: r -- ) ( fracdigits -- sign Dint Dfrac )
\               Converts to integers suitable for pictured numeric format.
\               Fracdigits is the number of digits to the right of the decimal.
\ n#s           ( UD fracdigits -- )
\               Outputs a fixed number of digits

: fsplit        ( F: r -- ) ( fracdigits -- sign Dint Dfrac )
                >R expx1 NIP FABS               \ int part must fit in a double
                FDUP F>D 2DUP D>F F-            \ get int, leave frac
            2 0 R> M[ D2* 2DUP D2* D2* D+ ]M    \ 2 * 10^precision
                D>F F* F>D  1 0 D+ ud2/ ;       \ round

: n#s           ( UD cnt -- )
                M[ # ]M 2DROP ;

\ (F.) uses PRECISION as the number of digits after the decimal. F. clips off
\ the result to avoid displaying extra (possibly garbage) digits. However, this
\ defeats last-digit rounding. (F.) TYPE is the prefered display method. F. is
\ included for completeness.

: (F.)          ( F: r -- ) ( -- addr len )
                <# FDEPTH 1- 0< IF 0 0 EXIT THEN \ empty stack -> blank
                PRECISION fsplit
                PRECISION n#s
                PRECISION IF [CHAR] . HOLD THEN
                #S ROT SIGN #> ;

: F.            ( F: r -- )  (F.) PRECISION 1+ MIN TYPE SPACE ;
: R.            ( F: r -- )  (F.) TYPE SPACE ;

: FCONSTANT     ( -<name>- ) ( F: r -- )        \ compile time
                             ( F: -- r )        \ runtime
                CREATE HERE F! B/FLOAT ALLOT DOES> F@ ;

: FVARIABLE     ( -<name>- )                    \ compile time
                             ( F: -- r )        \ runtime
                CREATE B/FLOAT ALLOT ;

\ test goodies

: fd            fstak fdepth b/float * DUMP ;    \ dump stack

fclear
18 SET-PRECISION

\ ------------------------------------------------------------------------------
\ FLOATING and FLOATING EXT words not implemented here:
\ >FLOAT FLITERAL REPRESENT  F** FACOS FACOSH FALOG FASIN FASINH FATAN FATAN2
\ FATANH FCOS FCOSH FE. FEXP FEXPM1 FLN FLNP1 FLOG FS.
\ FSIN FSINCOS FSINH FTAN FTANH

\ Revision history:
\ 0: Initial release 11/7/02
\ 1: Removed locals from F*, PAD from F/. Added FSQRT.
\ 2: Fixed FROUND, F.
\ 3: Fixed FPICK, converted standard words to upper case, sped up stack.
\ 4: Limited the number of significant digits in F. to comply with ANS standard.
\ 5: Changed F2* and F2/ to use fshift. You can use fshift for quick *2^n.
\    Replaced DO..LOOP with M[ ]M structure.


