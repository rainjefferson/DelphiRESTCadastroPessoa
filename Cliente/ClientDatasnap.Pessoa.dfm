object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'Cadastro Pessoa - DatasnapRESTFul (Vers'#227'o 1.0.4)'
  ClientHeight = 613
  ClientWidth = 889
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 889
    Height = 613
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 796
    object TabSheet1: TTabSheet
      Caption = 'Exerc'#237'cio 3'
      ExplicitLeft = 8
      ExplicitTop = 28
      object Label9: TLabel
        Left = 8
        Top = 8
        Width = 51
        Height = 16
        Caption = 'Pessoa:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label10: TLabel
        Left = 575
        Top = 8
        Width = 65
        Height = 16
        Caption = 'Endere'#231'o:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label12: TLabel
        Left = 3
        Top = 413
        Width = 29
        Height = 13
        Caption = 'Insert'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 16744448
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object Label13: TLabel
        Left = 84
        Top = 413
        Width = 35
        Height = 13
        Caption = 'Update'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clTeal
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object Label14: TLabel
        Left = 168
        Top = 415
        Width = 31
        Height = 13
        Caption = 'Excluir'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object dbgrigPessoa: TDBGrid
        Left = 3
        Top = 30
        Width = 566
        Height = 153
        DataSource = DataSourcePessoa
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        Columns = <
          item
            Expanded = False
            FieldName = 'idpessoa'
            Width = 60
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'flnatureza'
            Width = 60
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'dsdocumento'
            Width = 70
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'nmprimeiro'
            Width = 119
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'nmsegundo'
            Width = 139
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'dtregistro'
            Width = 80
            Visible = True
          end>
      end
      object dbgridEndereco: TDBGrid
        Left = 575
        Top = 30
        Width = 302
        Height = 153
        DataSource = DataSourceEndereco
        TabOrder = 1
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        Columns = <
          item
            Expanded = False
            FieldName = 'idendereco'
            Width = 80
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'idpessoa'
            Width = 80
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'dscep'
            Width = 103
            Visible = True
          end>
      end
      object btnGetPessoa: TButton
        Left = 3
        Top = 189
        Width = 75
        Height = 25
        Caption = 'Get'
        TabOrder = 2
        OnClick = btnGetPessoaClick
      end
      object GroupBox1: TGroupBox
        Left = 3
        Top = 220
        Width = 875
        Height = 154
        TabOrder = 3
        object Label1: TLabel
          Left = 264
          Top = 27
          Width = 72
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Natureza:'
        end
        object Label2: TLabel
          Left = 412
          Top = 27
          Width = 72
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Documento:'
        end
        object Label3: TLabel
          Left = 88
          Top = 52
          Width = 72
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Primero Nome:'
        end
        object Label4: TLabel
          Left = 352
          Top = 54
          Width = 72
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Sobrenome:'
        end
        object Label5: TLabel
          Left = 3
          Top = 76
          Width = 65
          Height = 16
          Caption = 'Endere'#231'o:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = [fsBold, fsItalic]
          ParentFont = False
        end
        object Label6: TLabel
          Left = 88
          Top = 25
          Width = 72
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'C'#243'digo:'
        end
        object Label7: TLabel
          Left = 89
          Top = 98
          Width = 72
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'C'#243'digo:'
        end
        object Label8: TLabel
          Left = 89
          Top = 125
          Width = 72
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'CEP:'
        end
        object Label11: TLabel
          Left = 3
          Top = 3
          Width = 51
          Height = 16
          Caption = 'Pessoa:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = [fsBold, fsItalic]
          ParentFont = False
        end
        object edtNatureza: TEdit
          Left = 349
          Top = 22
          Width = 57
          Height = 21
          NumbersOnly = True
          TabOrder = 0
          Text = '1'
        end
        object edtDocumento: TEdit
          Left = 490
          Top = 24
          Width = 121
          Height = 21
          TabOrder = 1
        end
        object edtPrimeiroNome: TEdit
          Left = 173
          Top = 49
          Width = 174
          Height = 21
          TabOrder = 2
        end
        object edtSobrenome: TEdit
          Left = 437
          Top = 51
          Width = 174
          Height = 21
          TabOrder = 3
        end
        object edtCodigoPessoa: TEdit
          Left = 173
          Top = 22
          Width = 57
          Height = 21
          NumbersOnly = True
          TabOrder = 4
          Text = '1'
        end
        object edtIdEndereco: TEdit
          Left = 174
          Top = 95
          Width = 57
          Height = 21
          NumbersOnly = True
          TabOrder = 5
          Text = '1'
        end
        object edtCEP: TEdit
          Left = 174
          Top = 122
          Width = 121
          Height = 21
          TabOrder = 6
        end
        object pnlWait: TPanel
          Left = 656
          Top = 78
          Width = 102
          Height = 73
          BevelOuter = bvNone
          TabOrder = 7
        end
      end
      object btnPut: TButton
        Left = 3
        Top = 388
        Width = 75
        Height = 25
        Caption = 'Put '
        TabOrder = 4
        OnClick = btnPutClick
      end
      object btnPost: TButton
        Left = 84
        Top = 388
        Width = 75
        Height = 25
        Caption = 'Post'
        TabOrder = 5
        OnClick = btnPostClick
      end
      object btnDelete: TButton
        Left = 165
        Top = 388
        Width = 75
        Height = 25
        Caption = 'Delete'
        TabOrder = 6
        OnClick = btnDeleteClick
      end
      object mmResult: TMemo
        Left = 3
        Top = 459
        Width = 875
        Height = 123
        ScrollBars = ssVertical
        TabOrder = 7
      end
      object btnAtualizarEnderecos: TButton
        Left = 589
        Top = 388
        Width = 289
        Height = 25
        Caption = 'Exerc'#237'cio 4 - Atualizar Endere'#231'os - ViaCep.com.br'
        TabOrder = 8
        OnClick = btnAtualizarEnderecosClick
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Exerc'#237'cio 3 - Lote'
      ImageIndex = 1
      ExplicitWidth = 788
      object mmListaPessoas: TMemo
        Left = 3
        Top = 0
        Width = 779
        Height = 462
        Lines.Strings = (
          '['
          '{'
          '    "idpessoa":1,'
          '    "flnatureza":1,'
          '    "dsdocumento":"123123",'
          '    "nmprimeiro":"WK",'
          '    "nmsegundo":"Technology",'
          '    "dtregistro":"2023-03-14",'
          '    "dscep": "81830220"'
          '},'
          '{'
          '    "idpessoa":2,'
          '    "flnatureza":1,'
          '    "dsdocumento":"123123",'
          '    "nmprimeiro":"WK",'
          '    "nmsegundo":"Technology",'
          '    "dtregistro":"2023-03-14",    '
          '    "dscep": "81830220"'
          '},'
          '{'
          '    "idpessoa":3,'
          '    "flnatureza":1,'
          '    "dsdocumento":"123123",'
          '    "nmprimeiro":"WK",'
          '    "nmsegundo":"Technology",'
          '    "dtregistro":"2023-03-14",'
          '    "dtregistro":"2023-03-14",'
          '    "dscep": "81830220"'
          '},'
          '{'
          '    "idpessoa":4,'
          '    "flnatureza":1,'
          '    "dsdocumento":"123123",'
          '    "nmprimeiro":"WK",'
          '    "nmsegundo":"Technology",'
          '    "dtregistro":"2023-03-14",'
          '    "dscep": "81830220"'
          '}'
          ']')
        TabOrder = 0
      end
      object btnEnviarLote: TButton
        Left = 3
        Top = 480
        Width = 110
        Height = 25
        Caption = 'Enviar Lote'
        TabOrder = 1
        OnClick = btnEnviarLoteClick
      end
    end
  end
  object DataSourcePessoa: TDataSource
    DataSet = DMClientDatasnap.FDMemTablePessoa
    Left = 640
    Top = 24
  end
  object DataSourceEndereco: TDataSource
    DataSet = DMClientDatasnap.FDMemTableEndereco
    Left = 504
    Top = 232
  end
end
