program ipcreate;

{$APPTYPE CONSOLE}

uses
  Windows,
  SysUtils,
  utils in 'utils.pas',
  parse in 'parse.pas',
  errorlvl in 'errorlvl.pas',
  build in 'build.pas',
  u_bin_save in 'u_bin_save.pas',
  u_build in 'u_build.pas',
  u_const in 'u_const.pas',
  logoman in 'logoman.pas',
  ImageType in 'ImageType.pas',
  imgconv in 'imgconv.pas',
  imgman in 'imgman.pas',
  U_Interpolation_BiLineaire in 'U_Interpolation_Bilineaire.pas',
  pngutils in 'pngutils.pas',
  generate in 'generate.pas';

const
  VersionPrg : string = '1.1';
  
var
  IP_Dir : string;
  OK     : boolean;
  
//ipcreate C:\IP.BIN Version ReleaseDate ManufacturerID BootFileName Application Logo

//---Main---
begin
  Randomize; //pour la génération des trucks...
  
  //Inits des variables
  ThisFile          := ExtractFileName(ParamStr(0));
  UtilsDir          := GetRealPath(GetTempDir + IPBUILD_TMP);

  IP_File           := GetRealPath(GetCurrentDir) + 'IP.BIN';
  Version           := '1.000';
  ReleaseDate       := DateToStr(Date);
  ManufacturerID    := 'SiZiOUS';
  BootFileName      := '1ST_READ.BIN';
  ApplicationTitle  := 'GENERIC APPLICATION';
  Logo              := '';

  //Init des switchs
  Silent      := False;
  Overwrite   := False;
  Help        := False;
  ShowErrMsg  := False;

  //Présentation
  WriteLn('IPCREATE - Command Line - v' + VersionPrg + ' - by [big_fury]SiZiOUS');
  WriteLn('http://www.sbibuilder.fr.st/ - Created for LyingWake.' + #13 + #10);

  //Savoir les options.
  ParseCmd;

  //Si le mec voulais avoir de l'aide...
  if ParamCount = 0 then
    AddDebug('If you want help, type "' + ThisFile + ' -h".');

  //Vérifier, corriger l'emplacement du IP.BIN
  IP_File := GetFullPath(IP_File);
  IP_Dir  := GetRealPath(ExtractFilePath(IP_File));

  //Pour le logo :
  if Length(Logo) <> 0 then
    Logo := GetFullPath(Logo);

  //Afficher les différentes aides si demandée.
  if Help then DisplayHelp;
  if ShowErrMsg then DisplayErrCodes;
  if Help or ShowErrMsg then Stop(NO_ERRORS);

  //Pareil vérifions que le fichier IP.BIN contient pas de caractères invalides.
  if not IsValidFileName(IP_File) then
  begin
    AddDebug('Invalid filename : ' + IP_File, True);
    Stop(INPUT_FILES_ERROR);
  end;

  //* Vérifions pour le fichier IP.BIN voulant être créé que le dossier qui est demandé existe...
  if not DirectoryExists(IP_Dir) then
  begin

    //Si c'est overwrite, on va créer le dossier.
    if OverWrite then
    begin
      AddDebug('Creating directories...');
      ForceDirectories(IP_Dir);
    end else begin
      AddDebug(IP_Dir + ' : No such file or directory', True);
      Stop(INPUT_FILES_ERROR);
    end;
    
  end;

  //* Vérifions que le BIN n'existe pas. (si -ow (overwrite) n'est pas activé).
  if FileExists(IP_File) then
  begin

    if not OverWrite then
    begin
      AddDebug(IP_File + ': File already exists', True);
      Stop(INPUT_FILES_ERROR);
    end else begin
      AddDebug(IP_File + ': File already exists... Overwriting it.');
      DeleteFile(IP_File);
    end;

  end;

  //Transformer la date.
  //Si le mec entre une date style 15-02-2005...
  ReleaseDate := StringReplace(ReleaseDate, '-', '/', [rfReplaceAll, rfIgnoreCase]);

  CheckParams(Version, ReleaseDate, ManufacturerID, BootFileName, ApplicationTitle);

  //-----*** OK POUR TOUS LES PARAMETRES POUR FAIRE LE FICHIER IP.BIN ***-----

  ExtractAllFiles;

  OK := BuildFile(IP_File, Version, ReleaseDate, ManufacturerID, BootFileName,
    ApplicationTitle, Logo);

  DeleteAllFiles;

  if OK then
    Stop(NO_ERRORS)
  else Stop(ERROR_WITH_STANDARD_IPBIN);
end.
