program FKernel;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  IKFUtils in 'IKFUtils.pas',
  IKFCommon in 'IKFCommon.pas',
  IKFunc in 'IKFunc.pas';

var
  ImageFileName: string;
  StartFile: string;

begin
  ImageFileName:= ChangeFileExt(ParamStr(0), '.img');
  StartFile:=     ExtractRelativePath(GetCurrentDir + '\', ChangeFileExt(ParamStr(0), '.f'));
  StartForth(ImageFileName, StartFile);
end.
