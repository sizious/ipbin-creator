unit u_bin_save;

interface

uses
  Windows, SysUtils;

function WriteBytes(var F : File ; Offset : Word ; Data : array of Byte) : boolean;
function WriteString(var F : File ; Offset : Word ; DatasToWrite : string) : boolean;

implementation

uses utils;

//---WriteBytes---
function WriteBytes(var F : File ; Offset : Word ; Data : array of Byte) : boolean;
begin

  try

    Seek(F, Offset);
    BlockWrite(F, Data, SizeOf(Data));
    //Application.ProcessMessages;

    Result := True;
  except
    Result := False;
  end;

end;

//---WriteString---
function WriteString(var F : File ; Offset : Word ; DatasToWrite : string) : boolean;
var
  Datas : array of byte;
  i, ArrayLength : integer;

begin
  Result := False;
  if Length(DatasToWrite) = 0 then Exit;

  ArrayLength := Length(DatasToWrite);

  //Remplir le tableau
  SetLength(Datas, ArrayLength);
  for i := 0 to ArrayLength do
    Datas[i-1] := Ord(DatasToWrite[i]);

  Result := WriteBytes(F, Offset, Datas);
end;

end.
