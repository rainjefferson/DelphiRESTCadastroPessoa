unit uiThread;

interface

uses
  System.Classes;

type  
  ///   Interface que define a estrutura para um controlador de ciclo de vida das threads
  IjrThreadCicloVida = interface(IInterface)
    ['{77EC0664-FA78-4B55-A685-2AB4F5513D2E}']

    function GetCount: Integer;

    ///   Fun��o que adiciona uma thread ao contador de thread
    procedure Inicio;

    ///   Fun��o que sinaliza que uma thread foi finalizada vida controlada
    procedure Termino;

    ///   Fun��o que aguarda todas as threads serem finalizadas
    procedure Wait; overload;


    ///   Propriedade que cont�m o n�mero de thread que est�o em execu��o
    property Count: Integer read GetCount;
  end;

implementation

end.

