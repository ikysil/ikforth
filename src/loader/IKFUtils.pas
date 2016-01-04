unit IKFUtils;

interface

uses
  Windows,
  SysUtils,
  IKFCommon,
  IKFunc;

procedure StartForth(ImageFileName, StartFile: string);

var
  IHeader: TImageHeader;
  hOut: THandle;
  CanExit: Boolean;

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
  WriteLn(Msg);
//  MessageBox(0, PChar(Msg), nil, MB_ICONERROR + MB_OK);
  LocalFree(HLocal(ErrMessage));
end;

procedure SetFuncTable(const Header: PImageHeader);
var
  FT: PFuncTable;
begin
  FT:= Header.FuncTableAddr;
  ZeroMemory(FT, SizeOf(TFuncTable));
  FT.fLoadLibrary:= @fLoadLibrary;
  FT.fFreeLibrary:= @fFreeLibrary;
  FT.fGetProcAddress:= @fGetProcAddress;
  FT.fBye:= @fBye;
  FT.fEmit:= @fEmit;
  FT.fType:= @fType;
  FT.fFileClose:= @fFileClose;
  FT.fFileCreate:= @fFileCreate;
  FT.fFilePosition:= @fFilePosition;
  FT.fFileOpen:= @fFileOpen;
  FT.fFileReposition:= @fFileReposition;
  FT.fFileReadLine:= @fFileReadLine;
  FT.fStartThread:= @fStartThread;
  FT.fPage:= @fPage;
  FT.fAlloc:= @fAlloc;
  FT.fFree:= @fFree;
  FT.fReAlloc:= @fReAlloc;
end;

procedure StartForth(ImageFileName, StartFile: string);
var
  FHandle: THandle;
  LHeader: PImageHeader;
begin
  hOut:= GetStdHandle(STD_OUTPUT_HANDLE);
  FHandle:= FileOpen(ImageFileName, fmOpenReadWrite);
  if FHandle = INVALID_HANDLE_VALUE then
  begin
    ShowLastError(Format('Cannot open file ''%s.''', [ImageFileName]));
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
    WriteLn(Format('''%s'' is not valid IKForth image.', [ImageFileName]));
//    MessageBox(0, PChar(Format('%s'#13#10'is not valid IKForth image.',
//                               [ImageFileName])),
//                nil, MB_ICONERROR + MB_OK);
    FileClose(FHandle);
    Exit;
  end;
  LHeader:= VirtualAlloc(IHeader.DesiredBase, IHeader.DesiredSize,
                       MEM_RESERVE or MEM_COMMIT, PAGE_EXECUTE_READWRITE);
  if LHeader <> IHeader.DesiredBase then
  begin
    ShowLastError(Format('Cannot allocate memory by VirtualAlloc: ' +
                         '0x%p returned, but 0x%p expected...',
                         [LHeader, IHeader.DesiredBase]));
    FileClose(FHandle);
    Exit;
  end;
  FileSeek(FHandle, - SizeOf(IHeader), 1);
  FileRead(FHandle, LHeader^, IHeader.DesiredSize);
  FileClose(FHandle);
  SetFuncTable(LHeader);
  CanExit:= False;
  IHeader.MainProcAddr(PChar(StartFile), Length(StartFile));
  while not CanExit do Sleep(100);
  VirtualFree(LHeader, IHeader.DesiredSize, MEM_DECOMMIT);
  VirtualFree(LHeader, 0, MEM_RELEASE);
  FileClose(hOut);
end;

end.
