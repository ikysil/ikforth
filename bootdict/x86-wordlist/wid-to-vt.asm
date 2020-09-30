;  WID>VT
;  D: ( wid -- wid-vt-addr )
                $CODE       'WID>VT',$WID_TO_VT
                POPDS       EAX
                ADD         EAX,CELL_SIZE * 3
                PUSHDS      EAX
                $NEXT
