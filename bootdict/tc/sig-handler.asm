;  SIG-HANDLER
;  D: signal-id -- signal-id
                $DEFER      'SIG-HANDLER',$SIG_HANDLER,$PSIG_HANDLER

;  (SIG-HANDLER)
;  D: signal-id -- signal-id
                $COLON      '(SIG-HANDLER)',$PSIG_HANDLER,VEF_USUAL
                $END_COLON
