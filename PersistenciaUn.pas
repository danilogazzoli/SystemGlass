unit PersistenciaUn;

interface

uses FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MSSQL,
  FireDAC.Phys.MSSQLDef, FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, Datasnap.DBClient, Datasnap.Provider,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, SysUtils, System.Classes,
  StrUtils, System.Types, System.Variants;

type
  TSystemConnection = class(TFDConnection)
  private
  public
    class function getInstance: TSystemConnection;
  end;

  TSystemQuery = class(TFDQuery)
  private
    FNomeTabela: string;
    FPKFieldName: string;
    procedure setPKFieldName(const Value: string);
    procedure CheckEditDataSet;
    function GetId: integer;
    procedure SetId(const Value: integer);
    const
      cSQL = 'SELECT * FROM dbo.% WHERE %s =:%s';
      cSQLFK = 'SELECT * FROM %s WHERE %s = %s';
  protected
    procedure SetTableName(const Value: string);
    procedure SetFieldValueAsBoolean(const aFieldName: string; const aValue: boolean);
    procedure SetFieldValueAsCurrency(const aFieldName: string;
      const aValue: currency);
    procedure SetFieldValueAsInteger(const aFieldName: string; const aValue: integer);
    procedure SetFieldValueAsString(const aFieldName: string; const aValue: string);
    procedure SetFieldValueAsDateTime(const aFieldName: string; const aValue: TDateTime);
    function GetInitialLoad: Variant; virtual;
  public
    constructor Create(AOwner: TComponent; aSystemConnection: TSystemConnection); reintroduce; virtual;
    property NomeTabela: string read FNomeTabela write SetTableName;
    property PKFieldName: string read FPKFieldName write setPKFieldName;
    function LoadByID(const aID: Variant): boolean; virtual;
    function LoadByFK(const aFKID: integer; aFKName: string): boolean; virtual;
    function GetNextId: integer;
    property ID: integer read GetId write SetId;
  end;

implementation

var
  SystemConnection : TSystemConnection;

{ TSystemConnection }

class function TSystemConnection.getInstance: TSystemConnection;
begin
  if SystemConnection = nil then
  begin
    SystemConnection := TSystemConnection.Create(nil);
    SystemConnection.Params.Add('DriverID=MSSQL');
    SystemConnection.Params.Add('Address=192.168.1.79');
    SystemConnection.Params.Add('Database=TestePadrao');
    SystemConnection.Params.Add('Password=sgsi2018as');
    SystemConnection.Params.Add('User_Name=desenv');
    SystemConnection.LoginPrompt := False;
    SystemConnection.Connected := True;
  end;
  Result := SystemConnection;
end;

{ TSystemQuery }

constructor TSystemQuery.Create(AOwner: TComponent;
  aSystemConnection: TSystemConnection);
begin
  inherited Create(AOwner);
  Self.Connection := aSystemConnection;
  Self.CachedUpdates := True;
  Self.LoadByID(Self.GetInitialLoad);
end;

function TSystemQuery.GetId: integer;
begin
  Result := Self.FieldByName(Self.FPKFieldName).AsInteger;
end;

function TSystemQuery.GetInitialLoad: Variant;
begin
  Result := -1;
end;

function TSystemQuery.GetNextId: integer;
var
 _NextID: TSystemQuery;
begin
  Result := 0;
  _NextID := TSystemQuery.Create(Self, TSystemConnection(Self.Connection));
  try
    _NextID.SQL.Add('SELECT NEXT VALUE FOR GEN_'+Self.FNomeTabela + ' AS NextID');
    _NextID.Open;
    if _NextID.Active then
      Result := _NextID.FieldByName('NextId').AsInteger;
  finally
    _NextID.Free;
  end;
end;

function TSystemQuery.LoadByFK(const aFKID: integer; aFKName: string): boolean;
begin
  Self.Close;
  Self.SQL.Clear;
  Self.SQL.Text := 'SELECT * FROM dbo.' + Self.FNomeTabela + ' WHERE ' + aFKName + ' = :' + aFKName;
  // Format(cSQL, [Self.FNomeTabela, Self.FPKFieldName, Self.FPKFieldName]);
  Self.Params.ParamByName(Self.FPKFieldName).AsInteger := aFKID;
  Self.Open;
  Result := (Self.Active) and (not Self.IsEmpty);
end;

function TSystemQuery.LoadByID(const aID: Variant): boolean;
var
  _Aux: TStringDynArray;
  _i: integer;
begin
  _Aux := StrUtils.SplitString(Self.FPKFieldName, ';');
  if Length(_Aux) = 0 then
  begin
    Result := False;
    Exit;
  end;

  Self.Close;
  Self.SQL.Clear;
  Self.SQL.Text := 'SELECT * FROM dbo.' + Self.FNomeTabela + ' WHERE ';
  for _i := low(_Aux) to High(_Aux) do
  begin
    if _i > 0 then
      Self.SQL.Add(' and ');
    if VarIsArray(AID) then
      Self.SQL.Add(_Aux[_i] + ' = ' + VarToStr(VarArrayGet(aID,[_i])))
    else
      Self.SQL.Add(_Aux[_i] + ' = ' + VarToStr(aId));
  end;
  //+ Self.FPKFieldName + ' = :' + Self.FPKFieldName;
  // Format(cSQL, [Self.FNomeTabela, Self.FPKFieldName, Self.FPKFieldName]);
  {if VarIsArray(AID) then
  begin
    for _i := VarArrayLowBound(aID, 1) to VarArrayHighBound(aID, 1) do
      Self.Params.ParamByName(_Aux[_i]).AsInteger := VarArrayGet(aID,[_i]);
  end
  else
    Self.Params.ParamByName(Self.FPKFieldName).AsInteger := aID;}
  Self.Open;
  Result := (Self.Active) and (not Self.IsEmpty);
end;

procedure TSystemQuery.setPKFieldName(const Value: string);
begin
  FPKFieldName := Value;
end;

procedure TSystemQuery.SetTableName(const Value: string);
begin
  FNomeTabela := Value;
end;


procedure TSystemQuery.SetFieldValueAsBoolean(const aFieldName: string;
  const aValue: boolean);
begin
  Self.CheckEditDataSet;
  Self.FieldByName(aFieldName).asBoolean := aValue;
end;

procedure TSystemQuery.SetFieldValueAsCurrency(const aFieldName: string;
  const aValue: currency);
begin
  Self.CheckEditDataSet;
  Self.FieldByName(aFieldName).asCurrency := aValue;
end;

procedure TSystemQuery.SetFieldValueAsDateTime(const aFieldName: string;
  const aValue: TDateTime);
begin
  Self.CheckEditDataSet;
  Self.FieldByName(aFieldName).AsDateTime := aValue;
end;

procedure TSystemQuery.SetFieldValueAsInteger(const aFieldName: string;
  const aValue: integer);
begin
  Self.CheckEditDataSet;
  Self.FieldByName(aFieldName).asInteger := aValue;
end;

procedure TSystemQuery.SetFieldValueAsString(const aFieldName: string;
  const aValue: string);
begin
  Self.CheckEditDataSet;
  Self.FieldByName(aFieldName).AsString := aValue;
end;

procedure TSystemQuery.SetId(const Value: integer);
begin
  Self.CheckEditDataSet;
  Self.FieldByName(Self.FPKFieldName).AsInteger := Value;
end;

procedure TSystemQuery.CheckEditDataSet;
begin
  if not (Self.State in dsEditModes) then
    Self.Edit;
end;


initialization
  SystemConnection := nil;

finalization
  FreeAndNil(SystemConnection);
end.
