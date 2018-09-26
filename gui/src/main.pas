unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, XPMan, ExtCtrls, ComCtrls, DateUtils, ExtDlgs, JPEG,
  GIFImage, PNGImage, Buttons, Menus, ImgList, XPMenu, AppEvnts,
  TFlatHintUnit, ShellApi;

type
  TMain_Form = class(TForm)
    XPManifest: TXPManifest;
    Shape1: TShape;
    Panel1: TPanel;
    Bevel1: TBevel;
    bAbout: TButton;
    NoEnabled: TButton;
    StatusBar1: TStatusBar;
    NStart: TButton;
    bCancel: TButton;
    Bevel2: TBevel;
    PScreen1: TButton;
    NScreen1: TButton;
    PScreen2: TButton;
    NScreen2: TButton;
    PScreen3: TButton;
    NScreen3: TButton;
    PScreen4: TButton;
    NScreen4: TButton;
    PScreen5: TButton;
    NScreen5: TButton;
    PScreen6: TButton;
    NScreen6: TButton;
    Label9: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label17: TLabel;
    Label21: TLabel;
    odLogo: TOpenPictureDialog;
    Bevel4: TBevel;
    mRun: TMemo;
    sdIP: TSaveDialog;
    pmLogo: TPopupMenu;
    Openimage1: TMenuItem;
    N1: TMenuItem;
    Deleteimage1: TMenuItem;
    ilGeneral: TImageList;
    XPMenu: TXPMenu;
    aeGeneral: TApplicationEvents;
    GroupBox16: TGroupBox;
    Label23: TLabel;
    bOpenPreset: TBitBtn;
    Screen1: TPanel;
    Label12: TLabel;
    GroupBox1: TGroupBox;
    cbU: TCheckBox;
    cbE: TCheckBox;
    cbJ: TCheckBox;
    GroupBox9: TGroupBox;
    eManID: TComboBox;
    GroupBox10: TGroupBox;
    Label3: TLabel;
    Label13: TLabel;
    cbMediaConfig: TComboBox;
    eMediaID: TEdit;
    GroupBox2: TGroupBox;
    Label2: TLabel;
    Label16: TLabel;
    HardwareID: TComboBox;
    VendorID: TComboBox;
    Screen2: TPanel;
    Label1: TLabel;
    GroupBox3: TGroupBox;
    cbBtnMouse: TCheckBox;
    cbBtnGun: TCheckBox;
    cbBtnKeyboard: TCheckBox;
    cbAnalogY2: TCheckBox;
    cbAnalogX2: TCheckBox;
    cbAnalogY1: TCheckBox;
    cbAnalogX1: TCheckBox;
    cbAnalogL: TCheckBox;
    cbAnalogR: TCheckBox;
    cbBtnDirectionsKeyBtn2: TCheckBox;
    cbBtnZ: TCheckBox;
    cbBtnY: TCheckBox;
    cbBtnX: TCheckBox;
    cbBtnD: TCheckBox;
    cbBtnC: TCheckBox;
    cbBtnDirectionsKeyBtn1: TCheckBox;
    GroupBox6: TGroupBox;
    OS00: TCheckBox;
    GroupBox4: TGroupBox;
    Bevel3: TBevel;
    EP03: TCheckBox;
    EP02: TCheckBox;
    EP01: TCheckBox;
    EP00: TCheckBox;
    AV00: TCheckBox;
    Screen3: TPanel;
    Label10: TLabel;
    GroupBox12: TGroupBox;
    cbBootFilename: TComboBox;
    GroupBox11: TGroupBox;
    Label11: TLabel;
    mGameTitle: TMemo;
    GroupBox8: TGroupBox;
    Label5: TLabel;
    eVerHi: TEdit;
    eVerLo: TEdit;
    GroupBox5: TGroupBox;
    eProdNo: TEdit;
    GroupBox7: TGroupBox;
    Label4: TLabel;
    Label22: TLabel;
    eDay: TEdit;
    eMonth: TEdit;
    eYear: TEdit;
    Screen4: TPanel;
    Label6: TLabel;
    GroupBox13: TGroupBox;
    Panel2: TPanel;
    iLogo: TImage;
    GroupBox14: TGroupBox;
    eFileLogo: TEdit;
    bLogoOpen: TBitBtn;
    bLogoDel: TBitBtn;
    Screen5: TPanel;
    Label7: TLabel;
    GroupBox15: TGroupBox;
    pBar: TProgressBar;
    Screen6: TPanel;
    Label8: TLabel;
    GroupBox17: TGroupBox;
    Label18: TLabel;
    bSavePreset: TBitBtn;
    Label19: TLabel;
    Label20: TLabel;
    GroupBox18: TGroupBox;
    Label24: TLabel;
    BitBtn3: TBitBtn;
    bAddManufacturer: TBitBtn;
    bDelManufacturer: TBitBtn;
    bGenMediaID: TBitBtn;
    bGenProdNo: TBitBtn;
    sdPreset: TSaveDialog;
    odPreset: TOpenDialog;
    Bevel5: TBevel;
    cbKeepIDNumbers: TCheckBox;
    cbKeepGenerationDate: TCheckBox;
    cbCheckLogoIfExists: TCheckBox;
    cbKeepAppName: TCheckBox;
    FlatHint: TFlatHint;
    Viewthisimage1: TMenuItem;
    bViewImage: TBitBtn;
    Image1: TImage;
    Image2: TImage;
    procedure NStartClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PScreen1Click(Sender: TObject);
    procedure NScreen1Click(Sender: TObject);
    procedure NScreen2Click(Sender: TObject);
    procedure NScreen3Click(Sender: TObject);
    procedure NScreen4Click(Sender: TObject);
    procedure lick(Sender: TObject);
    procedure bCancelClick(Sender: TObject);
    procedure PScreen2Click(Sender: TObject);
    procedure PScreen3Click(Sender: TObject);
    procedure PScreen4Click(Sender: TObject);
    procedure PScreen5Click(Sender: TObject);
    procedure NScreen6Click(Sender: TObject);
    procedure eVerLoKeyPress(Sender: TObject; var Key: Char);
    procedure eVerHiChange(Sender: TObject);
    procedure eDayChange(Sender: TObject);
    procedure eMonthChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure eFileLogoChange(Sender: TObject);
    procedure bAboutClick(Sender: TObject);
    procedure StatusBar1DblClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure bLogoOpenClick(Sender: TObject);
    procedure bLogoDelClick(Sender: TObject);
    procedure aeGeneralException(Sender: TObject; E: Exception);
    procedure bAddManufacturerClick(Sender: TObject);
    procedure bDelManufacturerClick(Sender: TObject);
    procedure bGenMediaIDClick(Sender: TObject);
    procedure bGenProdNoClick(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure bSavePresetClick(Sender: TObject);
    procedure bOpenPresetClick(Sender: TObject);
    procedure bViewImageClick(Sender: TObject);
    procedure PScreen6Click(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

const
  Version   : string = '1.0';
  PrgName   : string = 'IP.BIN Creator';

var
  Main_Form : TMain_Form;
  DontCare  : boolean = True;

implementation

uses utils, generate, build, logoman, debuglog, preset, aboutprg;

{$R *.dfm}

procedure TMain_Form.NStartClick(Sender: TObject);
begin
  GoNext(1);
end;

procedure TMain_Form.FormCreate(Sender: TObject);
var
  i   : integer;
  fn  : string;

begin
  Application.Title := Main_Form.Caption;
  Randomize; //Init du générateur de nbs aléatoire.

  //---Init fichiers---
  ExtractAllFiles;  //dans un DLL, construire le dossier qui faut et tout
  PNG_TO_MR_TOOL := GetRealPath(GetTempDir + IPBUILD_TMP) + PNG_TO_MR_TOOL;
  LOGO_INSERT_TOOL := GetRealPath(GetTempDir + IPBUILD_TMP) + LOGO_INSERT_TOOL;
  //---Init fichiers----

  bGenMediaID.Click; //Generer un Media ID
  bGenProdNo.Click;

  //pour les panels transparents
  for i := 0 to ComponentCount - 1 do
    if Components[i] is TPanel then (Components[i] as TPanel).ParentBackground := false;

  //pour charger la liste de manufacturers.
  fn := ChangeFileExt(Application.ExeName, '.ini');
  if FileExists(fn) then
    Main_Form.eManID.Items.LoadFromFile(fn);
end;

procedure TMain_Form.PScreen1Click(Sender: TObject);
begin
  GoPrev(1);
end;

procedure TMain_Form.NScreen1Click(Sender: TObject);
begin
  if Length(eManID.Text) = 0 then
  begin
    MsgBox(Handle, 'Please enter a Manufacturer''s Name / ID.', 'Error', 48);
    Exit;
  end;

  if (cbJ.Checked = False) and (cbE.Checked = False)
    and (cbU.Checked = False) then
    begin
      MsgBox(Handle, 'Please select at least a region code.', 'Error', 48);
      Exit;
    end;

  if (Length(Main_Form.eMediaID.Text) <> 4) then
  begin
    MsgBox(Handle, 'Error, enter a valid Media ID.', 'Warning', 48);
    Exit;
  end;

  DontCare := True;
  GoNext(2);
end;

procedure TMain_Form.NScreen2Click(Sender: TObject);
begin
  GoNext(3);
end;

procedure TMain_Form.NScreen3Click(Sender: TObject);
begin
  if (Length(Main_Form.eVerHi.Text) = 0) or
    (Length(Main_Form.eVerLo.Text) = 0) then
    begin
      MsgBox(Handle, 'Error, enter a valid version.', 'Warning', 48);
      Exit;
    end;

  if Length(Main_Form.cbBootFilename.Text) = 0 then
  begin
    MsgBox(Handle, 'Error, enter a valid boot file name.', 'Warning', 48);
    Exit;
  end;

  if Length(Main_Form.eProdNo.Text) = 0 then
  begin
    MsgBox(Handle, 'Error, enter a valid product number.', 'Warning', 48);
    Exit;
  end;

  //Vérifier si tout OK sur la date.
  if (Length(Main_Form.eDay.Text) = 0)
    or (StrToInt(Main_Form.eDay.Text) < 1)
    or (StrToInt(Main_Form.eDay.Text) > 31)
    or (Length(Main_Form.eMonth.Text) = 0)
    or (StrToInt(Main_Form.eMonth.Text) < 1)
    or (StrToInt(Main_Form.eMonth.Text) > 12)
    or (Length(Main_Form.eYear.Text) < 4) then
    begin
      MsgBox(Handle, 'Error, enter a valid date.', 'Warning', 48);
      Exit;
    end;
    
  GoNext(4);
end;

procedure TMain_Form.NScreen4Click(Sender: TObject);
var
  OK : boolean;

begin

  if Length(eFileLogo.Text) <> 0 then
  begin

    //Si le fichier existe pas...
    if FileExists(eFileLogo.Text) = False then
    begin
      AddDebug('Error : Image file doesn''t exists : "' + eFileLogo.Text + '".');
      MsgBox(Handle, 'Error : Image file doesn''t exists.' + WrapStr + 'Filename : "' + eFileLogo.Text + '".', 'Warning', 48);
      Exit;
    end;


    //convertir image sélectionnée vers format MR.
    NScreen4.Enabled := False;
    PScreen4.Enabled := False;

    OK := ConvertSelectedImageToMr;

    NScreen4.Enabled := True;
    PScreen4.Enabled := True;

    if not OK then Exit;

  end;

  GoNext(5);
end;

procedure TMain_Form.lick(Sender: TObject);
begin
  if Main_Form.sdIP.Execute then
  begin

    NScreen5.Enabled := False;
    PScreen5.Enabled := False;

    if BuildFile(Main_Form.sdIP.FileName) then
      GoNext(6); //passer à la suivante si tout OK.

  end;

  NScreen5.Enabled := True;
  PScreen5.Enabled := True;
end;

procedure TMain_Form.bCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TMain_Form.PScreen2Click(Sender: TObject);
begin
  GoPrev(2);
end;

procedure TMain_Form.PScreen3Click(Sender: TObject);
begin
  GoPrev(3);
end;

procedure TMain_Form.PScreen4Click(Sender: TObject);
begin
  GoPrev(4);
end;

procedure TMain_Form.PScreen5Click(Sender: TObject);
var
  MrFile : string;

begin
  //effacer le mr.
  MrFile := GetTempDir + '~tempmr.tmp';

  if FileExists(MrFile) then
  begin
    AddDebug('Deleting ' + MrFile + '.');
    DeleteFile(MrFile);
    AddDebug('Ready');
  end;
  
  GoPrev(5);
end;

procedure TMain_Form.NScreen6Click(Sender: TObject);
begin
  Close;
end;

procedure TMain_Form.eVerLoKeyPress(Sender: TObject; var Key: Char);
begin

  if not (Key in [#8, #13, '0'..'9']) then
  begin
    Key := #0;
    Exit;
  end;

end;

procedure TMain_Form.eVerHiChange(Sender: TObject);
begin
  if Length(eVerHi.Text) = eVerHi.MaxLength then
    eVerLo.SetFocus;
end;

procedure TMain_Form.eDayChange(Sender: TObject);
begin
  if DontCare = True then
    if Length(eDay.Text) = eDay.MaxLength then
      eMonth.SetFocus;
end;

procedure TMain_Form.eMonthChange(Sender: TObject);
begin
  if DontCare = True then
    if Length(eMonth.Text) = eMonth.MaxLength then
      eYear.SetFocus;
end;

procedure TMain_Form.FormActivate(Sender: TObject);
begin
  //Date du jour...
  DontCare := False;

  PutCurrentDate;  //dans utils

  DontCare := True;
end;

procedure TMain_Form.eFileLogoChange(Sender: TObject);
begin
  if FileExists(eFileLogo.Text) = True then
    iLogo.Picture.LoadFromFile(eFileLogo.Text);
end;

procedure TMain_Form.bAboutClick(Sender: TObject);
begin
  AboutPrg_Form.ShowModal;
end;

procedure TMain_Form.StatusBar1DblClick(Sender: TObject);
begin
  DebugLog_Form.Show;
end;

procedure TMain_Form.FormClose(Sender: TObject; var Action: TCloseAction);
var
  CanDo : integer;

begin
  if UpperCase(StatusBar1.Panels[1].Text) <> 'READY' then
  begin
    CanDo := MsgBox(Handle, 'Are you sure to quit ?', 'Warning', 48 + MB_YESNO + MB_DEFBUTTON2);

    if CanDo = IDNO then
    begin
      Action := caNone;
      Exit;
    end;
    
  end;

  CleanTempFiles;
  SaveManufacturerList;
  Halt(0); //forcer l'arret du prg si il fait qqch.
end;

procedure TMain_Form.bLogoOpenClick(Sender: TObject);
begin
  if odLogo.Execute = True then
    eFileLogo.Text := odLogo.FileName;
end;

procedure TMain_Form.bLogoDelClick(Sender: TObject);
var
  CanDo : integer;

begin
  if iLogo.Picture.Graphic = nil then
  begin
    MsgBox(Handle, 'No picture loaded.', 'Error', 48);
    Exit;
  end; 

  CanDo := MsgBox(Handle, 'Sure to remove the logo from the project ?', 'Question', 32 + MB_YESNO + MB_DEFBUTTON2);
  if CanDo = IDNO then Exit;
  
  iLogo.Picture := nil;
  eFileLogo.Clear;
end;

procedure TMain_Form.aeGeneralException(Sender: TObject; E: Exception);
var
  CanDo : integer;

begin
  AddDebug('FATAL : "' + E.Message + '".');

  CanDo := MsgBox(Handle, 'FATAL ERROR : "' + E.Message + '".'
    + WrapStr + 'Error added in the Debug Log. Sorry my compiler is in French :/'
    + WrapStr + 'Do you want to save the debug log and exit the program now (recommanded) ?', 'FATAL ERROR', 16 + MB_OKCANCEL + MB_SYSTEMMODAL);

  AddDebug('Ready');

  //Activer les controls.
  NScreen4.Enabled := True;
  PScreen4.Enabled := True;
  NScreen5.Enabled := True;
  PScreen5.Enabled := True;
  
  if CanDo = IDCANCEL then Exit;

  DebugLog_Form.Savedebuglogto1.Click;
  CleanTempFiles;
  Halt(1); //error
end;

procedure TMain_Form.bAddManufacturerClick(Sender: TObject);
var
  i : integer;

begin
  //Quelque chose à rentrer ?
  if Length(eManID.Text) = 0 then
  begin
    MsgBox(Handle, 'Manufacturer''s Name / ID field is empty.', 'Error', 48);
    Exit;
  end;

  //Vérifier si l'item est déjà dans la liste.
  for i := 0 to eManID.Items.Count - 1 do
  begin
    if UpperCase(eManID.Items[i]) = UpperCase(eManID.Text) then
    begin
      MsgBox(Handle, 'Error, item "' + eManID.Text + '" is already in the list.', 'Error', 48);
      Exit;
    end;
  end;

  eManID.Items.Add(eManID.Text);
  MsgBox(Handle, 'Item "' + eManID.Text + '" added to the list.', 'Information', 64);
end;

procedure TMain_Form.bDelManufacturerClick(Sender: TObject);
var
  i, CanDo, Index   : integer;
  Exists            : boolean;
  Name              : string;

begin
  Exists := False;
  Index := -1;
  Name := eManID.Text;

  //Pas d'items
  if eManID.Items.Count = 0 then
  begin
    MsgBox(Handle, 'No more items to delete.', 'Error', 48);
    Exit;
  end;

  //Quelque chose à rentrer ?
  if Length(Name) = 0 then
  begin
    MsgBox(Handle, 'Manufacturer''s Name / ID field is empty.', 'Error', 48);
    Exit;
  end;

  //Vérifier si l'item est dans la liste.
  for i := 0 to eManID.Items.Count - 1 do
    if UpperCase(eManID.Items[i]) = UpperCase(Name) then Exists := True;

  if Exists = False then
  begin
    MsgBox(Handle, 'Error, item "' + Name + '" isn''t in the list.', 'Error', 48);
    Exit;
  end;

  CanDo := MsgBox(Handle, 'Sure to delete "' + Name + '" from the list ?', 'Question', 32 + MB_YESNO + MB_DEFBUTTON2);
  if CanDo = IDNO then Exit;

  for i := 0 to eManID.Items.Count - 1 do
  begin

    if UpperCase(eManID.Items[i]) = UpperCase(Name) then
    begin
      Index := i;
      Break;  //on a l'index de l'item à supprimer, on se tire.
    end;

  end;

  eManID.Items.Delete(Index);
  MsgBox(Handle, 'Item "' + Name + '" deleted from the list.', 'Information', 64);
  eManID.Text := Name; //Le remettre dans la zone text
end;

procedure TMain_Form.bGenMediaIDClick(Sender: TObject);
begin
  eMediaID.Text := RandomHexPassword(4);
end;

procedure TMain_Form.bGenProdNoClick(Sender: TObject);
begin
  eProdNo.Text := GenProductNo;
end;

procedure TMain_Form.BitBtn3Click(Sender: TObject);
begin
  DebugLog_Form.Show;
end;

procedure TMain_Form.bSavePresetClick(Sender: TObject);
begin
  if sdPreset.Execute then
  begin

    if SavePreset(sdPreset.FileName) then
    { begin
      AddDebug('Error when saving the preset (' + sdPreset.FileName + ').');
      MsgBox(Handle, 'Error when saving the preset !', 'Error', 48);
    end else }

    begin
      AddDebug('Preset saved (' + sdPreset.FileName + ').');
      MsgBox(Handle, 'Preset saved successfully.', 'Information', 64);
    end;

    AddDebug('Ready');

  end;

end;

procedure TMain_Form.bOpenPresetClick(Sender: TObject);
var
  OK : boolean;

begin
  if odPreset.Execute then
  begin
    OK := LoadPreset(odPreset.FileName);
    //showmessage(booltostr(ok));

    if OK then
    { begin
      AddDebug('Error when loading the preset (' + odPreset.FileName + ').');
      MsgBox(Handle, 'Error when loading the preset !', 'Error', 48); 
    end else }

      AddDebug('Preset loaded (' + sdPreset.FileName + ').');

    AddDebug('Ready');

  end;


end;

procedure TMain_Form.bViewImageClick(Sender: TObject);
begin
  if not FileExists(eFileLogo.Text) then
  begin
    MsgBox(Handle, 'Error, image not found.' + WrapStr + 'File : "' + eFileLogo.Text + '".', 'Warning', 48);
    Exit;
  end;

  ShellExecute(Handle, 'open', PChar(eFileLogo.Text), '', '', SW_SHOWNORMAL);
end;

procedure TMain_Form.PScreen6Click(Sender: TObject);
begin
  RestartApp;
end;

end.
