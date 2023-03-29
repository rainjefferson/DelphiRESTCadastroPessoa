unit uEndereco;

interface

uses
  System.JSON;

type
  TEndereco = class
  private
    FIdEndereco: Integer;
    FDsCEP: String;
    FIdPessoa: Integer;
  public
    function ToJson: String; overload;
    function ToJson(const Json: String): TJSONObject; overload;
  published
    property IdEndereco: Integer read FIdEndereco write FIdEndereco;
    property IdPessoa: Integer read FIdPessoa write FIdPessoa;
    property DsCEP: String read FDsCEP write FDsCEP;
  end;

implementation

uses
  System.SysUtils;

{ TEndereco }

function TEndereco.ToJson: String;
begin
  Result := '{"idendereco":"' + IntToStr(IdEndereco) +
            '","idpessoa":"' + IntToStr(IdPessoa) +
            '","dscep":"' + StringReplace(FDsCEP,'"','',[rfReplaceAll]) + '"}';
end;

function TEndereco.ToJson(const Json: String): TJSONObject;
var
  sJson: String;
  JsonValue: TJsonValue;
begin
  if Json <> '' then
    sJson := Json
  else
    sJson := ToJson;
  JsonValue := TJSonObject.ParseJSONValue(sJson);
  Result := TJsonObject(JsonValue);
end;

end.
