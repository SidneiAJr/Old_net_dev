<%@ Language="VBScript" %>
<!-- #include file="includes/verifica_sessao.asp" -->
<!-- #include file="includes/conexao.asp" -->
<%
Dim sMensagem, bSucesso
sMensagem = ""
bSucesso  = False

If Request.ServerVariables("REQUEST_METHOD") = "POST" Then
    Dim iCod, sTitulo, sDescricao, sLocal, sDataEv, sHorario, sCategoria, sContato
    iCod       = CInt(Request.Form("f_cod"))
    sTitulo    = Trim(Request.Form("f_titulo"))
    sDescricao = Trim(Request.Form("f_descricao"))
    sLocal     = Trim(Request.Form("f_local"))
    sDataEv    = Trim(Request.Form("f_data"))
    sHorario   = Trim(Request.Form("f_horario"))
    sCategoria = Trim(Request.Form("f_categoria"))
    sContato   = Trim(Request.Form("f_contato"))

    Dim sSQL
    sSQL = "UPDATE eventos SET " & _
           "titulo='"    & sTitulo    & "', " & _
           "descricao='" & sDescricao & "', " & _
           "local='"     & sLocal     & "', " & _
           "data_ev=#"   & sDataEv    & "#, " & _
           "horario='"   & sHorario   & "', " & _
           "categoria='" & sCategoria & "', " & _
           "contato='"   & sContato   & "' " & _
           "WHERE id="   & iCod

    On Error Resume Next
    oConn.Execute sSQL
    If Err.Number <> 0 Then
        sMensagem = "Erro ao alterar: " & Err.Description
    Else
        bSucesso  = True
        sMensagem = "Evento alterado com sucesso!"
    End If
    On Error GoTo 0
Else
    ' GET — carrega dados do evento pra preencher o form
    iCod = CInt(Request.QueryString("cod"))
End If

' Carrega o registro atual (pra exibir o form preenchido)
Dim oRS
Set oRS = Server.CreateObject("ADODB.Recordset")
oRS.Open "SELECT * FROM eventos WHERE id=" & iCod, oConn

Dim sTituloAtual, sDescAtual, sLocalAtual, sDataAtual, sHorAtual, sCatAtual, sContAtual
If Not oRS.EOF Then
    sTituloAtual = oRS("titulo")
    sDescAtual   = oRS("descricao")
    sLocalAtual  = oRS("local")
    sDataAtual   = oRS("data_ev")
    sHorAtual    = oRS("horario")
    sCatAtual    = oRS("categoria")
    sContAtual   = oRS("contato")
End If
oRS.Close
Set oRS = Nothing
oConn.Close
Set oConn = Nothing
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
  "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Agenda de Eventos - Alterar</title>
<style type="text/css">
body { background-color: #2b1a4a; color: #e0d0ff; font-family: Verdana, Arial, sans-serif; }
table { background-color: #3d2566; border: 2px solid #6a3fa0; }
td { padding: 8px; color: #e0d0ff; }
input, select, textarea { background: #1e0f33; color: #e0d0ff; border: 1px solid #6a3fa0; padding: 4px; }
input[type=submit] { background: #6a3fa0; color: #fff; border: none; padding: 5px 14px; cursor: pointer; }
a { color: #c084fc; } h2 { color: #c084fc; }
.ok   { color: #86efac; font-weight: bold; }
.erro { color: #f87171; font-weight: bold; }
</style>
</head>
<body>
<table width="600" align="center" cellpadding="6" cellspacing="0" border="1">
  <tr><td><h2>Agenda de Eventos &mdash; Alterar Evento</h2></td></tr>
</table>
<% If sMensagem <> "" Then %>
<br />
<table width="600" align="center" cellpadding="6" cellspacing="0" border="1">
  <tr><td align="center">
    <% If bSucesso Then %>
      <span class="ok"><%= sMensagem %></span>
    <% Else %>
      <span class="erro"><%= sMensagem %></span>
    <% End If %>
  </td></tr>
</table>
<% End If %>
<br />
<table width="600" align="center" cellpadding="6" cellspacing="0" border="1">
  <tr><td>
    <form action="alt_evento.asp" method="post" name="frmAlt">
      <input type="hidden" name="f_cod" value="<%= iCod %>" />
      <!--
        NOTA HISTORICA: input type="hidden" era a forma de passar o ID entre paginas.
        Nao existia React state, nao existia Redux, nao existia nada.
        Se voce precisava manter um valor entre requisicoes, era hidden field ou Session.
        Hidden field podia ser alterado pelo usuario via DevTools — ja que DevTools nao existia
        na epoca, era "seguro o suficiente". Hoje seria uma falha obvia de IDOR.
      -->
      <p>Titulo:<br /><input type="text" name="f_titulo" size="50" value="<%= sTituloAtual %>" /></p>
      <p>Categoria:<br />
        <select name="f_categoria">
          <%
          ' NOTA HISTORICA: selected="selected" era o XHTML correto.
          ' Em HTML 4 era so selected sem valor.
          ' A galera usava os dois, o browser aceitava os dois.
          ' Hoje seria selected no atributo booleano HTML5.
          Dim aCats(4), i
          aCats(0) = "Show"
          aCats(1) = "Palestra"
          aCats(2) = "Festa"
          aCats(3) = "Esporte"
          aCats(4) = "Outro"
          For i = 0 To 4
          %>
          <option value="<%= aCats(i) %>"
            <% If aCats(i) = sCatAtual Then Response.Write "selected=""selected""" %>>
            <%= aCats(i) %>
          </option>
          <% Next %>
        </select>
      </p>
      <p>Data (MM/DD/AAAA):<br /><input type="text" name="f_data" size="12" value="<%= sDataAtual %>" /></p>
      <p>Horario:<br /><input type="text" name="f_horario" size="8" value="<%= sHorAtual %>" /></p>
      <p>Local:<br /><input type="text" name="f_local" size="50" value="<%= sLocalAtual %>" /></p>
      <p>Contato:<br /><input type="text" name="f_contato" size="50" value="<%= sContAtual %>" /></p>
      <p>Descricao:<br /><textarea name="f_descricao" rows="5" cols="50"><%= sDescAtual %></textarea></p>
      <p><input type="submit" value="Salvar Alteracoes" /></p>
    </form>
  </td></tr>
</table>
<br />
<table width="600" align="center" cellpadding="6" cellspacing="0" border="1">
  <tr><td><a href="lista_eventos.asp">Voltar</a></td></tr>
</table>
</body>
</html>
