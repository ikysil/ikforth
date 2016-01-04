;******************************************************************************
;
;  facility.inc
;  IKForth
;
;  Copyright (C) 1999-2001 Illya Kysil
;
;******************************************************************************
;  FACILITY words
;******************************************************************************

;  10.6.1.0742 AT-XY
                        $DEF    'AT-XY',$AT_XY
                        $CALL   AT_XY_FUNC
                        $NEXT

;  10.6.1.2005 PAGE
                        $DEF    'PAGE'
                        $CALL   PAGE_FUNC
                        $NEXT

;  (BYE)
                        $DEF    '(BYE)',$PBYE
                        $CALL   BYE_FUNC
                        $NEXT

