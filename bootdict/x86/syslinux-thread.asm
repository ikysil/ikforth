;******************************************************************************
;
;  syslinux-thread.asm
;  IKForth
;
;  Unlicense since 1999 by Illya Kysil
;
;******************************************************************************
;  THREAD & support words
;******************************************************************************

;  LINUX-THREAD-EXIT
                $CODE       'LINUX-THREAD-EXIT',$LINUX_THREAD_EXIT
                MOV         ESI,DWORD [EDI + VAR_ESI]
                MOV         EBP,DWORD [EDI + VAR_EBP]
                MOV         ESP,DWORD [EDI + VAR_ESP]
                MOV         EBX,DWORD [EDI + VAR_EBX]
; remove per-thread exception handler data
;                        POPDS   <DWORD [FS:0]>
;                        ADD     ESP,4
                PUSHDS      <DWORD [EDI + VAR_RETURN_ADDR]>
                MOV         EDI,DWORD [EDI + VAR_EDI]
                RET

LINUX_THREAD_PROC:
                POPDS       EDX                     ; return address
                MOV         EAX,EDI
                POPDS       EDI                     ; user data pointer
                POPDS       ECX                     ; xt
                MOV         DWORD [EDI + VAR_RETURN_ADDR],EDX
                MOV         DWORD [EDI + VAR_EDI],EAX
                MOV         DWORD [EDI + VAR_ESI],ESI
                MOV         DWORD [EDI + VAR_EBP],EBP
                MOV         DWORD [EDI + VAR_EBX],EBX
; setup per-thread exception handler
;                        MOV     EAX,SEH_HANDLER + IMAGE_BASE
;                        PUSHDS  EAX
;                        PUSHDS  <DWORD [FS:0]>
;                        MOV     DWORD [FS:0],ESP
; setup exception stack
                LEA         EAX,DWORD [EDI + VAR_EXC_STACK]
                MOV         DWORD [EDI + VAR_EXCP],EAX
; setup return stack
                LEA         EBP,DWORD [EDI + VAR_RSTACK]

                MOV         DWORD [EDI + VAR_ESP],ESP
                PUSHDS      ECX
                MOV         ESI,DO_LINUX_THREAD + IMAGE_BASE
                $NEXT
DO_LINUX_THREAD:
                CW          $CATCH, $DROP, $LINUX_THREAD_EXIT

SIG_HANDLER:
                PUSH        EBP
                MOV         EBP,ESP
                PUSH        EBX
                PUSH        EDI
                PUSH        ESI
                MOV         EBX,DWORD [EBP + 08h] ; get pointer to ExceptionRecord
                MOV         EAX,DWORD [EBX]       ; get exception code
                MOV         EBX,DWORD [EBP + 10h] ; get pointer to CONTEXT
; store CONTEXT
                MOV         ECX,0CCh
                MOV         ESI,EBX
; load EDI with UDP
                MOV         EDI,DWORD [EBX + 39 * 4]
                ADD         EDI,VAR_WIN32_EXCEPTION_CONTEXT
        REP     MOVSB
; fixup CONTEXT.EIP
                MOV         DWORD [EBX + 46 * 4],DO_SIG + IMAGE_BASE
; fixup CONTEXT.EAX (= Win32 exception code)
                MOV         DWORD [EBX + 44 * 4],EAX
; eax=0 reload context & continue execution
                MOV         EAX,0
                POP         ESI
                POP         EDI
                POP         EBX
                MOV         ESP,EBP
                POP         EBP
                RET
DO_SIG:
                PUSHDS      EAX
                MOV         ESI,DO_FORTH_SIG + IMAGE_BASE
                $NEXT
DO_FORTH_SIG:
                CW          $SIG_HANDLER, $THROW
