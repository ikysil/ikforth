;******************************************************************************
;
;  block.inc
;  IKForth
;
;  Copyright (C) 1999-2003 Illya Kysil
;
;******************************************************************************
;  Block words
;******************************************************************************

;  7.6.1.0790 BLK
                        $USER   'BLK',$BLK
                        CC      BLK_VAR

;  BLOCK#
                        $USER   'BLOCK#'
                        CC      BLOCK_NUM_VAR

;  BLOCK-UPDATED
                        $USER   'BLOCK-UPDATED'
                        CC      BLOCK_UPDATED_VAR

;  BLOCK-DATA
                        $USER   'BLOCK-DATA'
                        CC      BLOCK_VAR

;  7.6.1.0800 BLOCK
                        $DEF    'BLOCK',$BLOCK
                        MOV     EAX,[DWORD PTR EDI + BLOCK_NUM_VAR]
                        OR      EAX,EAX
                        JZ      SHORT BLOCK_READ
                        MOV     EAX,[DWORD PTR EDI + BLOCK_UPDATED_VAR]
                        CMP     EAX,F_FALSE
                        JZ      SHORT BLOCK_READ
                        MOV     EBX,EDI
                        ADD     EBX,BLOCK_VAR
                        PUSHDS  EBX
                        PUSHDS  <[DWORD PTR EDI + BLOCK_NUM_VAR]>
                        $CALL   WRITE_BLOCK_FUNC
                        MOV     [DWORD PTR EDI + BLOCK_UPDATED_VAR],F_FALSE
BLOCK_READ:
                        POPDS   EAX
                        MOV     [DWORD PTR EDI + BLOCK_NUM_VAR],EAX
                        MOV     EBX,EDI
                        ADD     EBX,BLOCK_VAR
                        PUSHDS  EBX
                        PUSHDS  EBX
                        PUSHDS  EAX
                        $CALL   READ_BLOCK_FUNC
                        $NEXT

