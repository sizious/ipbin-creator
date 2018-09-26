unit preset;

interface

uses
  Windows, SysUtils, Classes, StdCtrls, IniFiles;
  
function SavePreset(FileName : string) : boolean;
function LoadPreset(FileName : string) : boolean;

implementation

uses main, utils;

//---SavePreset---
function SavePreset(FileName : string) : boolean;
var
  Ini       : TIniFile;
  i         : integer;
  Compo     : TComponent;
  MM        : TMemo;
  CB        : TComboBox;
  NewLine   : string;

begin
  Result := False;
  if FileExists(FileName) then DeleteFile(FileName);
  
  Ini := TIniFile.Create(FileName);
  if Ini = nil then Exit;
  
  try

    Ini.WriteString('INFOS', 'PrgName', PrgName);
    Ini.WriteString('INFOS', 'Author', '[big_fury]SiZiOUS');
    Ini.WriteString('INFOS', 'Version', Version);
    Ini.WriteString('INFOS', 'Date', DateToStr(Date));
    
    for i := 0 to Main_Form.ComponentCount - 1 do
    begin

      //Save tous les edits.
      if Main_Form.Components[i] is TEdit then
      begin
        Compo := (Main_Form.Components[i] as TEdit);
        Ini.WriteString('CONTROLS', Compo.Name, (Compo as TEdit).Text);
      end;

      //Save tous les booleans
      if Main_Form.Components[i] is TCheckBox then
      begin
        Compo := (Main_Form.Components[i] as TCheckBox);

        if  (UpperCase(Compo.Name) <> UpperCase(Main_Form.cbKeepIDNumbers.Name)) and
            (UpperCase(Compo.Name) <> UpperCase(Main_Form.cbKeepGenerationDate.Name)) and
            (UpperCase(Compo.Name) <> UpperCase(Main_Form.cbCheckLogoIfExists.Name)) and
            (UpperCase(Compo.Name) <> UpperCase(Main_Form.cbKeepAppName.Name)) then

          Ini.WriteBool('CONTROLS', Compo.Name, (Compo as TCheckBox).Checked);
      end;

      //Save tous les memos
      if Main_Form.Components[i] is TMemo then
      begin
        Compo := (Main_Form.Components[i] as TMemo);

        //3 checks box qu'on veut pas sauver
        if UpperCase(Compo.Name) <> 'MRUN' then //on veut pas ce mémo
        begin
          MM := (Compo as TMemo);
          NewLine := StringReplace(MM.Text, WrapStr, #255, [rfReplaceAll, rfIgnoreCase]);  //faut enlever le saut de ligne !!
          Ini.WriteString('CONTROLS', Compo.Name, NewLine);
        end;

      end;

      //Save tous les combo box
      if Main_Form.Components[i] is TComboBox then
      begin
        Compo := (Main_Form.Components[i] as TComboBox);
        CB := (Compo as TComboBox);

        if CB.Style = csDropDown then
          Ini.WriteString('CONTROLS', Compo.Name, CB.Text)
        else Ini.WriteInteger('CONTROLS', Compo.Name, CB.ItemIndex);
      end;


    end;

    Result := True;

  finally
    Ini.Free;
  end;

end;

//---LoadPreset---
function LoadPreset(FileName : string) : boolean;
var
  Ini   : TIniFile;
  PT    : string;
  CanDo,
  i     : integer;
  Compo : TComponent;
  CB    : TComboBox;
  ChBox : TCheckBox;

begin
  Result := False;
  if not FileExists(FileName) then Exit;

  Ini := TIniFile.Create(FileName);
  if Ini = nil then Exit;

  try
    //Result := False;
    //****VERIF DE ROUTINE****

    PT := Ini.ReadString('INFOS', 'PrgName', '');

    if PT <> PrgName then
    begin
      AddDebug('Error, this file isn''t a valid ' + PrgName + ' file.');
      MsgBox(Main_Form.Handle, 'Error, this file isn''t a valid ' + PrgName + ' file.', 'Error', 48);
      Exit;
    end;

    PT := Ini.ReadString('INFOS', 'Version', Version);
    if PT <> Version then
    begin
      AddDebug('Version mismatch. The current version is ' + Version + ', and the version found is ' + PT + '.');
      CanDo := MsgBox(Main_Form.Handle, 'Version mismatch. The current version is ' + Version + ', and the version found is ' + PT + '. Continue ?', 'Warning', 48 + MB_YESNO);
      if CanDo = IDNO then Exit;
    end;

    //****CHARGEMENT ICI****

    for i := 0 to Main_Form.ComponentCount - 1 do
    begin

      //Save tous les edits.
      if Main_Form.Components[i] is TEdit then
      begin
        Compo := (Main_Form.Components[i] as TEdit);
        (Compo as TEdit).Text := Ini.ReadString('CONTROLS', Compo.Name, '');
      end;

      //Save tous les booleans
      if Main_Form.Components[i] is TCheckBox then
      begin
        DontCare := False; //pour empecher le SetFocus des Edits pour la date (pour passer au suivant)

        Compo := (Main_Form.Components[i] as TCheckBox);
        ChBox := (Compo as TCheckBox);

        //3 checks box qu'on veut pas sauver
        if  (UpperCase(Compo.Name) <> UpperCase(Main_Form.cbKeepIDNumbers.Name)) and
            (UpperCase(Compo.Name) <> UpperCase(Main_Form.cbKeepGenerationDate.Name)) and
            (UpperCase(Compo.Name) <> UpperCase(Main_Form.cbCheckLogoIfExists.Name)) and
            (UpperCase(Compo.Name) <> UpperCase(Main_Form.cbKeepAppName.Name)) then
          
        ChBox.Checked := Ini.ReadBool('CONTROLS', Compo.Name, False);

        //DontCare := True; //pas possible ici
      end;

      //Save tous les memos
      if Main_Form.Components[i] is TMemo then
      begin
        Compo := (Main_Form.Components[i] as TMemo);
        PT := Ini.ReadString('CONTROLS', Compo.Name, '');
        PT := StringReplace(PT, #255, WrapStr, [rfReplaceAll, rfIgnoreCase]);
        (Compo as TMemo).Text := PT;
      end;

      //Save tous les combo box
      if Main_Form.Components[i] is TComboBox then
      begin
        Compo := (Main_Form.Components[i] as TComboBox);
        CB := (Compo as TComboBox);

        if CB.Style = csDropDown then
          CB.Text := Ini.ReadString('CONTROLS', Compo.Name, '')
        else begin
          if CB.Items.Count > 0 then
            CB.ItemIndex := Ini.ReadInteger('CONTROLS', Compo.Name, 0);
        end;

      end;

    end;

    //****Faire les différentes vérifications avec les checks box...****

    //pour le fichier logo
    if Main_Form.cbCheckLogoIfExists.Checked then
      if not FileExists(Main_Form.eFileLogo.Text) then
        Main_Form.eFileLogo.Text := '';

    //pour les ID
    if not Main_Form.cbKeepIDNumbers.Checked then
    begin
      Main_Form.bGenMediaID.Click;
      Main_Form.bGenProdNo.Click;
    end;

    //pour la date de génération du preset
    if not Main_Form.cbKeepGenerationDate.Checked then
      PutCurrentDate; //dans utils, met la date courante dans les bons edits.

    //pour le nom de l'appli
    if not Main_Form.cbKeepAppName.Checked then
      Main_Form.mGameTitle.Clear;

    Result := True;
  finally
    Ini.Free;
  end;

end;

end.
