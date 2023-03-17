object DMClientDatasnap: TDMClientDatasnap
  OldCreateOrder = False
  Height = 398
  Width = 761
  object RESTClientPessoa: TRESTClient
    Accept = 'application/json, text/plain; q=0.9, text/html;q=0.8,'
    AcceptCharset = 'UTF-8, *;q=0.8'
    BaseURL = 'http://localhost:8081/datasnap/rest/tpessoa/pessoa'
    Params = <>
    HandleRedirects = True
    Left = 88
    Top = 32
  end
  object RESTRequestPessoa: TRESTRequest
    Client = RESTClientPessoa
    Params = <
      item
        Kind = pkREQUESTBODY
        name = 'body'
        Options = [poDoNotEncode]
        ContentType = ctAPPLICATION_JSON
      end>
    Response = RESTResponsePessoa
    SynchronizedEvents = False
    Left = 88
    Top = 96
  end
  object RESTResponsePessoa: TRESTResponse
    Left = 88
    Top = 152
  end
  object RESTResponseDataSetAdapterPessoa: TRESTResponseDataSetAdapter
    Dataset = FDMemTablePessoa
    FieldDefs = <>
    Response = RESTResponsePessoa
    Left = 88
    Top = 224
  end
  object FDMemTablePessoa: TFDMemTable
    FieldDefs = <>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    StoreDefs = True
    Left = 88
    Top = 288
  end
  object RESTClientEndereco: TRESTClient
    Accept = 'application/json, text/plain; q=0.9, text/html;q=0.8,'
    AcceptCharset = 'UTF-8, *;q=0.8'
    BaseURL = 'http://localhost:8081/datasnap/rest/tendereco/endereco'
    Params = <>
    HandleRedirects = True
    Left = 296
    Top = 40
  end
  object RESTRequestEndereco: TRESTRequest
    Client = RESTClientEndereco
    Params = <
      item
        Kind = pkREQUESTBODY
        name = 'body'
        Options = [poDoNotEncode]
        ContentType = ctAPPLICATION_JSON
      end>
    Response = RESTResponseEndereco
    SynchronizedEvents = False
    Left = 296
    Top = 112
  end
  object RESTResponseEndereco: TRESTResponse
    ContentType = 'text/html'
    Left = 296
    Top = 176
  end
  object RESTResponseDataSetAdapterEndereco: TRESTResponseDataSetAdapter
    Dataset = FDMemTableEndereco
    FieldDefs = <>
    Response = RESTResponseEndereco
    Left = 296
    Top = 248
  end
  object FDMemTableEndereco: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 304
    Top = 320
  end
  object RESTClientViaCep: TRESTClient
    Accept = 'application/json, text/plain; q=0.9, text/html;q=0.8,'
    AcceptCharset = 'UTF-8, *;q=0.8'
    BaseURL = 'http://viacep.com.br/ws/81830220/json'
    Params = <>
    HandleRedirects = True
    RaiseExceptionOn500 = False
    Left = 584
    Top = 16
  end
  object RESTRequestViaCep: TRESTRequest
    Client = RESTClientViaCep
    Params = <>
    Response = RESTResponseViaCep
    SynchronizedEvents = False
    Left = 584
    Top = 72
  end
  object RESTResponseViaCep: TRESTResponse
    ContentType = 'application/json'
    Left = 584
    Top = 136
  end
end
