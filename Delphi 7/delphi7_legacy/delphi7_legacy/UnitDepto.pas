unit UnitDepto;

{ ============================================================
  UnitDepto.pas  -  Tela de Departamentos  (abre MODAL)
  Delphi 7  +  IBX  +  Firebird 1.5
  ============================================================
  Componentes no Form:
    IBQuery3    - SELECT * FROM DEPARTAMENTO
    DataSource3 - liga IBQuery3 ao DBGrid2
    DBGrid2     - grade de departamentos
    DBEdit6     - campo Nome
    DBEdit7     - campo Ramal
    BitBtn6 Novo / BitBtn7 Gravar / BitBtn8 Excluir
    BitBtn9 Fechar  (ModalResult = mrOk)
    Label7, Label8
    GroupBox2
  ============================================================ }

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IBDatabase, IBQuery, DB, DBCtrls, Grids, DBGrids, StdCtrls,
  Buttons, ComCtrls, ExtCtrls;

type
  TfrmDepto = class(TForm)
    { Reutiliza IBDatabase e IBTransaction do form principal via propriedade }
    IBQuery3:   TIBQuery;
    DataSource3: TDataSource;
    DBGrid2:    TDBGrid;

    grpDepto:   TGroupBox;
    Label7:     TLabel;    { Nome: }
    Label8:     TLabel;    { Ramal: }
    edtDeptoNome:  TDBEdit;
    edtDeptoRamal: TDBEdit;

    btnDNovo:    TBitBtn;
    btnDGravar:  TBitBtn;
    btnDExcluir: TBitBtn;
    btnDFechar:  TBitBtn;   { ModalResult := mrOk }

    StatusBar2: TStatusBar;

    procedure FormCreate(Sender: TObject);
    procedure btnDNovoClick(Sender: TObject);
    procedure btnDGravarClick(Sender: TObject);
    procedure btnDExcluirClick(Sender: TObject);
    procedure btnDFecharClick(Sender: TObject);
    procedure DBGrid2DblClick(Sender: TObject);

  private
    FDB:  TIBDatabase;     { recebe referencia do form pai }
    FTrn: TIBTransaction;
    procedure CarregarDeptos;
    procedure HabBotoes(aEdit: Boolean);
    procedure Msg(const s: string);
  public
    { Propriedades pra receber o banco do form pai }
    property Banco:     TIBDatabase    write FDB;
    property Transacao: TIBTransaction write FTrn;
  end;

{ Como chamar do form principal:
    var fDepto: TfrmDepto;
    fDepto := TfrmDepto.Create(Self);
    try
      fDepto.Banco     := IBDatabase1;
      fDepto.Transacao := IBTransaction1;
      fDepto.ShowModal;   // bloqueia ate fechar
    finally
      fDepto.Free;
    end;
  Assim o form filho compartilha a mesma conexao - padrao da epoca.
}

var
  frmDepto: TfrmDepto;

implementation

{$R *.dfm}

procedure TfrmDepto.FormCreate(Sender: TObject);
begin
  { IBQuery3 usa o banco passado pelo form pai }
  if Assigned(FDB) then
  begin
    IBQuery3.Database    := FDB;
    IBQuery3.Transaction := FTrn;
    CarregarDeptos;
    HabBotoes(False);
    Msg('Departamentos carregados.');
  end
  else
    ShowMessage('ERRO: banco nao informado pelo form pai!');
end;

procedure TfrmDepto.CarregarDeptos;
begin
  IBQuery3.Close;
  IBQuery3.SQL.Text := 'SELECT ID_DEPTO, NOME, RAMAL FROM DEPARTAMENTO ORDER BY NOME';
  IBQuery3.Open;
  Msg('Total: ' + IntToStr(IBQuery3.RecordCount) + ' departamento(s).');
end;

procedure TfrmDepto.btnDNovoClick(Sender: TObject);
begin
  IBQuery3.Insert;
  HabBotoes(True);
  edtDeptoNome.SetFocus;
end;

procedure TfrmDepto.btnDGravarClick(Sender: TObject);
begin
  if Trim(IBQuery3.FieldByName('NOME').AsString) = '' then
  begin
    ShowMessage('Nome do departamento e obrigatorio!');
    edtDeptoNome.SetFocus;
    Exit;
  end;

  try
    IBQuery3.Post;
    FTrn.Commit;
    FTrn.StartTransaction;
    HabBotoes(False);
    CarregarDeptos;
    Msg('Departamento gravado.');
  except
    on E: Exception do
    begin
      FTrn.Rollback;
      FTrn.StartTransaction;
      ShowMessage('Erro ao gravar departamento: ' + E.Message);
    end;
  end;
end;

procedure TfrmDepto.btnDExcluirClick(Sender: TObject);
var
  sNome: string;
begin
  if IBQuery3.IsEmpty then Exit;
  sNome := IBQuery3.FieldByName('NOME').AsString;

  if MessageDlg('Excluir departamento "' + sNome + '"?' + #13#10 +
                'Funcionarios vinculados ficarao sem departamento.',
                mtWarning, [mbYes, mbNo], 0) <> mrYes then Exit;
  try
    IBQuery3.Delete;
    FTrn.Commit;
    FTrn.StartTransaction;
    CarregarDeptos;
    Msg('Departamento excluido.');
  except
    on E: Exception do
    begin
      FTrn.Rollback;
      FTrn.StartTransaction;
      ShowMessage('Erro ao excluir: ' + E.Message);
    end;
  end;
end;

procedure TfrmDepto.btnDFecharClick(Sender: TObject);
begin
  { Cancela qualquer edicao pendente antes de fechar }
  if IBQuery3.State in [dsInsert, dsEdit] then
    IBQuery3.Cancel;
  ModalResult := mrOk;   { libera o ShowModal do form pai }
end;

{ Clique duplo na grade: coloca em modo Edit }
procedure TfrmDepto.DBGrid2DblClick(Sender: TObject);
begin
  if not IBQuery3.IsEmpty then
  begin
    IBQuery3.Edit;
    HabBotoes(True);
    edtDeptoNome.SetFocus;
  end;
end;

procedure TfrmDepto.HabBotoes(aEdit: Boolean);
begin
  btnDNovo.Enabled    := not aEdit;
  btnDExcluir.Enabled := not aEdit;
  btnDFechar.Enabled  := not aEdit;
  btnDGravar.Enabled  := aEdit;
  edtDeptoNome.ReadOnly  := not aEdit;
  edtDeptoRamal.ReadOnly := not aEdit;
end;

procedure TfrmDepto.Msg(const s: string);
begin
  StatusBar2.Panels[0].Text := s;
end;

end.
