program ClientDatasnap;

uses
  Vcl.Forms,
  ClientDatasnap.Pessoa in 'ClientDatasnap.Pessoa.pas' {Form2},
  DM.ClientDatasnap in 'DM.ClientDatasnap.pas' {DMClientDatasnap: TDataModule},
  uPessoa in 'uPessoa.pas',
  uEndereco in 'uEndereco.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TDMClientDatasnap, DMClientDatasnap);
  Application.Run;
end.
