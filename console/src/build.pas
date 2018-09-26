unit build;

interface

uses
  Windows, SysUtils, DateUtils;
  
function BuildFile( FileName, Version, ReleaseDate, ManufacturerID,
                    BootFileName, ApplicationTitle, LogoImage: string) : boolean;

implementation

uses u_const, u_bin_save, utils, logoman, imgman, u_build, generate, errorlvl;

var
  F : File;

//---BuildFile---
function BuildFile( FileName, Version, ReleaseDate, ManufacturerID,
                    BootFileName, ApplicationTitle, LogoImage: string) : boolean;
var
  Directory,
  TempIpBin,
  TS   : string;    //TS : temp string

begin
//  Result := False;
  //Main_Form.pBar.Position := 0;

  //Extraire le dossier du FileName.
  Directory := GetRealPath(ExtractFilePath(FileName));
  //writeln(directory);
  if DirectoryExists(Directory) = False then Stop(INPUT_FILES_ERROR);


  //Copier le fichier IP.BIN vers le temp.
  TempIpBin := GetTempDir + '~ipbin.tmp';     //fichier temporaire qui va être créé.
  if FileExists(TempIpBin) then DeleteFile(TempIpBin);
  if not PrepareTempIpBin then                //PrepareTempIpBin : cette fonction copie le IP.BIN extrait dans le dossier ipbuild_tmp, vers GetTempDir + '~ipbin.tmp'.
  begin
    AddDebug('Fatal : Error when creating the standard IP.BIN !!! Aborted.', True);
    Halt(ERROR_WITH_STANDARD_IPBIN);
  end;

  AddDebug('Starting IP.BIN creation...');

  //---On va écrire le fichier...
  AddDebug('Writing standard IP.BIN...');

  AssignFile(F, TempIpBin);
  {$I+} Reset(F, 1); {$I-}

  if IOResult <> 0 then
  begin
    AddDebug('Error when creating the stardard IP.BIN file ! Aborted. (Code=' + IntToStr(IOResult) + ')', True);
    Halt(ERROR_WITH_STANDARD_IPBIN);
  end;

  AddDebug('Writing version...');
  WriteVersion(F, Version); //Traitement special

  AddDebug('Writing release date...');
  WriteDate(F, ReleaseDate);    //idem (pour les jours commencant par '0'

  AddDebug('Writing media ID...');
  WriteString(F, MEDIA_ID_ADDR, RandomHexPassword(4));

  AddDebug('Writing manufacturer name...');
  WriteString(F, MANUFACTURER_NAME_ID_ADDR, ManufacturerID);
  //if not Result then Exit;

  AddDebug('Writing boot file name...');
  WriteString(F, BOOTSTRAP_ADDR, BootFileName);
  //if not Result then Exit;

  AddDebug('Writing application title...');
  TS := StringReplace(ApplicationTitle, WrapStr, ' ', [rfReplaceAll, rfIgnoreCase]);
  WriteString(F, APPLICATION_TITLE_ADDR, TS); //faut enlever les #13 + #10 et mettre des blancs à la place
  //if not Result then Exit;

  AddDebug('Writing media type...');
  WriteString(F, MEDIA_TYPE_ADDR, 'CD-ROM1/1');
  //if not Result then Exit;

  AddDebug('Writing product ID...');
  WriteString(F, PRODUCT_ID_ADDR, GenProductNo);
  //if not Result then Exit;

  AddDebug('Writing area symbols...');
  WriteAllAreaSymbols(F);

  AddDebug('Writing SEGA OS info...');
  WriteSegaOS(F);

  AddDebug('Writing extended peripherical infos...');
  WriteAllExtendedPeriph(F);

  AddDebug('Writing minimal buttons needeed section...');
  WriteAllMinimumButtons(F);

  AddDebug('Closing IP.BIN file.');
  CloseFile(F);
  Result := True;  //tout est ok jusqu'a ici.

  //---Ajouter un logo (ValidLogo) au fichier IP.BIN... si y'en a.---
  if Length(LogoImage) <> 0 then
  begin

    if FileExists(LogoImage) then //un logo est mis.
    begin

      if not InsertSelectedImageToIpBin(LogoImage) then
      begin
        AddDebug('Error when creating the logo file. Aborted.', True);
        Stop(ERROR_WITH_LOGO);
      end;

    end else AddDebug('Logo "' + LogoImage + '" not found. Skipping.', True);

  end;

  //---Tester si tout OK--- (final)
  
  if Result then
  begin

    //c'est tout ok. on copie le fichier temp ip.bin à la place du vrai avec son nom attendu.
    //AddDebug('IP.BIN successfully created.');
    
    if FileExists(TempIpBin) then
    begin
      if FileExists(FileName) then DeleteFile(FileName); //effacer l'IP.BIN original (de destination, car le mec est OBLIGE d'overwrite).
      CopyFile(PChar(TempIpBin), PChar(FileName), False); //copier le fichier créé, si il existe...
    end;

    AddDebug('Saved to "' + ExtractFilePath(FileName) + '".');
    AddDebug('YESS! IP.BIN successfully created. Enjoy it !', True);

  end else begin

    AddDebug('NOO :( Error when building IP.BIN. Too bad !', True);
      
  end;

  //on l'efface.
  if FileExists(TempIpBin) then DeleteFile(TempIpBin);
end;

end.
