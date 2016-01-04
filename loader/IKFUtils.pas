unit IKFUtils;

interface

uses
  Windows,
  SysUtils,
  IKFCommon,
  IKFunc;

procedure ShowLastError(Where: string = ''); overload;
procedure StartForth;

var
  IHeader: TImageHeader;
  FHandle: THandle;
  PData: Pointer;
  hOut: THandle;
  hIn: THandle;

implementation

procedure ShowLastError(Where: string = ''); overload;
var
  Err: Integer;
  ErrMessage: PChar;
  Msg: string;
begin
  Err:= GetLastError;
  FormatMessage(FORMAT_MESSAGE_ALLOCATE_BUFFER Or FORMAT_MESSAGE_FROM_SYSTEM,
                 nil, Err, 0, @ErrMessage, 0, nil);
  if Where <> '' then
    Msg:= Format('%s'#13#10'%s', [Where, ErrMessage])
  else
    Msg:= Format('%s', [ErrMessage]);
  MessageBox(0, PChar(Msg), nil, MB_ICONERROR + MB_OK);
  LocalFree(HLocal(ErrMessage));
end;

procedure SetFuncTable;
begin
  FT.fGetLastError:= @fGetLastError;
  FT.fLoadLibrary:= @fLoadLibrary;
  FT.fFreeLibrary:= @fFreeLibrary;
  FT.fGetProcAddress:= @fGetProcAddress;
  FT.fBye:= @fBye;
  FT.fEmit:= @fEmit;
  FT.fType:= @fType;
  FT.fAccept:= @fAccept;
  FT.fReadBlock:= @fReadBlock;
  FT.fWriteBlock:= @fWriteBlock;
  FT.fFileClose:= @fFileClose;
  FT.fFileCreate:= @fFileCreate;
  FT.fFilePosition:= @fFilePosition;
  FT.fFileOpen:= @fFileOpen;
  FT.fFileRead:= @fFileRead;
  FT.fFileReposition:= @fFileReposition;
  FT.fFileWrite:= @fFileWrite;
  FT.fFileReadLine:= @fFileReadLine;
  FT.fFileResize:= @fFileResize;
  FT.fATXY:= @fATXY;
  FT.fStartThread:= @fStartThread;
  FT.fCompare:= @fCompare;
  FT.fPage:= @fPage;
  FT.fAlloc:= @fAlloc;
  FT.fFree:= @fFree;
  FT.fReAlloc:= @fReAlloc;
  TImageHeader(Pointer(IHeader.DesiredBase)^).FuncTableAddr:= Integer(@FT);
end;

procedure StartForth;
begin
  FHandle:= FileOpen(ImageFileName, fmOpenReadWrite);
  if FHandle = INVALID_HANDLE_VALUE then
  begin
    ShowLastError(Format('Cannot open file'#13#10'%s.', [ImageFileName]));
    Exit;
  end;
  FileRead(FHandle, IHeader, SizeOf(IHeader));
  if (IHeader.Signature[0] = 'M') and (IHeader.Signature[1] = 'Z') then
  begin
//  This is an EXE file
    FileSeek(FHandle, $600, 0);
    FileRead(FHandle, IHeader, SizeOf(IHeader));
  end;
  if string(IHeader.Signature) <> Signature then
  begin
    MessageBox(0, PChar(Format('%s'#13#10'is not valid IKForth image.',
                               [ImageFileName])),
                nil, MB_ICONERROR + MB_OK);
    FileClose(FHandle);
    Exit;
  end;
  PData:= VirtualAlloc(Pointer(IHeader.DesiredBase), IHeader.DesiredSize,
                        MEM_RESERVE or MEM_COMMIT, PAGE_EXECUTE_READWRITE);
  if Integer(PData) <> IHeader.DesiredBase then
  begin
    ShowLastError(Format('Cannot allocate memory by VirtualAlloc:'#13#10 +
                         '0x%p returned, but 0x%.8x expected...',
                         [PData, IHeader.DesiredBase]));
    FileClose(FHandle);
    Exit;
  end;
  FileSeek(FHandle, - SizeOf(IHeader), 1);
  FileRead(FHandle, PData^, IHeader.DesiredSize);
  FileClose(FHandle);
  SetFuncTable;
  hOut:= GetStdHandle(STD_OUTPUT_HANDLE);
  hIn:= GetStdHandle(STD_INPUT_HANDLE);
  TMainProc(IHeader.MainProcAddr)(PChar(StartFile), Length(StartFile));
  while not CanExit do Sleep(100);
  VirtualFree(PData, IHeader.DesiredSize, MEM_DECOMMIT);
  VirtualFree(PData, 0, MEM_RELEASE);
  FileClose(hIn);
  FileClose(hOut);
end;

end.
