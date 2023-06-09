unit DS.Model.Entidade.Pessoa;

interface

uses
  System.SysUtils, System.Classes, DS.Model.Conexao.Firedac, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, System.JSON,
  DataSetConverter4D.Helper, DataSetConverter4D.Impl;

type
  TModelEntidadePessoa = class(TDataModule)
    FDQuery1: TFDQuery;
    FDQuery2: TFDQuery;
  private
    { Private declarations }
    function ObterProximoCodigo(const Tabela, Campo: String): Variant;
  public
    { Public declarations }
    function Get(const Key : String = ''): TJSONArray;
    function Put(const Key : String; JObject : TJSONObject): TModelEntidadePessoa;
    function Post(const Key : String; JObject : TJSONObject): TModelEntidadePessoa;
    function Delete(const Key : String): TModelEntidadePessoa;
    function InsertLote(JsonArray: TJSONArray): TModelEntidadePessoa;
  end;

var
  ModelEntidadePessoa: TModelEntidadePessoa;

implementation

uses
  DS.Model.Entidade.Endereco, uEndereco;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TModelEntidadeProduto }

function TModelEntidadePessoa.Delete(const Key: String): TModelEntidadePessoa;
begin
  Result := Self;
  FDQuery1.Close;
  FDQuery1.SQL.Clear;
  FDQuery1.SQL.Add('delete from pessoa where idpessoa = ' + Key);

  DMConexaoFiredac.FDTransaction.StartTransaction;
  try
    FDQuery1.ExecSQL;
    DMConexaoFiredac.FDTransaction.Commit;
  except
    on E: Exception do
    begin
      DMConexaoFiredac.FDTransaction.Rollback;
      raise Exception.Create('Erro ao excluir pessoa no banco de dados com c�digo ' +
         Key + ' Erro: ' + E.Message);
    end;
  end;
end;

function TModelEntidadePessoa.Get(const Key: String): TJSONArray;
begin
  FDQuery1.Close;
  FDQuery1.SQL.Clear;
  FDQuery1.SQL.Add('select * from pessoa ');
  if Key <> '' then
    FDQuery1.SQL.Add(' where idpessoa = ' + Key);
  FDQuery1.Open;
  Result :=  FDQuery1.AsJSONArray;
end;

function TModelEntidadePessoa.InsertLote(JsonArray: TJSONArray): TModelEntidadePessoa;
var
  aJsonObject: TJSonValue;
  ModelEndereco: TModelEntidadeEndereco;
  oEndereco: TEndereco;
begin
  Result := Self;
  ModelEndereco := TModelEntidadeEndereco.Create(Self);
  oEndereco := TEndereco.Create;
  try
    for aJsonObject in JsonArray do
    begin
      FDQuery1.Close;
      FDQuery1.SQL.Clear;
      FDQuery1.SQL.Add('select * from pessoa where 1=2');
      FDQuery1.Open;
      FDQuery1.RecordFromJSONObject(aJsonObject as TJSonObject);

      if not (FDQuery1.State in dsEditModes) then
        FDQuery1.Edit;

      FDQuery1.FieldByName('idpessoa').Value := ObterProximoCodigo('pessoa', 'idpessoa');

      DMConexaoFiredac.FDTransaction.StartTransaction;
      try
        FDQuery1.ApplyUpdates(-1);
        DMConexaoFiredac.FDTransaction.Commit;

        // Insere endere�o
        oEndereco.IdEndereco := 0;
        oEndereco.IdPessoa := FDQuery1.FieldByName('idpessoa').AsInteger;
        oEndereco.DsCep := (aJsonObject as TJSonObject).GetValue('dscep').ToString;
        ModelEndereco.Put('', oEndereco.toJson(''));

      except
        on E: Exception do
        begin
          DMConexaoFiredac.FDTransaction.Rollback;
          raise Exception.Create('Erro ao gravar lista de array de pessoa no banco de dados com c�digo ' +
             ' Erro: ' + E.Message);
        end;
      end;
    end;
  finally
    FreeAndNil(ModelEndereco);
    FreeAndNil(oEndereco);
  end;
end;

function TModelEntidadePessoa.Post(const Key: String;
  JObject: TJSONObject): TModelEntidadePessoa;
begin
  Result := Self;
  FDQuery1.Close;
  FDQuery1.SQL.Clear;
  FDQuery1.SQL.Add('select * from pessoa where idpessoa = ' + Key);
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
      raise Exception.Create('Erro ao gravar altera��o de pessoa no banco de dados com c�digo ' +
         Key + ' Erro: ' + E.Message);
    end;
  end;
end;

function TModelEntidadePessoa.Put(const Key: String;
  JObject: TJSONObject): TModelEntidadePessoa;
begin
  Result := Self;
  FDQuery1.Close;
  FDQuery1.SQL.Clear;
  FDQuery1.SQL.Add('select * from pessoa where 1=2');
  FDQuery1.Open;

  FDQuery1.FromJSONObject(JObject);

  if not (FDQuery1.State in dsEditModes) then
    FDQuery1.Edit;

  FDQuery1.FieldByName('idpessoa').Value := ObterProximoCodigo('pessoa', 'idpessoa');

  DMConexaoFiredac.FDTransaction.StartTransaction;
  try
    FDQuery1.ApplyUpdates(-1);
    DMConexaoFiredac.FDTransaction.Commit;
  except
    on E: Exception do
    begin
      DMConexaoFiredac.FDTransaction.Rollback;
      raise Exception.Create('Erro ao gravar inclus�o de pessoa no banco de dados Erro: ' + E.Message);
    end;
  end;
end;

function TModelEntidadePessoa.ObterProximoCodigo(const Tabela, Campo: String): Variant;
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
