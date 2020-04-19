PURPOSE: WINERR definitions
LICENSE: Unlicense since 1999 by Illya Kysil

REQUIRES" sysdict/x86-windows/winconst.4th"

REPORT-NEW-NAME @
REPORT-NEW-NAME OFF


: WIN-ERR>IOR (S 0 -- ior | x -- 0 )
   (G Check BOOL result and convert it to ior if failed )
   0= IF   GetLastError   ELSE   0   THEN
;

: HANDLE-ERR>IOR (S INVALID_HANDLE_VALUE -- ior | x -- 0 )
   (G Check HANDLE result and convert it to ior if failed )
   WINCONST: INVALID_HANDLE_VALUE = IF   GetLastError   ELSE   0   THEN
;


REPORT-NEW-NAME !
