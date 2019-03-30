unit GeneroUn;

interface

uses PersistenciaUn, Classes;

type
  TGenero = class(TSystemQuery)
  private
    function GetDescricao: string;
    procedure SetDescricao(const Value: string);
  public
    constructor Create(AOwner: TComponent; aSystemConnection: TSystemConnection); override;
    property Descricao: string read GetDescricao write SetDescricao;
  end;

implementation

{ TGenero }

constructor TGenero.Create(AOwner: TComponent;
  aSystemConnection: TSystemConnection);
begin
  Self.NomeTabela := 'Genero';
  Self.PKFieldName := 'IdGenero';
  inherited;

end;

function TGenero.GetDescricao: string;
begin
  Result := Self.FieldByName('Descricao').asString;
end;

procedure TGenero.SetDescricao(const Value: string);
begin
  Self.SetFieldValueAsString('Descricao', Value);
end;

end.
