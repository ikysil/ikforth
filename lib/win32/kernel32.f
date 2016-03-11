\
\  kernel32.f
\
\  Copyright (C) 1999-2016 Illya Kysil
\

REQUIRES" lib/win32/dllintf.f"

CR .( Loading KERNEL32 definitions )

REPORT-NEW-NAME @
REPORT-NEW-NAME OFF

DLLImport KERNEL32.DLL "kernel32.dll"

Int32DLLEntry GlobalAlloc        KERNEL32.DLL GlobalAlloc
Int32DLLEntry GlobalFree         KERNEL32.DLL GlobalFree
Int32DLLEntry GlobalReAlloc      KERNEL32.DLL GlobalReAlloc

VoidDLLEntry  GetSystemTime      KERNEL32.DLL GetSystemTime
VoidDLLEntry  GetLocalTime       KERNEL32.DLL GetLocalTime

VoidDLLEntry  FlushFileBuffers   KERNEL32.DLL FlushFileBuffers

VoidDLLEntry  FillMemory         KERNEL32.DLL RtlFillMemory
VoidDLLEntry  ZeroMemory         KERNEL32.DLL RtlZeroMemory

Int32DLLEntry IsBadCodePtr       KERNEL32.DLL IsBadCodePtr
Int32DLLEntry IsBadReadPtr       KERNEL32.DLL IsBadReadPtr
Int32DLLEntry IsBadWritePtr      KERNEL32.DLL IsBadWritePtr
Int32DLLEntry IsBadStringPtrA    KERNEL32.DLL IsBadStringPtrA
Int32DLLEntry IsBadStringPtrW    KERNEL32.DLL IsBadStringPtrW

DEFER IsBadStringPtr
' IsBadStringPtrA IS IsBadStringPtr

Int32DLLEntry GetStdHandle       KERNEL32.DLL GetStdHandle

Int32DLLEntry AreFileApisANSI    KERNEL32.DLL AreFileApisANSI
VoidDLLEntry  SetFileApisToANSI  KERNEL32.DLL SetFileApisToANSI
VoidDLLEntry  SetFileApisToOEM   KERNEL32.DLL SetFileApisToOEM

Int32DLLEntry DeleteFileA        KERNEL32.DLL DeleteFileA
Int32DLLEntry DeleteFileW        KERNEL32.DLL DeleteFileW

DEFER DeleteFile
' DeleteFileA IS DeleteFile

Int32DLLEntry MoveFileA          KERNEL32.DLL MoveFileA
Int32DLLEntry MoveFileW          KERNEL32.DLL MoveFileW

DEFER MoveFile
' MoveFileA IS MoveFile

Int32DLLEntry GetFileAttributesA KERNEL32.DLL GetFileAttributesA
Int32DLLEntry GetFileAttributesW KERNEL32.DLL GetFileAttributesW

DEFER GetFileAttributes
' GetFileAttributesA IS GetFileAttributes

Int32DLLEntry GetFileSize        KERNEL32.DLL GetFileSize
Int32DLLEntry SetEndOfFile       KERNEL32.DLL SetEndOfFile
Int32DLLEntry SetFilePointer     KERNEL32.DLL SetFilePointer
Int32DLLEntry SetFilePointerEx   KERNEL32.DLL SetFilePointerEx
Int32DLLEntry ReadFile           KERNEL32.DLL ReadFile
Int32DLLEntry WriteFile          KERNEL32.DLL WriteFile

VoidDLLEntry  ExitProcess        KERNEL32.DLL ExitProcess

Int32DLLEntry GetCommandLineA    KERNEL32.DLL GetCommandLineA
Int32DLLEntry GetCommandLineW    KERNEL32.DLL GetCommandLineW

DEFER GetCommandLine
' GetCommandLineA IS GetCommandLine

Int32DLLEntry lstrlenA           KERNEL32.DLL lstrlenA
Int32DLLEntry lstrlenW           KERNEL32.DLL lstrlenW

DEFER lstrlen
' lstrlenA IS lstrlen

Int32DLLEntry lstrcmpA           KERNEL32.DLL lstrcmpA
Int32DLLEntry lstrcmpW           KERNEL32.DLL lstrcmpW

DEFER lstrcmp
' lstrcmpA IS lstrcmp

Int32DLLEntry ReadConsoleInputA  KERNEL32.DLL ReadConsoleInputA
Int32DLLEntry ReadConsoleInputW  KERNEL32.DLL ReadConsoleInputW

DEFER ReadConsoleInput
' ReadConsoleInputA IS ReadConsoleInput

VoidDLLEntry WriteConsoleA  KERNEL32.DLL WriteConsoleA
VoidDLLEntry WriteConsoleW  KERNEL32.DLL WriteConsoleW

DEFER WriteConsole
' WriteConsoleA IS WriteConsole

Int32DLLEntry GetNumberOfConsoleInputEvents KERNEL32.DLL GetNumberOfConsoleInputEvents

STRUCT COORD
  WORD: COORD.X
  WORD: COORD.Y
ENDSTRUCT

STRUCT SMALL_RECT
  WORD: SMALL_RECT.Left
  WORD: SMALL_RECT.Top
  WORD: SMALL_RECT.Right
  WORD: SMALL_RECT.Bottom
ENDSTRUCT

STRUCT CONSOLE_SCREEN_BUFFER_INFO
  COORD STRUCT-SIZEOF STRUCT-FIELD      CONSOLE_SCREEN_BUFFER_INFO.dwSize
  COORD STRUCT-SIZEOF STRUCT-FIELD      CONSOLE_SCREEN_BUFFER_INFO.dwCursorPosition
  WORD:                                 CONSOLE_SCREEN_BUFFER_INFO.wAttributes
  SMALL_RECT STRUCT-SIZEOF STRUCT-FIELD CONSOLE_SCREEN_BUFFER_INFO.srWindow
  COORD STRUCT-SIZEOF STRUCT-FIELD      CONSOLE_SCREEN_BUFFER_INFO.dwMaximumWindowSize
ENDSTRUCT

Int32DLLEntry SetConsoleCursorPosition KERNEL32.DLL SetConsoleCursorPosition

Int32DLLEntry GetConsoleScreenBufferInfo KERNEL32.DLL GetConsoleScreenBufferInfo
Int32DLLEntry FillConsoleOutputCharacterA KERNEL32.DLL FillConsoleOutputCharacterA
Int32DLLEntry FillConsoleOutputCharacterW KERNEL32.DLL FillConsoleOutputCharacterW

DEFER FillConsoleOutputCharacter
' FillConsoleOutputCharacterA IS FillConsoleOutputCharacter

Int32DLLEntry FormatMessageA KERNEL32.DLL FormatMessageA
Int32DLLEntry FormatMessageW KERNEL32.DLL FormatMessageW

DEFER FormatMessage
' FormatMessageA IS FormatMessage

VoidDLLEntry  RaiseException KERNEL32.DLL RaiseException

VoidDLLEntry  Sleep KERNEL32.DLL Sleep
' Sleep IS MS

Int32DLLEntry CompareStringA KERNEL32.DLL CompareStringA
Int32DLLEntry CompareStringW KERNEL32.DLL CompareStringW

DEFER CompareString
' CompareStringA IS CompareString

REPORT-NEW-NAME !
