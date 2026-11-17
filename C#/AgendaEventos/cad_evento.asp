<%@ Language="VBScript" %>
<!-- #include file="includes/verifica_sessao.asp" -->
<%
Dim sMensagem, bSucesso
sMensagem = ""
bSucesso  = False

If Request.ServerVariables("REQUEST_METHOD") = "POST" Then
    Dim sTitulo, sDescricao, sLocal, sDataEv, sHorario, sCategoria, sContato
    sTitulo    = Trim(Request.Form("f_titulo"))
    sDescricao = Trim(Request.Form("f_descricao"))
    sLocal     = Trim(Request.Form("f_local"))
    sDataEv    = Trim(Request.Form("f_data"))
    sHorario   = Trim(Request.Form("f_horario"))
    sCategoria = Trim(Request.Form("f_categoria"))
    sContato   = Trim(Request.Form("f_contato"))

    ' NOTA HISTORICA: Trim() era o strip() / trim() do VBScript.
    ' Validacao de formulario em ASP era 100% manual — sem biblioteca,
    ' sem HTML5 required, sem nada. Voce checava campo por campo com IF.
    ' Required attribute no HTML5 so veio em 2014.

    If sTitulo = "" Then
        sMensagem = "TITULO e obrigatorio!"
    ElseIf sDataEv = "" Then
        sMensagem = "DATA e obrigatoria!"
    Else
        ' NOTA HISTORICA: ADO.Command com parametros existia mas era verboso.
        ' O padrao real do mercado era SQL concatenado — simples, direto,
        ' e um desastre de segurança que a maioria so descobriu quando foi hackeada.
        <!-- #include file="includes/conexao.asp" -->

        ' NOTA: CDate() converte string pra Date no VBScript.
        ' Format de data dependia da configuracao regional do Windows Server.
        ' Um servidor em ingles esperava MM/DD/YYYY, servidor em portugues DD/MM/YYYY.
        ' Era fonte infinita de bugs ao mudar de hospedagem.
        Dim sSQL
        sSQL = "INSERT INTO eventos (titulo, descricao, local, data_ev, horario, categoria, contato) " & _
               "VALUES ('" & sTitulo    & "', " & _
                       "'" & sDescricao & "', " & _
                       "'" & sLocal     & "', " & _
                       "#" & sDataEv    & "#, " & _
                       "'" & sHorario   & "', " & _
                       "'" & sCategoria & "', " & _
                       "'" & sContato   & "')"
        ' NOTA HISTORICA: Datas no Access ficavam entre # # em vez de aspas simples.
        ' Era um detalhe que pegava todo mundo que vinha do MySQL.
        ' MySQL: WHERE data = '2001-12-25'
        ' Access: WHERE data = #12/25/2001#
        ' Formato americano, sempre, independente do servidor estar em PT-BR.

        On Error Resume Next
        ' NOTA HISTORICA: On Error Resume Next desligava os erros — o codigo
        ' continuava executando mesmo se o SQL falhasse.
        ' Era a forma mais comum de "tratamento de erro" em ASP da epoca.
        ' O dev checava Err.Number depois pra saber se deu errado.
        ' O equivalente seria um try/catch que nunca relanca o erro.
        oConn.Execute sSQL
        If Err.Number <> 0 Then
            sMensagem = "Erro ao cadastrar evento: " & Err.Description
        Else
            bSucesso = True
            sMensagem = "Evento cadastrado com sucesso!"
        End If
        On Error GoTo 0

        oConn.Close
        Set oConn = Nothing
    End If
End If
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
  "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Agenda de Eventos - Cadastrar</title>
<style type="text/css">
body { background-color: #2b1a4a; color: #e0d0ff; font-family: Verdana, Arial, sans-serif; }
table { background-color: #3d2566; border: 2px solid #6a3fa0; }
td { padding: 8px; color: #e0d0ff; }
input, select, textarea { background: #1e0f33; color: #e0d0ff; border: 1px solid #6a3fa0; padding: 4px; }
input[type=submit] { background: #6a3fa0; color: #fff; border: none; padding: 5px 14px; cursor: pointer; }
input[type=reset]  { background: #3d2566; color: #e0d0ff; border: 1px solid #6a3fa0; padding: 5px 14px; cursor: pointer; }
a { color: #c084fc; } h2 { color: #c084fc; }
.ok   { color: #86efac; font-weight: bold; }
.erro { color: #f87171; font-weight: bold; }
</style>
</head>
<body>
<table width="600" align="center" cellpadding="6" cellspacing="0" border="1">
  <tr><td><h2>Agenda de Eventos &mdash; Cadastrar Evento</h2></td></tr>
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
    <form action="cad_evento.asp" method="post" name="frmCad">
      <p>Titulo:<br /><input type="text" name="f_titulo" size="50" /></p>
      <p>Categoria:<br />
        <select name="f_categoria">
          <option value="Show">Show / Concerto</option>
          <option value="Palestra">Palestra / Seminario</option>
          <option value="Festa">Festa</option>
          <option value="Esporte">Esporte</option>
          <option value="Outro">Outro</option>
        </select>
      </p>
      <p>Data (MM/DD/AAAA):<br /><input type="text" name="f_data" size="12" />
      <!--
        NOTA HISTORICA: input type="date" nao existia em HTML 4.
        Voce digitava a data no formato que o servidor esperava — e rezava.
        jQuery UI Datepicker (2007) foi uma revolucao por isso.
        O type="date" nativo so chegou com HTML5/Chrome 2012.
        No IE so funcionou no IE 12 (Edge). IE 11 mostrava um input de texto normal.
      -->
      </p>
      <p>Horario:<br /><input type="text" name="f_horario" size="8" placeholder="19:30" /></p>
      <p>Local:<br /><input type="text" name="f_local" size="50" /></p>
      <p>Contato:<br /><input type="text" name="f_contato" size="50" /></p>
      <p>Descricao:<br /><textarea name="f_descricao" rows="5" cols="50"></textarea></p>
      <p>
        <input type="submit" value="Cadastrar" />
        <input type="reset" value="Limpar" />
      </p>
    </form>
  </td></tr>
</table>
<br />
<table width="600" align="center" cellpadding="6" cellspacing="0" border="1">
  <tr><td><a href="menu.asp">Voltar ao Menu</a></td></tr>
</table>
</body>
</html>
