unit MainFormUn;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.UITypes, Vcl.Menus;

type
  TMainForm = class(TForm)
    MainMenu: TMainMenu;
    Arquivo1: TMenuItem;
    Vendas1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure Vendas1Click(Sender: TObject);
  private
    procedure CriarForm(const aClasseForm: String);
    procedure HandleApplicationExceptions(Sender: TObject; E: Exception);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses PersistenciaUn, VendaUn;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  self.WindowState := wsMaximized;
  Application.OnException := HandleApplicationExceptions;
  ReportMemoryLeaksOnShutdown := (DebugHook <> 0);
 (*
  FDQuery1.Connection := TSystemConnection.getInstance;
  FDQuery1.SQL.Add('SELECT * FROM dbo.genero');
  FDQuery1.Open;

  FDQuery1.Insert;
  FDQuery1.FieldByName('descricao').AsString := 'XXX';
  FDQuery1.CachedUpdates := True;
  FDQuery1.Post;
  FDQuery1.ApplyUpdates(0);
  }
  //_F := TITemVenda.Create(Self, TSystemConnection.getInstance);
  _F := TSystemQuery.Create(Self, TSystemConnection.getInstance);
  try
    _F.NomeTabela := 'itens_da_Venda';
    _F.GetNextId;
    _F.PKFieldName := 'idvenda;idlivro';
    _F.LoadByID(VarArrayOf([-1,-1]));
  finally
    _F.Free;
  end;
  *)
end;


procedure TMainForm.CriarForm(const aClasseForm : String);
var
  _Classe : TFormClass;
  _Form : TForm;
begin
  _Classe := TFormClass(FindClass(aClasseForm));
  _Form := _Classe.Create(nil);
  try
    _Form.ShowModal;
  finally
    FreeAndNil(_Form);
  end;
end;

procedure TMainForm.HandleApplicationExceptions(Sender: TObject; E: Exception);
begin
   MessageDlg('Houve um erro: ' + E.Message, mtWarning, [mbOk],0 )
end;


procedure TMainForm.Vendas1Click(Sender: TObject);
begin
  Self.CriarForm('TPedidoVendaFrm');
end;

end.
