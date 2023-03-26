unit DS.Model.Entidade.Endereco;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async,
  FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, System.JSON,
  DataSetConverter4D.Helper, DataSetConverter4D.Impl;

type
  TModelEntidadeEndereco = class(TDataModule)
    FDQuery1: TFDQuery;
    FDQuery2: TFDQuery;
  private
    { Private declarations }
    procedure ExcluirRegistro(const Id, Tabela: String);
    function ObterProximoCodigo(const Tabela, Campo: String): Variant;
  public
    { Public declarations }
    function Get(const Key: String = ''): TJSONArray;
    function Put(const Key: String; JObject: TJSONObject): TModelEntidadeEndereco;
    function Post(const Key: String; JObject : TJSONObject): TModelEntidadeEndereco;
    function Delete(const Key: String) : TModelEntidadeEndereco;
    function AtualizarEndereco(const Key: String; JObject: TJSONObject): TModelEntidadeEndereco;
  end;

var
  ModelEntidadeEndereco: TModelEntidadeEndereco;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

uses DS.Model.Conexao.Firedac;

{$R *.dfm}

{ TModelEntidadeEndereco }

function TModelEntidadeEndereco.AtualizarEndereco(const Key: String; JObject: TJSONObject): TModelEntidadeEndereco;
begin
  Result := Self;
  ExcluirRegistro(Key, 'endereco_integracao');

  FDQuery1.Close;
  FDQuery1.SQL.Clear;
  FDQuery1.SQL.Add('select * from endereco_integracao where 1=2');
  FDQuery1.Open;

  FDQuery1.FromJSONObject(JObject);

  DMConexaoFiredac.FDTransaction.StartTransaction;
  try
    FDQuery1.ApplyUpdates(-1);
    DMConexaoFiredac.FDTransaction.Commit;
  except
    on E: Exception do
    begin
      DMConexaoFiredac.FDTransaction.Rollback;
      raise Exception.Create('Erro ao gravar inclusão de endereco_integracao no banco de dados Erro: ' + E.Message);
    end;
  end;
end;

function TModelEntidadeEndereco.Delete(const Key: String): TModelEntidadeEndereco;
begin
  Result := Self;
  ExcluirRegistro(Key, 'endereco');
end;

procedure TModelEntidadeEndereco.ExcluirRegistro(const Id, Tabela: String);
begin
  FDQuery1.Close;
  FDQuery1.SQL.Clear;
  FDQuery1.SQL.Add('delete from ' + Tabela + ' where idendereco = ' + Id);
  DMConexaoFiredac.FDTransaction.StartTransaction;
  try
    FDQuery1.ExecSQL;
    DMConexaoFiredac.FDTransaction.Commit;
  except
    on E: Exception do
    begin
      DMConexaoFiredac.FDTransaction.Rollback;
      raise Exception.Create('Erro ao excluir registro da tabela "' + Tabela + '" no banco de dados com código ' +
         Id + ' Erro: ' + E.Message);
    end;
  end;
end;

function TModelEntidadeEndereco.Get(const Key: String): TJSONArray;
begin
  FDQuery1.Close;
  FDQuery1.SQL.Clear;
  FDQuery1.SQL.Add('select * from endereco ');
  if Key <> '' then
    FDQuery1.SQL.Add(' where idendereco = ' + Key);
  FDQuery1.Open;
  Result :=  FDQuery1.AsJSONArray;
end;

function TModelEntidadeEndereco.Post(const Key: String; JObject: TJSONObject): TModelEntidadeEndereco;
begin
  Result := Self;
  FDQuery1.Close;
  FDQuery1.SQL.Clear;
  FDQuery1.SQL.Add('select * from endereco where idendereco = ' + Key);
  FDQuery1.Open;
  FDQuery1.RecordFromJSONObject(JObject);

  DMConexaoFiredac.FDTransaction.StartTransaction;
  try
    FDQuery1.ApplyUpdates(-1);
    DMConexaoFiredac.FDTransaction.Commit;
  except
    on E: Exception do
    begin
      DMConexaoFiredac.FDTransaction.Rollback;
      raise Exception.Create('Erro ao gravar alteração de endereço no banco de dados com código ' +
         Key + ' Erro: ' + E.Message);
    end;
  end;
end;

function TModelEntidadeEndereco.Put(const Key: String; JObject: TJSONObject): TModelEntidadeEndereco;
begin
  Result := Self;
  FDQuery1.Close;
  FDQuery1.SQL.Clear;
  FDQuery1.SQL.Add('select * from endereco where 1=2');
  FDQuery1.Open;

  FDQuery1.FromJSONObject(JObject);

  if not (FDQuery1.State in dsEditModes) then
    FDQuery1.Edit;

  FDQuery1.FieldByName('idendereco').Value := ObterProximoCodigo('endereco', 'idendereco');

  DMConexaoFiredac.FDTransaction.StartTransaction;
  try
    FDQuery1.ApplyUpdates(-1);
    DMConexaoFiredac.FDTransaction.Commit;
  except
    on E: Exception do
    begin
      DMConexaoFiredac.FDTransaction.Rollback;
      raise Exception.Create('Erro ao gravar inclusão de endereço no banco de dados Erro: ' + E.Message);
    end;
  end;
end;

function TModelEntidadeEndereco.ObterProximoCodigo(const Tabela, Campo: String): Variant;
begin
  FDQuery2.Close;
  FDQuery2.SQL.Clear;
  FDQuery2.SQL.Add('select max(' + Campo + ') as prox from ' + Tabela);
  FDQuery2.Open;
  if FDQuery2.FieldByName('prox').IsNull then
    Result := 1
  else
    Result := FDQuery2.FieldByName('prox').Value + 1;
end;

end.
