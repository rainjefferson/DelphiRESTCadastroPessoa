unit DS.View.Entidade.Pessoa;

interface

uses
  System.SysUtils, System.Classes, System.JSON, DS.Controller,
  Datasnap.DSServer, Datasnap.DSAuth;

{$METHODINFO ON}
type
  TPessoa = class(TDataModule)
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
    FController : TController;
  public
    { Public declarations }
    function Pessoa(const Key : String) : TJSONArray;
    function acceptPessoa(const Key : String; JObject : TJSONObject): Integer;
    procedure updatePessoa(const Key : String; JObject : TJSONObject);
    procedure cancelPessoa(const key : String);
    procedure updatePessoaLote(JsonArrayObject: TJSONArray);
  end;
{$METHODINFO OFF}

var
  Pessoa: TPessoa;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TProduto }

function TPessoa.acceptPessoa(const Key: String; JObject: TJSONObject): Integer;
begin
  Result := FController.Entidades.Pessoa.Put(Key,JObject).FDQuery1.FieldByName('idpessoa').AsInteger;
end;

procedure TPessoa.cancelPessoa(const key: String);
begin
  FController.Entidades.Pessoa.Delete(Key);
end;

procedure TPessoa.DataModuleCreate(Sender: TObject);
begin
  FController := TController.Create;
end;

procedure TPessoa.DataModuleDestroy(Sender: TObject);
begin
  FController.DisposeOf;
end;

function TPessoa.Pessoa(const Key: String): TJSONArray;
begin
  Result := FController.Entidades.Pessoa.Get(Key);
end;

procedure TPessoa.updatePessoaLote(JsonArrayObject: TJSONArray);
begin
  FController.Entidades.Pessoa.InsertLote(JsonArrayObject);
end;

procedure TPessoa.updatePessoa(const Key: String; JObject: TJSONObject);
begin
  FController.Entidades.Pessoa.Post(Key,JObject);
end;

end.
