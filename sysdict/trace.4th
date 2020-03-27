\
\  trace.4th
\
\  Unlicense since 1999 by Illya Kysil
\

CR .( Loading TRACE definitions )

REPORT-NEW-NAME @
REPORT-NEW-NAME OFF


DEFER TRACE (S xt -- )

: TRACE-OFF (G Turn off tracing )
   ['] DROP IS TRACE
;

TRACE-OFF

: .TRACE-WORD-NAME
   \ S: xt --
   \ Print the name of the word or (noname)
   >HEAD H>#NAME
   ?DUP IF   TYPE   ELSE   DROP ." (noname)"   THEN
;

: .TRACE-WORD (S xt -- )
   ." [" .TRACE-WORD-NAME ." ]"
;

: TRACE-WORD (G Turn on word tracing - print name of every word executed )
   ['] .TRACE-WORD IS TRACE
;

: .TRACE-STACK (S xt -- )
   ." [" .TRACE-WORD-NAME SPACE H.S ." ]" CR
;

: TRACE-STACK (G Turn on stack tracing - print name of every word executed and contents of the stack )
   ['] .TRACE-STACK IS TRACE
;

: (NOTRACE-:) : ;

: TRACE-: : RECURSE-XT @ POSTPONE LITERAL POSTPONE TRACE ;

DEFER :
' (NOTRACE-:) IS :

: TRACE-BEGIN ['] TRACE-: IS : ;

: TRACE-END   ['] (NOTRACE-:) IS : ;

REPORT-NEW-NAME !
