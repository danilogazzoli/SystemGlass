unit VendaControllerUn;

interface

Uses PersistenciaUn, System.Classes, SysUtils, Data.DB, VendaUn;

Type
  TVendaController = class
  private
    FVenda : TVenda;
    FConnection : TSystemConnection;
    function GetVenda: TVenda;
  public
    constructor Create(AOwner: TComponent; aSQLConnection: TSystemConnection);
    destructor Destroy; override;
    function LoadVendaByID(const aID: integer): boolean;
    property Venda: TVenda read GetVenda;
    function Save(const aIdCliente: integer; const aDataVenda: TDateTime): integer;
    procedure CancelEdit;
  end;

implementation

{ TVendaController }
constructor TVendaController.Create(AOwner: TComponent;
  aSQLConnection: TSystemConnection);
begin
  Self.FConnection := aSQLConnection;
  Self.FVenda := TVenda.Create(AOwner, Self.FConnection);
end;

destructor TVendaController.Destroy;
begin
  FreeAndNil(Self.FVenda);
  inherited;
end;

procedure TVendaController.CancelEdit;
begin
  Self.FVenda.ItensVenda.CancelUpdates;
  Self.FVenda.ItensVenda.Cancel;
  Self.FVenda.CancelUpdates;
  Self.FVenda.Cancel;

end;

function TVendaController.GetVenda: TVenda;
begin
  Result := Self.FVenda;
end;

function TVendaController.LoadVendaByID(const aID: integer): boolean;
begin
  Result := Self.FVenda.LoadByID(aID);
end;

function TVendaController.Save(const aIdCliente: integer; const aDataVenda: TDateTime): integer;
begin
  if Self.FVenda.ItensVenda.IsEmpty then
    raise Exception.Create('Não há itens nesta venda.');

  Self.FConnection.StartTransaction;
  try
    Self.FVenda.Edit;
    Self.FVenda.DataVenda := aDataVenda;
    Self.FVenda.IdCliente := aIdCliente;
    Self.FVenda.Post;
    Result := Self.FVenda.ApplyUpdates(0);
    Self.FVenda.ItensVenda.PopulateFK(Self.FVenda.ID);
    Result := Result and Self.FVenda.ItensVenda.ApplyUpdates(0);
    Self.FConnection.Commit;
  except
    on E: Exception do
    begin
      Self.FConnection.Rollback;
      raise;
    end;
  end;
end;

end.
