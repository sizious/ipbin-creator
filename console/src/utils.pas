unit utils;

interface

uses
  Windows, SysUtils;

const
  WrapStr : string = #13 + #10;
  
var
  ThisFile : string;

function IsValidFileName(FileName : string) : boolean;
procedure DisplayHelp;
procedure AddDebug(Msg : string ; Error : boolean = False);
procedure DisplayErrCodes;
function GetRealPath(Path : string) : string;
function GetTempDir : string;
function GaucheNDroite(substr: string; s: string;n:integer): string;
function NbSousChaine(substr: string; s: string): integer;
procedure ExtractAllFiles; stdcall ; external 'ipbuild.dll';
procedure DeleteAllFiles; stdcall ; external 'ipbuild.dll';
function PrepareTempIpBin : boolean; stdcall ; external 'ipbuild.dll';
function GetFullPath(FileOrPathFile : string) : string;
procedure CheckParams(var  CVersion, CReleaseDate, CManufacturerID, CBootFileName,
                          CApplicationTitle : string);
procedure Stop(ErrorCode : integer = 0);

implementation

uses parse;

//---DisplayErrCodes---
procedure DisplayErrCodes;
begin
  WriteLn('  Errors codes : No errors                 : 0');
  WriteLn('                 Invalid switch            : 1');
  WriteLn('                 Input/Output files errors : 2');
  WriteLn('                 Invalid parameters        : 3');
  WriteLn('                 Error with the IP.BIN     : 4');
  WriteLn('                 Error with the logo       : 5');
end;

//---DisplayHelp---
procedure DisplayHelp;
begin
  WriteLn('Generate a valid customized IP.BIN file.');
  WriteLn(#13 + #10 + '  Usage :' + #13 + #10 + '    '
          + ThisFile + ' [option1, ..., optionN]' + #13 + #10);

//  WriteLn('   If you write only the .ELF file, the .BIN file will be called' + #13 + #10 +
//    '   the same name as the .ELF.' + #13 + #10);

  WriteLn('  Options  : -o          : Change the location and/or filename of the ''IP.BIN''.');
  WriteLn('             -v          : Change version.');
  WriteLn('             -d          : Change date, format : dd/mm/yyyy.');
  WriteLn('             -m          : Change manufacturer.');
  WriteLn('             -b          : Change boot file name (Such : 1ST_READ.BIN).');
  WriteLn('             -a          : Change application title. (Such : YOUR PROG!)');
  WriteLn('             -l          : Insert any kind of image in the IP.BIN.');
  WriteLn('  Switches : -ow         : overwrite output files if file exists and');
  WriteLn('                           create directories if it isn''t found');
  WriteLn('             -silent     : hide all success messages');
  WriteLn('             -help or -h : Show this help');
  WriteLn('             -errmsg     : Show errors codes' + #13 + #10);

  WriteLn('  Examples : ' + ThisFile + ' -o yo\ip.bin -a Hi U! -v 1.0 -l "f:\nice app\hi.bmp"');
  WriteLn('                 Create a ''<CurrDir>\yo\ip.bin'' file with f:\.\hi.bmp inside.');
  //WriteLn('');
end;

//---AddDebug---
//Si c'est une error, même si le switch "-silent" est activé, on l'affiche.
procedure AddDebug(Msg : string ; Error : boolean = False);
begin

  if Error then
  begin
    WriteLn(ThisFile + ': ' + Msg);
    Exit;
  end;

  if Silent then Exit;
  WriteLn(ThisFile + ': ' + Msg);
end;

//---IsValidFileName---
function IsValidFileName(FileName : string) : boolean;
const
  InvalidChars : array[1..9] of char = ('\', '/', ':', '*', '?',
                                        '"', '<', '>', '|');
var
  i, j        : integer;
  CharToScan  : char;
  FnToScan    : string;

begin
  Result := True;
  if Length(FileName) = 0 then Exit; //si c'est vide, c'est implicite (comme je l'ai dit dans l'aide).

  FnToScan := ExtractFileName(FileName); //pour avoir que le nom de fichier !
  if Length(FnToScan) = 0 then FnToScan := FileName;

  //Chopper le caractère à scanner.
  for i := 1 to Length(FnToScan) do
  begin
    CharToScan := FnToScan[i];

    //Scanner le caractère choppé avec les caractères du tableau.
    for j := 1 to 9 do
    begin

      //On a trouvé ce qu'on voulait.
      if UpperCase(CharToScan) = UpperCase(InvalidChars[j]) then
      begin
        Result := False;
        Exit;
      end;

    end;
    
  end; 
  
end;

//---GetRealPath---
function GetRealPath(Path : string) : string;
var
  i : integer;
  LastCharWasSeparator : Boolean;

begin
  Result := '';
  if Length(Path) = 0 then Exit;

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
  Dossier: array[0..MAX_PATH] of Char;

begin
  Result := '';
  if GetTempPath(SizeOf(Dossier), Dossier)<>0 then Result := StrPas(Dossier);
end;

//---GaucheNDroite---
function GaucheNDroite(substr: string; s: string;n:integer): string;
var i:integer;
begin
  S:=S+substr;
  for i:=1 to n do
  begin
    S:=copy(s, pos(substr, s)+length(substr), length(s)-pos(substr, s)+length(substr));
  end;
  result:=copy(s, 1, pos(substr, s)-1);
end;

//---droite---
function droite(substr: string; s: string): string;
begin
  if pos(substr,s)=0 then result:='' else
    result:=copy(s, pos(substr, s)+length(substr), length(s)-pos(substr, s)+length(substr));
end;

//---NbSousChaine---
function NbSousChaine(substr: string; s: string): integer;
begin
  result:=0;
  while pos(substr,s)<>0 do
  begin
    S:=droite(substr,s);
    inc(result);
  end;
end;

//---GetFullPath---
{ Avoir le chemin complet + le nom du fichier.
  OK si :
  - .\caca\pd.bin, le '.' sera remplacé par le rép courant.
  - caca\pd.bin, on aura le rép courant avant.
  - pd.bin, on aura le rep courant avant aussi.
  - f:\caca\pd.bin, on change rien. }
function GetFullPath(FileOrPathFile : string) : string;
begin
  //Result := FileOrPathFile;
  //if Length(FileOrPathFile) = 0 then Exit;
  
  if Length(ExtractFilePath(FileOrPathFile)) = 0 then

    Result := GetRealPath(GetCurrentDir) + FileOrPathFile

  else begin

    //c'est du style '.\' : si le mec il entre ".\cool\pd" le "." est remplacé par le rep. courant.
    if FileOrPathFile[1] = '.' then
      Result := StringReplace(FileOrPathFile, '.', GetRealPath(GetCurrentDir), [rfIgnoreCase])
    else begin

      if NbSousChaine(':', ExtractFilePath(FileOrPathFile)) = 0 then //c'est pas un chemin direct.
        Result := GetRealPath(GetCurrentDir) + GetRealPath(ExtractFilePath(FileOrPathFile)) + ExtractFileName(FileOrPathFile) //on ajoute la pos. courante
      else Result := FileOrPathFile;

    end;

    //si c'est putain\pd.a
    //Result := GetRealPath(GetCurrentDir) + GetRealPath(ExtractFilePath(FileOrPathFile)) + ExtractFileName(FileOrPathFile); //c'est un chemin direct..  

  end;

  Result := GetRealPath(ExtractFilePath(Result)) + ExtractFileName(Result);
end; 

//---CheckParams---
procedure CheckParams(var CVersion, CReleaseDate, CManufacturerID, CBootFileName,
  CApplicationTitle : string);
begin

  //Vérif si la version est bonne.. "1.000", longeur : 5.
  if Length(CVersion) > 5 then
  begin
    AddDebug('Version too long. Truncated.');
    Version := Copy(CVersion, 0, 5);
  end;

  //Ceci pour éviter les dates du style : 000/000/00000
  //ca me soule ca marche pas. (vérifié lors de l'écriture de la date).
{  CReleaseDate := '/' + CReleaseDate + '/';
  writeln(CReleaseDate);
  ReleaseDate := ''; //effacer la fausse date.
  Temp := GaucheNDroite('/', CReleaseDate, 0);
  WRITELN(temp);
  ReleaseDate := ReleaseDate + Copy(Temp, 0, 1) + '/';
  Temp := GaucheNDroite('/', CReleaseDate, 1);
  ReleaseDate := ReleaseDate + Copy(Temp, 0, 1) + '/';
  Temp := GaucheNDroite('/', CReleaseDate, 2);
  ReleaseDate := ReleaseDate + Copy(Temp, 0, 3);
  WRITELN(RELEASEDATE);
}

  //Date trop longue ? 00/00/0000
  if Length(ReleaseDate) > 10 then
  begin
    AddDebug('Release date too long. Truncated.');
    ReleaseDate := Copy(ReleaseDate, 0, 10);
  end;

  //ManufacturerID trop long?
  if Length(CManufacturerID) > 16 then
  begin
    AddDebug('Manufacturer ID too long. Truncated.');
    ManufacturerID := Copy(CManufacturerID, 0, 16);
  end;

  //pour le nom du fichier de boot.
  if Length(CBootFileName) > 12 then
  begin
    AddDebug('Release date too long. Truncated.');
    BootFileName := Copy(CBootFileName, 0, 12);
  end;

  if Length(CApplicationTitle) > 128 then
  begin
    AddDebug('Application title too long. Truncated.');
    ApplicationTitle := Copy(CApplicationTitle, 0, 128);
  end;

end;

//---Stop---
procedure Stop(ErrorCode : integer = 0);
begin
  DeleteAllFiles;
  Halt(ErrorCode);
end;

end.
