unit VendaUn;

interface

uses PersistenciaUn, Classes, LivroUn, ClienteUn, SysUtils, Variants;

type
  EQuantidadeInvalida = class (Exception)
  end;

  TItemVenda = class;

  TVenda = class(TSystemQuery)
  private
    FCliente: TCliente;
    FItens: TItemVenda;
    function GetDataVenda: TDateTime;
    procedure SetDataVenda(const Value: TDateTime);
    function GetCliente: TCliente;
    function GetTotalVenda: currency;
    procedure AtualizaTotalVenda;
    function GetItensVenda: TItemVenda;
    procedure SetIdCliente(const Value: integer);
    function GetIdCliente: integer;
  protected
    procedure DoBeforePost; override;
    procedure DoBeforeApplyUpdate; override;
  public
    constructor Create(AOwner: TComponent; aSystemConnection: TSystemConnection); override;
    destructor Destroy; override;
    property DataVenda: TDateTime read GetDataVenda write SetDataVenda;
    property IdCliente: integer read GetIdCliente write SetIdCliente;
    property TotalVenda: currency read GetTotalVenda;
    property Cliente: TCliente read GetCliente;
    property ItensVenda: TItemVenda read GetItensVenda;
    function LoadByID(const aID: Variant): boolean; override;
    procedure InsereItem(const aIdLivro, aQuantidade: integer);
    procedure RemoveItem(const aIdLivro: integer);
  end;

  TItemVenda = class(TSystemQuery)
  private
    FLivro: TLivro;
    function GetQuantidade: integer;
    procedure SetQuantidade(const Value: integer);
    function GetLivro: TLivro;
  protected
    function GetInitialLoad: Variant; override;
  public
    constructor Create(AOwner: TComponent; aSystemConnection: TSystemConnection); override;
    destructor Destroy; override;
    property Quantidade: integer read GetQuantidade write SetQuantidade;
    property Livro: TLivro read GetLivro;
    function LoadByIdVenda(const aIdVenda: integer): boolean;
    procedure PopulateFK(const aIdVenda: integer);
  end;

implementation

{ TVenda }

constructor TVenda.Create(AOwner: TComponent;
  aSystemConnection: TSystemConnection);
begin
  Self.NomeTabela := 'Venda';
  Self.PKFieldName := 'IdVenda';
  inherited;
  FCliente := TCliente.Create(AOwner, ASystemConnection);
  FItens := TItemVenda.Create(AOwner, ASystemConnection);
end;

destructor TVenda.Destroy;
begin
  FreeAndNil(Self.FCliente);
  FreeAndNil(Self.FItens);
  inherited;
end;

procedure TVenda.DoBeforeApplyUpdate;
begin
  inherited;
  Self.ItensVenda.First;
  while not Self.ItensVenda.Eof do
  begin
    self.FItens.Livro.LoadByID(Self.FItens.FieldByName('IdLivro').AsInteger);
    Self.FItens.Livro.DecrementaEstoque(Self.FItens.GetQuantidade*-1);
    Self.ItensVenda.Next;
  end;
end;

procedure TVenda.DoBeforePost;
begin
  inherited;
  Self.AtualizaTotalVenda;
end;

procedure TVenda.AtualizaTotalVenda;
var
  _Tot: currency;
begin
  //percorrer os itens e atualizar, antes do post
  _Tot := 0;
  Self.FItens.First;
  while not Self.FItens.Eof do
  begin
    if Self.FItens.Livro.LoadByID(Self.FItens.FieldByName('IdLivro').AsInteger) then
      _Tot := _Tot + (Self.FItens.Quantidade * Self.FItens.Livro.Preco);
    Self.FItens.Next;
  end;
  Self.SetFieldValueAsCurrency('Total', _Tot);
end;

function TVenda.GetCliente: TCliente;
begin
  Result := Self.FCliente;
  //Self.FCliente.LoadByID(Self.FieldByName('IdCliente').AsInteger)
end;

function TVenda.GetDataVenda: TDateTime;
begin
  Result := Self.FieldByName('Dt_venda').AsDateTime;
end;

function TVenda.GetIdCliente: integer;
begin
  Result := Self.FieldByName('IdCliente').AsInteger
end;

function TVenda.GetItensVenda: TItemVenda;
begin
  Result := Self.FItens;
end;

function TVenda.GetTotalVenda: currency;
begin
  Result := Self.FieldByName('Total').asCurrency;
end;

procedure TVenda.InsereItem(const aIdLivro, aQuantidade: integer);
begin
  if Self.FItens.Livro.LoadByID(aIdLivro) then
  begin
    //Self.FItens.Livro.DecrementaEstoque(aQuantidade);
    Self.FItens.Insert;
    Self.FItens.FieldByName('IdVenda').AsInteger := Self.ID;
    Self.FItens.FieldByName('IdLivro').AsInteger := aIdLivro;
    Self.FItens.Quantidade := aQuantidade;
    Self.FItens.Post;
    Self.AtualizaTotalVenda;
  end
  else
    raise Exception.Create('Livro não encontrado.');
end;

function TVenda.LoadByID(const aID: Variant): boolean;
begin
  Result := inherited;
  if Result then
  begin
    Self.FItens.LoadByIdVenda(Self.FieldByName('IdVenda').AsInteger);
    Self.FCliente.LoadByID(Self.FieldByName('IdCliente').AsInteger)
  end;
end;

procedure TVenda.RemoveItem(const aIdLivro: integer);
begin
  if Self.FItens.Locate('IdLivro', aIdLivro, []) then
  begin
    //self.FItens.Livro.LoadByID(aIdLivro);
    //Self.FItens.Livro.DecrementaEstoque(Self.FItens.GetQuantidade*-1);
    Self.FItens.Delete;
    Self.AtualizaTotalVenda;
  end
  else
    raise Exception.Create('Item não encontrado.');
end;

procedure TVenda.SetDataVenda(const Value: TDateTime);
begin
  Self.SetFieldValueAsDateTime('Dt_venda', Value);
end;

procedure TVenda.SetIdCliente(const Value: integer);
begin
  if not Self.FCliente.LoadByID(Value) then
    raise Exception.Create('Cliente inexistente.');
  Self.SetFieldValueAsInteger('IdCliente', Value);
end;

{ TItemVenda }

constructor TItemVenda.Create(AOwner: TComponent;
  aSystemConnection: TSystemConnection);
begin
  Self.NomeTabela := 'Itens_da_Venda';
  Self.PKFieldName := 'IdVenda;IdLivro';
  inherited;
  FLivro := TLivro.Create(AOwner, aSystemConnection);
end;

destructor TItemVenda.Destroy;
begin
  FreeAndNil(Self.FLivro);
  inherited;
end;

function TItemVenda.GetInitialLoad: Variant;
begin
  Result := VarArrayOf([-1,-1]);
end;

function TItemVenda.GetLivro: TLivro;
begin
  Result := Self.FLivro;
  //Self.FLivro.LoadByID(Self.FieldByName('IdLivro').AsInteger)
end;

function TItemVenda.GetQuantidade: integer;
begin
  Result := Self.FieldByName('Qtd').AsInteger
end;

function TItemVenda.LoadByIdVenda(const aIdVenda: integer): boolean;
begin
  Result := Self.LoadByFK(aIdVenda, 'IdVenda');
end;

procedure TItemVenda.PopulateFK(const aIdVenda: integer);
begin
  Self.First;
  while not Self.Eof do
  begin
    Self.SetFieldValueAsInteger('IdVenda', aIdVenda);
    Self.Post;
    Self.Next;
  end;
end;

procedure TItemVenda.SetQuantidade(const Value: integer);
begin
  if Value <= 0 then
    raise EQuantidadeInvalida.Create('Quantidade incorreta.');
  Self.SetFieldValueAsInteger('Qtd', Value);
end;

end.
