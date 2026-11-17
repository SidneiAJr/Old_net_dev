<%@ Language="VBScript" %>
<!-- #include file="includes/verifica_sessao.asp" -->
<!-- #include file="includes/conexao.asp" -->
<%
Dim iCod
iCod = CInt(Request.QueryString("cod"))
' NOTA HISTORICA: CInt() convertia pra inteiro — era a protecao minima contra SQL Injection
' que a maioria dos devs da epoca conhecia. Se o campo era numerico, CInt() primeiro.
' Se desse erro, a pagina quebrava — mas pelo menos nao injetava SQL.
' Para strings nao havia CStr() equivalente seguro — era vulneravel ponto final.

If iCod > 0 Then
    On Error Resume Next
    oConn.Execute "DELETE FROM eventos WHERE id=" & iCod
    If Err.Number <> 0 Then
        Response.Write "Erro ao excluir: " & Err.Description & " "
    Else
        Response.Write "Evento excluido com sucesso! "
    End If
    On Error GoTo 0
Else
    Response.Write "Codigo invalido! "
End If

oConn.Close
Set oConn = Nothing
%>
<a href="lista_eventos.asp" style="color:#c084fc;">Voltar</a>
