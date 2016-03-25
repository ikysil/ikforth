;******************************************************************************
;
;  except.asm
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
                        XT_$EXIT

;  EXCP!
                        $COLON  'EXCP!',$EXCPSTORE,VEF_USUAL
                        CSTORE  $EXCP
                        XT_$EXIT

;  >EXC
;  Move value from the data stack to exception stack
;  D: a --
;  EXC:   -- a
                        $COLON  '>EXC',$TOEXC
                        XT_$EXCPFETCH
                        CCLIT   CELL_SIZE
                        XT_$SUB
                        XT_$SWAP
                        XT_$OVER
                        XT_$STORE
                        XT_$EXCPSTORE
                        XT_$EXIT

;  EXC>
;  Move x from the exception stack to the data stack.
;  ( D: -- x ) ( EXC:  x -- )
                        $COLON  'EXC>',$EXCFROM
                        XT_$EXCPFETCH
                        XT_$DUP
                        XT_$FETCH
                        XT_$SWAP
                        XT_$CELLADD
                        XT_$EXCPSTORE
                        XT_$EXIT

;  EXC@
;  Copy value from the exception stack to data stack
;  EXC: a -- a
;  D:   -- a
                        $COLON  'EXC@',$EXCFETCH,VEF_USUAL
                        XT_$EXCPFETCH
                        XT_$FETCH
                        XT_$EXIT

;  Return depth of exception stack
;  D:   -- a
                        $COLON  'EXC-DEPTH',$EXCDEPTH,VEF_USUAL
                        XT_$EXCP0
                        XT_$EXCPFETCH
                        XT_$SUB
                        XT_$STOD
                        CCLIT   CELL_SIZE
                        XT_$UMDIVMOD
                        XT_$SWAP
                        XT_$DROP
                        XT_$EXIT

;  EXC-DROP
;  Drop value from the exception stack
;  EXC: a --
                        $COLON  'EXC-DROP',$EXCDROP
                        XT_$EXCFROM
                        XT_$DROP
                        XT_$EXIT

                        $DEFER  'EXC-FRAME-PUSH',$EXC_FRAME_PUSH,$PEXC_FRAME_PUSH

                        $COLON  '(EXC-FRAME-PUSH)',$PEXC_FRAME_PUSH
                        XT_$EXIT

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
                        XT_$SPFETCH
                        XT_$RFROM
                        XT_$SWAP
                        XT_$TOEXC
                        CFETCH  $EXCEPTION_HANDLER
                        XT_$TOEXC
                        XT_$RPFETCH
                        XT_$TOEXC
                        CWLIT   $PEXC_POP_THROW
                        XT_$TOEXC
                        XT_$EXCPFETCH
                        XT_$EXC_FRAME_PUSH
                        XT_$TOEXC
                        XT_$EXCPFETCH
                        CSTORE  $EXCEPTION_HANDLER
                        XT_$TOR
                        XT_$EXIT

;  pop exception frame from exception stack
;  restore EXCEPTION-HANDLER
;  EXC: see table above --
                        $COLON  '(EXC-POP-CATCH)',$PEXC_POP_CATCH
;  skip optional exception frame data
                        XT_$EXCFROM
                        XT_$EXCPSTORE
;  process mandatory exception frame data
                        XT_$EXCDROP
                        XT_$EXCDROP
                        XT_$EXCFROM
                        CSTORE  $EXCEPTION_HANDLER
                        XT_$EXCDROP
                        XT_$EXIT

;  restore execution environment from exception stack
;  restore SP, RP, EXCP, and EXCEPTION-HANDLER
;  EXC: see table above --
;  (THROW)
;  D: exc-id --
                        $COLON  '(THROW)',$PTHROW
                        CFETCH  $EXCEPTION_HANDLER
                        XT_$EXCPSTORE
;  skip the address of the mandatory exception frame data
                        XT_$EXCDROP
;  execute chain to restore execution environment from optional data
PTHROW_CHAIN:
                        XT_$EXCFROM
                        XT_$EXECUTE
                        CBR     PTHROW_CHAIN
                        XT_$EXIT

                        $COLON  '(EXC-POP-THROW)',$PEXC_POP_THROW
                        XT_$EXCFROM
                        XT_$RPSTORE
                        XT_$EXCFROM
                        CSTORE  $EXCEPTION_HANDLER
                        XT_$EXCFROM
                        XT_$SWAP
                        XT_$TOR
                        XT_$SPSTORE
                        XT_$DROP
                        XT_$RFROM
                        XT_$EXIT

;  9.6.1.0875 CATCH
;  D: x*i xt -- x*j 0 | x*i exc-id
                        $COLON  'CATCH',$CATCH

                        XT_$PEXC_PUSH
                        XT_$EXECUTE
                        XT_$PEXC_POP_CATCH
                        XT_$ZERO
                        XT_$EXIT

;  9.6.1.2275 THROW
;  D: exc-id --
                        $COLON  'THROW',$THROW

                        XT_$QDUP
                        CQBR    THROW_EXIT
                        XT_$PTHROW
THROW_EXIT:
                        XT_$EXIT

