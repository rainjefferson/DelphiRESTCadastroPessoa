object ModelEntidadeEndereco: TModelEntidadeEndereco
  OldCreateOrder = False
  Height = 150
  Width = 215
  object FDQuery1: TFDQuery
    CachedUpdates = True
    Connection = DMConexaoFiredac.FDConnection
    SQL.Strings = (
      'select * from endereco')
    Left = 72
    Top = 56
  end
end
