unit DM.ClientDatasnap;

interface

uses
  System.SysUtils, System.Classes, IPPeerClient, REST.Client, Data.Bind.Components, Data.Bind.ObjectScope, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, REST.Response.Adapter, System.JSON;

type
  TDMClientDatasnap = class(TDataModule)
    RESTClientPessoa: TRESTClient;
    RESTRequestPessoa: TRESTRequest;
    RESTResponsePessoa: TRESTResponse;
    RESTResponseDataSetAdapterPessoa: TRESTResponseDataSetAdapter;
    FDMemTablePessoa: TFDMemTable;
    RESTClientEndereco: TRESTClient;
    RESTRequestEndereco: TRESTRequest;
    RESTResponseEndereco: TRESTResponse;
    RESTResponseDataSetAdapterEndereco: TRESTResponseDataSetAdapter;
    FDMemTableEndereco: TFDMemTable;
    RESTClientViaCep: TRESTClient;
    RESTRequestViaCep: TRESTRequest;
    RESTResponseViaCep: TRESTResponse;
  private
    function AtualizarEnderecoIntegracao(const Json: String; const CodEnd: Integer): String;
    { Private declarations }
  public
    { Public declarations }
    function EnviarRequestPUT(const JSon, EndPointPut: String): String;
    function EnviarRequestPOST(const JSon, EndPointPost, ResourcePost: String): String;
    function EnviarRequestDELETE(const EndPointDelete, ResourceDelete: String): String;
    function EnviarPessoasEmLote(const Json: String): String;
    procedure AtualizarEnderecoPorCep(const Cep: String; const CodEnd: Integer);
  end;

var
  DMClientDatasnap: TDMClientDatasnap;

implementation

uses
  REST.Types;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TDMClientDatasnap }

procedure TDMClientDatasnap.AtualizarEnderecoPorCep(const Cep: String; const CodEnd: Integer);
var
  JSonEndIntegra: String;
  JsonViaCep: TJsonObject;
begin
  RESTClientViaCep.BaseURL := 'http://viacep.com.br/ws/' + Cep + '/json';
  RESTRequestViaCep.Execute;
  if RESTRequestViaCep.Response.StatusCode = 200 then
  begin
    JsonViaCep := TJsonObject(TJSonObject.ParseJSONValue(RESTRequestViaCep.Response.Content));

    // Consultar cep errado - retorna codigo 200 - com json { "erro": true }
    if not assigned(JsonViaCep.GetValue('erro')) then
    begin
      JSonEndIntegra := '{"idendereco":' + IntToStr(CodEnd) + ', ' +
                        ' "dsuf":"", ' +
                        ' "nmcidade":' + JsonViaCep.GetValue('localidade').ToString + ', ' +
                        ' "nmbairro":' + JsonViaCep.GetValue('bairro').ToString + ', ' +
                        ' "nmlogradouro":' + JsonViaCep.GetValue('logradouro').ToString + ', ' +
                        ' "dscomplemento":' + JsonViaCep.GetValue('complemento').ToString +  '} ';

      AtualizarEnderecoIntegracao(JSonEndIntegra, CodEnd);
    end;
  end;
end;

function TDMClientDatasnap.AtualizarEnderecoIntegracao(const Json: String; const CodEnd: Integer): String;
var
  RESTClient: TRESTClient;
  RESTRequest: TRESTRequest;
  RESTResponse: TRESTResponse;
begin
  RESTClient := TRESTClient.Create('http://localhost:8081/datasnap/rest/tendereco/enderecointegracao/' + IntToStr(CodEnd));
  RESTClient.Accept := 'application/json, text/plain; q=0.9, text/html;q=0.8,';
  RESTClient.AcceptCharset := 'UTF-8, *;q=0.8';
  RESTClient.ContentType := 'application/json';

  RESTRequest := TRESTRequest.Create(Self);
  RESTRequest.Accept := 'application/json, text/plain; q=0.9, text/html;q=0.8,';
  RESTRequest.AcceptCharset := 'UTF-8, *;q=0.8';
  RESTRequest.Method := rmPOST;

  RESTRequest.Client := RESTClient;

  RESTResponse := TRESTResponse.Create(Self);
  RESTRequest.Response := RESTResponse;
  try
     RESTRequest.AddBody(Json, ContentTypeFromString('application/json'));
     RESTRequest.Execute;
     Result := IntToStr(RESTRequest.Response.StatusCode) + ' ' + RESTRequest.Response.StatusText;
     if RESTRequest.Response.Content <> '' then
       Result := Result + '. ' + RESTRequest.Response.Content;
  finally
     FreeAndNil(RESTClient);
     FreeAndNil(RESTRequest);
     FreeAndNil(RESTResponse);
  end;
end;

function TDMClientDatasnap.EnviarPessoasEmLote(const Json: String): String;
var
  RESTClient: TRESTClient;
  RESTRequest: TRESTRequest;
  RESTResponse: TRESTResponse;
begin
  RESTClient := TRESTClient.Create('http://localhost:8081/datasnap/rest/tpessoa/pessoalote');
  RESTClient.Accept := 'application/json, text/plain; q=0.9, text/html;q=0.8,';
  RESTClient.AcceptCharset := 'UTF-8, *;q=0.8';
  RESTClient.ContentType := 'application/json';

  RESTRequest := TRESTRequest.Create(Self);
  RESTRequest.Accept := 'application/json, text/plain; q=0.9, text/html;q=0.8,';
  RESTRequest.AcceptCharset := 'UTF-8, *;q=0.8';
  RESTRequest.Method := rmPOST;

  RESTRequest.Client := RESTClient;

  RESTResponse := TRESTResponse.Create(Self);
  RESTRequest.Response := RESTResponse;
  try
     RESTRequest.AddBody(Json, ContentTypeFromString('application/json'));
     RESTRequest.Execute;
     Result := IntToStr(RESTRequest.Response.StatusCode) + ' ' + RESTRequest.Response.StatusText;
     if RESTRequest.Response.Content <> '' then
       Result := Result + '. ' + RESTRequest.Response.Content;
  finally
     FreeAndNil(RESTClient);
     FreeAndNil(RESTRequest);
     FreeAndNil(RESTResponse);
  end;
end;

function TDMClientDatasnap.EnviarRequestDELETE(const EndPointDelete, ResourceDelete: String): String;
var
  RESTClient: TRESTClient;
  RESTRequest: TRESTRequest;
  RESTResponse: TRESTResponse;
begin
  RESTClient := TRESTClient.Create('http://localhost:8081/datasnap/rest/' + EndPointDelete);
  RESTClient.Accept := 'application/json, text/plain; q=0.9, text/html;q=0.8,';
  RESTClient.AcceptCharset := 'UTF-8, *;q=0.8';
  RESTClient.ContentType := 'application/json';

  RESTRequest := TRESTRequest.Create(Self);
  RESTRequest.Accept := 'application/json, text/plain; q=0.9, text/html;q=0.8,';
  RESTRequest.AcceptCharset := 'UTF-8, *;q=0.8';
  RESTRequest.Resource := ResourceDelete;
  RESTRequest.Method := rmDELETE;

  RESTRequest.Client := RESTClient;

  RESTResponse := TRESTResponse.Create(Self);
  RESTRequest.Response := RESTResponse;
  try
     RESTRequest.Execute;
     Result := IntToStr(RESTRequest.Response.StatusCode) + ' ' + RESTRequest.Response.StatusText;
     if RESTRequest.Response.Content <> '' then
       Result := Result + '. ' + RESTRequest.Response.Content;
  finally
     FreeAndNil(RESTClient);
     FreeAndNil(RESTRequest);
     FreeAndNil(RESTResponse);
  end;
end;

function TDMClientDatasnap.EnviarRequestPOST(const JSon, EndPointPost, ResourcePost: String): String;
var
  RESTClient: TRESTClient;
  RESTRequest: TRESTRequest;
  RESTResponse: TRESTResponse;
begin
  RESTClient := TRESTClient.Create('http://localhost:8081/datasnap/rest/' + EndPointPost);
  RESTClient.Accept := 'application/json, text/plain; q=0.9, text/html;q=0.8,';
  RESTClient.AcceptCharset := 'UTF-8, *;q=0.8';
  RESTClient.ContentType := 'application/json';

  RESTRequest := TRESTRequest.Create(Self);
  RESTRequest.Accept := 'application/json, text/plain; q=0.9, text/html;q=0.8,';
  RESTRequest.AcceptCharset := 'UTF-8, *;q=0.8';
  RESTRequest.Resource := ResourcePost;
  RESTRequest.Method := rmPOST;

  RESTRequest.Client := RESTClient;

  RESTResponse := TRESTResponse.Create(Self);
  RESTRequest.Response := RESTResponse;
  try
     RESTRequest.AddBody(JSon, ContentTypeFromString('application/json'));
     RESTRequest.Execute;
     Result := IntToStr(RESTRequest.Response.StatusCode) + ' ' + RESTRequest.Response.StatusText;
     if RESTRequest.Response.Content <> '' then
       Result := Result + '. ' + RESTRequest.Response.Content;
  finally
     FreeAndNil(RESTClient);
     FreeAndNil(RESTRequest);
     FreeAndNil(RESTResponse);
  end;
end;

function TDMClientDatasnap.EnviarRequestPUT(const JSon, EndPointPut: String): String;
var
  RESTClient: TRESTClient;
  RESTRequest: TRESTRequest;
  RESTResponse: TRESTResponse;
begin
  RESTClient := TRESTClient.Create('http://localhost:8081/datasnap/rest/' + EndPointPut);
  RESTClient.Accept := 'application/json, text/plain; q=0.9, text/html;q=0.8,';
  RESTClient.AcceptCharset := 'UTF-8, *;q=0.8';
  RESTClient.ContentType := 'application/json';

  RESTRequest := TRESTRequest.Create(Self);
  RESTRequest.Accept := 'application/json, text/plain; q=0.9, text/html;q=0.8,';
  RESTRequest.AcceptCharset := 'UTF-8, *;q=0.8';
  RESTRequest.Method := rmPUT;

  RESTRequest.Client := RESTClient;

  RESTResponse := TRESTResponse.Create(Self);
  RESTRequest.Response := RESTResponse;
  try
     RESTRequest.AddBody(JSon, ContentTypeFromString('application/json'));
     RESTRequest.Execute;
     Result := IntToStr(RESTRequest.Response.StatusCode) + ' ' + RESTRequest.Response.StatusText;
     if RESTRequest.Response.Content <> '' then
       Result := Result + '. ' + RESTRequest.Response.Content;
  finally
     FreeAndNil(RESTClient);
     FreeAndNil(RESTRequest);
     FreeAndNil(RESTResponse);
  end;
end;

end.
