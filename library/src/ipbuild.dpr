library ipbuild;

uses
  SysUtils,
  Classes,
  ctrl in 'ctrl.pas',
  utils in 'utils.pas';

{$R *.res}
{$R ipbuild_dll.RES}


//---Exportation---
exports ExtractAllFiles;
exports DeleteAllFiles;
exports PrepareTempIpBin;

begin
  //Init TempDir
  TempDir := GetRealPath(GetTempDir + TEMP_DIR);
end.
