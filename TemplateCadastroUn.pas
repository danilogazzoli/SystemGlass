unit TemplateCadastroUn;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Actions, Vcl.ActnList,
  Vcl.StdCtrls, Vcl.Mask, Vcl.ComCtrls, System.UITypes;

type
  TCadastroTemplateFormUn = class(TForm)
    pgcCadastro: TPageControl;
    Cadastro: TTabSheet;
    CadastroGroupBox: TGroupBox;
    GroupBox1: TGroupBox;
    NovoButton: TButton;
    SalvarButton: TButton;
    SairButton: TButton;
    TabSheet2: TTabSheet;
    PesquisaEdit: TComboBox;
    CodigoEdit: TMaskEdit;
    lbxPesquisa: TListBox;
    CadastroActionList: TActionList;
    NovoAction: TAction;
    SalvarAction: TAction;
    EditarAction: TAction;
    ExcluirAction: TAction;
    PesquisarAction: TAction;
    SairAction: TAction;
    CancelarButton: TButton;
    CancelarAction: TAction;
    ExcluirButton: TButton;
    procedure SairActionExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lbxPesquisaDblClick(Sender: TObject);
    procedure NovoActionExecute(Sender: TObject);
  private
    { Private declarations }
  protected
    procedure ClearControls; virtual;
    procedure PopulateControls; virtual;
  public
    { Public declarations }
  end;

var
  CadastroTemplateFormUn: TCadastroTemplateFormUn;

implementation

{$R *.dfm}

procedure TCadastroTemplateFormUn.FormCreate(Sender: TObject);
begin
  Self.pgcCadastro.ActivePageIndex := 0;
end;

procedure TCadastroTemplateFormUn.lbxPesquisaDblClick(Sender: TObject);
begin
  lbxPesquisa.Clear;
  CodigoEdit.Clear;
  pgcCadastro.ActivePageIndex := 0;
  PopulateControls;
end;

procedure TCadastroTemplateFormUn.NovoActionExecute(Sender: TObject);
begin
  Self.ClearControls;
end;

procedure TCadastroTemplateFormUn.PopulateControls;
begin
end;

procedure TCadastroTemplateFormUn.ClearControls;
var
  _i: integer;
begin
  for _i := 0 to Self.ComponentCount - 1 do
  begin
    if Self.Components[_i] is TMaskEdit then
      TMaskEdit(Self.Components[_i]).Clear
  end;
end;

procedure TCadastroTemplateFormUn.SairActionExecute(Sender: TObject);
begin
  if MessageDlg('Deseja realmente sair?', mtConfirmation, [mbYes, mbNo], 0) = MrYes then
  begin
    Close;
  end;

end;

end.