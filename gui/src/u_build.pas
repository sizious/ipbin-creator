unit u_build;

interface

uses
  Windows, SysUtils, Forms, DateUtils;
  
function WriteMinimumButtons(var F : File) : boolean;
function WriteVersion(var F : File) : boolean;
function WriteDate(var F : File) : boolean;
function WriteAreaSymbols(var F : File) : boolean;
function WriteExtendedPeriph(var F : File) : boolean;
function WriteSegaOS(var F : File) : boolean;

implementation

uses main, u_bin_save, u_const;

//******************************************************************************

//---WriteToFile---
{function WriteToFile(FileName : string ; Offset : Word ; Data : array of Byte) : boolean;
var
  F : File;

begin
  Result := True;
  if FileExists(FileName) = False then Exit;

  AssignFile(F, FileName);
  Reset(F, 1);
  Seek(F, Offset);
  BlockWrite(F, Data, SizeOf(Data));
  CloseFile(F);
  Result := True;
end;    }

{
//---WriteDatas---
function WriteDatas(Directory : string ; Offset : Word ; DatasToWrite : string) : boolean;
var
  Datas : array of byte;
  i, ArrayLength : integer;

begin
  Result := False;
  if Length(DatasToWrite) = 0 then Exit;
  if DirectoryExists(Directory) = False then Exit;

  ArrayLength := Length(DatasToWrite);

  //Remplir le tableau
  SetLength(Datas, ArrayLength);
  for i := 0 to ArrayLength do
    Datas[i-1] := Ord(DatasToWrite[i]);   //OUAI AVEC SETLENGTH LE TABLEAU COMMENCE A ZERO,
                                          //D'HABITUDE C PAS VRAI.

  Result := WriteToFile(GetRealPath(Directory) + IPBIN_FILE, Offset, Datas);
end; }

//******************************************************************************

//---WriteVersion---
function WriteVersion(var F : File) : boolean;
type
  TVersion = record
    Hi  : Char;
    Lo  : string;
end;

var
  Version : TVersion;
  Datas : array of byte;
  i, ArrayLength : integer;  //j
  //Directory : string;

begin
//  Result := False;
  //Directory := GetRealPath(ExtractFilePath(FileName));
  //if DirectoryExists(Directory) = False then Exit;
  
  //Ecrire la version
  Version.Hi := Main_Form.eVerHi.Text[1];
  Version.Lo := Main_Form.eVerLo.Text;
  if Version.Hi = '' then Version.Hi := '1';   //Vals par défaut.
  if Version.Lo = '' then Version.Lo := '000';

  if Length(Version.Lo) < 3 then
    for i := Length(Version.Lo) to 2 do
      Version.Lo := Version.Lo + '0';

  ArrayLength := (1 + Length(Version.Lo) + 2); //2 pour le 'V' et le '.' (le 1 = Version.Hi)

  //Remplir le tableau
  SetLength(Datas, ArrayLength);
  Datas[0] := Ord('V'); //V
  Datas[1] := Ord(Version.Hi); //V1
  Datas[2] := Ord('.');   //V1.

  for i := 3 to Length(Version.Lo) + 3 do
  //begin
    Datas[i] := Ord(Version.Lo[i-2]);   //V1.000
    //ShowMessage(IntToStr(Datas[i]));
  //end;

  Result := WriteBytes(F, VERSION_ADDR, Datas);
end;

//---WriteDate---
function WriteDate(var F : File) : boolean;
var
  Datas : array of byte;
  i, ArrayLength : integer;
  CDate, CDay, CMonth, CYear : string;
  //Directory : string;

begin
//  Result := False;
  //Directory := GetRealPath(ExtractFilePath(FileName));
  //if DirectoryExists(Directory) = False then Exit;
  
  CYear := Main_Form.eYear.Text;

  if Length(Main_Form.eDay.Text) = 1 then
    CDay := '0' + Main_Form.eDay.Text
  else CDay := Main_Form.eDay.Text;
  if Length(CDay) = 0 then CDay := IntToStr(DayOf(Date)); //val par def. (si rien, date d'auj).

  if Length(Main_Form.eMonth.Text) = 1 then
    CMonth := '0' + Main_Form.eMonth.Text
  else CMonth := Main_Form.eMonth.Text;
  if Length(CMonth) = 0 then CMonth := IntToStr(MonthOf(Date)); //val par def.

  if Length(CYear) = 0 then CYear := IntToStr(YearOf(Date));

  CDate := CYear + CMonth + CDay;
  ArrayLength := Length(CDate);

  //Remplir le tableau
  SetLength(Datas, ArrayLength);
  for i := 0 to ArrayLength do
    Datas[i-1] := Ord(CDate[i]);

  Result := WriteBytes(F, DATE_ADDR, Datas);
end;

//---WriteAreaSymbols---
function WriteAreaSymbols(var F : File) : boolean;
//var
//  Directory : string;
  
begin
  Result := False;
  //Directory := GetRealPath(ExtractFilePath(FileName));
  //if DirectoryExists(Directory) = False then Exit;

  WriteString(F, AREA_SYMBOL_JAPANESE_ADDR, AREA_SYMBOL_NONE);
  WriteString(F, AREA_SYMBOL_EUROPE_ADDR, AREA_SYMBOL_NONE);
  WriteString(F, AREA_SYMBOL_USA_ADDR, AREA_SYMBOL_NONE);

  if Main_Form.cbU.Checked = True then
    Result := WriteString(F, AREA_SYMBOL_USA_ADDR, AREA_SYMBOL_USA);

  if Main_Form.cbJ.Checked = True then
    Result := WriteString(F, AREA_SYMBOL_JAPANESE_ADDR, AREA_SYMBOL_JAPANESE);

  if Main_Form.cbE.Checked = True then
    Result := WriteString(F, AREA_SYMBOL_EUROPE_ADDR, AREA_SYMBOL_EUROPE);
end;

//---WriteSegaOS---
function WriteSegaOS(var F : File) : boolean;
//var
//  Directory : string;

begin
//  Result := False;
  //Directory := GetRealPath(ExtractFilePath(FileName));
  //if DirectoryExists(Directory) = False then Exit;

  if Main_Form.OS00.Checked = True then
  //begin
    Result := WriteString(F, SEGA_OS_USED_ADDR, SEGA_OS_USED_TRUE)
    //;showmessage('true');
    //showmessage(SEGA_OS_USED_TRUE);
  //end
  else Result := WriteString(F, SEGA_OS_USED_ADDR, SEGA_OS_USED_FALSE);

  //showmessage('written');
end;

//---WriteExtendedPeriph---
function WriteExtendedPeriph(var F : File) : boolean;
var
  Val   : integer;
  Datas : string;
//  Directory : string;
  
begin
//  Result := False;
  //Directory := GetRealPath(ExtractFilePath(FileName));
  //if DirectoryExists(Directory) = False then Exit;
                       
  //Mettre tout à zéro.
  WriteString(F, EXTENDED_PERIPHERALS_ADDR, NONE);

  if Main_Form.AV00.Checked = True then
    WriteString(F, VGA_BOX_SUPPORT_ADDR, VGA_BOX_SUPPORT_TRUE)
  else WriteString(F, VGA_BOX_SUPPORT_ADDR, VGA_BOX_SUPPORT_FALSE);
  
  Val := $00;

  if Main_Form.EP00.Checked = True then Val := Val + OTHERS_ENABLE;
  if Main_Form.EP01.Checked = True then Val := Val + VIBRATION_PACK_ENABLE;
  if Main_Form.EP02.Checked = True then Val := Val + SOUND_INPUT_PERIPHERAL;
  if Main_Form.EP03.Checked = True then Val := Val + MEMORY_CARD_ENABLE;
  Datas := IntToHex(Val, 1);
  //Datas := Chr(Val);

  Result := WriteString(F, EXTENDED_PERIPHERALS_ADDR, Datas);
end;

//---WriteMinimumButtons---
function WriteMinimumButtons(var F : File) : boolean;
var
  Val   : byte;
  Datas : string;
//  Directory : string;
  
begin
  Result := False;
//  Directory := GetRealPath(ExtractFilePath(FileName));
//  if DirectoryExists(Directory) = False then Exit;

  //---MOUSE_GUN_KBD_AN_Y2_ADDR---
  Val := $00;
  if Main_Form.cbAnalogY2.Checked = True then Val := Val + ANALOG_Y2_ENABLE;
  if Main_Form.cbBtnKeyboard.Checked = True then Val := Val + KEYBOARD_ENABLE;
  if Main_Form.cbBtnMouse.Checked = True then Val := Val + MOUSE_ENABLE;
  if Main_Form.cbBtnGun.Checked = True then Val := Val + GUN_ENABLE;
  Datas := IntToHex(Val, 1);
  WriteString(F, MOUSE_GUN_KBD_AN_Y2_ADDR, Datas);

  //---ANALOG_X2_Y1_X1_L_ADDR---
  Val := $00;
  if Main_Form.cbAnalogX2.Checked = True then Val := Val + ANALOG_X2_ENABLE;
  if Main_Form.cbAnalogY1.Checked = True then Val := Val + ANALOG_Y1_ENABLE;
  if Main_Form.cbAnalogX1.Checked = True then Val := Val + ANALOG_X1_ENABLE;
  if Main_Form.cbAnalogL.Checked = True then Val := Val + ANALOG_L_ENABLE;
  Datas := IntToHex(Val, 1);
  WriteString(F, ANALOG_X2_Y1_X1_L_ADDR, Datas);

  //---ANALOG_R_BTN2_Z_Y_ADDR---
  Val := $00;
  if Main_Form.cbAnalogR.Checked = True then Val := Val + ANALOG_R_ENABLE;
  if Main_Form.cbBtnDirectionsKeyBtn2.Checked = True then Val := Val + DIRECT_KEY_BUTTON_2;
  if Main_Form.cbBtnZ.Checked = True then Val := Val + BUTTON_Z_ENABLE;
  if Main_Form.cbBtnY.Checked = True then Val := Val + BUTTON_Y_ENABLE;
  Datas := IntToHex(Val, 1);
  WriteString(F, ANALOG_R_BTN2_Z_Y_ADDR, Datas);

  //---BTN_X_D_C_BTN1_A_ADDR---
  Val := $00;
  if Main_Form.cbBtnX.Checked = True then Val := Val + BUTTON_X_ENABLE;
  if Main_Form.cbBtnD.Checked = True then Val := Val + BUTTON_D_ENABLE;
  if Main_Form.cbBtnC.Checked = True then Val := Val + BUTTON_C_ENABLE;
  if Main_Form.cbBtnDirectionsKeyBtn1.Checked = True then Val := Val + DIRECT_KEY_BUTTON1_A;
  Datas := IntToHex(Val, 1);
  WriteString(F, BTN_X_D_C_BTN1_A_ADDR, Datas);

  //Result := WriteDatas(Directory, $3C, '0');
end;

//******************************************************************************

end.
