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

    ///   Função que recebe uma função e um tempo de espera. Após atingir este tempo
    ///  a sua execução é colocado na fila para ser executada na thread principal
    class procedure EnfilerarExecucao(
      const AThreadProc: TProc;
      const Espera: Integer = 10);

    ///   Função que coloca em uma fila por TTask a criação de uma exceção. Se a mensagem
    ///  contiver a tag de aviso então o título não é exibido (e a tag é removido)
    class procedure EnfilerarExecucaoRaise(
      const Levantar: Boolean;
      const Titulo: String;
      const Mensagem: String); overload;

    ///   Função que coloca em uma fila por TTask a criação de uma exceção. Se a mensagem
    ///  contiver a tag de aviso então o título não é exibido (e a tag é removido)
    class procedure EnfilerarExecucaoRaise(
      const Levantar: Boolean;
      const Mensagem: String); overload;

    ///   Função que verifica se a threa passada é valida e se for tenta finalizá-la
    class procedure ParaExecucao(var AThread: TThread);
  end;

  ///   Classe que implementa as definições para controlar o ciclo de vida de uma lista de threads
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

    ///   Propriedade que contém o número de thread que estão em execução
    property Count: Integer read GetCount;

    constructor Create; virtual;
    destructor Destroy; override;

    ///   Função que adiciona uma thread ao contador de thread
    procedure Inicio;

    ///   Função que sinaliza que uma thread foi finalizada vida controlada
    procedure Termino;

    ///   Função que aguarda todas as threads serem finalizadas
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

