unit ucThreadAni;

interface

uses
  System.Classes, System.SysUtils, Vcl.StdCtrls, Vcl.WinXCtrls, Vcl.Controls,
  uiThread;

type
  TjrThreadAnimacao = class(TThread)
  private
    { Private declarations }
    FProc: TProc;
    FParent: TWinControl;
    FaniProcura: TActivityIndicator;
    FExibeAnimacao: Boolean;
    FErro: String;
    FOnErro: TNotifyEvent;
    FThreadCicloVida: IjrThreadCicloVida;

    ///   Função que cria o objeto de animação e o exibe dentro da thread principal
    procedure CriaAnimacao;

    ///   Função que através da thread principal finaliza a visualização da animação de espera
    procedure FinalizaAnimacao;

    ///   Função que dispara o evento de erro que ocorreu
    procedure DisparaEventoErro;
  protected
    { Protected declarations }	

    ///   Propriedade que indica a necessidade de exibir uma animação de espera enquanto a função anônima é executada
    property ExibeAnimacao: Boolean read FExibeAnimacao;

    procedure Execute; override;
  public
    { Public declarations }	

    ///   Propriedade que guarda a mensagem de erro caso algum tenha ocorrido durante a execução
    property Erro: String read FErro;

    ///   Propriedade que contém o evento disparado quando uma exceção ocorre para quem chamou poder tratá-la
    /// </summary>
    property OnErro: TNotifyEvent read FOnErro write FOnErro;

    constructor Create(AProc: TProc; AParent: TWinControl; const AIniciar: Boolean; const AExibeAnimacao: Boolean); overload; virtual;
    constructor Create(AProc: TProc; AParent: TWinControl; const AIniciar: Boolean; const AExibeAnimacao: Boolean;
      AOnTermino: TNotifyEvent; AThreadCicloVida: IjrThreadCicloVida = nil); overload; virtual;

    ///   Função de classe que cria uma instância da thread, atribui seu evento de término e já a inicia em seguida

    class function CriaEInicia(
      AProc: TProc;
      AParent: TWinControl;
      const AExibeAnimacao: Boolean;
      AOnTerminoThread: TNotifyEvent;
      const AIniciar: Boolean = True;
      AThreadCicloVida: IjrThreadCicloVida = nil): TjrThreadAnimacao;
  end;

implementation

{ TjrThreadAnimacao }

constructor TjrThreadAnimacao.Create(
  AProc: TProc;
  AParent: TWinControl;
  const AIniciar: Boolean;
  const AExibeAnimacao: Boolean);
begin
  FProc := AProc;
  FParent := AParent;
  FExibeAnimacao := AExibeAnimacao;
  FaniProcura := nil;
  FreeOnTerminate := True;
  inherited Create(not AIniciar);
end;

constructor TjrThreadAnimacao.Create(
  AProc: TProc;
  AParent: TWinControl;
  const AIniciar: Boolean;
  const AExibeAnimacao: Boolean;
  AOnTermino: TNotifyEvent;
  AThreadCicloVida: IjrThreadCicloVida = nil);
begin
  FProc := AProc;
  FParent := AParent;
  FExibeAnimacao := AExibeAnimacao;
  FaniProcura := nil;
  OnTerminate := AOnTermino;
  FThreadCicloVida := AThreadCicloVida;
  FreeOnTerminate := True;
  inherited Create(not AIniciar);
end;

procedure TjrThreadAnimacao.CriaAnimacao;
begin
  if FaniProcura = nil then
    FaniProcura := TActivityIndicator.Create(nil);

  FaniProcura.Parent := FParent;
  FaniProcura.Align := alClient;
  FaniProcura.Visible := True;
  FaniProcura.Enabled := True;
  FaniProcura.IndicatorSize := aisXLarge;
  FaniProcura.IndicatorType := aitSectorRing;
  FaniProcura.Animate := True;
end;

procedure TjrThreadAnimacao.FinalizaAnimacao;
begin
  FaniProcura.Enabled := False;
  FaniProcura.Visible := False;
  FaniProcura.Animate := False;
  FaniProcura.DisposeOf;
end;

procedure TjrThreadAnimacao.DisparaEventoErro;
begin
  if Assigned(FOnErro) then
    FOnErro(Self);
end;

procedure TjrThreadAnimacao.Execute;
begin
  FErro := '';
  try
    try
      if ExibeAnimacao then
        Synchronize(CriaAnimacao);

      if Assigned(FThreadCicloVida) then
        FThreadCicloVida.Inicio;
      try
        if Assigned(FProc) then
          FProc;
      finally
        if Assigned(FThreadCicloVida) then
          FThreadCicloVida.Termino;
      end;
    except
      On E: Exception do
      begin
        FErro := E.Message;
        Synchronize(DisparaEventoErro);
      end;
    end;
  finally
    if ExibeAnimacao then
      Synchronize(FinalizaAnimacao);
  end;
end;

class function TjrThreadAnimacao.CriaEInicia(
  AProc: TProc;
  AParent: TWinControl;
  const AExibeAnimacao: Boolean;
  AOnTerminoThread: TNotifyEvent;
  const AIniciar: Boolean = True;
  AThreadCicloVida: IjrThreadCicloVida = nil): TjrThreadAnimacao;
begin
  result := TjrThreadAnimacao.Create(
    AProc,
    AParent,
    AIniciar,
    AExibeAnimacao,
    AOnTerminoThread,
    AThreadCicloVida);
end;

end.
