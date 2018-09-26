unit logoman;

interface

uses
  Windows, SysUtils, Forms, StdCtrls;

var
  PNG_TO_MR_TOOL    : string = 'pngtomr.exe';
  LOGO_INSERT_TOOL  : string = 'logoinsert.exe';
  IPBUILD_TMP       : string = 'ipbuild_tmp'; //nom du dossier temp ou y'a tt les fichiers important.

//function InsertPngInIpBin(PngFile, IpBin : string) : boolean;   //cette fct faisait tout : c pourri.
function InsertSelectedImageToIpBin : boolean;
function ConvertSelectedImageToMr : boolean;

implementation

uses main, utils, debuglog, imgman;

//---RunDosInMemo---
procedure RunDosInMemo(DosApp : String ; AMemo:TMemo);
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
                  Application.ProcessMessages; 
            until (Apprunning <> WAIT_TIMEOUT); 
            repeat 
                  BytesRead := 0; 
                  ReadFile(ReadPipe,Buffer[0], 
                  ReadBuffer,BytesRead,nil); 
                  Buffer[BytesRead]:= #0; 
                  OemToAnsi(Buffer,Buffer); 
                  AMemo.Text := AMemo.text + String(Buffer); 
            until (BytesRead < ReadBuffer); 
      end; 
      FreeMem(Buffer); 
      CloseHandle(ProcessInfo.hProcess); 
      CloseHandle(ProcessInfo.hThread); 
      CloseHandle(ReadPipe); 
      CloseHandle(WritePipe); 
  end; 
end;

//---NbSousChaine---
function NbSousChaine(substr: string; s: string): integer;

function Droite(substr: string; s: string): string;
begin
  if pos(substr,s)=0 then result:='' else
    result:=copy(s, pos(substr, s)+length(substr), length(s)-pos(substr, s)+length(substr));
end;

begin
  result:=0;
  while pos(substr,s)<>0 do
  begin
    S:=droite(substr,s);
    inc(result);
  end;
end;

//---ParseErrors---
function ParseErrors(AMemo : TMemo) : boolean;
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

  for i := 0 to AMemo.Lines.Count - 1 do
  begin

    for j := 1 to 6 do //nb erreurs
    begin

      if (NbSousChaine(TErrors[j], AMemo.Lines.Strings[i]) > 0) then
      begin
        AddDebug('Error when inserting logo in IP.BIN. ' + AMemo.Lines.Strings[i] + ', aborted.');
        MsgBox(Main_Form.Handle, 'Error when inserting logo in IP.BIN.'
          + WrapStr + AMemo.Lines.Strings[i]
          + WrapStr + 'IP.BIN creation aborted.', 'Error', 48);
        Result := False;
        Exit;
      end;

    end;

  end;

end;

//---CopyMemoToDebugListBox---
procedure CopyMemoToDebugListBox;
var
  i       : integer;
  Memo    : TMemo;
//  ListBox : TListBox;

begin
  Memo := Main_Form.mRun;
//  ListBox := DebugLog_Form.lbDebug;

  for i := 0 to Memo.Lines.Count - 1 do
  begin
    //ListBox.Items.Add(Memo.Lines.Strings[i]);
    AddDebug(Memo.Lines.Strings[i]);
  end;
end;

//---ExecuteCmd---
function ExecuteCmd(Command : string) : boolean;
var
   Memo : TMemo;

begin
  Memo := Main_Form.mRun;

  //Lancer l'execution
  Memo.Clear;
  RunDosInMemo(Command, Memo);
  CopyMemoToDebugListBox;
  Result := ParseErrors(Memo);
end;

//---PngToMr---
function PngToMr(PngFile, MrFile : string) : boolean;
var
  CommandLine : string;

begin
  Result := False;

  //Vérifier si l'exe existe
  if not FileExists(PNG_TO_MR_TOOL) then
  begin
    AddDebug('Error : ' + PNG_TO_MR_TOOL + ' not found.');
    MsgBox(Main_Form.Handle, 'Error when running "' + PNG_TO_MR_TOOL + '".', 'Error', 16);
    Exit;
  end;

  //fichier source existe pas = erreur
  if not FileExists(PngFile) then
  begin
    AddDebug('Error : ' + PngFile + ' not found.');
    MsgBox(Main_Form.Handle, 'File "' + PngFile + '" not found.', 'Error', 48);
    Exit;
  end;

  //fichier mr, par contre, on peut l'effacer
  if FileExists(MrFile) then
    DeleteFile(MrFile);

  //lancer commande.
  CommandLine := PNG_TO_MR_TOOL + ' "' + PngFile + '" "' + MrFile + '"';
  Result := ExecuteCmd(CommandLine);
end;

//---InsertLogo---
function InsertLogo(MrFile, IpBin : string) : boolean;
var
  CommandLine : string;

begin
  Result := False;

  if not FileExists(PNG_TO_MR_TOOL) then
  begin
    AddDebug('Error : ' + PNG_TO_MR_TOOL + ' not found.');
    MsgBox(Main_Form.Handle, 'Error when running "' + PNG_TO_MR_TOOL + '".', 'Error', 16);
    Exit;
  end;

  //les deux fichiers sont a verifier : .mr file existe?
  if not FileExists(MrFile) then
  begin
    AddDebug('Error : ' + MrFile + ' not found.');
    MsgBox(Main_Form.Handle, 'File "' + MrFile + '" not found.', 'Error', 48);
    Exit;
  end;

  //les deux fichiers sont à verifier. ip.bin existe ?
  if not FileExists(IpBin) then
  begin
    AddDebug('Error : ' + IpBin + ' not found.');
    MsgBox(Main_Form.Handle, 'File "' + IpBin + '" not found.', 'Error', 48);
    Exit;
  end;

  CommandLine := LOGO_INSERT_TOOL + ' "' + MrFile + '" "' + IpBin + '"';
  Result := ExecuteCmd(CommandLine);
end;

//---InsertPngInIpBin---
//Cette fonction fait les deux... mais c'est pas bien.
//C'est con de dire apres que tout est prêt, dire "merde le png finalement est pas bon".
//faut le dire avant, lorsque le mec veut passer à la création du ip.bin
{function InsertPngInIpBin(PngFile, IpBin : string) : boolean;
var
  MrFile : string;

begin
  AddDebug('-> Logo insert full procedure : start !');
  MrFile := GetTempDir + ExtractFileName(ChangeFileExt(PngFile, '.mr'));
   
  Result := PngToMr(PngFile, MrFile);
  if not Result then Exit;

  Result := InsertLogo(MrFile, IpBin);
  if FileExists(MrFile) then DeleteFile(MrFile);

  if Result then
  begin
    AddDebug('logoinsert.exe: Done !');
    AddDebug('-> Logo insert full procedure : done.');
  end;
end; }

//---ConvertSelectedImageToMr---
function ConvertSelectedImageToMr : boolean;
var
  ValidLogo : string;
  MrFile,
  PngFile : string;
    
begin
  Result := False;
  PngFile := Main_Form.eFileLogo.Text;

  //ValidLogo est le nom du vrai PNG a convertir en MR.
  ValidLogo := GetTempDir + '~iplogo.tmp';
  if FileExists(ValidLogo) then DeleteFile(ValidLogo);  //etre sur qu'on peut faire le fichier ~iplogo.tmp.
      
  //---Convertir l'image en PNG, retaillée si besoin---
  if not GenerateValidPng(PngFile, ValidLogo) then
  begin
    AddDebug('Error when converting the file to a valid re-sized PNG !');
    MsgBox(Main_Form.Handle, 'Error when converting the file to a valid re-sized PNG !', 'Error', 48);
    AddDebug('Ready');
    Exit;     //pour le test final... c'est foiré!
  end;

  //AddDebug('Logo insert full procedure : start !');
  AddDebug('* Converting the selected image to MR format...');
  MrFile := GetTempDir + '~tempmr.tmp';
  Result := PngToMr(ValidLogo, MrFile);

  if FileExists(ValidLogo) then DeleteFile(ValidLogo); //on a plus besoin du logo temporaire.

  AddDebug('Ready');
  if not Result then Exit;

  Result := True;
end;

//---InsertSelectedImageToIpBin---
function InsertSelectedImageToIpBin : boolean;
var
  MrFile, PngFile, TempIpBin : string;
  
begin
  Result := False;
  TempIpBin := GetTempDir + '~ipbin.tmp';     //fichier temporaire qui va être créé.
  PngFile := Main_Form.eFileLogo.Text;
  MrFile := GetTempDir + '~tempmr.tmp';

  if not FileExists(MrFile) then Exit;

  AddDebug('Inserting the image in the IP.BIN...');
  Result := InsertLogo(MrFile, TempIpBin);

  if not Result then
  begin
    AddDebug('Error when inserting the image in the IP.BIN !');
    AddDebug('Ready');
    Exit;
  end;

  if FileExists(MrFile) then DeleteFile(MrFile);
  AddDebug('Logo inserted in the IP.BIN.');
  Result := True;
end;

end.
