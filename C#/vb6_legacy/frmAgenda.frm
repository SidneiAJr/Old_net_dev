VERSION 5.00
' ============================================================
' frmAgenda.frm
' Formulario principal - CRUD de contatos
'
' Usava MSFlexGrid pra mostrar dados em grade - era o DataGrid
' "pobre" do VB6. O DataGrid "rico" precisava de licenca extra.
' MSFlexGrid era somente leitura, populado manualmente via codigo.
'
' A maioria dos sistemas VB6 tinha UM form grandao com tudo:
' lista, cadastro, busca. Dividir em forms era "avancado".
' ============================================================

Begin VB.Form frmAgenda
   Caption         =   "Agenda de Contatos v1.0"
   ClientHeight    =   7200
   ClientWidth     =   9600
   StartUpPosition =   2  'CenterScreen
   
   ' Frame de cadastro - GroupBox do VB6
   Begin VB.Frame fraCadastro
      Caption  =   "Dados do Contato"
      Height   =   2400
      Left     =   120
      Top      =   120
      Width    =   9360
      
      Begin VB.Label lblNome
         Caption  =   "Nome:"
         Left     =   240
         Top      =   360
         Width    =   852
      End
      Begin VB.TextBox txtNome
         Left     =   1200
         Top      =   336
         Width    =   3612
      End
      Begin VB.Label lblFone
         Caption  =   "Telefone:"
         Left     =   240
         Top      =   840
         Width    =   852
      End
      Begin VB.TextBox txtFone
         Left     =   1200
         Top      =   816
         Width    =   1812
      End
      Begin VB.Label lblEmail
         Caption  =   "E-mail:"
         Left     =   240
         Top      =   1320
         Width    =   852
      End
      Begin VB.TextBox txtEmail
         Left     =   1200
         Top      =   1296
         Width    =   3612
      End
      
      ' Botoes de acao - era comum ter uma fileira de botoes
      Begin VB.CommandButton btnNovo
         Caption  =   "&Novo"
         Left     =   5400
         Top      =   360
         Width    =   852
      End
      Begin VB.CommandButton btnSalvar
         Caption  =   "&Salvar"
         Left     =   6360
         Top      =   360
         Width    =   852
      End
      Begin VB.CommandButton btnExcluir
         Caption  =   "E&xcluir"
         Left     =   7320
         Top      =   360
         Width    =   852
      End
      Begin VB.CommandButton btnLimpar
         Caption  =   "&Limpar"
         Left     =   8280
         Top      =   360
         Width    =   852
      End
   End
   
   ' Frame de busca
   Begin VB.Frame fraBusca
      Caption  =   "Buscar"
      Height   =   720
      Left     =   120
      Top      =   2640
      Width    =   9360
      
      Begin VB.TextBox txtBusca
         Left     =   1200
         Top      =   240
         Width    =   3612
      End
      Begin VB.CommandButton btnBuscar
         Caption  =   "&Buscar"
         Left     =   5040
         Top      =   228
         Width    =   852
      End
      Begin VB.CommandButton btnListarTodos
         Caption  =   "Listar &Todos"
         Left     =   6000
         Top      =   228
         Width    =   1212
      End
   End
   
   ' MSFlexGrid - a "tabela" do VB6
   ' Precisava adicionar o componente: Projeto > Componentes >
   ' Microsoft FlexGrid Control 6.0
   Begin MSFlexGridLib.MSFlexGrid grdContatos
      Height   =   3600
      Left     =   120
      Top      =   3480
      Width    =   9360
   End
   
   ' Barra de status na parte de baixo
   Begin VB.Label lblStatus
      Alignment   =   1  'Right Justify
      Caption     =   "Pronto"
      Height      =   252
      Left        =   120
      Top         =   7080
      Width       =   9360
   End
   
End

' ============================================================
' Codigo
' ============================================================
Attribute VB_Name = "frmAgenda"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

' ID do contato selecionado na grade - pra saber o que editar/excluir
Private nIdSelecionado As Long

' ============================================================
' Form_Load
' ============================================================
Private Sub Form_Load()
    nIdSelecionado = 0
    
    ' Configura o MSFlexGrid
    With grdContatos
        .Rows = 1          ' comeca com 1 linha (cabecalho)
        .Cols = 4          ' 4 colunas
        .FixedRows = 1     ' primeira linha e cabecalho fixo
        .FixedCols = 0     ' sem colunas fixas
        
        ' Largura das colunas em twips (unidade medieval do VB6)
        ' 1 twip = 1/1440 de polegada. Alguem achou isso uma boa ideia.
        .ColWidth(0) = 600    ' ID
        .ColWidth(1) = 3000   ' Nome
        .ColWidth(2) = 1800   ' Telefone
        .ColWidth(3) = 3600   ' Email
        
        ' Cabecalhos - Row 0 e a linha de cabecalho
        .Row = 0 : .Col = 0 : .Text = "ID"
        .Row = 0 : .Col = 1 : .Text = "Nome"
        .Row = 0 : .Col = 2 : .Text = "Telefone"
        .Row = 0 : .Col = 3 : .Text = "E-mail"
    End With
    
    ' Carrega todos os contatos ao abrir
    Call CarregarContatos("")
End Sub

' ============================================================
' CarregarContatos - popula o MSFlexGrid com dados do banco
' Parametro filtro: vazio = todos, preenchido = busca por nome
' ============================================================
Private Sub CarregarContatos(ByVal sFiltro As String)
    Dim rs   As ADODB.Recordset
    Dim sSQL As String
    Dim i    As Integer
    
    ' Monta o SQL dependendo do filtro
    If sFiltro = "" Then
        sSQL = "SELECT id, nome, fone, email FROM contatos ORDER BY nome"
    Else
        ' Concatenacao direta de novo - era o padrao triste da epoca
        sSQL = "SELECT id, nome, fone, email FROM contatos " & _
               "WHERE nome LIKE '%" & sFiltro & "%' ORDER BY nome"
    End If
    
    Set rs = New ADODB.Recordset
    
    On Error GoTo ErrCarregar
    rs.Open sSQL, gConexao, adOpenForwardOnly, adLockReadOnly
    
    ' Limpa a grade mantendo o cabecalho
    grdContatos.Rows = 1
    
    ' Percorre o Recordset e popula a grade
    ' Era o while($linha = mysql_fetch_row()) do PHP, so que mais verboso
    i = 1
    Do While Not rs.EOF
        grdContatos.Rows = i + 1  ' adiciona uma linha
        
        grdContatos.Row = i
        grdContatos.Col = 0 : grdContatos.Text = CStr(rs.Fields("id").Value)
        grdContatos.Col = 1 : grdContatos.Text = rs.Fields("nome").Value
        grdContatos.Col = 2 : grdContatos.Text = rs.Fields("fone").Value & ""
        grdContatos.Col = 3 : grdContatos.Text = rs.Fields("email").Value & ""
        ' & "" converte Null pra string vazia - Null matava o programa no VB6
        ' Era bug classico: "Tipos incompativeis" quando campo era NULL
        
        i = i + 1
        rs.MoveNext  ' avanca pro proximo registro
    Loop
    
    rs.Close
    Set rs = Nothing
    
    lblStatus.Caption = i - 1 & " contato(s) encontrado(s)"
    Exit Sub

ErrCarregar:
    MsgErro "Erro ao carregar contatos: " & Err.Description
    If Not rs Is Nothing Then
        If rs.State = adStateOpen Then rs.Close
        Set rs = Nothing
    End If
End Sub

' ============================================================
' grdContatos_Click - seleciona contato ao clicar na grade
' ============================================================
Private Sub grdContatos_Click()
    Dim nLinha As Integer
    nLinha = grdContatos.Row
    
    ' Linha 0 e cabecalho, ignora
    If nLinha = 0 Then Exit Sub
    
    ' Pega o ID da coluna 0
    nIdSelecionado = CLng(grdContatos.TextMatrix(nLinha, 0))
    
    ' Preenche os campos do formulario com os dados da linha
    txtNome.Text  = grdContatos.TextMatrix(nLinha, 1)
    txtFone.Text  = grdContatos.TextMatrix(nLinha, 2)
    txtEmail.Text = grdContatos.TextMatrix(nLinha, 3)
    
    lblStatus.Caption = "Contato selecionado: " & txtNome.Text
End Sub

' ============================================================
' btnNovo_Click - limpa campos pra cadastrar novo
' ============================================================
Private Sub btnNovo_Click()
    nIdSelecionado = 0
    txtNome.Text  = ""
    txtFone.Text  = ""
    txtEmail.Text = ""
    txtNome.SetFocus
    lblStatus.Caption = "Novo contato"
End Sub

' ============================================================
' btnSalvar_Click - INSERT ou UPDATE dependendo do nIdSelecionado
' ============================================================
Private Sub btnSalvar_Click()
    Dim sNome  As String
    Dim sFone  As String
    Dim sEmail As String
    Dim sSQL   As String
    
    sNome  = LimparTexto(txtNome.Text)
    sFone  = LimparTexto(txtFone.Text)
    sEmail = LimparTexto(txtEmail.Text)
    
    If sNome = "" Then
        MsgBox "Nome obrigatorio!", vbExclamation, "Aviso"
        txtNome.SetFocus
        Exit Sub
    End If
    
    ' Escapa aspas simples duplicando - era a "sanitizacao" do VB6
    ' Replace(nome, "'", "''") - ainda nao e prepared statement mas ja e algo
    sNome  = Replace(sNome,  "'", "''")
    sFone  = Replace(sFone,  "'", "''")
    sEmail = Replace(sEmail, "'", "''")
    
    On Error GoTo ErrSalvar
    
    If nIdSelecionado = 0 Then
        ' Novo registro - INSERT
        sSQL = "INSERT INTO contatos (nome, fone, email) " & _
               "VALUES ('" & sNome & "', '" & sFone & "', '" & sEmail & "')"
        gConexao.Execute sSQL
        MsgBox "Contato salvo com sucesso!", vbInformation, "OK"
    Else
        ' Registro existente - UPDATE
        sSQL = "UPDATE contatos SET " & _
               "nome  = '" & sNome  & "', " & _
               "fone  = '" & sFone  & "', " & _
               "email = '" & sEmail & "' " & _
               "WHERE id = " & nIdSelecionado
        gConexao.Execute sSQL
        MsgBox "Contato atualizado!", vbInformation, "OK"
    End If
    
    ' Recarrega a lista
    Call CarregarContatos("")
    Call btnNovo_Click  ' limpa campos
    Exit Sub

ErrSalvar:
    MsgErro "Erro ao salvar: " & Err.Description
End Sub

' ============================================================
' btnExcluir_Click
' ============================================================
Private Sub btnExcluir_Click()
    If nIdSelecionado = 0 Then
        MsgBox "Selecione um contato na lista!", vbExclamation, "Aviso"
        Exit Sub
    End If
    
    ' MsgBox com vbYesNo - o confirm() do VB6
    Dim resposta As Integer
    resposta = MsgBox("Excluir o contato " & txtNome.Text & "?", _
                      vbYesNo + vbQuestion, "Confirmar Exclusao")
    
    If resposta = vbNo Then Exit Sub
    
    On Error GoTo ErrExcluir
    
    gConexao.Execute "DELETE FROM contatos WHERE id = " & nIdSelecionado
    MsgBox "Contato excluido!", vbInformation, "OK"
    Call CarregarContatos("")
    Call btnNovo_Click
    Exit Sub

ErrExcluir:
    MsgErro "Erro ao excluir: " & Err.Description
End Sub

' ============================================================
' btnBuscar_Click
' ============================================================
Private Sub btnBuscar_Click()
    Dim sBusca As String
    sBusca = LimparTexto(txtBusca.Text)
    If sBusca = "" Then
        MsgBox "Digite algo pra buscar!", vbExclamation, "Aviso"
        Exit Sub
    End If
    Call CarregarContatos(sBusca)
End Sub

' ============================================================
' btnListarTodos_Click
' ============================================================
Private Sub btnListarTodos_Click()
    txtBusca.Text = ""
    Call CarregarContatos("")
End Sub

' ============================================================
' txtBusca_KeyPress - busca ao pressionar Enter
' ============================================================
Private Sub txtBusca_KeyPress(KeyAscii As Integer)
    If KeyAscii = 13 Then
        btnBuscar_Click
        KeyAscii = 0
    End If
End Sub

' ============================================================
' Form_Unload - evento ao fechar o formulario
' Pergunta se quer sair - era padrao em TODO sistema VB6
' ============================================================
Private Sub Form_Unload(Cancel As Integer)
    Dim resposta As Integer
    resposta = MsgBox("Deseja sair do sistema?", vbYesNo + vbQuestion, "Sair")
    If resposta = vbNo Then
        Cancel = 1  ' cancela o fechamento
    Else
        Call FecharConexao
    End If
End Sub
