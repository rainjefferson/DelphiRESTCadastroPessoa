unit ucThread;

interface

uses
  System.Classes, System.SysUtils, System.Threading, System.Generics.Collections,
  System.SyncObjs, System.StrUtils, System.Types,
  uiThread;

type
  TjrThreadFactoryClass = class of TjrThreadFactory;
  TjrThreadFactory = class(TObject)
  public
    { public declarations }
    function Cria: TThread; virtual; abstract;
  end;

  TjrThread = class(TThread)
  private
    { private declarations }
    class var FTagAviso: String;
  public
    { public declarations }

    ///   Propriedade relativa ao texto de uma mensagem de erro a ser levantada
    ///  para identificar que o mesmo deve ser exibido como aviso
    class property TagAviso: String read FTagAviso write FTagAviso;

    ///   Fun��o que recebe uma fun��o e um tempo de espera. Ap�s atingir este tempo
    ///  a sua execu��o � colocado na fila para ser executada na thread principal
    class procedure EnfilerarExecucao(
      const AThreadProc: TProc;
      const Espera: Integer = 10);

    ///   Fun��o que coloca em uma fila por TTask a cria��o de uma exce��o. Se a mensagem
    ///  contiver a tag de aviso ent�o o t�tulo n�o � exibido (e a tag � removido)
    class procedure EnfilerarExecucaoRaise(
      const Levantar: Boolean;
      const Titulo: String;
      const Mensagem: String); overload;

    ///   Fun��o que coloca em uma fila por TTask a cria��o de uma exce��o. Se a mensagem
    ///  contiver a tag de aviso ent�o o t�tulo n�o � exibido (e a tag � removido)
    class procedure EnfilerarExecucaoRaise(
      const Levantar: Boolean;
      const Mensagem: String); overload;

    ///   Fun��o que verifica se a threa passada � valida e se for tenta finaliz�-la
    class procedure ParaExecucao(var AThread: TThread);
  end;

  ///   Classe que implementa as defini��es para controlar o ciclo de vida de uma lista de threads
  TjrThreadCicloVida = class(TInterfacedObject,
    IjrThreadCicloVida)
  private
    { private declarations }
    FLock: TCriticalSection;
    FCount: Integer;
    FEvento: TEvent;
  protected
    { protected declarations }
    function GetCount: Integer; virtual;
  public
    { public declarations }

    ///   Propriedade que cont�m o n�mero de thread que est�o em execu��o
    property Count: Integer read GetCount;

    constructor Create; virtual;
    destructor Destroy; override;

    ///   Fun��o que adiciona uma thread ao contador de thread
    procedure Inicio;

    ///   Fun��o que sinaliza que uma thread foi finalizada vida controlada
    procedure Termino;

    ///   Fun��o que aguarda todas as threads serem finalizadas
    procedure Wait;

  end;

implementation

uses
  udThread;

class procedure TjrThread.EnfilerarExecucao(
  const AThreadProc: TProc;
  const Espera: Integer = 10);
var
  aTask: ITask;
begin
  aTask := TTask.Create(
    procedure
    begin
      Sleep(Espera);
      TThread.Queue(
        nil,
        procedure
        begin
          AThreadProc;
        end);
    end);

   aTask.Start;
end;

class procedure TjrThread.EnfilerarExecucaoRaise(
  const Levantar: Boolean;
  const Titulo: String;
  const Mensagem: String);
var
  ATask: ITask;
  AMensagem: String;
begin
  if not Levantar then
    Exit;

  AMensagem :=
    IfThen(
      Pos(TagAviso, Mensagem) = 1,
        StringReplace(Mensagem, TagAviso, '', [rfIgnoreCase]),
        IfThen(
          Titulo = '',
          Mensagem,
          Titulo + LineFeed + Mensagem));

  ATask := TTask.Create(
    procedure
    begin
      TThread.Queue(
        nil,
        procedure
        begin
          raise Exception.Create(AMensagem);
        end);
    end);

   ATask.Start;
end;

class procedure TjrThread.EnfilerarExecucaoRaise(
  const Levantar: Boolean;
  const Mensagem: String);
var
  ATask: ITask;
  AMensagem: String;
begin
  if not Levantar then
    Exit;

  AMensagem :=
    IfThen(
      Pos(TagAviso, Mensagem) = 1,
        StringReplace(Mensagem, TagAviso, '', [rfIgnoreCase]),
        Mensagem);

  ATask := TTask.Create(
    procedure
    begin
      TThread.Queue(
        nil,
        procedure
        begin
          raise Exception.Create(AMensagem);
        end);
    end);

   ATask.Start;
end;

class procedure TjrThread.ParaExecucao(var AThread: TThread);
begin
  if AThread <> nil then
    AThread.Terminate;
end;

constructor TjrThreadCicloVida.Create;
begin
  FLock := TCriticalSection.Create;
  FEvento := TEvent.Create;
end;

destructor TjrThreadCicloVida.Destroy;
begin
  FEvento.DisposeOf;
  FLock.DisposeOf;
  inherited;
end;

function TjrThreadCicloVida.GetCount: Integer;
begin
  FLock.Acquire;
  try
    result := FCount;
  finally
    FLock.Release;
  end;
end;

procedure TjrThreadCicloVida.Inicio;
begin
  FLock.Acquire;
  try
    if FCount = 0 then
      FEvento.ResetEvent;

    Inc(FCount);
  finally
    FLock.Release;
  end;
end;

procedure TjrThreadCicloVida.Termino;
begin
  FLock.Acquire;
  try
    Dec(FCount);
    if FCount = 0 then
      FEvento.SetEvent;
  finally
    FLock.Release;
  end;
end;

procedure TjrThreadCicloVida.Wait;
var
  Resultado: TWaitResult;
begin
  Resultado := FEvento.WaitFor(TempoEsperaThread);
  if Resultado <> wrSignaled then
    raise Exception.Create(sErroAguardandoThread + IntToStr(Integer(Resultado)));
end;

end.

