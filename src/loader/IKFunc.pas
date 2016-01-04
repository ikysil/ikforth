unit IKFunc;

interface

function  fLoadLibrary(NameLen: Integer; NameAddr: Cardinal): Cardinal; stdcall;
procedure fFreeLibrary(LibID: Integer); stdcall;
function  fGetProcAddress(LibID: Integer; NameLen: Integer; NameAddr: Cardinal): Pointer; stdcall;
procedure fBye; stdcall;
procedure fEmit(A: Char); stdcall;
procedure fType(Len, Addr: Integer); stdcall;
procedure fFileClose(FileId: Integer); stdcall;
function  fFileCreate(FileAccessMethod, NameLen: Integer; NameAddr: Cardinal): Integer; stdcall;
function  fFilePosition(FileId: Integer): Int64; stdcall;
function  fFileOpen(FileAccessMethod, NameLen: Integer; NameAddr: Cardinal): Integer; stdcall;
procedure fFileReposition(FileId: Integer; HighWord, LowWord: Cardinal); stdcall;
function  fFileReadLine(FileId: Integer; Len, Addr: Cardinal): Int64; stdcall;
function  fStartThread(ParentUserDataAreaAddr: Cardinal;
                       CreateSuspended: Integer; XT: Cardinal): LongWord; stdcall;
procedure fPage; stdcall;
function  fAlloc(Size: Cardinal): Pointer; stdcall;
procedure fFree(Addr: Pointer); stdcall;
function  fReAlloc(Addr: Pointer; NewSize: Cardinal): Pointer; stdcall;

implementation

uses
  Windows, SysUtils, Classes, Math,
  IKFUtils, IKFCommon;

function GetString(Addr, Len: Integer): string;
begin
  Result:= '';
  if Len <= 0 then
    Exit;
  SetLength(Result, Len);
  FillChar(Result[1], Len, #0);
  if Addr > 0 then
    StrLCopy(PChar(Result), PChar(Addr), Len);
end;

function Print(S: string): Cardinal;
begin
  WriteConsole(hOut, PChar(S), Length(S), Result, nil);
end;

function fLoadLibrary(NameLen: Integer; NameAddr: Cardinal): Cardinal;
var
  LibName: string;
begin
  LibName:= GetString(NameAddr, NameLen);
  Result:= {Safe}LoadLibrary(PChar(LibName));
  if Result <> 0 then
    SetLastError(0);
end;

procedure fFreeLibrary(LibId: Integer);
begin
  FreeLibrary(LibId);
end;

function fGetProcAddress(LibId: Integer; NameLen: Integer; NameAddr: Cardinal): Pointer;
var
  ProcName: string;
begin
  SetLastError(0);
  ProcName:= GetString(NameAddr, NameLen);
  Result:= GetProcAddress(LibId, PChar(ProcName));
end;

procedure fBye;
begin
  CanExit:= True;
  while True do Sleep(1000);
end;

procedure fEmit(A: Char);
begin
  Print(A);
end;

procedure fType(Len, Addr: Integer);
begin
  Print(GetString(Addr, Len));
end;

procedure fFileClose(FileId: Integer);
begin
  FileClose(FileId);
end;

function fFileCreate(FileAccessMethod, NameLen: Integer; NameAddr: Cardinal): Integer;
var
  FName: string;
begin
  FName:= GetString(NameAddr, NameLen);
  Result:= FileCreate(FName);
  if Result <> -1 then
    SetLastError(0);
end;

function fFilePosition(FileId: Integer): Int64;
var
  LowWord, HighWord: Cardinal;
begin
  HighWord:= 0;
  LowWord:= SetFilePointer(FileId, 0, @HighWord, FILE_CURRENT);
  Result:= (Int64(HighWord) shl 32) or LowWord;
end;

function fFileOpen(FileAccessMethod, NameLen: Integer; NameAddr: Cardinal): Integer;
var
  FName: string;
begin
  FName:= GetString(NameAddr, NameLen);
  Result:= FileOpen(FName, FileAccessMethod);
end;

procedure fFileReposition(FileId: Integer; HighWord, LowWord: Cardinal);
begin
  SetFilePointer(FileId, LowWord, @HighWord, FILE_BEGIN);
end;

function fFileReadLine(FileId: Integer; Len, Addr: Cardinal): Int64;
var
  Res: Cardinal;
  C: Char;
  EndOfFile: Boolean;
  Flag: Integer;
  I: Cardinal;
begin
  I:= 0;
  EndOfFile:= False;
  while I < Len do
  begin
    Res:= FileRead(FileId, C, 1);
    if Res = 0 then
    begin
      EndOfFile:= True;
      Break;
    end;
    PChar(Addr + I)^:= C;
    if (C = #10) or (C = #13) then Break;
    Inc(I);
  end;
  if EndOfFile and (I = 0) then
    Flag:= 0
  else
    Flag:= -1;
  Result:= (Int64(Flag) shl 32) or I;
end;

type
  PForthThreadParams = ^TForthThreadParams;
  TForthThreadParams = record
    UserDataAreaAddr: Pointer;
    ExecutionToken: Cardinal;
  end;

function fThreadFunc(Parameter: Pointer): Integer;
var
  FTP: PForthThreadParams;
begin
  FTP:= PForthThreadParams(Parameter);
  try
    IHeader.ThreadProcAddr(FTP.UserDataAreaAddr, FTP.ExecutionToken);
  finally
    FreeMem(Pointer(FTP.UserDataAreaAddr), IHeader.UserDataAreaSize);
    FreeMem(FTP, SizeOf(TForthThreadParams));
    Result:= 0;
  end;
end;

function fStartThread(ParentUserDataAreaAddr: Cardinal;
                      CreateSuspended: Integer; XT: Cardinal): LongWord;
var
  FTP: PForthThreadParams;
  Flags: LongWord;
begin
  GetMem(FTP, SizeOf(TForthThreadParams));
  ZeroMemory(FTP, SizeOf(TForthThreadParams));
  FTP.ExecutionToken:= XT;
  GetMem(FTP.UserDataAreaAddr, IHeader.UserDataAreaSize);
  ZeroMemory(FTP.UserDataAreaAddr, IHeader.UserDataAreaSize);
  if ParentUserDataAreaAddr <> 0 then
  begin
    Move(Pointer(ParentUserDataAreaAddr)^, Pointer(FTP.UserDataAreaAddr)^,
         IHeader.UserDataAreaSize);
  end;
  Flags:= 0;
  if CreateSuspended = fTRUE then
    Flags:= CREATE_SUSPENDED;
  BeginThread(nil, IHeader.DataStackSize, fThreadFunc, FTP, Flags, Result);
end;

procedure fPage;
var
  C: _COORD;
  CSBI: TConsoleScreenBufferInfo;
  Chars: Cardinal;
begin
  C.X:= 0;
  C.Y:= 0;
  GetConsoleScreenBufferInfo(hOut, CSBI);
  FillConsoleOutputCharacter(hOut, ' ', CSBI.dwSize.X * CSBI.dwSize.Y, C, Chars);
  SetConsoleCursorPosition(hOut, C);      
end;

function  fAlloc(Size: Cardinal): Pointer;
begin
  Result:= Pointer(GlobalAlloc(GPTR, Size));
  if Assigned(Result) then
    SetLastError(0);
end;

procedure fFree(Addr: Pointer);
begin
  if GlobalFree(Cardinal(Addr)) = 0 then
    SetLastError(0);
end;

function  fReAlloc(Addr: Pointer; NewSize: Cardinal): Pointer;
begin
  Result:= Pointer(GlobalReAlloc(Cardinal(Addr), NewSize, GMEM_ZEROINIT));
  if Assigned(Result) then
    SetLastError(0);
end;

end.
