//SEGA OS, VGA BOX, WriteAllExtendedPeriph, WriteAllMinimumButtons ne peuvent
//être changées par l'utilisateur de ce programme.

unit u_build;

interface

uses
  Windows, SysUtils, DateUtils;

function WriteVersion(var F : File ; StringVersion : string) : boolean;
function WriteDate(var F : File ; ThisDate : string) : boolean;
function WriteAllAreaSymbols(var F : File) : boolean;
function WriteSegaOS(var F : File) : boolean;
function WriteAllExtendedPeriph(var F : File) : boolean;
function WriteAllMinimumButtons(var F : File) : boolean;

implementation

uses u_bin_save, u_const, utils;

//---WriteVersion---
function WriteVersion(var F : File ; StringVersion : string) : boolean;
type
  TVersion = record
    Hi  : Char;
    Lo  : string;
end;

var
  Version         : TVersion;
  Datas           : array of byte;
  i, ArrayLength  : integer;
  VersionHi       : string;

begin
  //Ecrire la version
  VersionHi := GaucheNDroite('.', StringVersion, 0);
  Version.Hi := VersionHi[1];
  Version.Lo := GaucheNDroite('.', StringVersion, 1);
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
function WriteDate(var F : File ; ThisDate : string) : boolean;
var
  Datas : array of byte;
  i, ArrayLength : integer;
  CDate, CDay, CMonth, CYear : string;
  Day, Month, Year : string;

begin
  Year := GaucheNDroite('/', ThisDate, 2);
  CYear := Year;

  Day := GaucheNDroite('/', ThisDate, 0);
  if Length(Day) = 1 then
    CDay := '0' + Day
  else CDay := Day;
  if Length(CDay) = 0 then CDay := IntToStr(DayOf(Date)); //val par def. (si rien, date d'auj).

  Month := GaucheNDroite('/', ThisDate, 1);
  if Length(Month) = 1 then
    CMonth := '0' + Month
  else CMonth := Month;
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

//---WriteAllAreaSymbols---
function WriteAllAreaSymbols(var F : File) : boolean;
begin
  Result := False;

  WriteString(F, AREA_SYMBOL_JAPANESE_ADDR, AREA_SYMBOL_JAPANESE);
  WriteString(F, AREA_SYMBOL_EUROPE_ADDR, AREA_SYMBOL_EUROPE);
  WriteString(F, AREA_SYMBOL_USA_ADDR, AREA_SYMBOL_USA);
end;

//---WriteSegaOS---
function WriteSegaOS(var F : File) : boolean;
begin
  Result := WriteString(F, SEGA_OS_USED_ADDR, SEGA_OS_USED_TRUE);
end;

//---WriteExtendedPeriph---
function WriteAllExtendedPeriph(var F : File) : boolean;
var
  Val   : integer;
  Datas : string;

begin
  //Mettre tout à zéro.
  WriteString(F, EXTENDED_PERIPHERALS_ADDR, NONE);

  //Ecrire le VGA Box support
  WriteString(F, VGA_BOX_SUPPORT_ADDR, VGA_BOX_SUPPORT_TRUE);

  //Ecrire other + vibration + sound + memory card.
  Val := OTHERS_ENABLE + VIBRATION_PACK_ENABLE + SOUND_INPUT_PERIPHERAL
    + MEMORY_CARD_ENABLE;
  Datas := IntToHex(Val, 1);

  Result := WriteString(F, EXTENDED_PERIPHERALS_ADDR, Datas);
end;

//---WriteAllMinimumButtons---
function WriteAllMinimumButtons(var F : File) : boolean;
var
  Val   : byte;
  Datas : string;

begin
  Result := False;

  //---MOUSE_GUN_KBD_AN_Y2_ADDR---
  //Val := $00 + ANALOG_Y2_ENABLE + KEYBOARD_ENABLE + MOUSE_ENABLE + GUN_ENABLE;
  Val := MOUSE_ENABLE + GUN_ENABLE + KEYBOARD_ENABLE;
  Datas := IntToHex(Val, 1);
  WriteString(F, MOUSE_GUN_KBD_AN_Y2_ADDR, Datas);

  //---ANALOG_X2_Y1_X1_L_ADDR---
  Val := 00;
  { if Main_Form.cbAnalogX2.Checked = True then Val := Val + ANALOG_X2_ENABLE;
  if Main_Form.cbAnalogY1.Checked = True then Val := Val + ANALOG_Y1_ENABLE;
  if Main_Form.cbAnalogX1.Checked = True then Val := Val + ANALOG_X1_ENABLE;
  if Main_Form.cbAnalogL.Checked = True then Val := Val + ANALOG_L_ENABLE; }
  Datas := IntToHex(Val, 1);
  WriteString(F, ANALOG_X2_Y1_X1_L_ADDR, Datas);

  //---ANALOG_R_BTN2_Z_Y_ADDR---
  Val := 00;
  { if Main_Form.cbAnalogR.Checked = True then Val := Val + ANALOG_R_ENABLE;
  if Main_Form.cbBtnDirectionsKeyBtn2.Checked = True then Val := Val + DIRECT_KEY_BUTTON_2;
  if Main_Form.cbBtnZ.Checked = True then Val := Val + BUTTON_Z_ENABLE;
  if Main_Form.cbBtnY.Checked = True then Val := Val + BUTTON_Y_ENABLE; }
  Datas := IntToHex(Val, 1);
  WriteString(F, ANALOG_R_BTN2_Z_Y_ADDR, Datas);

  //---BTN_X_D_C_BTN1_A_ADDR---
  Val := 00;
  { if Main_Form.cbBtnX.Checked = True then Val := Val + BUTTON_X_ENABLE;
  if Main_Form.cbBtnD.Checked = True then Val := Val + BUTTON_D_ENABLE;
  if Main_Form.cbBtnC.Checked = True then Val := Val + BUTTON_C_ENABLE;
  if Main_Form.cbBtnDirectionsKeyBtn1.Checked = True then Val := Val + DIRECT_KEY_BUTTON1_A; }
  Datas := IntToHex(Val, 1);
  WriteString(F, BTN_X_D_C_BTN1_A_ADDR, Datas);
end;

//******************************************************************************

end.
