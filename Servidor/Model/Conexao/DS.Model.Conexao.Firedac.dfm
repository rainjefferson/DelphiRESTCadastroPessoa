object DMConexaoFiredac: TDMConexaoFiredac
  OldCreateOrder = False
  Height = 235
  Width = 345
  object FDConnection: TFDConnection
    Params.Strings = (
      'Database=pessoa'
      'User_Name=postgres'
      'Password=postgres10'
      'Server=localhost'
      'DriverID=PG')
    LoginPrompt = False
    BeforeConnect = FDConnectionBeforeConnect
    Left = 80
    Top = 56
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 216
    Top = 56
  end
  object FDPhysPgDriverLink1: TFDPhysPgDriverLink
    Left = 72
    Top = 136
  end
  object FDTransaction: TFDTransaction
    Connection = FDConnection
    Left = 216
    Top = 136
  end
end
