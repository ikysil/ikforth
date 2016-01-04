;******************************************************************************
;
;  thread.inc
;  IKForth
;
;  Copyright (C) 1999-2001 Illya Kysil
;
;******************************************************************************
;  THREAD & support words
;******************************************************************************

;  THREAD-EXIT
                        $DEF    'THREAD-EXIT',$THREAD_EXIT
                        MOV     ESI,[DWORD PTR EDI + ESI_VAR]
                        MOV     EBP,[DWORD PTR EDI + EBP_VAR]
                        MOV     ESP,[DWORD PTR EDI + ESP_VAR]
                        MOV     EBX,[DWORD PTR EDI + EBX_VAR]
                        PUSHDS  <[DWORD PTR EDI + RETURN_ADDR_VAR]>
                        MOV     EDI,[DWORD PTR EDI + EDI_VAR]
                        RET

THREAD_PROC:
                        POPDS   EDX                     ; return address
                        MOV     EAX,EDI
                        POPDS   EDI                     ; user data pointer
                        MOV     [DWORD PTR EDI + RETURN_ADDR_VAR],EDX
                        MOV     [DWORD PTR EDI + EDI_VAR],EAX
                        MOV     [DWORD PTR EDI + ESI_VAR],ESI
                        MOV     [DWORD PTR EDI + EBP_VAR],EBP
                        MOV     [DWORD PTR EDI + EBX_VAR],EBX
                        MOV     EBP,EDI
                        ADD     EBP,RSTACK_VAR
                        MOV     ESI,OFFSET DO_THREAD + DESIRED_BASE_EQU
                        POPDS   EAX
                        MOV     [DWORD PTR EDI + ESP_VAR],ESP
                        PUSHDS  EAX
                        $NEXT
DO_THREAD:
                        CW      $CATCH
                        CW      $DROP
                        CW      $THREAD_EXIT

;  THREAD
                        $DEF    'THREAD',$THREAD
                        PUSHDS  EDI
                        $CALL   START_THREAD_FUNC
                        PUSHDS  EAX
                        $NEXT

