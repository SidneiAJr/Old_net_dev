unit UnitFuncionario;

{ ============================================================
  UnitFuncionario.pas  -  Tela Principal
  Sistema de Agenda de Funcionarios
  Delphi 7  +  IBX (InterBase Express)  +  Firebird 1.5
  ============================================================
  Componentes visuais no Form (DFM):
    IBDatabase1    - conexao com o .fdb
    IBTransaction1 - transacao padrao
    IBQuery1       - query principal de FUNCIONARIO
    IBQuery2       - query p/ combo de DEPARTAMENTO
    DataSource1    - liga IBQuery1 ao DBGrid
    DBGrid1        - grade principal
    DBEdit1..5     - campos do cadastro
    DBComboBox1    - combo de departamento (via IBQuery2)
    BitBtn1 Novo / BitBtn2 Gravar / BitBtn3 Excluir / BitBtn4 Cancelar
    BitBtn5 Buscar / Edit1 (campo de busca)
    Label1..6      - rotulos
    GroupBox1      - agrupa os campos
    StatusBar1     - rodape com mensagens

  Nao tem MDI nao - era o estilo "form modal por cima"
  da epoca: OpenDialog, ShowModal, ModalResult.
  ============================================================ }

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IBDatabase, IBQuery, DB, DBCtrls, Grids, DBGrids, StdCtrls,
  Buttons, ComCtrls, ExtCtrls;

type
  TfrmFuncionario = class(TForm)
    IBDatabase1:    TIBDatabase;
    IBTransaction1: TIBTransaction;
    IBQuery1:       TIBQuery;       { SELECT * FROM FUNCIONARIO }
    IBQuery2:       TIBQuery;       { SELECT p/ combo departamento }
    DataSource1:    TDataSource;
    DataSource2:    TDataSource;
    DBGrid1:        TDBGrid;

    { Campos do cadastro }
    grpCadastro:  TGroupBox;
    Label1: TLabel;  Label2: TLabel;  Label3: TLabel;
    Label4: TLabel;  Label5: TLabel;  Label6: TLabel;
    edtNome:      TDBEdit;
    edtCargo:     TDBEdit;
    edtSalario:   TDBEdit;
    edtAdmissao:  TDBEdit;
    cbDepto:      TDBLookupComboBox;  { lookup direto no Firebird }

    { Botoes }
    btnNovo:     TBitBtn;
    btnGravar:   TBitBtn;
    btnExcluir:  TBitBtn;
    btnCancelar: TBitBtn;
    btnBuscar:   TBitBtn;
    edtBusca:    TEdit;
    lblBusca:    TLabel;

    StatusBar1: TStatusBar;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);

    procedure btnNovoClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnBuscarClick(Sender: TObject);
    procedure edtBuscaKeyPress(Sender: TObject; var Key: Char);

    procedure DBGrid1DblClick(Sender: TObject);

  private
    procedure AbrirBanco;
    procedure CarregarGrid;
    procedure HabilitarBotoes(aEditando: Boolean);
    procedure Mensagem(const aTxt: string);
  public
    { nada publico aqui - encapsulamento da epoca }
  end;

var
  frmFuncionario: TfrmFuncionario;

implementation

uses UnitDepto;   { Tela de Departamentos, abre modal }

{$R *.dfm}

{ ---- FormCreate: conecta o banco e carrega tudo ---- }
procedure TfrmFuncionario.FormCreate(Sender: TObject);
begin
  AbrirBanco;
  CarregarGrid;
  HabilitarBotoes(False);
  Mensagem('Sistema iniciado. ' + DateToStr(Now));
end;

procedure TfrmFuncionario.FormDestroy(Sender: TObject);
begin
  { IBX cuida do disconnect, mas por via das duvidas }
  if IBDatabase1.Connected then
    IBDatabase1.Disconnect;
end;

{ ---- Conexao: arquivo .fdb na pasta do exe ---- }
procedure TfrmFuncionario.AbrirBanco;
begin
  IBDatabase1.DatabaseName := ExtractFilePath(Application.ExeName) + 'agenda.fdb';
  IBDatabase1.LoginPrompt   := False;
  IBDatabase1.Params.Clear;
  IBDatabase1.Params.Add('user_name=SYSDBA');
  IBDatabase1.Params.Add('password=masterkey');
  IBDatabase1.Params.Add('lc_ctype=WIN1252');   { charset da epoca no Brasil }

  try
    IBDatabase1.Connected := True;
    IBTransaction1.StartTransaction;
  except
    on E: Exception do
    begin
      ShowMessage('Erro ao conectar: ' + E.Message +
                  #13#10 + 'Verifique se agenda.fdb existe na pasta.');
      Application.Terminate;
    end;
  end;

  { Query de departamento pra alimentar o DBLookupComboBox }
  IBQuery2.SQL.Text := 'SELECT ID_DEPTO, NOME FROM DEPARTAMENTO ORDER BY NOME';
  IBQuery2.Open;
end;

{ ---- Carrega a grade com todos os funcionarios ---- }
procedure TfrmFuncionario.CarregarGrid;
begin
  IBQuery1.Close;
  IBQuery1.SQL.Text :=
    'SELECT F.ID_FUNC, F.NOME, F.CARGO, F.SALARIO, ' +
    '       F.DT_ADMISSAO, D.NOME AS DEPTO '          +
    'FROM   FUNCIONARIO F '                            +
    'LEFT JOIN DEPARTAMENTO D ON D.ID_DEPTO = F.ID_DEPTO ' +
    'ORDER BY F.NOME';
  IBQuery1.Open;
  Mensagem('Total: ' + IntToStr(IBQuery1.RecordCount) + ' funcionario(s).');
end;

{ ---- NOVO: coloca o dataset em modo Insert ---- }
procedure TfrmFuncionario.btnNovoClick(Sender: TObject);
begin
  IBQuery1.Insert;
  HabilitarBotoes(True);
  edtNome.SetFocus;
  Mensagem('Novo registro. Preencha e clique em Gravar.');
end;

{ ---- GRAVAR: Post + Commit ---- }
procedure TfrmFuncionario.btnGravarClick(Sender: TObject);
begin
  if Trim(IBQuery1.FieldByName('NOME').AsString) = '' then
  begin
    ShowMessage('Nome e obrigatorio!');
    edtNome.SetFocus;
    Exit;
  end;

  try
    IBQuery1.Post;
    IBTransaction1.Commit;
    IBTransaction1.StartTransaction;   { Firebird exige nova transacao apos commit }
    HabilitarBotoes(False);
    CarregarGrid;
    Mensagem('Registro gravado com sucesso.');
  except
    on E: Exception do
    begin
      IBTransaction1.Rollback;
      IBTransaction1.StartTransaction;
      ShowMessage('Erro ao gravar: ' + E.Message);
    end;
  end;
end;

{ ---- EXCLUIR: confirmacao + Delete + Commit ---- }
procedure TfrmFuncionario.btnExcluirClick(Sender: TObject);
var
  sNome: string;
begin
  if IBQuery1.IsEmpty then Exit;

  sNome := IBQuery1.FieldByName('NOME').AsString;

  if MessageDlg('Excluir "' + sNome + '"?',
                mtConfirmation, [mbYes, mbNo], 0) <> mrYes then Exit;

  try
    IBQuery1.Delete;
    IBTransaction1.Commit;
    IBTransaction1.StartTransaction;
    CarregarGrid;
    Mensagem('Registro excluido.');
  except
    on E: Exception do
    begin
      IBTransaction1.Rollback;
      IBTransaction1.StartTransaction;
      ShowMessage('Erro ao excluir: ' + E.Message);
    end;
  end;
end;

{ ---- CANCELAR: cancela o Insert/Edit ---- }
procedure TfrmFuncionario.btnCancelarClick(Sender: TObject);
begin
  if IBQuery1.State in [dsInsert, dsEdit] then
    IBQuery1.Cancel;
  HabilitarBotoes(False);
  Mensagem('Operacao cancelada.');
end;

{ ---- BUSCAR por nome (LIKE) ---- }
procedure TfrmFuncionario.btnBuscarClick(Sender: TObject);
var
  sBusca: string;
begin
  sBusca := Trim(edtBusca.Text);
  IBQuery1.Close;

  if sBusca = '' then
  begin
    { sem filtro: traz tudo }
    IBQuery1.SQL.Text :=
      'SELECT F.ID_FUNC, F.NOME, F.CARGO, F.SALARIO, '    +
      '       F.DT_ADMISSAO, D.NOME AS DEPTO '             +
      'FROM   FUNCIONARIO F '                              +
      'LEFT JOIN DEPARTAMENTO D ON D.ID_DEPTO = F.ID_DEPTO ' +
      'ORDER BY F.NOME';
  end
  else
  begin
    { LIKE com parametro - o jeito IBX da epoca }
    IBQuery1.SQL.Text :=
      'SELECT F.ID_FUNC, F.NOME, F.CARGO, F.SALARIO, '    +
      '       F.DT_ADMISSAO, D.NOME AS DEPTO '             +
      'FROM   FUNCIONARIO F '                              +
      'LEFT JOIN DEPARTAMENTO D ON D.ID_DEPTO = F.ID_DEPTO ' +
      'WHERE  UPPER(F.NOME) LIKE :PBUSCA '                 +
      'ORDER BY F.NOME';
    IBQuery1.ParamByName('PBUSCA').AsString :=
      '%' + UpperCase(sBusca) + '%';
  end;

  IBQuery1.Open;
  Mensagem('Encontrado(s): ' + IntToStr(IBQuery1.RecordCount) + ' registro(s).');
end;

{ Enter no campo de busca dispara a pesquisa }
procedure TfrmFuncionario.edtBuscaKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    btnBuscarClick(Sender);
  end;
end;

{ Duplo clique na grade: abre tela de departamento da linha selecionada }
procedure TfrmFuncionario.DBGrid1DblClick(Sender: TObject);
begin
  { Aqui poderia abrir detalhes - por ora so mostra mensagem }
  if not IBQuery1.IsEmpty then
    Mensagem('Funcionario selecionado: ' + IBQuery1.FieldByName('NOME').AsString);
end;

{ ---- Liga/desliga botoes conforme estado ---- }
procedure TfrmFuncionario.HabilitarBotoes(aEditando: Boolean);
begin
  btnNovo.Enabled     := not aEditando;
  btnExcluir.Enabled  := not aEditando;
  btnBuscar.Enabled   := not aEditando;
  btnGravar.Enabled   := aEditando;
  btnCancelar.Enabled := aEditando;

  { campos so editaveis quando inserindo/editando }
  edtNome.ReadOnly     := not aEditando;
  edtCargo.ReadOnly    := not aEditando;
  edtSalario.ReadOnly  := not aEditando;
  edtAdmissao.ReadOnly := not aEditando;
  cbDepto.Enabled      := aEditando;
end;

{ ---- Escreve no StatusBar (rodape) ---- }
procedure TfrmFuncionario.Mensagem(const aTxt: string);
begin
  StatusBar1.Panels[0].Text := aTxt;
end;

end.
