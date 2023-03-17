unit DS.Model.Entidade.Factory;

interface

uses
  DS.Model.Entidade.Pessoa, DS.Model.Entidade.Endereco;

type
  TModelEntidadeFactory = class
    private
      FModelEntidadePessoa: TModelEntidadePessoa;
      FModelEntidadeEndereco: TModelEntidadeEndereco;
    public
      constructor Create;
      destructor Destroy; override;
      function Pessoa : TModelEntidadePessoa;
      function Endereco: TModelEntidadeEndereco;
  end;

implementation

{ TModelEntidadeFactory }

constructor TModelEntidadeFactory.Create;
begin
  FModelEntidadePessoa := TModelEntidadePessoa.Create(nil);
  FModelEntidadeEndereco := TModelEntidadeEndereco.Create(nil);
end;

destructor TModelEntidadeFactory.Destroy;
begin
  FModelEntidadePessoa.DisposeOf;
  FModelEntidadeEndereco.DisposeOf;
  inherited;
end;

function TModelEntidadeFactory.Endereco: TModelEntidadeEndereco;
begin
  Result := FModelEntidadeEndereco;
end;

function TModelEntidadeFactory.Pessoa: TModelEntidadePessoa;
begin
  Result := FModelEntidadePessoa;
end;

end.
