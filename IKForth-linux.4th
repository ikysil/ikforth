include" lib/~ik/constdict.4th"

\ TRACE-STACK
\ TRACE-WORD

BEGIN-CONST
REQUIRES" build/linconst-extract/linconst.f"
END-CONST
CONSTDICT-HASH LINCONST

BEGIN-CONST
REQUIRES" build/winconst-extract/winconst.f"
END-CONST
CONSTDICT-HASH WINCONST
