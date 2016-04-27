;  EXCP0
;  S: -- excp0
;  Return base address of exception stack
                $CODE       'EXCP0',$EXCP0,VEF_USUAL
                LEA         EAX,DWORD [EDI + VAR_EXC_STACK]
                PUSHDS      EAX
                $NEXT
