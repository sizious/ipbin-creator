unit imgman;

interface

uses
  Windows, SysUtils;

function GenerateValidPng(SourceImage : string ; Target : string) : boolean;

implementation

uses U_Interpolation_BiLineaire, imgconv, pngutils, ImageType, utils, main;

function GenerateValidPng(SourceImage : string ; Target : string) : boolean;
var
  ImgType : TImageType;
  Temp    : string;

begin
  Result := False;
  Temp   := GetTempDir + '~temp.bmp';
  if FileExists(Temp) then DeleteFile(Temp);

  //showmessage(target);

  //Dans un premier temps on détecte le type d'image, puis on la convertit en BMP (si possible).
  ImgType := GetImageType(SourceImage);
  case ImgType of
    I_Jpeg    : JpgToPng(SourceImage, Target);
    I_BMP     : BitmapFileToPNG(SourceImage, Target);
    I_GIF     : GifToPng(SourceImage, Target);
    I_PNG     : CopyFile(PChar(SourceImage), PChar(Target), False);
    I_Unknow  : Exit;
  end;

  //Retailler le PNG si besoin (a partir d'ici, Target est un PNG).
  PNGFileToBitmap(Target, Temp);
  Result := ReSizeBMP(Temp, 320, 90);
  BitmapFileToPNG(Temp, Target);
  if FileExists(Temp) then DeleteFile(Temp);
  if FileExists(Target) then Result := True;
end;

end.
