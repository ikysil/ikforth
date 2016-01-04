\
\  winconsole.f
\
\  Copyright (C) 1999-2003 Illya Kysil
\

CR .( Loading WINCONSOLE definitions )

CREATE-REPORT @
CREATE-REPORT OFF

BASE @

DECIMAL

0 VALUE STDIN
0 VALUE STDOUT
0 VALUE STDERR

:NONAME STD_INPUT_HANDLE  GetStdHandle TO STDIN
        STD_OUTPUT_HANDLE GetStdHandle TO STDOUT
        STD_ERROR_HANDLE  GetStdHandle TO STDERR ;
DUP STARTUP-CHAIN CHAIN.ADD EXECUTE

USER NumberOfConsoleInputEvents 1 CELLS USER-ALLOC

: WIN-CONSOLE-EKEY? ( -- flag ) \ 93 FACILITY EXT
\ If a keyboard event is available, return true. Otherwise return false.
\ The event shall be returned by the next execution of EKEY.
\ After EKEY? returns with a value of true, subsequent executions of EKEY?
\ prior to the execution of KEY, KEY? or EKEY also return true,
\ referring to the same event.
  NumberOfConsoleInputEvents STDIN GetNumberOfConsoleInputEvents DROP
  NumberOfConsoleInputEvents @ 0<>
;

USER INPUT_RECORD 20 ( /INPUT_RECORD) USER-ALLOC

: ControlKeysMask ( -- u )
\ вернуть маску управляющих клавиш для последнего клавиатурного события.
  INPUT_RECORD ( Event dwControlKeyState ) 16 + @
;

USER NumberOfRecordsRead 1 CELLS USER-ALLOC

DECIMAL

: WIN-CONSOLE-EKEY ( -- u ) \ 93 FACILITY EXT
\ Принять одно клавиатурное событие u. Кодирование клавиатурных событий
\ зависит от реализации.
\ В данной реализации
\ byte  value
\    0  AsciiChar
\    2  ScanCod
\    3  KeyDownFlag
  NumberOfRecordsRead 1 INPUT_RECORD STDIN ReadConsoleInput DROP INPUT_RECORD
  DUP  ( EventType ) W@ KEY_EVENT <> IF DROP 0 EXIT THEN
  DUP  ( Event AsciiChar       ) 14 + W@
  OVER ( Event wVirtualScanCode) 12 + W@  16 LSHIFT OR
  OVER ( Event bKeyDown        ) 04 + C@  24 LSHIFT OR
  NIP
;

HEX

: WIN-CONSOLE-EKEY>CHAR ( u -- u false | char true ) \ 93 FACILITY EXT
\ Если клавиатурное событие u соответствует символу - вернуть символ и
\ "истину". Иначе u и "ложь".
  DUP    FF000000 AND  0=   IF FALSE    EXIT THEN
  DUP    000000FF AND  DUP  IF NIP TRUE EXIT THEN DROP
  FALSE
;

: EKEY>SCAN ( u -- scan flag )
\ вернуть скан-код клавиши, соответствующей клавиатурному событию u
\ flag=true - клавиша нажата. flag=false - отпущена.
  DUP  10 RSHIFT  000000FF AND
  SWAP FF000000 AND 0<>
;

DECIMAL

VARIABLE PENDING-CHAR \ клавиатура одна -> переменная глобальная, не USER

: WIN-CONSOLE-KEY? ( -- flag ) \ 94 FACILITY
\ Если символ доступен, вернуть "истину". Иначе "ложь". Если несимвольное
\ клавиатурное событие доступно, оно отбрасывается и больше недоступно.
\ Символ будет возвращен следующим выполнением KEY.
\ После того как KEY? возвратило значение "истина", следующие выполнения
\ KEY? до выполнения KEY или EKEY также возвращают "истину" без отбрасывания
\ клавиатурных событий.
  PENDING-CHAR @ 0 > IF TRUE EXIT THEN
  BEGIN
    EKEY?
  WHILE
    EKEY  EKEY>CHAR
    IF PENDING-CHAR ! TRUE EXIT THEN
    DROP
  REPEAT FALSE
;

: WIN-CONSOLE-KEY ( -- char ) \ 94
\ Принять один символ char. Клавиатурные события, не соответствующие
\ символам, отбрасываются и более не доступны.
\ Могут быть приняты все стандартные символы. Символы, принимаемые по KEY,
\ не отображаются на дисплее.
\ Программы, требующие возможность получения управляющих символов,
\ зависят от окружения.
  PENDING-CHAR @ 0 >
  IF PENDING-CHAR @ -1 PENDING-CHAR ! EXIT THEN
  BEGIN
    EKEY EKEY>CHAR 0=
  WHILE
    DROP
  REPEAT
;

' WIN-CONSOLE-EKEY?     IS EKEY?
' WIN-CONSOLE-EKEY      IS EKEY
' WIN-CONSOLE-EKEY>CHAR IS EKEY>CHAR
' WIN-CONSOLE-KEY?      IS KEY?
' WIN-CONSOLE-KEY       IS KEY

BASE !

CREATE-REPORT !
