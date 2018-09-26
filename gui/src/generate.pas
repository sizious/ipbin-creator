unit generate;

interface

uses
  Windows;
  
function RandomHexPassword(OfLength : integer): string;
function GenProductNo : string;

implementation

//---RandomPassword---
{ function RandomPassword(OfLength : integer): string;
const
  S = '013456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';

begin
  repeat
   Result := Result + S[Random(Length(S))+1];
  until Length(Result) = OfLength;
end; }

//---RandomHexPassword---
function RandomHexPassword(OfLength : integer): string;
const
  S = '013456789ABCDEF';

begin
  repeat
   Result := Result + S[Random(Length(S))+1]; 
  until Length(Result) = OfLength;
end;

//---RandomProdLetter---
function RandomProdLetter : string;
const
  S = 'NM';

begin
  repeat
   Result := Result + S[Random(Length(S))+1];
  until Length(Result) = 1;
end;

//---RandomNumbers---
function RandomNumbers(OfLength : integer): string;
const
  S = '0123456789';

begin
  repeat
   Result := Result + S[Random(Length(S))+1];
  until Length(Result) = OfLength;
end;

//---GenProductNo---
function GenProductNo : string;
var
  i : integer;

begin
  i := Random(5);

  case i of
    0 : Result := 'MK-' + RandomNumbers(5); //MK-.....
    1 : Result := 'MK' + RandomNumbers(4); //MK....
    2 : Result := 'T' + RandomNumbers(5) + RandomProdLetter; //T.....N
    3 : Result := 'T' + RandomNumbers(4) + RandomProdLetter; //T....M
    4 : Result := 'HDR-' + RandomNumbers(4);  //HDR-....
  end;

end;

end.
