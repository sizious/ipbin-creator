unit u_bin_save;

interface

uses
  Windows, SysUtils, Forms;

function WriteBytes(var F : File ; Offset : Word ; Data : array of Byte) : boolean;
function WriteString(var F : File ; Offset : Word ; DatasToWrite : string) : boolean;
//function WriteInteger(var F : File ; Offset : Word ; Data : LongInt) : boolean;

implementation

uses main, utils;

{
//---WriteInteger---
function WriteInteger(var F : File ; Offset : Word ; Data : LongInt) : boolean;
begin
  //AssignFile(F, FileName);
  
  try
    Seek(F, Offset);
    BlockWrite(F, Data, SizeOf(Data));
    Result := True;
  except
    Result := False;
  end;
end;
}

//---WriteBytes---
function WriteBytes(var F : File ; Offset : Word ; Data : array of Byte) : boolean;
begin
  //Result := False;
  //if FileExists(FileName) = False then Exit;

  //AssignFile(F, FileName);
  try

    { if FileExists(FileName) = True then
      Reset(F, 1)
    else ReWrite(F, 1); }

    Seek(F, Offset);
    BlockWrite(F, Data, SizeOf(Data));
    Application.ProcessMessages;

    //CloseFile(F);
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
  //if FileExists(FileName) = False then Exit;

  ArrayLength := Length(DatasToWrite);

  //Remplir le tableau
  SetLength(Datas, ArrayLength);
  for i := 0 to ArrayLength do
    Datas[i-1] := Ord(DatasToWrite[i]);

  Result := WriteBytes(F, Offset, Datas);
end;

end.
