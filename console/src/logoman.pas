unit logoman;

interface

uses
  Windows, SysUtils, Classes;

var
  PNG_TO_MR_TOOL    : string = 'pngtomr.exe';
  LOGO_INSERT_TOOL  : string = 'logoinsert.exe';
  IPBUILD_TMP       : string = 'ipbuild_tmp'; //nom du dossier temp ou y'a tt les fichiers important.
  UtilsDir          : string = '';

function InsertSelectedImageToIpBin(LogoImage : string) : boolean;
function ConvertSelectedImageToMr(PngFile : string) : boolean;
function ExecuteCmd(Command : string) : boolean;

implementation

uses utils, imgman, errorlvl;

var
  SL        : TStringList;

//---CopyTextToConsole---
procedure CopyTextToConsole;
var
  i : integer;

begin
  for i := 0 to SL.Count - 1 do
    WriteLn(SL.Strings[i]);
end;

//---RunDosInStringList---
procedure RunDosInStringList(DosApp : String);
const 
    ReadBuffer = 2400;
     
var 
  Security            : TSecurityAttributes; 
  ReadPipe,WritePipe  : THandle;
  start              : TStartUpInfo;
  ProcessInfo        : TProcessInformation; 
  Buffer              : Pchar; 
  BytesRead          : DWord; 
  Apprunning          : DWord;
   
begin 
  With Security do
  begin 
      nlength            := SizeOf(TSecurityAttributes); 
      binherithandle      := true; 
      lpsecuritydescriptor:= nil; 
  end; 
  if Createpipe (ReadPipe, WritePipe,@Security, 0) then 
  begin 
      Buffer  := AllocMem(ReadBuffer + 1); 
      FillChar(Start,Sizeof(Start),#0); 
      start.cb          := SizeOf(start); 
      start.hStdOutput  := WritePipe; 
      start.hStdInput  := ReadPipe; 
      start.dwFlags    := STARTF_USESTDHANDLES +STARTF_USESHOWWINDOW; 
      start.wShowWindow := SW_HIDE; 

      if CreateProcess(nil,PChar(DosApp),@Security,@Security,true,NORMAL_PRIORITY_CLASS,nil,nil,start,ProcessInfo) 
      then 
      begin 
            repeat 
                  Apprunning := WaitForSingleObject(ProcessInfo.hProcess,100); 
                  //Application.ProcessMessages; 
            until (Apprunning <> WAIT_TIMEOUT); 
            repeat 
                  BytesRead := 0; 
                  ReadFile(ReadPipe,Buffer[0], 
                  ReadBuffer,BytesRead,nil); 
                  Buffer[BytesRead]:= #0; 
                  OemToAnsi(Buffer,Buffer);
                  SL.Text := SL.text + String(Buffer);
            until (BytesRead < ReadBuffer); 
      end; 
      FreeMem(Buffer); 
      CloseHandle(ProcessInfo.hProcess); 
      CloseHandle(ProcessInfo.hThread); 
      CloseHandle(ReadPipe); 
      CloseHandle(WritePipe); 
  end; 
end;

//---ParseErrors---
function ParseErrors : boolean;
const
  TErrors : array[1..6] of string =
            ( 'Error with',
              'Reduce the number of colors to <= 128 and try again.',
              'This will NOT fit in a normal',
              'Cannot open ',
              'Warning: this image is larger than 8192 bytes and will',
              'No such file or directory');
var
  i, j : integer;

begin
  Result := True;

  if SL = nil then
  begin
    Result := False;
    AddDebug('ReadProcess failed. Skipped.');
    Exit;
  end;

  for i := 0 to SL.Count - 1 do
  begin

    for j := 1 to 6 do //nb erreurs
    begin

      if (NbSousChaine(TErrors[j], SL.Strings[i]) > 0) then
      begin
        //AddDebug('Error when inserting logo in IP.BIN. ' + SL.Strings[i] + ', aborted.');
        Result := False;
        Exit;
      end;

    end;

  end;

end;

//---ExecuteCmd---
function ExecuteCmd(Command : string) : boolean;
begin
  //Lancer l'execution
  Result := False;

  SL := TStringList.Create;
  try
    SL.Clear;
    RunDosInStringList(Command);
    CopyTextToConsole;
    Result := ParseErrors;
  except
    SL.Free;
  end;

end;

//---PngToMr---
function PngToMr(PngFile, MrFile : string) : boolean;
var
  CommandLine : string;

begin
  //Result := False;

  //Vérifier si l'exe existe
  if not FileExists(UtilsDir + PNG_TO_MR_TOOL) then
  begin
    AddDebug('Error : ' + UtilsDir + PNG_TO_MR_TOOL + ' not found.', True);
    Halt(ERROR_WITH_LOGO);
  end;

  //fichier source existe pas = erreur
  if not FileExists(PngFile) then
  begin
    AddDebug('Error : ' + PngFile + ' not found.', True);
    Halt(ERROR_WITH_LOGO);
  end;

  //fichier mr, par contre, on peut l'effacer
  if FileExists(MrFile) then
    DeleteFile(MrFile);

  //lancer commande.
  CommandLine := UtilsDir + PNG_TO_MR_TOOL + ' "' + PngFile + '" "' + MrFile + '"';
  Result := ExecuteCmd(CommandLine);
end;

//---InsertLogo---
function InsertLogo(MrFile, IpBin : string) : boolean;
var
  CommandLine : string;

begin
  //Result := False;

  if not FileExists(UtilsDir + PNG_TO_MR_TOOL) then
  begin
    AddDebug('Error : ' + UtilsDir + PNG_TO_MR_TOOL + ' not found.', True);
    Halt(ERROR_WITH_LOGO);
  end;

  //les deux fichiers sont a verifier : .mr file existe?
  if not FileExists(MrFile) then
  begin
    AddDebug('Error : ' + MrFile + ' not found.', True);
    Halt(ERROR_WITH_LOGO);
  end;

  //les deux fichiers sont à verifier. ip.bin existe ?
  if not FileExists(IpBin) then
  begin
    AddDebug('Error : ' + IpBin + ' not found.', True);
    Halt(ERROR_WITH_STANDARD_IPBIN);
  end;

  CommandLine := UtilsDir + LOGO_INSERT_TOOL + ' "' + MrFile + '" "' + IpBin + '"';
  Result := ExecuteCmd(CommandLine);
end;

//---ConvertSelectedImageToMr---
function ConvertSelectedImageToMr(PngFile : string) : boolean;
var
  ValidLogo : string;
  MrFile : string;
    
begin
  //Result := False;

  //ValidLogo est le nom du vrai PNG a convertir en MR.
  ValidLogo := GetTempDir + '~iplogo.tmp';
  if FileExists(ValidLogo) then DeleteFile(ValidLogo);  //etre sur qu'on peut faire le fichier ~iplogo.tmp.
      
  //---Convertir l'image en PNG, retaillée si besoin---
  if not GenerateValidPng(PngFile, ValidLogo) then
  begin
    AddDebug('Error when converting the file to a valid re-sized PNG !', True);
    //Exit;     //pour le test final... c'est foiré!
    Halt(ERROR_WITH_LOGO);
  end;

  //AddDebug('Logo insert full procedure : start !');
  AddDebug('Converting the selected image to MR format...');
  MrFile := GetTempDir + '~tempmr.tmp';
  Result := PngToMr(ValidLogo, MrFile);

  if FileExists(ValidLogo) then DeleteFile(ValidLogo); //on a plus besoin du logo temporaire.

  if not Result then Exit;

  Result := True;
end;

//---InsertSelectedImageToIpBin---
function InsertSelectedImageToIpBin(LogoImage : string) : boolean;
var
  MrFile, TempIpBin : string;

begin
  //Result := False;
  TempIpBin := GetTempDir + '~ipbin.tmp';     //fichier temporaire qui va être créé.
  MrFile := GetTempDir + '~tempmr.tmp';

  Result := ConvertSelectedImageToMr(LogoImage);
  if not Result then Exit;
  
  if not FileExists(MrFile) then Exit;

  AddDebug('Inserting the image in the IP.BIN...');
  Result := InsertLogo(MrFile, TempIpBin);

  if not Result then
  begin
    AddDebug('Error when inserting the image in the IP.BIN !', True);
    //Exit;
    Halt(ERROR_WITH_LOGO);
  end;

  if FileExists(MrFile) then DeleteFile(MrFile);
  AddDebug('Logo inserted in the IP.BIN.');
  Result := True;
end;

end.
