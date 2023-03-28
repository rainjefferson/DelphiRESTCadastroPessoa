unit ClientDatasnap.Pessoa;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.ComCtrls, Vcl.ExtCtrls;

type
  TForm2 = class(TForm)
    DataSourcePessoa: TDataSource;
    DataSourceEndereco: TDataSource;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Label9: TLabel;
    dbgrigPessoa: TDBGrid;
    Label10: TLabel;
    dbgridEndereco: TDBGrid;
    btnGetPessoa: TButton;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    edtNatureza: TEdit;
    edtDocumento: TEdit;
    edtPrimeiroNome: TEdit;
    edtSobrenome: TEdit;
    edtCodigoPessoa: TEdit;
    edtIdEndereco: TEdit;
    edtCEP: TEdit;
    btnPut: TButton;
    btnPost: TButton;
    btnDelete: TButton;
    Label11: TLabel;
    mmResult: TMemo;
    mmListaPessoas: TMemo;
    btnEnviarLote: TButton;
    btnAtualizarEnderecos: TButton;
    pnlWait: TPanel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    procedure btnGetPessoaClick(Sender: TObject);
    procedure btnPutClick(Sender: TObject);
    procedure btnPostClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnEnviarLoteClick(Sender: TObject);
    procedure btnAtualizarEnderecosClick(Sender: TObject);
  private
    { Private declarations }
    FFuncaoFecharSucesso: Boolean;
    FFuncaoExecutarThread: TThread;
    FFuncaoExecutarErroThread: String;
    procedure OnTerminoThreadFuncaoExecutarEvento(Sender: TObject);
    function ObterJsonPessoa: String;
    function ObterJsonEndereco(const IdPessoa: Integer): String;
    function EfetuarPut(const JsonPessoa, JsonEndereco: String): String;
    function EfetuarPost(const JsonPessoa, JsonEndereco: String; const CodPes, CodEnd: Integer): String;
    function InformacoesValidasParaPut: Boolean;
    function InformacoesValidaParaPost: Boolean;
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

uses
  DM.ClientDatasnap, REST.Types, uPessoa, uEndereco, ucThreadAni, ucThread,
  System.StrUtils;

procedure TForm2.btnDeleteClick(Sender: TObject);
begin
  if edtCodigoPessoa.Text = '' then
    Application.MessageBox('O Código da pessoa deve ser informado!', 'Aviso', MB_OK)
  else
  if edtIdEndereco.Text = '' then
    Application.MessageBox('O Código do endereço deve ser informado!', 'Aviso', MB_OK)
  else
  begin
    mmResult.Lines.Add(DMClientDatasnap.EnviarRequestDELETE('tendereco/endereco', '/' + edtIdEndereco.Text));
    mmResult.Lines.Add('');
    mmResult.Lines.Add(DMClientDatasnap.EnviarRequestDELETE('tpessoa/pessoa', '/' + edtCodigoPessoa.Text));
  end;
end;

procedure TForm2.btnEnviarLoteClick(Sender: TObject);
begin
  mmResult.Lines.Add(DMClientDatasnap.EnviarPessoasEmLote(mmListaPessoas.Text));
end;

procedure TForm2.btnGetPessoaClick(Sender: TObject);
begin
  DMClientDatasnap.RESTRequestPessoa.Resource := '';
  DMClientDatasnap.RESTRequestPessoa.Execute;

  DMClientDatasnap.RESTRequestEndereco.Resource := '';
  DMClientDatasnap.RESTRequestEndereco.Execute;
end;

procedure TForm2.btnPostClick(Sender: TObject);
var
  sPessoa, sEndereco: String;
begin
  if not InformacoesValidaParaPost then
    Exit;

  sPessoa := ObterJsonPessoa;
  sEndereco := ObterJsonEndereco(StrToInt(edtCodigoPessoa.Text));
  EfetuarPost(sPessoa, sEndereco, StrToInt(edtCodigoPessoa.Text), StrToInt(edtIdEndereco.Text));
end;

function TForm2.InformacoesValidaParaPost: Boolean;
begin
  Result := False;
  if Trim(edtCodigoPessoa.Text) = '' then
  begin
    Application.MessageBox('O código do cadastro da pessoa é obrigatório!', 'Validação', MB_OK);
    if edtCodigoPessoa.CanFocus then
      edtCodigoPessoa.SetFocus;
  end
  else
  if Trim(edtIdEndereco.Text) = '' then
  begin
    Application.MessageBox('O código do endereço da pessoa é obrigatório!', 'Validação', MB_OK);
    if edtIdEndereco.CanFocus then
      edtIdEndereco.SetFocus;
  end
  else
    Result := True;
end;

function TForm2.InformacoesValidasParaPut: Boolean;
begin
  Result := False;
  if Trim(edtNatureza.Text) = '' then
  begin
    Application.MessageBox('O código da natureza da pessoa é obrigatório!', 'Validação', MB_OK);
    if edtNatureza.CanFocus then
      edtNatureza.SetFocus;
  end
  else
  if Trim(edtDocumento.Text) = '' then
  begin
    Application.MessageBox('O código do documento da pessoa é obrigatório!', 'Validação', MB_OK);
    if edtDocumento.CanFocus then
      edtDocumento.SetFocus;
  end
  else
  if Trim(edtPrimeiroNome.Text) = '' then
  begin
    Application.MessageBox('O primeiro nome da pessoa é obrigatório!', 'Validação', MB_OK);
    if edtPrimeiroNome.CanFocus then
      edtPrimeiroNome.SetFocus;
  end
  else
  if Trim(edtSobrenome.Text) = '' then
  begin
    Application.MessageBox('O sobrenome da pessoa é obrigatório!', 'Validação', MB_OK);
    if edtSobrenome.CanFocus then
      edtSobrenome.SetFocus;
  end
  else
  if Trim(edtCEP.Text) = '' then
  begin
    Application.MessageBox('O CEP do endereço é obrigatório!', 'Validação', MB_OK);
    if edtCEP.CanFocus then
      edtCEP.SetFocus;
  end
  else
    Result := True;
end;

procedure TForm2.btnPutClick(Sender: TObject);
var
  sPessoa, sEndereco: String;
begin
  if not InformacoesValidasParaPut then
    Exit;

  sPessoa := ObterJsonPessoa;
  sEndereco := ObterJsonEndereco(StrToInt(edtCodigoPessoa.Text));
  EfetuarPut(sPessoa, sEndereco);
end;

procedure TForm2.btnAtualizarEnderecosClick(Sender: TObject);
begin
  FFuncaoExecutarThread :=
    TjrThreadAnimacao.CriaEInicia(
      procedure
      begin
        if DataSourceEndereco.DataSet.IsEmpty then
          btnGetPessoa.Click;

        dbgridEndereco.DataSource.DataSet.DisableControls;
        try
          dbgridEndereco.DataSource.DataSet.First;
          while not dbgridEndereco.DataSource.DataSet.Eof do
          begin
            DMClientDatasnap.AtualizarEnderecoPorCep(dbgridEndereco.DataSource.DataSet.FieldByName('dscep').AsString,
              dbgridEndereco.DataSource.DataSet.FieldByName('idendereco').AsInteger);
            dbgridEndereco.DataSource.DataSet.Next;
          end;
        finally
          dbgridEndereco.DataSource.DataSet.First;
          dbgridEndereco.DataSource.DataSet.EnableControls;
        end;
      end,
      pnlWait { Parent },
      True { AExibeAnimacao },
      OnTerminoThreadFuncaoExecutarEvento { OnTermino });
end;

function TForm2.EfetuarPut(const JsonPessoa, JsonEndereco: String): String;
begin
  mmResult.Lines.Add(DMClientDatasnap.EnviarRequestPUT(JsonPessoa, 'tpessoa/pessoa/-1'));
  mmResult.Lines.Add('');
  mmResult.Lines.Add(DMClientDatasnap.EnviarRequestPUT(JsonEndereco, 'tendereco/endereco/-1'));
end;

function TForm2.EfetuarPost(const JsonPessoa, JsonEndereco: String; const CodPes, CodEnd: Integer): String;
begin
  mmResult.Lines.Add(DMClientDatasnap.EnviarRequestPOST(JsonPessoa, 'tpessoa/pessoa', '/' + IntToStr(CodPes)));
  mmResult.Lines.Add('');
  mmResult.Lines.Add(DMClientDatasnap.EnviarRequestPOST(JsonEndereco, 'tendereco/endereco', '/' + IntToStr(CodEnd)));
end;

function TForm2.ObterJsonEndereco(const IdPessoa: Integer): String;
var
  oEndereco: TEndereco;
begin
  oEndereco := TEndereco.Create;
  try
    oEndereco.IdEndereco := StrToInt(edtIdEndereco.Text);
    oEndereco.IdPessoa := IdPessoa;
    oEndereco.DsCEP := edtCEP.Text;
    Result := oEndereco.ToJson;
  finally
    oEndereco.Free;
  end;
end;

function TForm2.ObterJsonPessoa: String;
var
  oPessoa: TPessoa;
begin
  oPessoa := TPessoa.Create;
  try
    oPessoa.IdPessoa := StrToInt(edtCodigoPessoa.Text);
    oPessoa.FlNatureza := StrToInt(edtNatureza.Text);
    oPessoa.DsDocumento := edtDocumento.Text;
    oPessoa.NmNome := edtPrimeiroNome.Text;
    oPessoa.SobreNome := edtSobrenome.Text;
    Result := oPessoa.ToJson;
  finally
    oPessoa.Free;
  end;
end;

procedure TForm2.OnTerminoThreadFuncaoExecutarEvento(Sender: TObject);
begin
  FFuncaoExecutarThread := nil;
  FFuncaoExecutarErroThread := IfThen(Sender is TjrThreadAnimacao, TjrThreadAnimacao(Sender).Erro, '');

  FFuncaoFecharSucesso := FFuncaoExecutarErroThread = '';

  TjrThread.EnfilerarExecucao(
    procedure
    begin
      if (FFuncaoExecutarErroThread <> '') then
        raise Exception.Create(FFuncaoExecutarErroThread);
    end);
end;

end.
