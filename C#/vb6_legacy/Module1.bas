Attribute VB_Name = "Module1"
' ============================================================
' Module1.bas
' Modulo global - ficava tudo que era compartilhado entre Forms
' Era o "conexao.php" do VB6: variaveis globais e funcoes uteis
'
' VB6 foi lancado em 1998 e ficou em producao em MUITA empresa
' ate 2010, 2015... alguns sistemas rodam ate hoje.
' Microsoft parou o suporte em 2008 mas o povo nao ligou.
' ============================================================
Option Explicit
' Option Explicit obrigava declarar todas as variaveis
' Sem isso, digitava "Dim Nmoe" em vez de "Dim Nome" e nao dava erro
' Muita gente nao usava e passava horas caçando bug de digitacao

' Variavel global da conexao - acessivel em qualquer Form
' Era assim: uma conexao aberta pra sempre enquanto o programa rodava
Public gConexao As ADODB.Connection

' Constantes de conexao - hard-coded mesmo, nao tinha .env na epoca
' O connection string era o maior copia-e-cola da internet em 2000
Public Const CONN_STRING As String = _
    "Provider=SQLOLEDB;" & _
    "Data Source=localhost;" & _
    "Initial Catalog=AgendaDB;" & _
    "User ID=sa;" & _
    "Password=;"
' "sa" sem senha era PADRAO em SQL Server 2000 instalado no modo rapido
' Segurança? Que segurança? Era rede local, ninguem se preocupava

' ============================================================
' AbrirConexao - chama no Form_Load do MDIForm principal
' ============================================================
Public Sub AbrirConexao()
    Set gConexao = New ADODB.Connection
    
    gConexao.ConnectionString = CONN_STRING
    gConexao.CursorLocation = adUseClient  ' cursor no cliente, nao no servidor
    
    On Error GoTo ErrConexao
    gConexao.Open
    
    MsgBox "Conectado ao banco com sucesso!", vbInformation, "Sistema Agenda"
    Exit Sub

ErrConexao:
    ' On Error GoTo era o try/catch do VB6
    ' Nao tinha Try/Catch - isso so veio no VB.NET
    MsgBox "ERRO ao conectar: " & Err.Description, vbCritical, "Erro de Conexao"
    End  ' End encerrava o programa inteiro - era o exit(1) do VB6
End Sub

' ============================================================
' FecharConexao - chama no Form_Unload do MDIForm
' ============================================================
Public Sub FecharConexao()
    If Not gConexao Is Nothing Then
        If gConexao.State = adStateOpen Then
            gConexao.Close
        End If
        Set gConexao = Nothing  ' libera memoria - sem isso vaza
    End If
End Sub

' ============================================================
' MsgErro - padrao pra mostrar erro, era repetido em todo projeto
' ============================================================
Public Sub MsgErro(ByVal sErro As String)
    MsgBox sErro, vbCritical, "Erro"
End Sub

' ============================================================
' LimparTexto - Remove espacos e retorna "" se for nulo
' Funcao utilitaria que todo VB6 do mundo tinha
' ============================================================
Public Function LimparTexto(ByVal sTexto As String) As String
    LimparTexto = Trim(sTexto)
End Function

' ============================================================
' EhNumero - valida se string e numero, sem IsNumeric builtin seguro
' IsNumeric("+") retorna True no VB6 - bug classico!
' ============================================================
Public Function EhNumero(ByVal sValor As String) As Boolean
    Dim i As Integer
    EhNumero = True
    If Len(sValor) = 0 Then
        EhNumero = False
        Exit Function
    End If
    For i = 1 To Len(sValor)
        If InStr("0123456789", Mid(sValor, i, 1)) = 0 Then
            EhNumero = False
            Exit Function
        End If
    Next i
End Function
