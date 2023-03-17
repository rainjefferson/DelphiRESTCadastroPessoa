unit uEndereco;

interface

uses
  System.SysUtils;

type
  TEndereco = class
  private
    FIdEndereco: Integer;
    FDsCEP: String;
    FIdPessoa: Integer;
  public
    function ToJson: String;
  published
    property IdEndereco: Integer read FIdEndereco write FIdEndereco;
    property IdPessoa: Integer read FIdPessoa write FIdPessoa;
    property DsCEP: String read FDsCEP write FDsCEP;
  end;

implementation

{ TEndereco }

function TEndereco.ToJson: String;
begin
  Result := '{"idendereco":"' + IntToStr(IdEndereco) +
            '","idpessoa":"' + IntToStr(IdPessoa) +
            '","dscep":"' + FDsCEP + '"}';
end;

end.
