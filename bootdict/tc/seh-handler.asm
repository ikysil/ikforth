;  SEH-HANDLER
;  D: win32-exc-id -- exc-id
                $DEFER      'SEH-HANDLER',$SEH_HANDLER,$PSEH_HANDLER

;  (SEH-HANDLER)
;  D: win32-exc-id -- exc-id
                $COLON      '(SEH-HANDLER)',$PSEH_HANDLER,VEF_USUAL
                $END_COLON

                $USER       'WIN32-EXCEPTION-CONTEXT',$WIN32_EXCEPTION_CONTEXT,VAR_WIN32_EXCEPTION_CONTEXT
