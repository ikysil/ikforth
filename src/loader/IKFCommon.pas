unit IKFCommon;

interface

const
  Signature = 'IKFI';
  CRLF      = #13#10;
  fTRUE     = -1;
  fFALSE    = 0;

type
  TMainProc = procedure(EvalStr: PChar; EvalStrLen: Cardinal); stdcall;
  TForthThreadProc = procedure(UserDataAreaAddr: Pointer; ExecutionToken: Cardinal); stdcall;

  PFuncTable = ^TFuncTable;
  TFuncTable = record
// order MUST be the same as in ftable.inc FUNC_TABLE
    fLoadLibrary,
    fFreeLibrary,
    fGetProcAddress,
    fBye,
    fEmit,
    fType,
    fFileClose,
    fFileCreate,
    fFilePosition,
    fFileOpen,
    fFileReposition,
    fFileReadLine,
    fStartThread,
    fPage,
    fAlloc,
    fFree,
    fReAlloc
      : Pointer;
  end;

  PImageHeader = ^TImageHeader;
  TImageHeader = record
    Signature: array[0 .. 14] of Char;
    EndOfSignature: Byte;  // shall be #0
    DesiredBase: Pointer;
    DesiredSize: Cardinal;
    MainProcAddr: TMainProc;
    ThreadProcAddr: TForthThreadProc;
    FuncTableAddr: PFuncTable;
    UserDataAreaSize: Cardinal;
    DataStackSize: Cardinal;
  end;

implementation

end.
