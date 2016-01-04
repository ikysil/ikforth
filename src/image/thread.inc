;******************************************************************************
;
;  thread.inc
;  IKForth
;
;  Copyright (C) 1999-2003 Illya Kysil
;
;******************************************************************************
;  THREAD & support words
;******************************************************************************

;  THREAD-EXIT
                        $CODE   'THREAD-EXIT',$THREAD_EXIT
                        MOV     ESI,[DWORD PTR EDI + ESI_VAR]
                        MOV     EBP,[DWORD PTR EDI + EBP_VAR]
                        MOV     ESP,[DWORD PTR EDI + ESP_VAR]
                        MOV     EBX,[DWORD PTR EDI + EBX_VAR]
; remove per-thread exception handler data
                        POPDS   <[DWORD PTR FS:0]>
                        ADD     ESP,4

                        PUSHDS  <[DWORD PTR EDI + RETURN_ADDR_VAR]>
                        MOV     EDI,[DWORD PTR EDI + EDI_VAR]
                        RET

THREAD_PROC:
                        POPDS   EDX                     ; return address
                        MOV     EAX,EDI
                        POPDS   EDI                     ; user data pointer
                        POPDS   ECX                     ; xt

; setup per-thread exception handler
                        PUSHDS  <OFFSET SEH_HANDLER + DESIRED_BASE_EQU>
                        PUSHDS  <[DWORD PTR FS:0]>
                        MOV     [DWORD PTR FS:0],ESP

                        MOV     [DWORD PTR EDI + RETURN_ADDR_VAR],EDX
                        MOV     [DWORD PTR EDI + EDI_VAR],EAX
                        MOV     [DWORD PTR EDI + ESI_VAR],ESI
                        MOV     [DWORD PTR EDI + EBP_VAR],EBP
                        MOV     [DWORD PTR EDI + EBX_VAR],EBX
                        MOV     EBP,EDI
                        ADD     EBP,RSTACK_VAR
                        MOV     [DWORD PTR EDI + ESP_VAR],ESP
                        PUSHDS  ECX
                        MOV     ESI,OFFSET DO_THREAD + DESIRED_BASE_EQU
                        $NEXT
DO_THREAD:
                        CW      $CATCH
                        CW      $DROP
                        CW      $THREAD_EXIT

SEH_HANDLER:
                        PUSH    EBP
                        MOV     EBP,ESP
                        PUSH    EBX
                        PUSH    EDI
                        PUSH    ESI
                        MOV     EBX,[DWORD PTR EBP + 08h] ; get pointer to ExceptionRecord
                        MOV     EAX,[DWORD PTR EBX]       ; get exception code
                        MOV     EBX,[DWORD PTR EBP + 10h] ; get pointer to CONTEXT
; store CONTEXT
                        MOV     ECX,0CCh
                        MOV     ESI,EBX
; load EDI with UDP
                        MOV     EDI,[DWORD PTR EBX + 39 * 4]
                        ADD     EDI,WIN32_EXCEPTION_CONTEXT_VAR
                REP     MOVSB
; fixup CONTEXT.EIP
                        MOV     [DWORD PTR EBX + 46 * 4],OFFSET DO_SEH + DESIRED_BASE_EQU
; fixup CONTEXT.EAX (= Win32 exception code)
                        MOV     [DWORD PTR EBX + 44 * 4],EAX
; eax=0 reload context & continue execution
                        MOV     EAX,0                     
                        POP     ESI
                        POP     EDI
                        POP     EBX
                        MOV     ESP,EBP
                        POP     EBP
                        RET
DO_SEH:
                        PUSHDS  EAX
                        MOV     ESI,OFFSET DO_FORTH_SEH + DESIRED_BASE_EQU
                        $NEXT
DO_FORTH_SEH:
                        CW      $SEH_HANDLER
                        CW      $THROW

;  (SEH-HANDLER)
;  D: win32-exc-id -- exc-id
                        $COLON  '(SEH-HANDLER)',$PSEH_HANDLER
                        CEXIT

;  SEH-HANDLER
;  D: win32-exc-id -- exc-id
                        $DEFER  'SEH-HANDLER',$SEH_HANDLER
                        CW      $PSEH_HANDLER

                        $USER   'WIN32-EXCEPTION-CONTEXT',$WIN32_EXCEPTION_CONTEXT
                        CC      WIN32_EXCEPTION_CONTEXT_VAR

