unit ctrl;

interface

uses
  Windows, SysUtils;

const
  TEMP_DIR : string  = 'ipbuild_tmp';

var
  TempDir : string;
  
procedure ExtractAllFiles; stdcall ; export;
procedure DeleteAllFiles; stdcall ; export;
function PrepareTempIpBin : boolean; stdcall ; export;

implementation

uses utils;

const
  CYGWIN1_DLL : string  = 'cygwin1.dll';
  IP_BIN      : string  = 'IP.BIN';
  LIBPNG_DLL  : string  = 'libpng.dll';
  LIBZ_DLL    : string  = 'libz.dll';
  LOGOINSERT  : string  = 'logoinsert.exe';
  PNGTOMR     : string  = 'pngtomr.exe';
  

//---ExtractAllFiles---
procedure ExtractAllFiles;
begin
  ForceDirectories(TempDir);
  
  if FileExists(TempDir + CYGWIN1_DLL) = False then
    ExtractFile(TempDir, 'CYGWIN1', 'DLL');

  if FileExists(TempDir + IP_BIN) = False then
    ExtractFile(TempDir, 'IP', 'BIN');

  if FileExists(TempDir + LIBPNG_DLL) = False then
     ExtractFile(TempDir, 'LIBPNG', 'DLL');

  if FileExists(TempDir + LIBZ_DLL) = False then
    ExtractFile(TempDir, 'LIBZ', 'DLL');

  if FileExists(TempDir + LOGOINSERT) = False then
    ExtractFile(TempDir, 'LOGOINSERT', 'EXE');

  if FileExists(TempDir + PNGTOMR) = False then
    ExtractFile(TempDir, 'PNGTOMR', 'EXE');
end;

//---DeleteAllFiles---
procedure DeleteAllFiles;
begin
  if FileExists(TempDir + CYGWIN1_DLL) = True then
    DeleteFile(TempDir + CYGWIN1_DLL);

  if FileExists(TempDir + IP_BIN) = True then
    DeleteFile(TempDir + IP_BIN);

  if FileExists(TempDir + LIBPNG_DLL) = True then
    DeleteFile(TempDir + LIBPNG_DLL);

  if FileExists(TempDir + LIBZ_DLL) = True then
    DeleteFile(TempDir + LIBZ_DLL);

  if FileExists(TempDir + LOGOINSERT) = True then
    DeleteFile(TempDir + LOGOINSERT);

  if FileExists(TempDir + PNGTOMR) = True then
    DeleteFile(TempDir + PNGTOMR);

  if DirectoryExists(TempDir) = True then
    RemoveDir(TempDir);
end;

//---PrepareTempIpBin---
function PrepareTempIpBin : boolean;
var
  TempIpBin : string;
  
begin
  Result := False;
  TempIpBin := GetTempDir + '~ipbin.tmp';
  if FileExists(TempIpBin) then DeleteFile(TempIpBin);
  CopyFile(PChar(TempDir + IP_BIN), PChar(TempIpBin), False);
  Result := True;
end;
  
end.
