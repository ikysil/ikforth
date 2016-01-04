unit IKFunc;

interface

function fGetLastError: Integer; stdcall;
function fLoadLibrary( NameLen: Integer; NameAddr: Cardinal ): Integer; stdcall;
procedure fFreeLibrary( LibID: Integer ); stdcall;
function fGetProcAddress( LibID: Integer; NameLen: Integer; NameAddr: Cardinal ): Pointer; stdcall;
procedure fBye; stdcall;
procedure fEmit( A: Char ); stdcall;
procedure fType( Len, Addr: Integer ); stdcall;
function fAccept( Len: Integer; Addr: Cardinal ): Cardinal; stdcall;
procedure fReadBlock( BlockNum, Addr: Cardinal ); stdcall;
procedure fWriteBlock( BlockNum, Addr: Cardinal ); stdcall;
procedure fFileClose( FileID: Integer ); stdcall;
function fFileCreate( FileAccessMethod, NameLen: Integer; NameAddr: Cardinal ): Integer; stdcall;
function fFilePosition( FileID: Integer ): Int64; stdcall;
function fFileOpen( FileAccessMethod, NameLen: Integer; NameAddr: Cardinal ): Integer; stdcall;
function fFileRead( FileID: Integer; Len, Addr: Cardinal ): Cardinal; stdcall;
procedure fFileReposition( FileID: Integer; HighWord, LowWord: Cardinal ); stdcall;
procedure fFileWrite( FileID: Integer; Len, Addr: Cardinal ); stdcall;
function fFileReadLine( FileID: Integer; Len, Addr: Cardinal ): Int64; stdcall;
procedure fFileResize( FileID: Integer; HighWord, LowWord: Cardinal ); stdcall;
procedure fATXY( Y, X: Integer ); stdcall;
function fStartThread( ParentUserDataAreaAddr: Cardinal;
                       CreateSuspended: Integer; XT: Cardinal ): LongWord; stdcall;
function fCompare( StrLen2, StrAddr2, StrLen1, StrAddr1: Cardinal ): Integer; stdcall;
procedure fPage; stdcall;

implementation

uses
  Math, IKFUtils, Windows, Classes, IKFCommon, SysUtils;

function GetString( Addr, Len: Cardinal ): string;
var
  I: Cardinal;
begin
  Result:= '';
  for I:= 0 to Len - 1 do
    Result:= Result + PChar( Addr + I )^;
end;

function Print( S: string ): Cardinal;
begin
  WriteConsole( hOut, PChar( S ), Length( S ), Result, nil );
end;

function fGetLastError: Integer;
begin
  Result:= GetLastError;
end;

function fLoadLibrary( NameLen: Integer; NameAddr: Cardinal ): Integer;
var
  LibName: string;
begin
  LibName:= GetString( NameAddr, NameLen );
  Result:= LoadLibrary( PChar( LibName ));
end;

procedure fFreeLibrary( LibID: Integer );
begin
  FreeLibrary( LibID );
end;

function fGetProcAddress( LibID: Integer; NameLen: Integer; NameAddr: Cardinal ): Pointer;
var
  ProcName: string;
begin
  ProcName:= GetString( NameAddr, NameLen );
  Result:= GetProcAddress( LibID, PChar( ProcName ));
end;

procedure fBye;
begin
  CanExit:= True;
  while True do Sleep( 1000 );
end;

procedure fEmit( A: Char );
begin
  Print( A );
end;

procedure fType( Len, Addr: Integer );
begin
  Print( GetString( Addr, Len ));
end;

function fAccept( Len: Integer; Addr: Cardinal ): Cardinal;
var
  IR: TInputRecord;
  Event: TKeyEventRecord;
  R: Cardinal;
  I: Integer;
  CanExit: Boolean;
  S: string;
begin
  CanExit:= False;
  S:= '';
  repeat
    ReadConsoleInput( hIn, IR, 1, R );
    if IR.EventType = KEY_EVENT then
    begin
      Event:= TKeyEventRecord( IR.Event );
      CanExit:= ( Event.bKeyDown ) and ( Event.AsciiChar = #13 );
      if ( Event.AsciiChar in [ #32 .. #127 ]) and Event.bKeyDown and
         ( Length( S ) < Len ) then
      begin
        S:= S + Event.AsciiChar;
        Print( Event.AsciiChar );
      end;
      if ( Event.AsciiChar = #8 ) and Event.bKeyDown and ( Length( S ) > 0 ) then
      begin
        SetLength( S, Length( S ) - 1 );
        Print( #8' '#8 );
      end;
    end;
  until CanExit;
  Result:= Cardinal( Min( Len, Length( S )));
  for I:= 0 to Result - 1 do
    Char( Pointer( Addr + Cardinal( I ))^):= S[ I + 1 ];
end;

procedure fReadBlock( BlockNum, Addr: Cardinal );
var
  Block: PBlock;
  FName: string;
  S: TStream;
begin
  Block:= PBlock( Addr );
  FName:= Format( '%s\blocks\%.8X', [ ApplicationPath, BlockNum ]);
  FillChar( Block^, BlockSize, ' ' );
  S:= nil;
  try
    S:= TFileStream.Create( FName, fmOpenRead );
    S.Read( Block^, 1024 );
  except
  end;
  FreeAndNil( S );
end;

procedure fWriteBlock( BlockNum, Addr: Cardinal );
var
  Block: PBlock;
  FName: string;
  S: TStream;
begin
  Block:= PBlock( Addr );
  FName:= Format( '%s\blocks\%.8X', [ ApplicationPath, BlockNum ]);
  S:= nil;
  try
    S:= TFileStream.Create( FName, fmCreate );
    S.Write( Block^, 1024 );
  except
  end;
  FreeAndNil( S );
end;

procedure fFileClose( FileID: Integer );
begin
  FileClose( FileID );
end;

function fFileCreate( FileAccessMethod, NameLen: Integer; NameAddr: Cardinal ): Integer;
var
  FName: string;
begin
  FName:= GetString( NameAddr, NameLen );
  if FileExists( FName ) then DeleteFile( FName );
  Result:= FileCreate( FName );
end;

function fFilePosition( FileID: Integer ): Int64;
var
  LowWord, HighWord: Cardinal;
begin
  HighWord:= 0;
  LowWord:= SetFilePointer( FileID, 0, @HighWord, FILE_CURRENT );
  Result:= ( Int64( HighWord ) shl 32 ) or LowWord;
end;

function fFileOpen( FileAccessMethod, NameLen: Integer; NameAddr: Cardinal ): Integer;
var
  FName: string;
begin
  FName:= GetString( NameAddr, NameLen );
  Result:= FileOpen( FName, FileAccessMethod );
end;

function fFileRead( FileID: Integer; Len, Addr: Cardinal ): Cardinal;
begin
  Result:= FileRead( FileID, Pointer( Addr )^, Len );
end;

procedure fFileReposition( FileID: Integer; HighWord, LowWord: Cardinal );
begin
  SetFilePointer( FileID, LowWord, @HighWord, FILE_BEGIN );
end;

procedure fFileWrite( FileID: Integer; Len, Addr: Cardinal );
begin
  FileWrite( FileID, Pointer( Addr )^, Len );
end;

function fFileReadLine( FileID: Integer; Len, Addr: Cardinal ): Int64;
var
  Res: Cardinal;
  C: Char;
  EndOfFile: Boolean;
  S: string;
  Flag: Integer;
  I: Cardinal;
begin
  I:= 0;
  S:= '';
  EndOfFile:= False;
  while I < Len do
  begin
    Res:= FileRead( FileID, C, 1 );
    if Res = 0 then
    begin
      EndOfFile:= True;
      Break;
    end;
    PChar( Addr + I )^:= C;
    if ( C = #10 ) or ( C = #13 ) then Break;
    S:= S + C;
    Inc( I );
  end;
  if EndOfFile and ( I = 0 ) then
    Flag:= 0
  else
    Flag:= -1;
  Result:= ( Int64( Flag ) shl 32 ) or I;
end;

procedure fFileResize( FileID: Integer; HighWord, LowWord: Cardinal );
begin
  SetFilePointer( FileID, LowWord, @HighWord, FILE_BEGIN );
  SetEndOfFile( FileID );
end;

procedure fATXY( Y, X: Integer );
var
  C: _COORD;
begin
  C.X:= X;
  C.Y:= Y;
  SetConsoleCursorPosition( hOut, C );
end;

type
  PForthThreadParams = ^TForthThreadParams;
  TForthThreadParams = record
    UserDataAreaAddr: Cardinal;
    ExecutionToken: Cardinal;
  end;

function fThreadFunc( Parameter: Pointer ): Integer;
var
  FTP: PForthThreadParams;
  Flag: Boolean;
begin
  FTP:= PForthThreadParams( Parameter );
  Flag:= True;
  while Flag do
  begin
    try
      TForthThreadFunc( IHeader.ThreadProcAddr )( FTP.UserDataAreaAddr, FTP.ExecutionToken );
      Flag:= False;
    except
      on E: Exception do
      begin
        Print( E.Message );
      end;
    end;
  end;
  FreeMem( Pointer( FTP.UserDataAreaAddr ), IHeader.UserDataAreaSize );
  FreeMem( FTP, SizeOf( TForthThreadParams ));
  Result:= 0;
end;

function fStartThread( ParentUserDataAreaAddr: Cardinal;
                       CreateSuspended: Integer; XT: Cardinal ): LongWord;
var
  FTP: PForthThreadParams;
  Flags: LongWord;
begin
  GetMem( FTP, SizeOf( TForthThreadParams ));
  FTP.ExecutionToken:= XT;
  GetMem( Pointer( FTP.UserDataAreaAddr ), IHeader.UserDataAreaSize );
  ZeroMemory( Pointer( FTP.UserDataAreaAddr ), IHeader.UserDataAreaSize );
  if ParentUserDataAreaAddr <> 0 then
  begin
    Move( Pointer( ParentUserDataAreaAddr )^, Pointer( FTP.UserDataAreaAddr )^,
          IHeader.UserDataAreaSize );
  end;
  Flags:= 0;
  if CreateSuspended = fTRUE then Flags:= CREATE_SUSPENDED;
  BeginThread( nil, IHeader.DataStackSize, fThreadFunc, FTP, Flags, Result );
end;

function fCompare( StrLen2, StrAddr2, StrLen1, StrAddr1: Cardinal ): Integer;
var
  S1, S2: string;
begin
  S1:= GetString( StrAddr1, StrLen1 );
  S2:= GetString( StrAddr2, StrLen2 );
  Result:= CompareStr( S1, S2 );
  if Result < 0 then Result:= -1;
  if Result > 0 then Result:= 1;
end;

procedure fPage;
var
  C: _COORD;
  Chars: Cardinal;
begin
  C.X:= 0;
  C.Y:= 0;
  FillConsoleOutputCharacter( hOut, ' ', 4096, C, Chars );
  SetConsoleCursorPosition( hOut, C );
end;

end.
