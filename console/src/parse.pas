unit parse;

interface

uses
  SysUtils;            

const
  SW_HELP1            : string = '-help';
  SW_HELP2            : string = '-h';
  SW_OVERWRITE        : string = '-ow';
  SW_SILENT           : string = '-silent';
  SW_ERRORHELP        : string = '-errmsg';
  SW_LOGO             : string = '-l';
  SW_APPLICATIONTITLE : string = '-a';
  SW_VERSION          : string = '-v';
  SW_RELEASEDATE      : string = '-d';
  SW_MANUFACTURERID   : string = '-m';
  SW_BOOTFILENAME     : string = '-b';
  SW_IPBIN            : string = '-o';

var
  Silent,
  Overwrite,
  Help,
  ShowErrMsg : boolean;

  IP_File, Version, ReleaseDate, ManufacturerID, BootFileName, ApplicationTitle,
  Logo : string;

procedure ParseCmd;
function InvalidSwitch(Switch : string) : boolean;
function IsSwitched(FileName : string) : boolean;

implementation

uses utils, errorlvl;

{
 -silent      : hide all success messages
 -ow          : overwrite all generated files
 -help or -h  : show help
}

procedure ParseCmd;
var
  i   : integer;
  Cmd : string;
  IsAppTitle : boolean; //peut etre sur plusieurs params...
  
begin
  IsAppTitle := False;
  
  for i := 1 to ParamCount do
  begin
    if not IsAppTitle then
      Cmd := LowerCase(ParamStr(i))
    else Cmd := ParamStr(i);

    //Vérifions que les switchs sont bien valides si y'en a.
    if IsSwitched(Cmd) then
    begin
      
      if InvalidSwitch(Cmd) then
      begin
        AddDebug('Invalid switch : ' + Cmd, True);
        AddDebug('Type "' + ThisFile + ' -h" for more infos.');
        Stop(INVALID_SWITCH);
      end;
      
    end;

    //Silencieux.
    if (Cmd = SW_SILENT) then
    begin
      Silent := True;
      IsAppTitle := False;
    end;

    //Affecter le fichier IP.BIN
    if (Cmd = SW_IPBIN) then
    begin
      if not IsSwitched(ParamStr(i+1)) then
        IP_File := ParamStr(i+1);
      IsAppTitle := False;
    end;

    //Ecraser les données si elles existent
    if (Cmd = SW_OVERWRITE) then
    begin
      Overwrite := True;
      IsAppTitle := False;
    end;

    //Afficher les codes d'erreurs
    if (Cmd = SW_ERRORHELP) then
    begin
      ShowErrMsg := True;
      IsAppTitle := False;
    end;

    //Afficher l'aide.
    if (Cmd = SW_HELP1) or (Cmd = SW_HELP2) then
    begin
      Help := True;
      Exit; //on peut sortir... quand on affiche l'aide on fait rien d'autre.
    end;

    //Version
    if (Cmd = SW_VERSION) then
    begin
      if not IsSwitched(ParamStr(i+1)) then
        Version := ParamStr(i+1);
      IsAppTitle := False;
    end;

    //Date
    if (Cmd = SW_RELEASEDATE) then
    begin
      if not IsSwitched(ParamStr(i+1)) then
        ReleaseDate := ParamStr(i+1);
      IsAppTitle := False;
    end;

    //ManufacturerID
    if (Cmd = SW_MANUFACTURERID) then
    begin
      if not IsSwitched(ParamStr(i+1)) then
        ManufacturerID := ParamStr(i+1);
      IsAppTitle := False;
    end;

    //BootFileName
    if (Cmd = SW_BOOTFILENAME) then
    begin
      if not IsSwitched(ParamStr(i+1)) then
        BootFileName := ParamStr(i+1);
      IsAppTitle := False;
    end;

    //Application Title
    if (Cmd = SW_APPLICATIONTITLE) then
    begin
      ApplicationTitle := '';
      IsAppTitle := True;
    end;

    //Logo
    if (Cmd = SW_LOGO) then
    begin
      if not IsSwitched(ParamStr(i+1)) then
        Logo := ParamStr(i+1);
      IsAppTitle := False;
    end;

    //peut etre sur plusieurs params..
    if IsAppTitle and (Cmd <> SW_APPLICATIONTITLE) then   //pas de '-a' dans le truc
    begin

      if Length(ApplicationTitle) = 0 then
        ApplicationTitle := Cmd
      else ApplicationTitle := ApplicationTitle + ' ' + Cmd;

    end;

  end;
end;

//---InvalidSwitch---
function InvalidSwitch(Switch : string) : boolean;
begin
  Result := True;

  //Si c'est vide, on s'en fout.
  if Length(Switch) = 0 then
  begin
    Result := False;
    Exit;
  end;

  //Sinon, on va traiter.
  if Switch[1] = '-' then
  begin
    Switch := LowerCase(Switch);

    if (Switch = SW_HELP1)
    or (Switch = SW_HELP2)
    or (Switch = SW_OVERWRITE)
    or (Switch = SW_SILENT)
    or (Switch = SW_ERRORHELP)
    or (Switch = SW_LOGO)
    or (Switch = SW_APPLICATIONTITLE)
    or (Switch = SW_VERSION)
    or (Switch = SW_RELEASEDATE)
    or (Switch = SW_MANUFACTURERID)
    or (Switch = SW_BOOTFILENAME)
    or (Switch = SW_IPBIN) then
    begin
      Result := False;
      Exit;
    end;

  end else Result := False;
end;

//---IsSwitched---
function IsSwitched(FileName : string) : boolean;
begin
  Result := False;
  if Length(FileName) = 0 then Exit;

  if FileName[1] = '-' then
    Result := True;
end;


end.
