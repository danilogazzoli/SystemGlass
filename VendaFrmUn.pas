unit VendaFrmUn;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, VendaControllerUn, Vcl.ComCtrls, TemplateCadastroUn,
  System.Actions, Vcl.ActnList, Vcl.StdCtrls, Vcl.Mask, Vcl.ExtCtrls, DB;

type
  TPedidoVendaFrm = class(TCadastroTemplateFormUn)
    Label7: TLabel;
    ClienteEdit: TMaskEdit;
    IdEdit: TMaskEdit;
    NomeClienteEdit: TMaskEdit;
    Label1: TLabel;
    DataEdit: TDateTimePicker;
    Label2: TLabel;
    Label3: TLabel;
    TotalEdit: TMaskEdit;
    Bevel1: TBevel;
    Label4: TLabel;
    Label5: TLabel;
    LivroEdit: TMaskEdit;
    NomeLivroEdit: TMaskEdit;
    QuantidadeEdit: TMaskEdit;
    Label6: TLabel;
    AdicionarButton: TButton;
    ExcluirLivroButton: TButton;
    ItensListBox: TListBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure NovoActionExecute(Sender: TObject);
    procedure SalvarActionExecute(Sender: TObject);
    procedure ClienteEditExit(Sender: TObject);
    procedure LivroEditExit(Sender: TObject);
    procedure AdicionarButtonClick(Sender: TObject);
    procedure ExcluirLivroButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CancelarActionExecute(Sender: TObject);
  private
    { Private declarations }
    FController: TVendaController;
    procedure ClearItemControls;
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses PersistenciaUn;

procedure TPedidoVendaFrm.FormCreate(Sender: TObject);
begin
  inherited;
  FController := TVendaController.Create(Self, TSystemConnection.getInstance);
 // Self.FocusControl(pgcCadastro);
end;

procedure TPedidoVendaFrm.FormDestroy(Sender: TObject);
begin
  inherited;
  FreeAndNil(Self.FController);
end;

procedure TPedidoVendaFrm.FormShow(Sender: TObject);
begin
  inherited;
  NovoButton.Click;
end;

procedure TPedidoVendaFrm.LivroEditExit(Sender: TObject);
begin
  inherited;
  if Self.FController.Venda.ItensVenda.Livro.LoadByID(StrToIntDef(LivroEdit.Text, 0)) then
    NomeLivroEdit.Text := Format('%s / %8.2f', [Self.FController.Venda.ItensVenda.Livro.Titulo,Self.FController.Venda.ItensVenda.Livro.Preco])
 { else
  begin
    LivroEdit.SetFocus;
    raise Exception.Create('Livro não encontrado');
  end;}
end;

procedure TPedidoVendaFrm.NovoActionExecute(Sender: TObject);
begin
  inherited;
  Self.ClearControls;
  Self.ClearItemControls;
  if ClienteEdit.CanFocus then
    ClienteEdit.SetFocus;
  if Self.FController.Venda.State in dsEditModes then
    Self.FController.CancelEdit;
  Self.FController.Venda.Insert;
  Self.FController.Venda.ID := Self.FController.Venda.GetNextId;
  idEdit.Text := Self.FController.Venda.ID.ToString;
end;

procedure TPedidoVendaFrm.SalvarActionExecute(Sender: TObject);
begin
  inherited;
  Self.FController.Save(StrToIntDef(ClienteEdit.Text, 0), DataEdit.Date);
end;

procedure TPedidoVendaFrm.CancelarActionExecute(Sender: TObject);
begin
  inherited;
  Self.FController.CancelEdit;
  Self.ClearItemControls;
  Self.ClearControls;
end;

procedure TPedidoVendaFrm.ClearItemControls;
begin
  LivroEdit.Clear;
  NomeLivroEdit.Clear;
  QuantidadeEdit.Clear;
  LivroEdit.SetFocus;
end;

procedure TPedidoVendaFrm.AdicionarButtonClick(Sender: TObject);
begin
  inherited;
  Self.FController.Venda.InsereItem(StrToIntDef(LivroEdit.Text, 0), StrToIntDef(QuantidadeEdit.Text, 0));
  TotalEdit.Text := Format('%8.2f', [Self.FController.Venda.TotalVenda]);
  ItensListBox.AddItem(NomeLivroEdit.Text, TObject(StrToIntDef(LivroEdit.Text, 0)));
  Self.ClearItemControls;
end;

procedure TPedidoVendaFrm.ClienteEditExit(Sender: TObject);
begin
  inherited;
  if Self.FController.Venda.Cliente.LoadByID(StrToIntDef(ClienteEdit.Text, 0)) then
    NomeClienteEdit.Text := Self.FController.Venda.Cliente.Nome
  else
  begin
    NomeClienteEdit.SetFocus;
    raise Exception.Create('Cliente não encontrado');
  end;

end;

procedure TPedidoVendaFrm.ExcluirLivroButtonClick(Sender: TObject);
begin
  inherited;
  if (ItensListBox.ItemIndex >= 0) and (ItensListBox.Items.Objects[ItensListBox.ItemIndex] <> nil) then
  begin
    Self.FController.Venda.RemoveItem(Integer(ItensListBox.Items.Objects[ItensListBox.ItemIndex]));
    ItensListBox.DeleteSelected;
  end;
  Self.ClearItemControls;
end;

initialization
  RegisterClass(TPedidoVendaFrm);

finalization
  UnregisterClass(TPedidoVendaFrm);

end.
