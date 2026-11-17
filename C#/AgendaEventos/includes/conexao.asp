<%
' ============================================================
' includes/conexao.asp
' ============================================================
' NOTA HISTORICA:
' Em ASP Classico nao existia PDO, nao existia mysqli.
' A tecnologia de acesso a banco era o ADO (ActiveX Data Objects).
' ADO era um componente COM do Windows — voce criava um objeto,
' abria conexao, executava SQL, iterava o Recordset, fechava tudo na mao.
' O equivalente moderno seria algo como new PDO() ou SqlConnection no C#.
'
' Connection string ficava hardcoded aqui ou no global.asa.
' Nao existia conceito de "injetar dependencia de banco".
' Todo arquivo que precisava do banco fazia #include deste arquivo.
' ============================================================

Dim oConn
Set oConn = Server.CreateObject("ADODB.Connection")

' NOTA: Application("ConnString") vem do global.asa
' Se global.asa nao existir, fallback direto:
Dim sConn
If Application("ConnString") <> "" Then
    sConn = Application("ConnString")
Else
    sConn = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & Server.MapPath("../banco/eventos.mdb")
End If

oConn.Open sConn

' NOTA HISTORICA: nao tinha try/catch em VBScript.
' O tratamento de erro era com "On Error Resume Next" —
' o codigo continuava mesmo com erro, e voce checava Err.Number depois.
' Era o On Error GoTo do VB6 mas ainda pior.
' Aqui estamos abrindo sem tratamento, igual 90% do codigo da epoca.
%>
