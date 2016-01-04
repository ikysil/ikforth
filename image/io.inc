;******************************************************************************
;
;  io.inc
;  IKForth
;
;  Copyright (C) 1999-2001 Illya Kysil
;
;******************************************************************************
;  I/O
;******************************************************************************

;  6.1.0695 ACCEPT
                        $DEF    'ACCEPT',$ACCEPT
                        $CALL   ACCEPT_FUNC
                        PUSH    EAX
                        $NEXT

;  6.1.1320 EMIT
;  Emit a char to output
;  D: char --
                        $DEF    'EMIT',$EMIT
                        $CALL   EMIT_FUNC
                        $NEXT

;  6.1.2310 TYPE
;  Display the character string specified by addr and length n
;  D: addr n --
                        $DEF    'TYPE',$TYPE
                        $CALL   TYPE_FUNC
                        $NEXT

;  (TYPE)
                        $COLON  '(TYPE)',$PTYPE
                        CW      $RFROM                  ; a
                        CW      $COUNT                  ; a+1 b
                        CW      $OVER                   ; a+1 b a+1
                        CW      $OVER                   ; a+1 b a+1 b
                        CW      $ADD                    ; a+1 b a+1+b
                        CW      $TOR                    ; a+1 b
                        CW      $TYPE
                        CW      $EXIT

