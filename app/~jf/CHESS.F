\ chess.f windowing and machine Forth removed to get back to basic ANS Forth
\ f21chess V1.k sped up several times
\ f21chess program V1.4 for T21F and ANSI Forth by Jeff Fox ok
\ chess program V1.3 for ANSIfied ProForth for MS Windows Jeff Fox
\ >defer and CELLS fixes, fpc not not ansi not, 78 dup c, c, @ is -7879 in fpc
\ chess program V1.1 in English for F-PC by Jeff Fox
\ Schaakprogramma V1.0 in Dutch for F-PC by Lennart Benschop

\ to now run this ANS version under FPC like CHESS.SEQ compile the next 5 lines
\ : INVERT NOT ; : CELLS 2* ; : CELL+ 2+ ;
\ : CHAR ( -<name>- c ) bl word 1+ c@ ; immediate
\ : [CHAR] ( -<name>- ) bl word 1+ c@
\  [compile] literal ; immediate
\ : at-xy at ;

\ >BODY being used as >defer is an environmental dependency
\ >BODY will work in some Forths with DEFERed words, check your system

\ case insensitive source

HEX

\ win32forth will run this program, but it will not scroll the
\ console window.  win32Forth needs an application window setup
\ so that a CR on the bottom line of the display will scroll the display.
\ The program will run without scroll but you will only see the current
\ move and not see the list of previous moves.

\ Pieces: King K, Queen q Rook r Bishop b Knight k Pawn p White W Black B
\
\ Load the game, type the word CHESS for a real game or AUTO for an automatic
\ game (machine plays against itself).
\ First you have to press any key (to initialize random generator),
\ then you have to say whether you want to play white (Y/N).
\ next you have to slect a level (2--5).
\
\ Moves are entered like E2-E4. Castling (Rocheren) is performed by moving the
\ King to the desired position (e.g. E1-G1). When a pawn reaches the last row,
\ you are asked for a piece it must promote to (e.g. D for Dame). I think the
\ rules are implemented correctly, including the complex castling rules, en
\ passant capture and minor promotion, but there are no checks for a forced
\ draw (triple repetition of same situation, 50 moves rule). The program knows
\ whether there is a 'check' (Schaak) and it detects checkmate (Schaakmat) and
\ stalemate (Pat).
\
\ Level 2 is fast on a Pentium, level 3 is usable. Level 4 is a bit slow and a
\ bit buggy. It's no match for Gnu Chess.
\
\ The game situation is administered with a stack of chess boards.
\ It contains the board situation as well as extra variables.
\ Every board takes 192 bytes (hex C0) and consists of 12 rows of 16 bytes.
\ The top two rows and the bottom two rows contain hex 07 to indicate that the
\ field is beyond the board. The fist two bytes of each row and also the 11th
\ and the 12th byte contain 07 as well. The 13th to 16th byte of each row
\ accommodate extra variables. The board position is registered at the 3rd to
\ 7th byte of the 3rd to 7th row. Empty field has value 0. Fields with a black
\ piece have values 1 to 6. Fields with a white piece have values hex 81 to
\ 86.

5 constant maxlevel    \ maximum level of play.
create bp0
maxlevel 1 + c0 * allot \ the stack contains 1 additional play situation.

variable bpv           \ pointer to the current chess board.

: bp bpv @ ; ( -- addr ) \ address of the current chess board.
: b@ bpv @ + c@ ;  ( offs -- byte) \ Read byte from playing board.
: b! bpv @ + c! ;  ( byte offs -- ) \ Write byte to playing board.

\ create does> boardvar words use pfa to get offset and return addr
\ c@ bpv @ + ;  ( pfa -- a ) \ Read byte from playing board.

: boardvar create , ( offs -- ) \ defines a variable on the board.
 does> c@ bpv @ + ; ( -- addr )    \ indicates the address of the current board.
  0c boardvar start     \ party whose move it is
  0d boardvar castlew   \ Can White still 'Castle'?
  0e boardvar castleb   \ Can Black still 'Castle'?
  0f boardvar ep        \ column with Pawn that can be captured in passing or 0
  1c boardvar starting  \ starting field. piece.....
  1d boardvar piece     \ best piece that is being played.
  1e boardvar best      \ destination field. (These are two words stuck together 'stillthrough')
  1f boardvar farther?  \ can piece still move farther?
  2c boardvar wlcastle? \ can White still Castle on the queen's side? 'long castle' =
  2d boardvar blcastle? \ can Black still Castle on the queen's side?
  2e boardvar check     \ is the king in check?
  2f boardvar pawnmove  \ column with Pawn that is moved forward two or 0
  3c boardvar kingw     \ position White king.
  3d boardvar kingb     \ position Black king.
  3e boardvar inpassing \ is this move an 'in passing' attach?
  4c boardvar advance   \ advance piece [or] promotion piece
  6c boardvar valuew    \ value of White material
  6e boardvar alfa
  7c boardvar beta
  7e boardvar (eval)
  8c boardvar highest
  8e boardvar cutoff
  9c boardvar valueb    \ value of Black material. played
  9e boardvar played

variable level \ level at which the program is looking. 0=actual position
               \ -1 one half move forward, etc.

: +level ( -- )        \ think one level deeper.
  bp dup c0 + c0 cmove \ move board to next level.
  c0 bpv +!   1 level +! ;

: -level ( -- )        \ go back one level.
  -c0 bpv +!  -1 level +! ;

               \ for text board
create symbols \ symbols of empty field and of the values of the pieces
\ compiled here with , so use CELLS instead of CHARS

  ( CHAR . ) BL , CHAR p , CHAR k , CHAR b ,
  CHAR r , CHAR q , CHAR K ,

create values \ values of empty field and of the pieces
 0 , 40 , c0 , c0 , 140 , 240 , 3000 ,

: .board ( -- ) \ print out chess board in text mode
  0 0 at-xy 20 spaces
  cr 2 spaces
  [CHAR] H 1 +  [CHAR] A do i emit 2 spaces loop \ letters along top
  bp 20 + 8 0 do
    cr 20 spaces
    cr [CHAR] 8 i - emit                   \ number of the row
    0a 2 do space
     dup i + c@ dup                         \ symbols compiled with , use CELLS
     07 and cells symbols + 1 type          \ type piece - 'key in' piece
     dup 80 and if ." W" drop else          \ is piece White?
      if ." B" else ."  " then
     then
    loop
    10 +                                 \ next row
  loop cr drop ;                         \ throw away pointer to the board

: .pos  ( offs ---)    \ print out position
  10 /mod              \ split into row and column
  swap 2 - [CHAR] A + emit   \ give column
  [CHAR] 8 2 + swap - emit ; \ give row  2+ is two bytes (chars)

\ constants that indicate the directions on the board
-11 constant nw    -0f constant no
 0f constant zw     11 constant zo
-10 constant n      10 constant z
 -1 constant w       1 constant o

create spring \ Knight jump table
-12 , -21 , -1f , -0e , 12 , 21 , 1f , 0e ,

defer tmove ( -- ) \ action that the move generator must carry out for each move.

defer attacktest ( offs --- f) \ test of field attacked status

: mine? ( offs --- f ) \ does the field contain a piece of ones own color?
  b@ dup 0= 0= swap 80 and start c@ = and ;

variable movits

: moveit ( direction ---) \ generate moves in a certain direction.
  starting c@ best c!   1 farther? c!
  begin
   best c@  over +  dup best c! \ move destination field up one
   dup mine? over b@ 87 = or 0= \ not to ones own piece or beyond the edge?
   farther? c@ and while        \ as long as you can still go farther.
    tmove                       \ generate the move.
    b@ 0= farther? c!           \ if the move was to an empty field, then you may still go farther
  repeat                        \ if you captured a piece, then you can't.
  drop drop
 1 movits +! ;

: Bishop ( -- )
  no nw zo zw  moveit moveit moveit moveit ;

: Rook ( -- )
  n o z w  moveit moveit moveit moveit ;

: Queen ( -- )
  n o z w no nw zo zw  8 0 do moveit loop ;

: Knight ( -- )
   8 0 do             \ jump table uses , so use cells for ANS
   i cells spring + @ \ get direction from jump table.
   starting c@ +  dup best c!   \ calculate destination field.
   dup mine? swap b@ 87 = or 0= \ not to ones own piece or over the edge?
   if tmove then                \ then generate move
   loop ;

: ?castle ( --- f) \ can one castle
  start c@ 80 = if castlew else castleb then  c@  check  c@ 0=  and ;

: ?lcastle ( --- f ) \ can one castle on the queen's side?
  start c@ 80 = if wlcastle? else blcastle? then  c@  check  c@ 0=  and ;

: king ( -- )
  n o z w no nw zo zw   8 0 do  \ Each side, move a square.
   starting c@ + dup best c!    \ calculate the destination field.
   dup mine? swap b@ 87 = or 0= \ not to ones own piece or over the edge?
   if tmove then
  loop
  ?castle if 28 start c@ if 70 + then \ Castling?, calculate destination king
           dup bp + 1- @ 0=           \ squares in between empty?
           if
            dup 1- attacktest 0=      \ field in between not under attack?
            if
             best c! tmove            \ done Castling
            else drop then
           else drop then
        then
  ?lcastle if 24 start c@ if 70 + then \ castle queen's side?
            dup bp + @ over bp + 1- @ or 0=
            if
             dup 1 + attacktest 0=
             if
              best c! tmove
             else drop then
            else drop then
         then ;

: Pawnrow ( n1 -- n2) \ calculate the direction in which the Pawn may go depending on the color :
  start c@ if negate then ;

: Pawnz ( offs ---) \ generate Pawn move to field indicated.
  dup best c!
  f0 and start c@ if 20 else 90 then = \ does sit land on the last row?
  if  6 2 do i advance c! tmove loop      \ generate promotion Knight-Queen.
  else tmove then                      \ otherwise just move
  0 pawnmove c! 0 inpassing c! 0 advance c! ;

: Pawn ( -- )
  starting c@ z Pawnrow + \ calculate destination 1 move forward.
  dup b@ if               \ Is something on that field?
   drop
  else
   dup Pawnz             \ generate move 1 field forward.
   z Pawnrow + dup b@ if \ is field 2 fields forward empty?
    drop
   else
    starting c@ f0 and   \ calculate row
    start c@ if 80 else 30 then = \ is it the first row?
    if starting c@ 0f and pawnmove c!  \ indicate column in variable.
       Pawnz             \ generate the move
    else drop
    then
   then
  then
  zw zo  2 0 do          \ try capture moves in two directions.
   Pawnrow starting c@ + \ calculate destination
   dup f0 and start c@ if 40 else 70 then = \ to the right row?
   over 0f and ep c@ = and \ can Pawn in that column be captured in passing?
   if 1 inpassing c!           \ indicate that e.p. is captured
      dup Pawnz          \ generate move
   then
   dup b@ dup 0= 2 pick mine? or \ is field empty does it contain ones own piece?
   swap 87 = or                  \ Is field beyond the edge?
   if drop else Pawnz then       \ generate capture move
  loop ;

create pieces \ table with actions for move generator for each piece

 ' noop , ' Pawn , ' Knight , ' Bishop , ' Rook , ' Queen , ' king ,

: piecemove ( -- ) \ generate moves for piece on field indicated in
\ using above jump table for each type of piece - jump table uses , (CELLS)
  piece c@ cells pieces + @ execute ;

: ?piecemove ( -- ) \ generate moves from field in
  starting c@ dup mine? if \ own piece?
   b@ 07 and piece c!      \ move the piece in variable PIECE
   0 pawnmove c! 0 inpassing c! 0 advance c!
   piecemove
  else drop then ;

: allmoves ( -- ) \ generate all moves on the board.
  start c@ 0= if \ Is it Black's move?
   22 starting c!  \ start at field A8 at the left top
   8 0 do       \ eight rows
    8 0 do      \ eight columns
     ?piecemove starting c@ 1 + starting c! \ go to next field
    loop
    starting c@ 8 + starting c! \ go to next row
   loop
  else
   92 starting c! \ start at field A1 left bottom. attack
   8 0 do         \ eight rows
    8 0 do        \ eight columns
     ?piecemove starting c@ 1 + starting c! \ go to next field
    loop
    starting c@ 18 - starting c! \ goto next row
   loop
  then ;

variable attack \ is the field under attack?

: ?attack ( -- ) \ action that the move generator carries out when testing for attack.
  best c@ dup mine? 0= \ is there a foreign piece on the destination field?
  swap b@ 07 and piece c@ = and \ and is that the right piece.
  attack @ or attack ! ; \ then can that piece reach the starting field and is that field under

: attacked? ( --- f ) \ test whether field in START is under attack.
  attack off 0 7 1 do \ carry out test for all attacking pieces.
   i piece c!
   piecemove          \ generate all moves from START for that piece.
   attack @ if drop 1 leave then
  loop ;

variable starting'
variable best'
variable start'
variable tmove' \ variables to store values when testing for attack

: settest ( -- ) \ set the variables for test for attack and store old values
  starting c@ starting' c!
  best  c@ best'  c!
  start c@ start' c!
  ['] tmove >body  @ tmove' !  \ >body for defered words is an environmental dependency
  ['] ?attack is tmove ;

: po@ \ herstel de variabelen na test op attack.
  starting' c@ starting c!
  best' c@ best c!
  start' c@ start c!
  tmove' @ is tmove ;

: changecolor \ change color that whose move it is.
  start c@ 80 xor start c! ;

variable endf        \ is the game over?
variable playlevel   \ playing level number of future plays looked at
variable #legal      \ counter number of legal moves.
variable selected    \ move selected
variable compcolor   \ color that the computer is playing.
variable move#       \ number of the move in the game.

create bp1 c0 allot  \ board for remembering the move played.

: endgame? ( --- f ) \ is the player busy with checkmating at the end of the game?
  start c@ if valueb else valuew then @ c1 < ;

: evalboard ( -- )   \ evaluate the board position
  valueb @ valuew @ - start c@ if negate then \ material difference
  55 mine? 1 and + 56 mine? 1 and + 65 mine? 1 and + 66 mine? 1 and +
  changecolor 55 mine? + 56 mine? + 65 mine? + 66 mine? + changecolor
  \ dominance of the middle fields
  endgame? if
   start c@ if kingb else kingw then c@ \ enemy king
   dup f0 and dup 20 = swap 90 = or 7 and \ on the top or bottom row?
   swap 0f and dup 2 = swap 9 = or 7 and + + \ in left or right column?
  then ;

: ?check ( -- ) \ see if king is checked
  settest       \ store variables of move generator
  start c@ if kingw else kingb then c@ \ determine field where king is located
  starting c! attacked? check  c!      \ see if it is under attack.
  po@ ;       \ restore variables

: (attacktest)  ( offs --- f) \ test whether field is under attack.
  ['] tmove >body @ ['] ?attack <> if \ not as (or 'if') move generator attack test
   settest
   starting c!
   attacked?
   po@
  else drop true
  then ;

' (attacktest) is attacktest

variable seed

: rnd ( --- n)
 seed @ 743 * 43 + dup seed ! ;
\ 1 ; \ for testing with fixed sequence

: domove ( -- ) \ carry out generated move by move generator
  best c@ b@ 7 and cells values + @ negate start c@ \ values compiled w/ , (cells)
  if valueb else valuew then +!  \ calculate any piece captured.
  starting c@ b@ best c@ b!      \ move piece
  0 starting c@ b!               \ empty starting field
  advance c@ if                     \ is there a promotion?
   advance c@ dup cells values + @ 40 - start c@
   if valueb else valueb then +! \ calculate the promotion.
   start c@ or best c@ b!        \ change piece on the board
  then
  piece c@ 4 = if                \ is it a Rook?
   starting c@ 0f and 2 =        \ in linker kolom?
   if
    0 start c@ if wlcastle? else blcastle? then c! \ forbid castling on the queen's side
   then
   starting c@ 0f and 9 =        \ in rechter kolom?
   if
    0 start c@ if castlew else castleb then c! \ forbid castling on the king's side
   then
  then
  piece c@ 6 = if               \ is it the king?
   0 0 start c@ if castlew else castleb then dup >r c! \ castling later forbidden
   r> 1f + c!                   \ as well as castling on the queen's side
   best c@ starting c@ - 2 =    \ is castling on the king's side meant?
   if
    4 start c@ or best c@ 1- b! \ place Rook left next to king.
    0 best c@ 1 + b!             \ empty original Rook field
   then
   best c@ starting c@ - -2 =   \ is castling on the queen's side meant?
   if
    4 start c@ or best c@ 1 + b! \ move Rook right next to the king.
    0 best c@ 2 - b!             \ empty original Rook field
   then
   best c@ start c@ if kingw else kingb then c! \ update position
  then
  inpassing c@ if                     \ is capturing in passing meant?
   0 best c@ n Pawnrow + b!     \ remove captured Pawn.
   -40 start c@ if valueb else valuew then +! \ calculate capture
  then
  pawnmove c@ ep c! ;                \ now a Pawn 2 forward = later e.p. capture

: deeper ( -- ) \ calculate value of move and possible check a level forward.
  cutoff @ \ ( was) not if \ FPC NOT is ANS INVERT
  invert if \ if no cutoff has been discovered
  +level
   domove         \ carry out the move
   ?check  check  c@ if -level exit then \ check not allowed
   -1 played  c0 - !
   level @ playlevel @ = if \ evaluate position at the highest level
    evalboard
    (eval) c0 - !
   else                     \ on another level look still farther
    alfa @ highest !
    alfa @ negate beta @ negate alfa ! beta !
    changecolor
    0 played !
    allmoves                \ generate moves a level deeper.
    played @ 0= if          \ if no moves are generated
     ?check  check  c@ if -2000 highest ! else 0 highest ! then
    then
    highest @ negate
    (eval) c0 - !
   then
  -level
   (eval) @ highest @ max
   highest ! \ remember highest value
   highest @ beta @ > if TRUE cutoff ! then
   \ if move for opponent is better than former move, stop further analysis
   \ a cutoff comes into being
  then ;

: analyse ( -- ) \ analyse each move to be played.
  +level
   domove
   ?check  check  c@ 0= if   \ check = no legal move, forget it.
    1 #legal +!              \ count the move as legal.
    changecolor
    ['] tmove >body @        \ remember the current contents of permove
    ['] deeper is tmove
    0 played !
    allmoves                 \ analyse the move deeper
    is tmove                 \ restore
    played @ 0= if           \ if no moves are generated.
     ?check  check  c@ if -2000 highest ! else 0 highest ! then
    then
     highest @ beta c0 - @ = if \ is the move just as good as the best.
    rnd 2000 > if #legal @ selected ! then \ select it conditionally
    then
    highest @ beta c0 - @ < if \ is the move better?
     #legal @ selected !     \ select it
     highest @ beta c0 - !   \ update alpha for cutoffs. : select
    then
   then
  -level ;

: select ( -- ) \ carry out the move at the time that the SELECT set is generated.
  +level
   domove
   ?check  check  c@ 0= if
    1 #legal +!              \ count the move as legal
    #legal @ selected @ = if \ has the right move been generated?
     bp bp1 c0 cmove         \ store the setting
     starting c@ .pos ." -" best c@ .pos space \ print it out
    then
   then
  -level ;

: against ( -- ) \ investigate whether the move is legal
  +level
   domove
   ?check  check  c@ 0= if
    1 #legal +!
   then
  -level ;

: compmove ( -- ) \ carry out the move of the computer.
 .board
  ['] analyse is tmove
  0 #legal !               \ still no moves generated
  -4000 alfa ! 4000 beta ! \ initialize variables for search process

\  0 18 at-xy cr \ for 25 line display to get bottom line
  scroll         \ force scrolling

  28 spaces
  start c@ if 1 move# +! move# @ 3 .r space else 4 spaces then
  ?check  check  c@ if ."  Check" then
  1 selected !
  allmoves                  \ analyse position and select a move.
  #legal @ 0= if            \ no move possible?
   check  c@ if
    ." mate"
   else
    ." Pat"                 \ pat what is that? stalemate?
   then
   TRUE endf !              \ was last move.
  else
   ['] select is tmove
   0 #legal !
   allmoves                 \ carry out the selected move.
   bp1 bp0 c0 cmove         \ place position in memory
   changecolor
   ['] against is tmove
   0 #legal !
   allmoves                 \ check whether opponent can move.
   ?check  check  c@ if ."  Check" then
   #legal @ 0= if           \ no moves possible?
    check  c@ if
     ." mate"
    else
     ." Pat"                \ pat what is that? stalemate?
    then
    TRUE endf !             \ was last move.
   then
  then
  .board ;

variable startingm
variable bestm
variable personmove         \ data for move made by person

: legal ( -- ) \ test whether move entered is also generated and is legal.
  startingm @ starting c@ =
  bestm @ best c@ = and
  personmove @ advance c@ = and \ Is this move meant?
  if
  +level
   domove
   ?check  check  c@ 0= if   \ Is the move legal?
    1 #legal !
    bp bp1 c0 cmove          \ save position.
   then
  -level
  then ;

create inputbuf 6 allot      \ buffer for human input.

: inpos ( offs-in-input --- f offs-in-board) \ calculate field number from input.
  dup inputbuf + c@ [CHAR] A -    \ take letter of field
  dup 8 u<
  rot inputbuf + 1 + c@ [CHAR] 1 - \ take number
  dup 8 u< rot and                \ check whether the field number is right.
  swap 7 swap - 10 * rot + 22 + ; \ calculate offset

: promote ( c --- c piece)   \ determine promotion piece
  0 6 2 do over symbols i cells + c@ = if drop i then loop ; \ symbols uses cells

: person ( -- ) \ accept human move and carry it out.
 begin
   .board

\  0 18 at-xy cr     \ force scrolling
   scroll

   28 spaces
   start c@ if 1 move# +! move# @ 3 .r else 3 spaces then

   inputbuf 5 expect         \ ask player for move.

   inputbuf c@ [CHAR] Q = if quit then
   0 inpos startingm !
   2 inputbuf + c@ [CHAR] - = and \ check whether (it) is found between the fields
   3 inpos bestm !
   and                       \ is all input correct? (flag on the stack.)
   bestm @ f0 and start c@ if 20 else 90 then =
   startingm b@ 07 and 1 =  and \ is it a promotion move
   if
    ." What piece? " 0 0 begin drop drop key promote dup until
    personmove ! emit
   else
    0 personmove !
   then
   if                     \ if all input is correct
    ['] legal is tmove
    0 #legal !            \ no legal moves generated
    startingm c@ starting c! ?piecemove \ generate the moves from start field.
    #legal @              \ if the move is legal, that it is generated
   else
    0                     \ no legal input = no legal move
   then
   dup 0=  start c@ and if -1 move# +! then
  until                   \ now legal move entered.
  bp1 bp0 c0 cmove        \ set position in memory
  changecolor




  cr




 .board ;

: setmove ( -- ) \ carry out a move or accept a move.
  compcolor @ 0<  start c@ 80 =  = if compmove else person then ;

variable manVsMachine

: askcolor ( -- ) \ ask for color
  manVSmachine @
  if ." Do you want White Y/N"
     key dup [CHAR] Y = swap [CHAR] y = or
     if 1 else -1 then compcolor !
  then ;

: asklevel ( -- ) \ ask for playing level
  cr ." Level? 2-"
   maxlevel . key [CHAR] 0 - 2 max maxlevel min playlevel !
  cls ;

: init ( -- ) \ initial board.
  0 level !   bp0 bpv !
  bp c0 87 fill \ add edge markings
  -7879 alfa !  \ this is what the FPC 16 bit ver got from 87 fill
  -7879 beta !
  -7879 (eval) !
  -7879 highest !
  -7879 cutoff !
  -7879 valuew !
  -7879 valueb !
  -7879 played !
  4 2 3 6 5 3 2 4   8 0 do bp 22 + i + c! loop  \ top row of pieces
  bp 32 + 8 01 fill \ top row black Pawns
  bp 42 + 8 00 fill   bp 52 + 8 00 fill
  bp 62 + 8 00 fill   bp 72 + 8 00 fill \ middle 4 rows are empty.
  bp 82 + 8 81 fill \ bottom row White Pawns.
  84 82 83 86 85 83 82 84   8 0 do bp 92 + i + c! loop \ bottom row.
  1 castlew c! 1 castleb c! 0 ep c! 1 wlcastle? c! 1 blcastle? c! 0 advance c!
  80 start c! 96 kingw c! 26 kingb c!
  askcolor cr asklevel
  0 move# ! 0 endf !
  0 check  c! 9c0 valuew ! 9c0 valueb ! ( decimal ) $0A base ! ;

: play ( -- )
  begin setmove endf @ until ;

: games ( -- )  \ play games with the computer
  begin init play again ;

: autoplay ( -- )
  begin setmove compcolor @ negate compcolor ! key? if quit then endf @ until ;

: auto ( -- )
  init -1 compcolor ! autoplay ;

: chess ( -- )
  cls
  ." ANS Forth Chess" cr
  ." Do you want to play against the computer? Y/N" cr
  begin rnd drop key? until key \ set up random generator.
  dup [CHAR] Y = swap [CHAR] y = or dup manVsMachine !
  if games else auto then ;

