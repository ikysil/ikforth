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

                        MOV     ESI,[EDI + ESI_VAR]
                        MOV     EBP,[EDI + EBP_VAR]
                        MOV     ESP,[EDI + ESP_VAR]
                        MOV     EBX,[EDI + EBX_VAR]
; remove per-thread exception handler data
                        POPDS   FS:[0]
                        ADD     ESP,4

                        PUSHDS  [EDI + RETURN_ADDR_VAR]
                        MOV     EDI,[EDI + EDI_VAR]
                        RET

THREAD_PROC:
                        POPDS   EDX                     ; return address
                        MOV     EAX,EDI
                        POPDS   EDI                     ; user data pointer
                        POPDS   ECX                     ; xt

                        MOV     [EDI + RETURN_ADDR_VAR],EDX
                        MOV     [EDI + EDI_VAR],EAX
                        MOV     [EDI + ESI_VAR],ESI
                        MOV     [EDI + EBP_VAR],EBP
                        MOV     [EDI + EBX_VAR],EBX

; setup per-thread exception handler
                        LEA     EAX,SEH_HANDLER - SIGN + DESIRED_BASE_EQU
                        PUSHDS  EAX
                        PUSHDS  FS:[0]
                        MOV     FS:[0],ESP

                        MOV     EBP,EDI
                        ADD     EBP,RSTACK_VAR
                        MOV     [EDI + ESP_VAR],ESP
                        PUSHDS  ECX
                        LEA     ESI,DO_THREAD - SIGN + DESIRED_BASE_EQU
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
                        MOV     EBX,[EBP + 08h] ; get pointer to ExceptionRecord
                        MOV     EAX,[EBX]       ; get exception code
                        MOV     EBX,[EBP + 10h] ; get pointer to CONTEXT
; store CONTEXT
                        MOV     ECX,0CCh
                        MOV     ESI,EBX
; load EDI with UDP
                        MOV     EDI,[EBX + 39 * 4]
                        ADD     EDI,WIN32_EXCEPTION_CONTEXT_VAR
                REP     MOVSB
; fixup CONTEXT.EIP
                        MOV     [EBX + 46 * 4],OFFSET DO_SEH - SIGN + DESIRED_BASE_EQU
; fixup CONTEXT.EAX (= Win32 exception code)
                        MOV     [EBX + 44 * 4],EAX
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
                        LEA     ESI,DO_FORTH_SEH - SIGN + DESIRED_BASE_EQU
                        $NEXT
DO_FORTH_SEH:
                        CW      $SEH_HANDLER
                        CW      $THROW

;  (SEH-HANDLER)
;  D: win32-exc-id -- exc-id
                        $COLON  '(SEH-HANDLER)',$PSEH_HANDLER,VEF_USUAL

                        CEXIT

;  SEH-HANDLER
;  D: win32-exc-id -- exc-id
                        $DEFER  'SEH-HANDLER',$SEH_HANDLER

                        CW      $PSEH_HANDLER

                        $USER   'WIN32-EXCEPTION-CONTEXT',$WIN32_EXCEPTION_CONTEXT

                        CC      WIN32_EXCEPTION_CONTEXT_VAR

