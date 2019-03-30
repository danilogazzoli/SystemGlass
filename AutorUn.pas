unit AutorUn;

interface

uses PersistenciaUn, Classes;

type
  TAutor = class(TSystemQuery)
  private
    function GetNome: string;
    function GetEmail: string;
  public
    constructor Create(AOwner: TComponent; aSystemConnection: TSystemConnection); override;
    property Nome: string read GetNome;
    property Email: string read GetEmail;
  end;


implementation

{ TCliente }

constructor TAutor.Create(AOwner: TComponent;
  aSystemConnection: TSystemConnection);
begin
  Self.NomeTabela := 'Autor';
  Self.PKFieldName := 'IdAutor';
  inherited;

end;

function TAutor.GetNome: string;
begin
  Result := Self.FieldByName('Nome').AsString
end;

function TAutor.GetEmail: string;
begin
  Result := Self.FieldByName('Email').AsString
end;


end.
