START:
; typedef struct _MainProcContext {
;     int           argc;
;     char const ** argv;
;     char const ** envp;
;     char const *  startFileName;
;     int           startFileNameLength;
;     int  const *  exitCode;
;     void const ** sysfunctions;
; } MainProcContext;
;
; typedef void __stdcall (* MainProc)(MainProcContext *);
                POP         EAX     ; move return address away
                POP         ESI     ; get address of MainProcContext
                PUSH        EAX
                MOV         EBX,IMAGE_BASE
                CLD
                LEA         EDI,[EBX + ARGC_VAR]
                MOVSD
                LEA         EDI,[EBX + ARGV_VAR]
                MOVSD
                LEA         EDI,[EBX + ENVP_VAR]
                MOVSD
                LEA         EDI,[EBX + SF_VAR]
                MOVSD
                LEA         EDI,[EBX + HASH_SF_VAR]
                MOVSD
                LEA         EDI,[EBX + EXIT_CODE_VAR]
                MOVSD
                LEA         EDI,[EBX + FUNC_TABLE_VAR]
                MOVSD
                MOV         EAX,DWORD [EBX + MAIN_PROC_VAR]
                PUSH        EAX
                PUSH        F_FALSE
                PUSH        0
                $CSYSCALL   START_THREAD
                RET
