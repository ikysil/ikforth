: TEST-STRING-PREFIX?
  S" windir"
  S" windir=123"
  STRING-PREFIX?
  IF ." OK " ELSE ." NOT OK " THEN CR

  S" windirz"
  S" windir=123"
  STRING-PREFIX? INVERT
  IF ." OK " ELSE ." NOT OK " THEN CR

  S" windirz"
  S" windirz=" DROP 3
  STRING-PREFIX? INVERT
  IF ." OK " ELSE ." NOT OK " THEN CR
;

CR
TEST-STRING-PREFIX?

: TEST-KEY=VALUE?
  S" windir"
  S" windir=123"
  KEY=VALUE?
  IF ." OK " ELSE ." NOT OK " THEN TYPE CR

  S" windirz"
  S" windir=123"
  KEY=VALUE? INVERT
  IF ." OK " ELSE ." NOT OK " THEN TYPE CR

  S" windirz"
  S" windirz=" DROP 3
  KEY=VALUE? INVERT
  IF ." OK " ELSE ." NOT OK " THEN TYPE CR
;

CR
TEST-KEY=VALUE?

