VERSION 5.00
' ============================================================
' frmLogin.frm
' Formulario de Login - VB6 puro
'
' No VB6 cada Form era um arquivo .frm que tinha:
' 1. O cabecalho VERSION 5.00
' 2. A definicao visual dos controles (que o IDE gerava)
' 3. O codigo VB embaixo
'
' Na pratica voce nao escrevia o bloco "Begin VB.Form" na mao -
' o IDE (Visual Basic 6 IDE) gerava isso arrastando controles.
' Aqui ta escrito pra documentar como ficava o arquivo.
' ============================================================

Begin VB.Form frmLogin
   Caption         =   "Login - Sistema Agenda"
   ClientHeight    =   2400
   ClientWidth     =   4200
   StartUpPosition =   2  'CenterScreen - abre no meio da tela
   
   ' Label do usuario
   Begin VB.Label lblUsuario
      Caption  =   "Usuario:"
      Height   =   252
      Left     =   240
      Top      =   360
      Width    =   1092
   End
   
   ' Caixa de texto do usuario
   Begin VB.TextBox txtUsuario
      Height   =   288
      Left     =   1440
      Top      =   336
      Width    =   2412
   End
   
   ' Label da senha
   Begin VB.Label lblSenha
      Caption  =   "Senha:"
      Height   =   252
      Left     =   240
      Top      =   840
      Width    =   1092
   End
   
   ' Caixa de senha - PasswordChar esconde o texto
   Begin VB.TextBox txtSenha
      Height        =   288
      Left          =   1440
      PasswordChar  =   "*"
      Top           =   816
      Width         =   2412
   End
   
   ' Botao OK
   Begin VB.CommandButton btnOK
      Caption  =   "&OK"       ' & coloca sublinhado no O, era o "hotkey"
      Default  =   -1  'True  ' Enter disparava esse botao
      Height   =   372
      Left     =   1200
      Top      =   1320
      Width    =   1092
   End
   
   ' Botao Cancelar
   Begin VB.CommandButton btnCancelar
      Caption  =   "&Cancelar"
      Cancel   =   -1  'True   ' Esc disparava esse botao
      Height   =   372
      Left     =   2400
      Top      =   1320
      Width    =   1092
   End
   
End

' ============================================================
' Codigo do formulario - vinha logo abaixo da definicao visual
' ============================================================
Attribute VB_Name = "frmLogin"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

' Variavel global pra saber se o login foi ok
' Era assim: variavel publica no form, acessada pelo MDIForm
Public LoginOK As Boolean

' ============================================================
' Form_Load - equivalente ao construtor
' Roda quando o formulario e criado/exibido
' ============================================================
Private Sub Form_Load()
    LoginOK = False
    txtUsuario.SetFocus  ' coloca o cursor no campo usuario
End Sub

' ============================================================
' btnOK_Click - evento de clique do botao OK
' Cada botao, cada textbox tinha seus proprios eventos
' Era o "addEventListener" do VB6, so que visual: dava duplo clique
' no controle no IDE e ele criava o Sub automaticamente
' ============================================================
Private Sub btnOK_Click()
    Dim sUsuario As String
    Dim sSenha   As String
    Dim rs       As ADODB.Recordset
    Dim sSQL     As String
    
    sUsuario = LimparTexto(txtUsuario.Text)
    sSenha   = LimparTexto(txtSenha.Text)
    
    ' Validacao basica
    If sUsuario = "" Then
        MsgBox "Digite o usuario!", vbExclamation, "Aviso"
        txtUsuario.SetFocus
        Exit Sub  ' Exit Sub = return antecipado
    End If
    
    If sSenha = "" Then
        MsgBox "Digite a senha!", vbExclamation, "Aviso"
        txtSenha.SetFocus
        Exit Sub
    End If
    
    ' Consulta no banco usando ADO (ActiveX Data Objects)
    ' ADO era a tecnologia Microsoft pra acesso a dados em VB6
    ' Antes tinha DAO, antes tinha RDO... cada versao tinha uma nova "revolucao"
    sSQL = "SELECT usu_login, usu_senha FROM tab_usuario " & _
           "WHERE usu_login = '" & sUsuario & "'"
    ' String concatenation pra montar SQL - SQL Injection na veia
    ' Em 2000 ninguem sabia o que era SQL Injection
    
    Set rs = New ADODB.Recordset
    
    On Error GoTo ErrLogin
    rs.Open sSQL, gConexao, adOpenForwardOnly, adLockReadOnly
    
    If rs.EOF Then
        ' EOF = End Of File = sem registros
        MsgBox "Usuario nao encontrado!", vbExclamation, "Login"
        txtUsuario.SetFocus
    Else
        ' Compara a senha - texto puro, sem hash, sem nada
        ' MD5 existia mas ninguem usava pra senha em sistema desktop
        If rs.Fields("usu_senha").Value = sSenha Then
            LoginOK = True
            Me.Hide  ' esconde o form de login
        Else
            MsgBox "Senha incorreta!", vbExclamation, "Login"
            txtSenha.Text = ""
            txtSenha.SetFocus
        End If
    End If
    
    rs.Close
    Set rs = Nothing
    Exit Sub

ErrLogin:
    MsgBox "Erro ao verificar login: " & Err.Description, vbCritical, "Erro"
    If Not rs Is Nothing Then
        If rs.State = adStateOpen Then rs.Close
        Set rs = Nothing
    End If
End Sub

' ============================================================
' btnCancelar_Click - fecha o programa
' ============================================================
Private Sub btnCancelar_Click()
    End  ' encerra o executavel inteiro
End Sub

' ============================================================
' txtSenha_KeyPress - detecta Enter no campo senha
' Nao tinha onKeyDown bonito - era evento por evento no controle
' ============================================================
Private Sub txtSenha_KeyPress(KeyAscii As Integer)
    If KeyAscii = 13 Then  ' 13 = Enter
        btnOK_Click        ' chama o clique do botao manualmente
        KeyAscii = 0       ' consome o evento pra nao dar bip
    End If
End Sub
