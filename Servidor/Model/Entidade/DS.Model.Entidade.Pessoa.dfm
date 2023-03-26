object ModelEntidadePessoa: TModelEntidadePessoa
  OldCreateOrder = True
  Height = 200
  Width = 268
  object FDQuery1: TFDQuery
    CachedUpdates = True
    Connection = DMConexaoFiredac.FDConnection
    SQL.Strings = (
      'select * from pessoa')
    Left = 100
    Top = 70
  end
  object FDQuery2: TFDQuery
    Connection = DMConexaoFiredac.FDConnection
    Left = 184
    Top = 72
  end
end
