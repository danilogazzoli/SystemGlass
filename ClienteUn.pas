unit ClienteUn;

interface

uses PersistenciaUn, Classes;

type
  TCliente = class(TSystemQuery)
  private
    function GetNome: string;
    function GetTelefone: string;
  public
    constructor Create(AOwner: TComponent; aSystemConnection: TSystemConnection); override;
    property Nome: string read GetNome;
    property Telefone: string read GetTelefone;
  end;


implementation

{ TCliente }

constructor TCliente.Create(AOwner: TComponent;
  aSystemConnection: TSystemConnection);
begin
  Self.NomeTabela := 'Cliente';
  Self.PKFieldName := 'IdCliente';
  inherited;

end;

function TCliente.GetNome: string;
begin
  Result := Self.FieldByName('Nome').AsString
end;

function TCliente.GetTelefone: string;
begin
  Result := Self.FieldByName('Telefone').AsString
end;

end.
