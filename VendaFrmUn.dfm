inherited PedidoVendaFrm: TPedidoVendaFrm
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Pedido de Venda'
  ClientHeight = 386
  ClientWidth = 506
  OnDestroy = FormDestroy
  OnShow = FormShow
  ExplicitWidth = 512
  ExplicitHeight = 415
  PixelsPerInch = 96
  TextHeight = 13
  inherited pgcCadastro: TPageControl
    Width = 506
    Height = 386
    ExplicitWidth = 723
    ExplicitHeight = 376
    inherited Cadastro: TTabSheet
      Caption = 'Pedido de Venda'
      ExplicitWidth = 410
      ExplicitHeight = 253
      inherited CadastroGroupBox: TGroupBox
        Width = 498
        Height = 358
        object Label7: TLabel [0]
          Left = 20
          Top = 23
          Width = 11
          Height = 13
          Caption = 'ID'
        end
        object Label1: TLabel [1]
          Left = 19
          Top = 50
          Width = 33
          Height = 13
          Caption = 'Cliente'
        end
        object Label2: TLabel [2]
          Left = 20
          Top = 77
          Width = 23
          Height = 13
          Caption = 'Data'
        end
        object Label3: TLabel [3]
          Left = 336
          Top = 77
          Width = 24
          Height = 13
          Caption = 'Total'
        end
        object Bevel1: TBevel [4]
          Left = 99
          Top = 67
          Width = 382
          Height = 50
          Shape = bsBottomLine
        end
        object Label4: TLabel [5]
          Left = 20
          Top = 106
          Width = 73
          Height = 13
          Caption = 'Itens da Venda'
        end
        object Label5: TLabel [6]
          Left = 19
          Top = 133
          Width = 23
          Height = 13
          Caption = 'Livro'
        end
        object Label6: TLabel [7]
          Left = 20
          Top = 160
          Width = 56
          Height = 13
          Caption = 'Quantidade'
        end
        inherited GroupBox1: TGroupBox
          Top = 307
          Width = 494
          inherited SairButton: TButton
            Left = 391
            Width = 88
            ExplicitLeft = 391
            ExplicitWidth = 88
          end
        end
        object ClienteEdit: TMaskEdit
          Left = 80
          Top = 47
          Width = 115
          Height = 21
          TabOrder = 2
          Text = ''
          OnExit = ClienteEditExit
        end
        object IdEdit: TMaskEdit
          Left = 80
          Top = 20
          Width = 115
          Height = 21
          Enabled = False
          TabOrder = 1
          Text = ''
        end
        object NomeClienteEdit: TMaskEdit
          Left = 201
          Top = 47
          Width = 280
          Height = 21
          Enabled = False
          TabOrder = 3
          Text = ''
        end
        object DataEdit: TDateTimePicker
          Left = 80
          Top = 74
          Width = 115
          Height = 21
          Date = 43554.595329895830000000
          Time = 43554.595329895830000000
          TabOrder = 4
        end
        object TotalEdit: TMaskEdit
          Left = 366
          Top = 74
          Width = 115
          Height = 21
          Enabled = False
          TabOrder = 5
          Text = ''
        end
        object LivroEdit: TMaskEdit
          Left = 80
          Top = 130
          Width = 115
          Height = 21
          TabOrder = 6
          Text = ''
          OnExit = LivroEditExit
        end
        object NomeLivroEdit: TMaskEdit
          Left = 201
          Top = 130
          Width = 280
          Height = 21
          Enabled = False
          TabOrder = 7
          Text = ''
        end
        object QuantidadeEdit: TMaskEdit
          Left = 80
          Top = 156
          Width = 115
          Height = 21
          TabOrder = 8
          Text = ''
        end
        object AdicionarButton: TButton
          Left = 320
          Top = 156
          Width = 75
          Height = 25
          Caption = 'Adicionar'
          TabOrder = 9
          OnClick = AdicionarButtonClick
        end
        object ExcluirLivroButton: TButton
          Left = 406
          Top = 156
          Width = 75
          Height = 25
          Caption = 'Excluir'
          TabOrder = 10
          OnClick = ExcluirLivroButtonClick
        end
        object ItensListBox: TListBox
          Left = 19
          Top = 187
          Width = 462
          Height = 99
          ItemHeight = 13
          TabOrder = 11
        end
      end
    end
    inherited TabSheet2: TTabSheet
      ExplicitWidth = 410
      ExplicitHeight = 253
      inherited CodigoEdit: TMaskEdit
        Width = 394
        ExplicitWidth = 394
      end
      inherited lbxPesquisa: TListBox
        Width = 483
        Height = 299
        ExplicitWidth = 483
        ExplicitHeight = 299
      end
    end
  end
  inherited CadastroActionList: TActionList
    Left = 448
    Top = 24
    inherited CancelarAction: TAction
      OnExecute = CancelarActionExecute
    end
    inherited SalvarAction: TAction
      OnExecute = SalvarActionExecute
    end
  end
end
