program Livraria;

uses
  Vcl.Forms,
  MainFormUn in 'MainFormUn.pas' {MainForm},
  PersistenciaUn in 'PersistenciaUn.pas',
  GeneroUn in 'GeneroUn.pas',
  LivroUn in 'LivroUn.pas',
  ClienteUn in 'ClienteUn.pas',
  AutorUn in 'AutorUn.pas',
  VendaUn in 'VendaUn.pas',
  VendaFrmUn in 'VendaFrmUn.pas' {PedidoVendaFrm},
  VendaControllerUn in 'VendaControllerUn.pas',
  TemplateCadastroUn in 'TemplateCadastroUn.pas' {CadastroTemplateFormUn};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TCadastroTemplateFormUn, CadastroTemplateFormUn);
  Application.Run;
end.
