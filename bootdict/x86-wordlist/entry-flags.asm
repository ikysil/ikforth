;   PURPOSE: Wordlist entry flags modification
;   LICENSE: Unlicense since 1999 by Illya Kysil

;  HFLAGS!
;  D: x h-id --
;  Store flags specified by x to the flags field of the header
                $COLON      'HFLAGS!',$HFLAGS_STORE
                CW          $NAME_TO_FLAGS, $C_STORE
                $END_COLON

;  HFLAGS@
;  D: h-id -- x
;  Get flags from the flags field of the header
                $COLON      'HFLAGS@',$HFLAGS_FETCH
                CW          $NAME_TO_FLAGS, $C_FETCH
                $END_COLON

;  SET-HFLAGS!
;  D: flags --
                $COLON      'SET-HFLAGS!'
                CW          $LATEST_NAME_FETCH, $DUPE, $HFLAGS_FETCH, $ROTE, $OR, $SWAP, $HFLAGS_STORE
                $END_COLON

;  RESET-HFLAGS!
;  D: flags --
                $COLON      'RESET-HFLAGS!'
                CW          $LATEST_NAME_FETCH, $DUPE, $HFLAGS_FETCH, $ROTE, $INVERT, $AND, $SWAP, $HFLAGS_STORE
                $END_COLON

;  INVERT-HFLAGS!
;  D: flags --
                $COLON      'INVERT-HFLAGS!'
                CW          $LATEST_NAME_FETCH, $DUPE, $HFLAGS_FETCH, $ROTE, $X_OR, $SWAP, $HFLAGS_STORE
                $END_COLON
