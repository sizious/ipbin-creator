unit aboutprg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, jpeg;

type
  TAboutPrg_Form = class(TForm)
    BitBtn1: TBitBtn;
    Bevel1: TBevel;
    BitBtn2: TBitBtn;
    Label2: TLabel;
    Label1: TLabel;
    Panel1: TPanel;
    Image1: TImage;
    Bevel2: TBevel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Bevel3: TBevel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    procedure BitBtn1Click(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  AboutPrg_Form: TAboutPrg_Form;

implementation

uses about;

{$R *.dfm}

procedure TAboutPrg_Form.BitBtn1Click(Sender: TObject);
begin
  AboutBox.ShowModal;
end;

end.
