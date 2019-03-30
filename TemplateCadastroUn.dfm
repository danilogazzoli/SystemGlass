object CadastroTemplateFormUn: TCadastroTemplateFormUn
  Left = 0
  Top = 0
  Caption = 'Template de Cadastro'
  ClientHeight = 434
  ClientWidth = 608
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pgcCadastro: TPageControl
    Left = 0
    Top = 0
    Width = 608
    Height = 434
    ActivePage = Cadastro
    Align = alClient
    TabOrder = 0
    object Cadastro: TTabSheet
      Caption = 'Cadastro'
      object CadastroGroupBox: TGroupBox
        Left = 0
        Top = 0
        Width = 600
        Height = 406
        Align = alClient
        TabOrder = 0
        object GroupBox1: TGroupBox
          Left = 2
          Top = 355
          Width = 596
          Height = 49
          Align = alBottom
          TabOrder = 0
          DesignSize = (
            596
            49)
          object NovoButton: TButton
            Left = 20
            Top = 13
            Width = 75
            Height = 25
            Action = NovoAction
            TabOrder = 0
          end
          object SalvarButton: TButton
            Left = 182
            Top = 13
            Width = 75
            Height = 25
            Action = SalvarAction
            TabOrder = 2
          end
          object SairButton: TButton
            Left = 508
            Top = 13
            Width = 75
            Height = 25
            Action = SairAction
            Anchors = [akLeft, akTop, akRight]
            TabOrder = 4
          end
          object CancelarButton: TButton
            Left = 101
            Top = 13
            Width = 75
            Height = 25
            Action = CancelarAction
            TabOrder = 1
          end
          object ExcluirButton: TButton
            Left = 264
            Top = 13
            Width = 75
            Height = 25
            Action = ExcluirAction
            TabOrder = 3
          end
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Pesquisa'
      ImageIndex = 1
      object PesquisaEdit: TComboBox
        Left = 6
        Top = 10
        Width = 83
        Height = 21
        Style = csDropDownList
        ItemIndex = 0
        TabOrder = 0
        Text = 'ID'
        Items.Strings = (
          'ID')
      end
      object CodigoEdit: TMaskEdit
        Left = 95
        Top = 10
        Width = 488
        Height = 21
        TabOrder = 1
        Text = ''
      end
      object lbxPesquisa: TListBox
        Left = 6
        Top = 43
        Width = 577
        Height = 310
        ItemHeight = 13
        TabOrder = 2
        OnDblClick = lbxPesquisaDblClick
      end
    end
  end
  object CadastroActionList: TActionList
    Left = 528
    Top = 32
    object NovoAction: TAction
      Caption = '&Novo'
      OnExecute = NovoActionExecute
    end
    object CancelarAction: TAction
      Caption = '&Cancelar'
    end
    object SalvarAction: TAction
      Caption = '&Salvar'
    end
    object EditarAction: TAction
      Caption = '&Editar'
    end
    object ExcluirAction: TAction
      Caption = '&Excluir'
    end
    object PesquisarAction: TAction
      Caption = '&Pesquisar'
    end
    object SairAction: TAction
      Caption = 'Sai&r'
      OnExecute = SairActionExecute
    end
  end
end
