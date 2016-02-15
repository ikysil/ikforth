;******************************************************************************
;
;  except.inc
;  IKForth
;
;  Copyright (C) 1999-2016 Illya Kysil
;
;******************************************************************************
;  EXCEPTION words
;******************************************************************************

;  EXCS-SIZE
                        $CONST  'EXCS-SIZE',,EXCEPTION_STACK_SIZE

;  EXCP0
                        $CODE   'EXCP0',$EXCP0,VEF_USUAL

                        LEA     EAX,DWORD [EDI + VAR_EXC_STACK]
                        PUSHDS  EAX
                        $NEXT

                        $USER   'EXCP',$EXCP,VAR_EXCP

;  EXCP@
                        $COLON  'EXCP@',$EXCPFETCH,VEF_USUAL
                        CFETCH  $EXCP
                        CEXIT

;  EXCP!
                        $COLON  'EXCP!',$EXCPSTORE,VEF_USUAL
                        CSTORE  $EXCP
                        CEXIT

;  >EXC
;  Move value from the data stack to exception stack
;  D: a --
;  EXC:   -- a
                        $COLON  '>EXC',$TOEXC
                        CW      $EXCPFETCH
                        CCLIT   CELL_SIZE
                        CW      $SUB
                        CW      $SWAP
                        CW      $OVER
                        CW      $STORE
                        CW      $EXCPSTORE
                        CEXIT

;  EXC>
;  Move x from the exception stack to the data stack.
;  ( D: -- x ) ( EXC:  x -- )
                        $COLON  'EXC>',$EXCFROM
                        CW      $EXCPFETCH
                        CW      $DUP
                        CW      $FETCH
                        CW      $SWAP
                        CW      $CELLADD
                        CW      $EXCPSTORE
                        CEXIT

;  EXC@
;  Copy value from the exception stack to data stack
;  EXC: a -- a
;  D:   -- a
                        $COLON  'EXC@',$EXCFETCH,VEF_USUAL
                        CW      $EXCPFETCH
                        CW      $FETCH
                        CEXIT

;  Return depth of exception stack
;  D:   -- a
                        $COLON  'EXC-DEPTH',$EXCDEPTH,VEF_USUAL
                        CW      $EXCP0
                        CW      $EXCPFETCH
                        CW      $SUB
                        CW      $STOD
                        CCLIT   CELL_SIZE
                        CW      $UMDIVMOD
                        CW      $SWAP
                        CW      $DROP
                        CEXIT

;  EXC-DROP
;  Drop value from the exception stack
;  EXC: a --
                        $COLON  'EXC-DROP',$EXCDROP
                        CW      $EXCFROM
                        CW      $DROP
                        CEXIT

                        $DEFER  'EXC-FRAME-PUSH',$EXC_FRAME_PUSH,$PEXC_FRAME_PUSH

                        $COLON  '(EXC-FRAME-PUSH)',$PEXC_FRAME_PUSH
                        CEXIT

;  push exception frame to exception stack
;  new EXCEPTION-HANDLER points to the EXCP + 0
;  EXC: -- see table below
;  offset (cells)    VALUE
;  + 0               address of mandatory exception frame data (EXCP + x*i + 1)
;  + x*i             optional exception frame data
;  + x*i + 1         ' (EXC-POP-THROW)
;  + x*i + 2         old RP@
;  + x*i + 3         old EXCEPTION-HANDLER
;  + x*i + 4         old SP@
;  the optional exception frame data consists of the blocks of following data:
;  x*j xt
;  where xt is the word to process the x*j data cells from exception stack
;  these blocks are pushed by the EXC-FRAME-PUSH chain
;  words in EXC-FRAME-PUSH has the following stack effects:
;  EXC: -- x*j xt
;  each word MUST invoke the DEFERRED EXC-FRAME-PUSH
;
;  xt has following stack effects:
;  EXC: x*j --
;  D: exc-id --
;  the chain will be invoked by THROW runtime in reverse order
                        $COLON  '(EXC-PUSH)',$PEXC_PUSH
                        CW      $SPFETCH
                        CW      $RFROM
                        CW      $SWAP
                        CW      $TOEXC
                        CFETCH  $EXCEPTION_HANDLER
                        CW      $TOEXC
                        CW      $RPFETCH
                        CW      $TOEXC
                        CWLIT   $PEXC_POP_THROW
                        CW      $TOEXC
                        CW      $EXCPFETCH
                        CW      $EXC_FRAME_PUSH
                        CW      $TOEXC
                        CW      $EXCPFETCH
                        CSTORE  $EXCEPTION_HANDLER
                        CW      $TOR
                        CEXIT

;  pop exception frame from exception stack
;  restore EXCEPTION-HANDLER
;  EXC: see table above --
                        $COLON  '(EXC-POP-CATCH)',$PEXC_POP_CATCH
;  skip optional exception frame data
                        CW      $EXCFROM
                        CW      $EXCPSTORE
;  process mandatory exception frame data
                        CW      $EXCDROP
                        CW      $EXCDROP
                        CW      $EXCFROM
                        CSTORE  $EXCEPTION_HANDLER
                        CW      $EXCDROP
                        CEXIT

;  restore execution environment from exception stack
;  restore SP, RP, EXCP, and EXCEPTION-HANDLER
;  EXC: see table above --
;  (THROW)
;  D: exc-id --
                        $COLON  '(THROW)',$PTHROW
                        CFETCH  $EXCEPTION_HANDLER
                        CW      $EXCPSTORE
;  skip the address of the mandatory exception frame data
                        CW      $EXCDROP
;  execute chain to restore execution environment from optional data
PTHROW_CHAIN:
                        CW      $EXCFROM
                        CW      $EXECUTE
                        CBR     PTHROW_CHAIN
                        CEXIT

                        $COLON  '(EXC-POP-THROW)',$PEXC_POP_THROW
                        CW      $EXCFROM
                        CW      $RPSTORE
                        CW      $EXCFROM
                        CSTORE  $EXCEPTION_HANDLER
                        CW      $EXCFROM
                        CW      $SWAP
                        CW      $TOR
                        CW      $SPSTORE
                        CW      $DROP
                        CW      $RFROM
                        CEXIT

;  9.6.1.0875 CATCH
;  D: x*i xt -- x*j 0 | x*i exc-id
                        $COLON  'CATCH',$CATCH

                        CW      $PEXC_PUSH
                        CW      $EXECUTE
                        CW      $PEXC_POP_CATCH
                        CW      $ZERO
                        CEXIT

;  9.6.1.2275 THROW
;  D: exc-id --
                        $COLON  'THROW',$THROW

                        CW      $QDUP
                        CQBR    THROW_EXIT
                          CW      $PTHROW
THROW_EXIT:
                        CEXIT

