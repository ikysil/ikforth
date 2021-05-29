;******************************************************************************
;
;  except.asm
;  IKForth
;
;  Unlicense since 1999 by Illya Kysil
;
;******************************************************************************
;  EXCEPTION words
;******************************************************************************

;  EXCS-SIZE
                $CONST      'EXCS-SIZE',,EXCEPTION_STACK_SIZE

                $USER       'EXCP',$EXCP,VAR_EXCP

;  EXCP@
                $COLON      'EXCP@',$EXCPFETCH,VEF_USUAL
                CFETCH      $EXCP
                $END_COLON

;  EXCP!
                $COLON      'EXCP!',$EXCPSTORE,VEF_USUAL
                CSTORE      $EXCP
                $END_COLON

;  >EXC
;  Move value from the data stack to exception stack
;  D: a --
;  EXC:   -- a
                $COLON      '>EXC',$TOEXC
                CW          $EXCPFETCH
                CCLIT       CELL_SIZE
                CW          $MINUS, $SWAP, $OVER, $STORE, $EXCPSTORE
                $END_COLON

;  EXC>
;  Move x from the exception stack to the data stack.
;  ( D: -- x ) ( EXC:  x -- )
                $COLON      'EXC>',$EXCFROM
                CW          $EXCPFETCH, $DUP, $FETCH, $SWAP, $CELL_PLUS, $EXCPSTORE
                $END_COLON

;  EXC@
;  Copy value from the exception stack to data stack
;  EXC: a -- a
;  D:   -- a
                $COLON      'EXC@',$EXCFETCH,VEF_USUAL
                CW          $EXCPFETCH, $FETCH
                $END_COLON

;  Return depth of exception stack
;  D:   -- a
                $COLON      'EXC-DEPTH',$EXCDEPTH,VEF_USUAL
                CW          $EXCP0, $EXCPFETCH, $MINUS, $STOD
                CCLIT       CELL_SIZE
                CW          $U_M_SLASH_MOD, $SWAP, $DROP
                $END_COLON

;  EXC-DROP
;  Drop value from the exception stack
;  EXC: a --
                $COLON      'EXC-DROP',$EXCDROP
                CW          $EXCFROM, $DROP
                $END_COLON

                $DEFER      'EXC-FRAME-PUSH',$EXC_FRAME_PUSH,$PEXC_FRAME_PUSH

                $COLON      '(EXC-FRAME-PUSH)',$PEXC_FRAME_PUSH
                $END_COLON

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
                $COLON      '(EXC-PUSH)',$PEXC_PUSH
                CW          $SPFETCH, $RFROM, $SWAP, $TOEXC
                CFETCH      $EXCEPTION_HANDLER
                CW          $TOEXC, $RPFETCH, $TOEXC
                CWLIT       $PEXC_POP_THROW
                CW          $TOEXC, $EXCPFETCH, $EXC_FRAME_PUSH, $TOEXC, $EXCPFETCH
                CSTORE      $EXCEPTION_HANDLER
                CW          $TO_R
                $END_COLON

;  pop exception frame from exception stack
;  restore EXCEPTION-HANDLER
;  EXC: see table above --
                $COLON      '(EXC-POP-CATCH)',$PEXC_POP_CATCH
;  skip optional exception frame data
                CW          $EXCFROM, $EXCPSTORE
;  process mandatory exception frame data
                CW          $EXCDROP, $EXCDROP, $EXCFROM
                CSTORE  $EXCEPTION_HANDLER
                CW          $EXCDROP
                $END_COLON

;  restore execution environment from exception stack
;  restore SP, RP, EXCP, and EXCEPTION-HANDLER
;  EXC: see table above --
;  (THROW)
;  D: exc-id --
                $COLON      '(THROW)',$PTHROW
                CFETCH      $EXCEPTION_HANDLER
                CW          $EXCPSTORE
;  skip the address of the mandatory exception frame data
                CW          $EXCDROP
;  execute chain to restore execution environment from optional data
                _BEGIN      PTHROW_CHAIN
                CW          $EXCFROM, $EXECUTE
                _AGAIN      PTHROW_CHAIN
                $END_COLON

                $COLON      '(EXC-POP-THROW)',$PEXC_POP_THROW
                CW          $EXCFROM, $RPSTORE, $EXCFROM
                CSTORE      $EXCEPTION_HANDLER
                CW          $EXCFROM, $SWAP, $TO_R, $SPSTORE, $DROP, $RFROM
                $END_COLON

;  9.6.1.0875 CATCH
;  D: x*i xt -- x*j 0 | x*i exc-id
                $COLON      'CATCH',$CATCH
                CW          $PEXC_PUSH, $EXECUTE, $PEXC_POP_CATCH, $ZERO
                $END_COLON

;  9.6.1.2275 THROW
;  D: exc-id --
                $COLON      'THROW',$THROW
                MATCH       =TRUE, DEBUG {
                $TRACE_WORD
                $TRACE_STACK 'THROW',1
                }
                CW          $QDUP
                _IF         THROW_HAS_EXCEPTION
                CW          $PTHROW
                _THEN       THROW_HAS_EXCEPTION
                $END_COLON

