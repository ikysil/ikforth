unit IKFCommon;

interface

const
  Signature = 'IKFI';
  BlockSize = 1024;
  CRLF      = #13#10;
  fTRUE     = -1;
  fFALSE    = 0;

type
  TMainProc = procedure(EvalStr: PChar; EvalStrLen: Cardinal); stdcall;
  TForthThreadFunc = procedure(UserDataAreaAddr, ExecutionToken: Cardinal); stdcall;

  TImageHeader = record
    Signature: array[0 .. 14] of Char;
    EndOfSignature: Byte;  // shall be #0
    DesiredBase: Integer;
    DesiredSize: Integer;
    MainProcAddr: Integer;
    ThreadProcAddr: Cardinal;
    FuncTableAddr: Integer;
    UserDataAreaSize: Integer;
    DataStackSize: Integer;
  end;

  PFuncTable = ^TFuncTable;
  TFuncTable = record
// order MUST be the same as in FKernel.asm FUNC_TABLE
    fGetLastError,
    fLoadLibrary,
    fFreeLibrary,
    fGetProcAddress,
    fBye,
    fEmit,
    fType,
    fAccept,
    fReadBlock,
    fWriteBlock,
    fFileClose,
    fFileCreate,
    fFilePosition,
    fFileOpen,
    fFileRead,
    fFileReposition,
    fFileWrite,
    fFileReadLine,
    fFileResize,
    fATXY,
    fStartThread,
    fCompare,
    fPage,
    fAlloc,
    fFree,
    fReAlloc
      : Pointer;
  end;

  PBlock = ^TBlock;
  TBlock = array[0 .. BlockSize - 1] of Char;

var
  ApplicationPath: string;
  ImageFileName: string;
  CanExit: Boolean;
  StartFile: string;
  FT: TFuncTable;

implementation

uses
  SysUtils;

initialization
begin
  CanExit:= False;
  ApplicationPath:= ExtractFileDir(ParamStr(0));
  ImageFileName:=   ChangeFileExt(ParamStr(0), '.img');
  StartFile:=       ExtractRelativePath(GetCurrentDir + '\', ChangeFileExt(ParamStr(0), '.f'));
end;

end.
