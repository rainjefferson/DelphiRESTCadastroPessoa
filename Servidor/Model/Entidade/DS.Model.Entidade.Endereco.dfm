object ModelEntidadeEndereco: TModelEntidadeEndereco
  OldCreateOrder = False
  Height = 150
  Width = 250
  object FDQuery1: TFDQuery
    CachedUpdates = True
    Connection = DMConexaoFiredac.FDConnection
    SQL.Strings = (
      'select * from endereco')
    Left = 72
    Top = 56
  end
  object FDQuery2: TFDQuery
    Connection = DMConexaoFiredac.FDConnection
    Left = 152
    Top = 56
  end
end
