;******************************************************************************
;
;  except.inc
;  IKForth
;
;  Copyright (C) 1999-2003 Illya Kysil
;
;******************************************************************************
;  EXCEPTION words
;******************************************************************************

                        $COLON  'EXC-PUSH',$EXC_PUSH

                        CW      $SPFETCH
                        CW      $RFROM
                        CW      $SWAP
                        CW      $TOR
                        CFETCH  $EXCEPTION_HANDLER
                        CW      $TOR
                        CW      $RPFETCH
                        CSTORE  $EXCEPTION_HANDLER
                        CW      $TOR
                        CEXIT

                        $COLON  'EXC-DROP',$EXC_DROP

                        CW      $RFROM
                        CW      $RFROM
                        CSTORE  $EXCEPTION_HANDLER
                        CW      $RFROM
                        CW      $DROP
                        CW      $TOR
                        CEXIT

;  9.6.1.0875 CATCH 
                        $COLON  'CATCH',$CATCH

                        CW      $EXC_PUSH
                        CW      $EXECUTE
                        CW      $EXC_DROP
                        CW      $ZERO
                        CEXIT

;  (THROW)
;  D: exc-id --
                        $COLON  '(THROW)',$PTHROW

                        CFETCH  $EXCEPTION_HANDLER
                        CW      $RPSTORE
                        CW      $RFROM
                        CSTORE  $EXCEPTION_HANDLER
                        CW      $RFROM
                        CW      $SWAP
                        CW      $TOR
                        CW      $SPSTORE
                        CW      $DROP
                        CW      $RFROM
                        CEXIT

;  9.6.1.2275 THROW
                        $COLON  'THROW',$THROW

                        CW      $QDUP
                        CQBR    THROW_EXIT
                          CW      $PTHROW
THROW_EXIT:
                        CEXIT

