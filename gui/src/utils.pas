unit utils;

interface

uses
  Windows, SysUtils, Classes, Forms, StdCtrls, ExtCtrls, DateUtils;

const
  WrapStr     : string = #13 + #10;

procedure GoNext(Index : integer);
procedure GoPrev(Index : integer);
function MsgBox(Handle : HWND ; Message, Caption : string ; Flags : integer) : integer;
procedure ShowMessage(Message : string);
function GetRealPath(Path : string) : string;
function GetTempDir : string;
procedure AddDebug(Msg : string);
procedure StepIt;
procedure ExtractAllFiles; stdcall ; external 'ipbuild.dll';
procedure DeleteAllFiles; stdcall ; external 'ipbuild.dll';
function PrepareTempIpBin : boolean; stdcall ; external 'ipbuild.dll';
procedure CleanTempFiles;
procedure InitDebugLog;
procedure PutCurrentDate;
procedure SaveManufacturerList;
procedure RestartApp;

implementation

uses main, debuglog;

//---GoNext---
procedure GoNext(Index : integer);
var
  Comp : TComponent;

begin
  Comp := Main_Form.FindComponent('Screen' + IntToStr(Index));
  if Comp is TPanel then (Comp as TPanel).Visible := True;
  Comp := Main_Form.FindComponent('NScreen' + IntToStr(Index));
  if Comp is TButton then (Comp as TButton).Visible := True;
  Comp := Main_Form.FindComponent('PScreen' + IntToStr(Index));
  if Comp is TButton then (Comp as TButton).Visible := True;
end;

//---GoBack---
procedure GoPrev(Index : integer);
var
  Comp : TComponent;

begin
  Comp := Main_Form.FindComponent('Screen' + IntToStr(Index));
  if Comp is TPanel then (Comp as TPanel).Visible := False;
  Comp := Main_Form.FindComponent('NScreen' + IntToStr(Index));
  if Comp is TButton then (Comp as TButton).Visible := False;
  Comp := Main_Form.FindComponent('PScreen' + IntToStr(Index));
  if Comp is TButton then (Comp as TButton).Visible := False;
end;

//---RestartApp---
procedure RestartApp;
begin
  //C'est moche, mais j'ai pas le temps de faire autrement.
  //Car quand je fait un for GoPrev(i), ca fait foireux, c'est grillé.
  Main_Form.Screen1.Visible := False;
  Main_Form.Screen2.Visible := False;
  Main_Form.Screen3.Visible := False;
  Main_Form.Screen4.Visible := False;
  Main_Form.Screen5.Visible := False;
  Main_Form.Screen6.Visible := False;
  Main_Form.PScreen1.Visible := False;
  Main_Form.PScreen2.Visible := False;
  Main_Form.PScreen3.Visible := False;
  Main_Form.PScreen4.Visible := False;
  Main_Form.PScreen5.Visible := False;
  Main_Form.PScreen6.Visible := False;
  Main_Form.NScreen1.Visible := False;
  Main_Form.NScreen2.Visible := False;
  Main_Form.NScreen3.Visible := False;
  Main_Form.NScreen4.Visible := False;
  Main_Form.NScreen5.Visible := False;
  Main_Form.NScreen6.Visible := False;
end;

//---MsgBox---
function MsgBox(Handle : HWND ; Message, Caption : string ; Flags : integer) : integer;
begin
  //AddDebug(Message);
  Result := MessageBoxA(Handle, PChar(Message), PChar(Caption), Flags);
end;

//---ShowMessage---
procedure ShowMessage(Message : string);
begin
  MsgBox(Main_Form.Handle, Message, Application.Title, 0);
end;

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
  Dossier: array[0..MAX_PATH] of Char;

begin
  Result := '';
  if GetTempPath(SizeOf(Dossier), Dossier)<>0 then Result := StrPas(Dossier);
end;

//---Delay---
procedure Delay(Delai : Double);
var
  HeureDepart:TDateTime;

begin
  HeureDepart:=now;
  Delai:=delai/24/60/60/1000; //transforme les millisecondes en fractions de jours
  repeat
    Application.ProcessMessages; // rend la main à Windows pour ne pas blocquer les autres applications
  Until Now>HeureDepart+Delai;
end;

//---AddDebug---
procedure AddDebug(Msg : string);
var
  Head : string;

begin
  Head := '[' + DateToStr(Date) + ' - ' + TimeToStr(Time) + '] ';
  DebugLog_Form.lbDebug.Items.Add(Head + Msg);
  DebugLog_Form.lbDebug.ItemIndex := DebugLog_Form.lbDebug.Items.Count - 1;
  
  Main_Form.StatusBar1.Panels[1].Text := Msg;
  Delay(300);
end;

//---StepIt---
procedure StepIt;
begin
  Main_Form.pBar.Position := Main_Form.pBar.Position + 1;
end;

//---CleanTempFiles---
procedure CleanTempFiles;
var
  MrFile, IpLogo, IpBin : string;

begin
  MrFile  := GetTempDir + '~tempmr.tmp';
  IpLogo  := GetTempDir + '~iplogo.tmp';
  IpBin   := GetTempDir + '~ipbin.tmp';

  DeleteAllFiles;

  if FileExists(MrFile) then
    DeleteFile(MrFile);

  if FileExists(IpLogo) then
    DeleteFile(IpLogo);

  if FileExists(IpBin) then
    DeleteFile(IpBin);
end;

//---InitDebugLog---
procedure InitDebugLog;
begin
  DebugLog_Form.Caption := Main_Form.Caption + ' - *DEBUG LOG*';
  DebugLog_Form.StatusBar1.SimpleText := DebugLog_Form.Caption;

  DebugLog_Form.lbDebug.Items.Add(Main_Form.Caption + ' - *DEBUG LOG*');
  DebugLog_Form.lbDebug.Items.Add('Ready');
  DebugLog_Form.lbDebug.Items.Add('');
  DebugLog_Form.lbDebug.ItemIndex := DebugLog_Form.lbDebug.Items.Count - 1;
end;

//---PutCurrentDate---
procedure PutCurrentDate;
var
  CDay, CMonth : string;

begin
  CDay := IntToStr(DayOf(Date));
  if Length(CDay) <= 1 then CDay := '0' + CDay;
  Main_Form.eDay.Text := CDay;

  CMonth := IntToStr(MonthOf(Date));
  if Length(CMonth) <= 1 then CMonth := '0' + CMonth;
  Main_Form.eMonth.Text := CMonth;

  Main_Form.eYear.Text := IntToStr(YearOf(Date));
end;

//---SaveManufacturerList---
procedure SaveManufacturerList;
var
  fn : string;

begin
  fn := ChangeFileExt(Application.ExeName, '.ini');
  Main_Form.eManID.Items.SaveToFile(fn);
end;

end.
