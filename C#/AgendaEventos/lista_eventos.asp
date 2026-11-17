<%@ Language="VBScript" %>
<!-- #include file="includes/verifica_sessao.asp" -->
<!-- #include file="includes/conexao.asp" -->
<%
' NOTA HISTORICA: colocar o include do conexao.asp antes do HTML era intencional —
' voce precisava do oConn disponivel durante a geracao do HTML.
' Nao existia separacao de camadas MVC. Era tudo misturado:
' busca no banco, logica de exibicao e HTML na mesma pagina.
' O primeiro framework PHP MVC (CakePHP) so veio em 2005.
' ASP.NET MVC so veio em 2009. Antes disso: spaghetti code era o padrao.

Dim sCat, sBusca, sSQL
sCat   = Request.QueryString("cat")
sBusca = Request.Form("f_busca")

If sCat <> "" Then
    sSQL = "SELECT * FROM eventos WHERE categoria='" & sCat & "' ORDER BY data_ev"
ElseIf sBusca <> "" Then
    ' NOTA HISTORICA: LIKE com % em Access funcionava igual ao MySQL.
    ' Uma das poucas coisas que era compativel entre os dois.
    sSQL = "SELECT * FROM eventos WHERE titulo LIKE '%" & sBusca & "%' ORDER BY data_ev"
Else
    sSQL = "SELECT * FROM eventos ORDER BY data_ev"
End If

Dim oRS
Set oRS = Server.CreateObject("ADODB.Recordset")
oRS.Open sSQL, oConn
' NOTA HISTORICA: oRS.Open com dois parametros usava cursor padrao (forward-only).
' Forward-only significa que voce so podia iterar pra frente — sem .MovePrevious.
' Para paginacao, a galera copiava todos os registros pra um array antes.
' Ou usava oRS.Open sSQL, oConn, 3, 3 — cursor estatico, lento mas flexivel.
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
  "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Agenda de Eventos - Listagem</title>
<style type="text/css">
body { background-color: #2b1a4a; color: #e0d0ff; font-family: Verdana, Arial, sans-serif; }
table { background-color: #3d2566; border: 2px solid #6a3fa0; }
td { padding: 8px; color: #e0d0ff; }
a { color: #c084fc; text-decoration: none; }
a:hover { text-decoration: underline; }
h2 { color: #c084fc; }
.rotulo { color: #a78bfa; font-weight: bold; width: 90px; }
input[type=text] { background: #1e0f33; color: #e0d0ff; border: 1px solid #6a3fa0; padding: 4px; }
input[type=submit] { background: #6a3fa0; color: #fff; border: none; padding: 4px 12px; cursor: pointer; }
</style>
<script type="text/javascript">
// NOTA HISTORICA: confirm() era o "modal de confirmacao" da epoca.
// Nao existia biblioteca de dialog, nao existia SweetAlert.
// Era o alert/confirm/prompt nativo do browser — feio, bloqueante, sem CSS.
// Mas funcionava em todos os browsers sem dependencia nenhuma.
function confirmaExclusao() {
    return confirm("Confirma a exclusao deste evento?");
}
</script>
</head>
<body>
<table width="620" align="center" cellpadding="6" cellspacing="0" border="1">
  <tr><td><h2>Agenda de Eventos &mdash; Listagem</h2></td></tr>
</table>
<br />
<table width="620" align="center" cellpadding="6" cellspacing="0" border="1">
  <tr><td>
    <form action="lista_eventos.asp" method="post" name="frmBusca">
      Buscar por titulo:
      <input type="text" name="f_busca" size="30" />
      <input type="submit" value="Buscar" />
    </form>
  </td></tr>
</table>
<br />
<%
If oRS.EOF Then
    Response.Write "<p align=""center"">Nenhum evento encontrado.</p>"
    ' NOTA HISTORICA: aspas duplas dentro de string VBScript eram escapadas
    ' dobrando-as: "" dentro de "" = uma aspa literal.
    ' Em PHP seria \" ou usar aspas simples. No VBScript era sempre duplo.
Else
    Do While Not oRS.EOF
        ' NOTA HISTORICA: oRS("campo") acessava por nome.
        ' oRS.Fields("campo").Value era a forma "correta" e mais lenta de escrever.
        ' A galera usava o atalho oRS("campo") em 100% dos casos.

        Dim dData
        dData = oRS("data_ev")
        ' NOTA HISTORICA: FormatDateTime era a funcao de formatacao de data do VBScript.
        ' vbLongDate, vbShortDate, vbGeneralDate — constantes pre-definidas.
        ' O formato dependia das configuracoes regionais do Windows Server.
        ' Nao existia moment.js, nao existia date-fns, nao existia Intl.DateTimeFormat.
        ' Era FormatDateTime() e rezava pra configuracao do servidor estar certa.
        Dim sDataFormatada
        If IsNull(dData) Or dData = "" Then
            sDataFormatada = "Data nao informada"
        Else
            sDataFormatada = FormatDateTime(dData, vbShortDate)
        End If
%>
<table width="620" align="center" cellpadding="6" cellspacing="0" border="1">
  <tr>
    <td class="rotulo">Titulo</td>
    <td><strong><%= oRS("titulo") %></strong></td>
  </tr>
  <tr>
    <td class="rotulo">Categoria</td>
    <td><%= oRS("categoria") %></td>
  </tr>
  <tr>
    <td class="rotulo">Data</td>
    <td><%= sDataFormatada %> &nbsp; <strong><%= oRS("horario") %></strong></td>
  </tr>
  <tr>
    <td class="rotulo">Local</td>
    <td><%= oRS("local") %></td>
  </tr>
  <tr>
    <td class="rotulo">Contato</td>
    <td><%= oRS("contato") %></td>
  </tr>
  <tr>
    <td class="rotulo">Descricao</td>
    <td><%= oRS("descricao") %></td>
  </tr>
  <tr>
    <td colspan="2">
      <a href="exc_evento.asp?cod=<%= oRS("id") %>" onclick="return confirmaExclusao();">Excluir</a>
      &nbsp;|&nbsp;
      <a href="alt_evento.asp?cod=<%= oRS("id") %>">Alterar</a>
    </td>
  </tr>
</table>
<br />
<%
        oRS.MoveNext
        ' NOTA HISTORICA: oRS.MoveNext movia pro proximo registro — igual mysqli_fetch_row
        ' mas manual. Voce controlava o cursor explicitamente.
        ' Em PHP o fetch ja avancava automaticamente no while.
        ' Em ADO voce tinha que chamar MoveNext ou o loop ficava infinito.
    Loop
End If

oRS.Close
Set oRS = Nothing
oConn.Close
Set oConn = Nothing
' NOTA HISTORICA: Set oObj = Nothing era a forma de liberar memoria em VBScript/COM.
' O garbage collector do VBScript era baseado em reference counting — igual ao PHP antigo.
' Se voce nao dava Nothing explicitamente, o objeto ficava na memoria ate a pagina terminar.
' A boa pratica era sempre fechar e liberar — mas poucos faziam.
%>
<table width="620" align="center" cellpadding="6" cellspacing="0" border="1">
  <tr><td><a href="menu.asp">Voltar ao Menu</a></td></tr>
</table>
</body>
</html>
