unit uPessoa;

interface

uses
  System.SysUtils;

type
  TPessoa = class
  private
    FIdPessoa: Integer;
    FFlNatureza: Integer;
    FDsDocumento: String;
    FNmNome: String;
    FSobreNome: String;
  public
    function ToJson: String;
  published
    property IdPessoa: Integer read FIdPessoa write FIdPessoa;
    property FlNatureza: Integer read FFlNatureza write FFlNatureza;
    property DsDocumento: String read FDsDocumento write FDsDocumento;
    property NmNome: String read FNmNome write FNmNome;
    property SobreNome: String read FSobreNome write FSobreNome;
  end;

implementation

{ TPessoa }

function TPessoa.ToJson: String;
begin
  Result := '{"idpessoa":"' + IntToStr(FIdPessoa) +
            '","flnatureza":"' + IntToStr(FlNatureza) +
            '","dsdocumento":"' + DsDocumento +
            '","nmprimeiro":"' + NmNome +
            '","nmsegundo":"' + SobreNome +
            '","dtregistro":"2023-03-13"}';
end;

end.
