unit utils;

interface

uses
  Windows, SysUtils, Classes;

function GetTempDir: string;
procedure ExtractFile(Dir : string ; Ressource : string ; Extension : string);
procedure ChangeFileName(OldFileNameInTempDir : string ; NewFileNameInTempDir : string);
function GetRealPath(Path : string) : string;

implementation

//---GetRealPath---
function GetRealPath(Path : string) : string;
var
  i : integer;
  LastCharWasSeparator : Boolean;

begin
  Result := '';
  LastCharWasSeparator := False;

  Path := Path + '\';

  for i := 1 to Length(Path) do
  begin
    if Path[i] = '\' then
    begin
      if not LastCharWasSeparator then
      begin
        Result := Result + Path[i];
        LastCharWasSeparator := True;
      end
    end
    else
    begin
       LastCharWasSeparator := False;
       Result := Result + Path[i];
    end;
  end;
end;

//---GetTempDir---
function GetTempDir : string;
var
  Dossier : array[0..MAX_PATH] of Char;

begin
  Result := '';
  if GetTempPath(SizeOf(Dossier), Dossier) <> 0 then Result := StrPas(Dossier);
  Result := GetRealPath(Result);
end;

//---ExtractFile---
procedure ExtractFile(Dir : string ; Ressource : string ; Extension : string);
var
 StrNomFichier  : string;
 ResourceStream : TResourceStream;
 FichierStream  : TFileStream;

begin
  StrNomFichier := GetRealPath(Dir) + Ressource + '.' + Extension;
  ResourceStream := TResourceStream.Create(hInstance, Ressource, RT_RCDATA);

  try
    FichierStream := TFileStream.Create(StrNomFichier, fmCreate);
    try
      FichierStream.CopyFrom(ResourceStream, 0);
    finally
      FichierStream.Free;
    end;
  finally
    ResourceStream.Free;
  end;
end;

//---ChangeFileName---
procedure ChangeFileName(OldFileNameInTempDir : string ; NewFileNameInTempDir : string);
begin
  if FileExists(GetTempDir + OldFileNameInTempDir) = True then
  begin
    RenameFile(GetTempDir + OldFileNameInTempDir, GetTempDir + NewFileNameInTempDir);
    if FileExists(GetTempDir + OldFileNameInTempDir) = True then
      DeleteFile(GetTempDir + OldFileNameInTempDir);
  end;
end;

end.
