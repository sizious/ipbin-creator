program ipbuild;

uses
  Forms,
  main in 'main.pas' {Main_Form},
  utils in 'utils.pas',
  generate in 'generate.pas',
  build in 'build.pas',
  u_const in 'u_const.pas',
  u_bin_save in 'u_bin_save.pas',
  logoman in 'logoman.pas',
  debuglog in 'debuglog.pas' {DebugLog_Form},
  imgconv in 'imgconv.pas',
  U_Interpolation_BiLineaire in 'U_Interpolation_Bilineaire.pas',
  ImageType in 'ImageType.pas',
  pngutils in 'pngutils.pas',
  imgman in 'imgman.pas',
  u_build in 'u_build.pas',
  preset in 'preset.pas',
  aboutprg in 'aboutprg.pas' {AboutPrg_Form},
  about in 'About.pas' {AboutBox};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMain_Form, Main_Form);
  Application.CreateForm(TDebugLog_Form, DebugLog_Form);
  Application.CreateForm(TAboutPrg_Form, AboutPrg_Form);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.Run;
end.
