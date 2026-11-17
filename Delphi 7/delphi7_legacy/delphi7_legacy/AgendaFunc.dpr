program AgendaFunc;

{ ============================================================
  AgendaFunc.dpr  -  Arquivo de projeto Delphi 7
  Arquivo .dpr = equivalente ao "main" do projeto
  O Delphi gerava esse arquivo automaticamente, mas
  qualquer alteracao manual era possivel aqui.
  ============================================================ }

uses
  Forms,
  UnitFuncionario in 'UnitFuncionario.pas' {frmFuncionario},
  UnitDepto       in 'UnitDepto.pas'       {frmDepto};

{$R *.res}   { inclui o icone .ico compilado }

begin
  { Application.Initialize era obrigatorio no D7 }
  Application.Initialize;

  Application.Title := 'Agenda de Funcionarios v1.0';

  { Cria o form principal }
  Application.CreateForm(TfrmFuncionario, frmFuncionario);

  { frmDepto NAO entra aqui - criado dinamicamente via Create/Free }
  { Se colocasse aqui, ia abrir dois forms na inicializacao - erro classico }

  Application.Run;
end.
