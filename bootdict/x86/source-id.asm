;  6.2.2218 SOURCE-ID
;  Identifies the input source as follows:
;
;  SOURCE-ID       Input source
;  -1              String (via EVALUATE)
;   0              User input device
;  >0              File handle
                $CODE       'SOURCE-ID',$SOURCE_ID,VEF_USUAL
                PUSHDS      <DWORD [EDI + VAR_SOURCE_ID]>
                $NEXT
