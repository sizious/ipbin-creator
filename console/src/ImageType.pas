{
/**********************************************************/
/*                     ImageType  V0.1                    */
/*                                                        */
/* Last release 09/02/2003                Sylvain Taufour */
/*                                sylvain.taufour@free.fr */
/**********************************************************/
}

unit ImageType;

interface

uses
  Classes, SysUtils;

type
  TImageType = (I_Jpeg, I_BMP, I_GIF, I_PNG, I_Unknow);

function GetImageType(FileName: string): TImageType;

implementation

function GetImageType(FileName: string): TImageType;
var
  FS: TFileStream;
  Buff: string;
begin
 SetLength(Buff, 3);
  FS := TFileStream.Create(FileName, fmOpenRead	+ fmShareDenyNone);
  with FS do
  begin
    Read(Buff[1], 3);
    if (Ord(Buff[1]) = $FF) and (Ord(Buff[2]) = $D8) then result := I_Jpeg
    else if (Ord(Buff[1]) = $42) and (Ord(Buff[2]) = $4D) then result := I_BMP
    else if Buff = 'GIF' then result := I_GIF
    else if (Ord(Buff[1]) = $89) and (Ord(Buff[2]) = $50) and (Ord(Buff[3]) = $4E) then
      result := I_PNG
    else result := I_Unknow;
    Free;
  end;
end;

end.


