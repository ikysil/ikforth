;******************************************************************************
;
;  except.inc
;  IKForth
;
;  Copyright (C) 1999-2001 Illya Kysil
;
;******************************************************************************
;  EXCEPTION words
;******************************************************************************

;  9.6.1.0875 CATCH 
                        $COLON  'CATCH',$CATCH
                        CW      $SPFETCH
                        CW      $TOR
                        CW      $EXCEPTION_HANDLER
                        CW      $FETCH
                        CW      $TOR
                        CW      $RPFETCH
                        CW      $EXCEPTION_HANDLER
                        CW      $STORE
                        CW      $EXECUTE
                        CW      $RFROM
                        CW      $EXCEPTION_HANDLER
                        CW      $STORE
                        CW      $RFROM
                        CW      $DROP
                        CW      $ZERO
                        CW      $EXIT

;  (THROW)
;  D: exc-id --
                        $COLON  '(THROW)',$PTHROW
                        CW      $EXCEPTION_HANDLER
                        CW      $FETCH
                        CW      $RPSTORE
                        CW      $RFROM
                        CW      $EXCEPTION_HANDLER
                        CW      $STORE
                        CW      $RFROM
                        CW      $SWAP
                        CW      $TOR
                        CW      $SPSTORE
                        CW      $DROP
                        CW      $RFROM
                        CW      $EXIT

;  9.6.1.2275 THROW
                        $COLON  'THROW',$THROW
                        CW      $ZERO
                        CW      $DUP
                        CW      $THROW_ADDRESS
                        CW      $STORE
                        CW      $THROW_WORD
                        CW      $STORE

                        CW      $QDUP
                        CW      $QBRANCH
                        CW      THROW_EXIT
                          CW      $PTHROW
THROW_EXIT:
                        CW      $EXIT
