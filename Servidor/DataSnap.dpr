program DataSnap;
{$APPTYPE GUI}

{$R *.dres}

uses
  Vcl.Forms,
  Web.WebReq,
  IdHTTPWebBrokerBridge,
  FormUnit1 in 'View\FormUnit1.pas' {Form1},
  ServerMethodsUnit1 in 'View\ServerMethodsUnit1.pas' {ServerMethods1: TDSServerModule},
  WebModuleUnit1 in 'WebModuleUnit1.pas' {WebModule1: TWebModule},
  DS.Model.Conexao.Firedac in 'Model\Conexao\DS.Model.Conexao.Firedac.pas' {DMConexaoFiredac: TDataModule},
  DS.Model.Entidade.Pessoa in 'Model\Entidade\DS.Model.Entidade.Pessoa.pas' {ModelEntidadePessoa: TDataModule},
  DS.Controller in 'Controller\DS.Controller.pas',
  DS.Model.Entidade.Factory in 'Model\Entidade\DS.Model.Entidade.Factory.pas',
  DS.View.Entidade.Pessoa in 'View\Entidade\DS.View.Entidade.Pessoa.pas' {Pessoa: TDataModule},
  DataSetConverter4D.Helper in 'DataSetConverter4D.Helper.pas',
  DataSetConverter4D.Impl in 'DataSetConverter4D.Impl.pas',
  DataSetConverter4D in 'DataSetConverter4D.pas',
  DataSetConverter4D.Util in 'DataSetConverter4D.Util.pas',
  DS.Model.Entidade.Endereco in 'Model\Entidade\DS.Model.Entidade.Endereco.pas' {ModelEntidadeEndereco: TDataModule},
  DS.View.Entidade.Endereco in 'View\Entidade\DS.View.Entidade.Endereco.pas' {Endereco: TDataModule},
  uEndereco in '..\Cliente\uEndereco.pas';

{$R *.res}

begin
  if WebRequestHandler <> nil then
    WebRequestHandler.WebModuleClass := WebModuleClass;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TDMConexaoFiredac, DMConexaoFiredac);
  Application.CreateForm(TModelEntidadePessoa, ModelEntidadePessoa);
  Application.CreateForm(TPessoa, Pessoa);
  Application.CreateForm(TModelEntidadeEndereco, ModelEntidadeEndereco);
  Application.Run;
end.
