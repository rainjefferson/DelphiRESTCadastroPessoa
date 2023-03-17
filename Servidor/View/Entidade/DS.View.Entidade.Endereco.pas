unit DS.View.Entidade.Endereco;

interface

uses
  System.SysUtils, System.Classes, System.JSON, DS.Controller;

{$METHODINFO ON}
type
  TEndereco = class(TDataModule)
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
    FController : TController;
  public
    { Public declarations }
    function Endereco(const Key: String) : TJSONArray;
    procedure acceptEndereco(const Key: String; JObject : TJSONObject);
    procedure updateEndereco(const Key: String; JObject : TJSONObject);
    procedure cancelEndereco(const key: String);
    procedure updateEnderecoIntegracao(const key: String; JObject : TJSONObject);
  end;
{$METHODINFO OFF}

var
  Endereco: TEndereco;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TEndereco }

procedure TEndereco.acceptEndereco(const Key: String; JObject: TJSONObject);
begin
  FController.Entidades.Endereco.Put(Key,JObject);
end;

procedure TEndereco.cancelEndereco(const key: String);
begin
  FController.Entidades.Endereco.Delete(Key);
end;

procedure TEndereco.DataModuleCreate(Sender: TObject);
begin
  FController := TController.Create;
end;

procedure TEndereco.DataModuleDestroy(Sender: TObject);
begin
  FController.DisposeOf;
end;

function TEndereco.Endereco(const Key: String): TJSONArray;
begin
  Result := FController.Entidades.Endereco.Get(Key);
end;

procedure TEndereco.updateEndereco(const Key: String; JObject: TJSONObject);
begin
  FController.Entidades.Endereco.Post(Key,JObject);
end;

procedure TEndereco.updateEnderecoIntegracao(const key: String; JObject: TJSONObject);
begin
  FController.Entidades.Endereco.AtualizarEndereco(Key, JObject);
end;

end.
