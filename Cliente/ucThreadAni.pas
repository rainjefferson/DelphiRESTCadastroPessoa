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

    ///   Fun��o que cria o objeto de anima��o e o exibe dentro da thread principal
    procedure CriaAnimacao;

    ///   Fun��o que atrav�s da thread principal finaliza a visualiza��o da anima��o de espera
    procedure FinalizaAnimacao;

    ///   Fun��o que dispara o evento de erro que ocorreu
    procedure DisparaEventoErro;
  protected
    { Protected declarations }	

    ///   Propriedade que indica a necessidade de exibir uma anima��o de espera enquanto a fun��o an�nima � executada
    property ExibeAnimacao: Boolean read FExibeAnimacao;

    procedure Execute; override;
  public
    { Public declarations }	

    ///   Propriedade que guarda a mensagem de erro caso algum tenha ocorrido durante a execu��o
    property Erro: String read FErro;

    ///   Propriedade que cont�m o evento disparado quando uma exce��o ocorre para quem chamou poder trat�-la
    /// </summary>
    property OnErro: TNotifyEvent read FOnErro write FOnErro;

    constructor Create(AProc: TProc; AParent: TWinControl; const AIniciar: Boolean; const AExibeAnimacao: Boolean); overload; virtual;
    constructor Create(AProc: TProc; AParent: TWinControl; const AIniciar: Boolean; const AExibeAnimacao: Boolean;
      AOnTermino: TNotifyEvent; AThreadCicloVida: IjrThreadCicloVida = nil); overload; virtual;

    ///   Fun��o de classe que cria uma inst�ncia da thread, atribui seu evento de t�rmino e j� a inicia em seguida

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
