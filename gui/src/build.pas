unit build;

interface

uses
  Windows, SysUtils, DateUtils;
  
function BuildFile(FileName : string) : boolean;

implementation

uses u_const, main, u_bin_save, utils, logoman, imgman, u_build;

const
  PROGRESS_MAX_WITHOUT_MR : integer = 15;
  PROGRESS_MAX_WITH_MR    : integer = 20;
  
var
  F : File;

//---BuildFile---
function BuildFile(FileName : string) : boolean;
var
  Directory,
  TempIpBin,
  TS   : string;    //TS : temp string

  
begin
  Result := False;
  Main_Form.pBar.Position := 0;

  //Extraire le dossier du FileName.
  Directory := GetRealPath(ExtractFilePath(FileName));
  if DirectoryExists(Directory) = False then Exit;

  //Copier le fichier IP.BIN vers le temp.
  TempIpBin := GetTempDir + '~ipbin.tmp';     //fichier temporaire qui va être créé.
  if FileExists(TempIpBin) then DeleteFile(TempIpBin);
  if not PrepareTempIpBin then                //PrepareTempIpBin : cette fonction copie le IP.BIN extrait dans le dossier ipbuild_tmp, vers GetTempDir + '~ipbin.tmp'.
  begin
    AddDebug('Fatal : Error when creating the standard IP.BIN !!! Aborted.');
    MsgBox(Main_Form.Handle, 'Error when creating the standard IP.BIN !!!'
      + WrapStr + 'Aborted.', 'Fatal Error', 16);
    Exit;
  end;

  if Length(Main_Form.eFileLogo.Text) = 0 then
    Main_Form.pBar.Max := PROGRESS_MAX_WITHOUT_MR
  else Main_Form.pBar.Max := PROGRESS_MAX_WITH_MR;

  AddDebug('Starting IP.BIN creation...');

  //---On va écrire le fichier...
  AddDebug('Writing standard IP.BIN...');
  StepIt;

  AssignFile(F, TempIpBin);
  {$I+} Reset(F, 1); {$I-}

  if IOResult <> 0 then
  begin
    AddDebug('Error when creating the stardard IP.BIN file ! Aborted. (Code=' + IntToStr(IOResult) + ')');
    MsgBox(Main_Form.Handle, 'Error when creating the stardard IP.BIN file (Code=' + IntToStr(IOResult) + ').' + WrapStr + 'Aborted.', 'Fatal Error', 16);
    AddDebug('Ready');
    Exit;
  end;

  StepIt;
  AddDebug('Writing version...');
  WriteVersion(F); //Traitement special
  //if not Result then Exit;

  StepIt;
  AddDebug('Writing release date...');
  WriteDate(F);    //idem (pour les jours commencant par '0'
  //if not Result then Exit;

  StepIt;
  AddDebug('Writing media ID...');
  WriteString(F, MEDIA_ID_ADDR, Main_Form.eMediaID.Text);
  //if not Result then Exit;

  StepIt;
  AddDebug('Writing manufacturer name...');
  WriteString(F, MANUFACTURER_NAME_ID_ADDR, Main_Form.eManID.Text);
  //if not Result then Exit;

  StepIt;
  AddDebug('Writing boot file name...');
  WriteString(F, BOOTSTRAP_ADDR, Main_Form.cbBootFilename.Text);
  //if not Result then Exit;

  StepIt;
  AddDebug('Writing application title...');
  TS := StringReplace(Main_Form.mGameTitle.Text, WrapStr, ' ', [rfReplaceAll, rfIgnoreCase]);
  WriteString(F, APPLICATION_TITLE_ADDR, TS); //faut enlever les #13 + #10 et mettre des blancs à la place
  //if not Result then Exit;

  StepIt;
  AddDebug('Writing media type...');
  WriteString(F, MEDIA_TYPE_ADDR, Main_Form.cbMediaConfig.Text);
  //if not Result then Exit;

  StepIt;
  AddDebug('Writing product ID...');
  WriteString(F, PRODUCT_ID_ADDR, Main_Form.eProdNo.Text);
  //if not Result then Exit;

  StepIt;
  AddDebug('Write area symbols...');
  WriteAreaSymbols(F);
  //if not Result then Exit;

  StepIt;
  AddDebug('Writing SEGA OS info...');
  WriteSegaOS(F);
  //if not Result then Exit;

  StepIt;
  AddDebug('Writing extended peripherical infos...');
  WriteExtendedPeriph(F);
  //if not Result then Exit;

  StepIt;
  AddDebug('Writing minimal buttons needeed section...');
  WriteMinimumButtons(F);
  //if not Result then Exit;

  StepIt;
  AddDebug('Closing IP.BIN file.');
  CloseFile(F);
  Result := True;  //tout est ok jusqu'a ici.

  //---Ajouter un logo (ValidLogo) au fichier IP.BIN... si y'en a.---
  if FileExists(Main_Form.eFileLogo.Text) then //un logo est mis.
  begin
    StepIt;
    if not InsertSelectedImageToIpBin then Exit;
  end;

  //---Tester si tout OK--- (final)
  StepIt;
  Main_Form.pBar.Position := Main_Form.pBar.Max;
  
  if Result then
  begin

    //c'est tout ok. on copie le fichier temp ip.bin à la place du vrai avec son nom attendu.
    AddDebug('IP.BIN successfully created.');
    
    if FileExists(TempIpBin) then
    begin
      if FileExists(FileName) then DeleteFile(FileName); //effacer l'IP.BIN original (de destination, car le mec est OBLIGE d'overwrite).
      CopyFile(PChar(TempIpBin), PChar(FileName), False); //copier le fichier créé, si il existe...
    end;

    MsgBox(Main_Form.Handle, 'YESS! IP.BIN successfully created. Enjoy it !', 'Information', 64);

  end else begin

    AddDebug('Error when building IP.BIN !');
    MsgBox(Main_Form.Handle, 'NOO :( Error when building IP.BIN. Too bad !'
      + WrapStr + 'Please view the Debug Log for more informations.', 'Information', 48);
      
  end;

  //on l'efface.
  if FileExists(TempIpBin) then DeleteFile(TempIpBin);

  AddDebug('Ready');
  Main_Form.pBar.Position := 0;
end;

end.
