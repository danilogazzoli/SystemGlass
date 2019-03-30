unit LivroUn;

interface

uses PersistenciaUn, Classes, GeneroUn, SysUtils;

type
  EEstoqueNegativo = class(Exception)
  end;

  TLivro = class(TSystemQuery)
  private
    FGenero: TGenero;
    function GetEstoque: integer;
    function GeTitulo: string;
    function GetPreco: currency;
    procedure SetPreco(const Value: currency);
    procedure SetTitulo(const Value: string);
    function GetGenero: TGenero;
  public
    constructor Create(AOwner: TComponent; aSystemConnection: TSystemConnection); override;
    property Titulo: string read GeTitulo write SetTitulo;
    property Preco: currency read GetPreco write SetPreco;
    property Estoque: integer read GetEstoque;
    property Genero: TGenero read GetGenero;
    function DecrementaEstoque(const aQuantidade: integer): boolean;
  end;

implementation

{ TLivro }

constructor TLivro.Create(AOwner: TComponent;
  aSystemConnection: TSystemConnection);
begin
  Self.NomeTabela := 'Livro';
  Self.PKFieldName := 'IdLivro';
  inherited;
  Self.FGenero := TGenero.Create(AOwner, aSystemConnection);
end;

function TLivro.DecrementaEstoque(const aQuantidade: integer): boolean;
var
  _id: integer;
begin
  _id := Self.Id;
  Self.Connection.StartTransaction;
  try
    self.LoadByID(_id);
    if (Self.GetEstoque - aQuantidade < 0) then
      raise EEstoqueNegativo.Create('Estoque ficará com valor negativo.');
    Self.SetFieldValueAsInteger('Estoque', Self.GetEstoque - aQuantidade);
    Self.Post;
    Result := Self.ApplyUpdates(0) = 0;
    Self.Connection.Commit;
  except
    on E: Exception do
    begin
      Self.Connection.Rollback;
      raise;
    end;
  end;
end;

function TLivro.GetEstoque: integer;
begin
  Result := Self.FieldByName('Estoque').Asinteger;
end;

function TLivro.GetGenero: TGenero;
begin
  Self.FGenero.LoadByID(Self.FieldByName('IdGenero').AsInteger);
  Result := Self.FGenero;
end;

function TLivro.GeTitulo: string;
begin
  Result := Self.FieldByName('Titulo').asString;
end;

function TLivro.GetPreco: currency;
begin
  Result := Self.FieldByName('Preco').asCurrency;
end;

procedure TLivro.SetPreco(const Value: currency);
begin
  self.SetFieldValueAsCurrency('Preco', Value);
end;

procedure TLivro.SetTitulo(const Value: string);
begin
  self.SetFieldValueAsString('Titulo', Value);
end;

end.
