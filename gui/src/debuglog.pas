unit debuglog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, Menus, XPMenu, ClipBrd;

type
  TDebugLog_Form = class(TForm)
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Panel1: TPanel;
    Button1: TButton;
    lbDebug: TListBox;
    StatusBar1: TStatusBar;
    sdLog: TSaveDialog;
    pmDebug: TPopupMenu;
    Copylinetoclipboard1: TMenuItem;
    N1: TMenuItem;
    Savedebuglogto1: TMenuItem;
    N2: TMenuItem;
    Cleardebuglog1: TMenuItem;
    XPMenu: TXPMenu;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Copylinetoclipboard1Click(Sender: TObject);
    procedure Savedebuglogto1Click(Sender: TObject);
    procedure Cleardebuglog1Click(Sender: TObject);
    procedure lbDebugContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  DebugLog_Form: TDebugLog_Form;

implementation

uses main, utils;

{$R *.dfm}

procedure TDebugLog_Form.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TDebugLog_Form.FormCreate(Sender: TObject);
begin
  InitDebugLog;
end;

procedure TDebugLog_Form.Copylinetoclipboard1Click(Sender: TObject);
begin
  ClipBoard.SetTextBuf(PChar(lbDebug.Items.Strings[lbDebug.ItemIndex]));
end;

procedure TDebugLog_Form.Savedebuglogto1Click(Sender: TObject);
begin
  if sdLog.Execute then
    lbDebug.Items.SaveToFile(sdLog.FileName);
end;

procedure TDebugLog_Form.Cleardebuglog1Click(Sender: TObject);
var
  CanDo : integer;

begin
  CanDo := MsgBox(Handle, 'Clean debug log ?', 'Warning', 48 + MB_YESNO + MB_DEFBUTTON2);
  if CanDo = IDNO then Exit;

  lbDebug.Clear;
  InitDebugLog;
end;

procedure TDebugLog_Form.lbDebugContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
var
  Point : TPoint;

begin
  //Avec MousePos de cette procedure, ca marche pas.
  //Pas compris pourquoi...

  //On prend les coordonnées du curseur de souris...
  GetCursorPos(Point);

  //Cette ensemble de procédure permet de simuler le click.
  //Un click gauche est constitué de deux clicks : quand le
  //bouton est en haut, et quand le bouton est en bas.
  Mouse_Event(MOUSEEVENTF_LEFTDOWN, Point.X, Point.Y, 0, 0);
  Mouse_Event(MOUSEEVENTF_LEFTUP, Point.X, Point.Y, 0, 0);

  //Permet "d'activer" la sélection. Sinon ca sélectionne pas.
  //En fait, ca rend la main a Windows.
  Application.ProcessMessages;

  //On déroule avec du code pour dérouler si seulement la
  //CheckBox est cochée. Vous pouvez enlever ca, et mettre
  //AutoPopup à True dans le PopupMenu.
  //PopUpMenu.Popup(Point.X, Point.Y);
end;

end.
