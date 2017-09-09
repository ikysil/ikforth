\
\  triple.4th
\
\  Copyright (C) 2017 Illya Kysil
\

CR .( Loading TRIPLE definitions )

REPORT-NEW-NAME @
REPORT-NEW-NAME ON

ONLY FORTH DEFINITIONS


: T0= (S t -- flag)
   \G flag is true if and only if all bits of triple-cell value t are zero.
   OR OR 0=
;


: T0<> (S t -- flag)
   \G flag is true if and only if any bit of triple-cell value t is not zero.
   OR OR 0<>
;


: T! (S t addr -- )
   \G Store triple-cell value t to address addr.
                 \ S: tlo tmi thi addr
   2SWAP ROT     \ S: thi tlo tmi addr
   ROT SWAP      \ S: thi tmi tlo addr
   !+ !+ !
;


: T@ (S addr -- t )
   \G Fetch triple-cell value t from address addr.
   @+ SWAP @+ SWAP @
;


: 3DROP (S t -- )
   \G Drop triple cell value t.
   DROP DROP DROP
;


: 3DUP (S t -- t t)
   \G Duplicate triple cell value t.
   \ S: nl nm nh -> nl nm nh nl nm nh
   >R 2DUP             \ S: nl nm nl nm     R: nh
   R@ -ROT R>
;


: 3OR (S t1 t2 -- t3)
   \G t3 is a bit-wise OR betwwen t1 and t2.
                 \ S: t1lo t1mi t1hi t2lo t2mi t2hi
   2SWAP         \ S: t1lo t1mi t2mi t2hi t1hi t2lo
   >R            \ S: t1lo t1mi t2mi t2hi t1hi        R: t2lo
   OR >R OR      \ S: t1lo t3mi                       R: t2lo t3hi
   R> ROT R> OR  \ S: t3mi t3hi t3lo
   ROT ROT
;


: S>T (S n -- t)
   \G Sign-extend n to triple cell value t.
   S>D S>D
;


: 3SWAP (S xl xm xh yl ym yh -- yl ym yh xl xm xh )
   2>R              \ S: xl xm xh yl           R: ym yh
   SWAP 2SWAP ROT   \ S: yl xl xm xh           R: ym yh
   2R> 2SWAP 2>R    \ S: yl xl ym yh           R: xm xh
   ROT 2R>          \ S: yl ym yh xl xm xh     R:
;


: T+ (S nlo nmi nhi mlo mmi mhi -- tlo tmi thi)
   (G Add triple-cell numbers.)
   >R ROT  >R        \ S: nlo nmi mlo mmi   R: mhi nhi
   >R SWAP >R        \ S: nlo mlo           R: mhi nhi mmi nmi
   0 SWAP OVER       \ S: nlo 0 mlo 0       R: mhi nhi mmi nmi
   D+ 0              \ S: tlo tmi1 0        R: mhi nhi mmi nmi
   R> 0 D+           \ S: tlo tmi2 thi1     R: mhi nhi mmi
   R> 0 D+           \ S: tlo tmi thi2      R: mhi nhi
   R> R> + +         \ S: tlo tmi thi       R:
;


: T2/ (S nlo nmi nhi -- nlo' nmi' nhi')
   (G Divide triple-cell value by 2 - shift right with sign extension)
   >R DUP >R
   D2/ DROP
   R> R>
   D2/
;


: T2* (S nlo nmi nhi -- nlo' nmi' nhi')
   \G Multiply triple-cell value by 2 - shift left
   D2* 2>R
   0 D2*
   0 2R>
   D+
;


REPORT-NEW-NAME !
