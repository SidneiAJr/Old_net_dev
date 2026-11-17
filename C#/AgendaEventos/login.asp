<%@ Language="VBScript" %>
<%
' ============================================================
' login.asp — Agenda de Eventos / ASP Classico ~2001
' ============================================================
' NOTA HISTORICA:
' A diretiva <%@ Language="VBScript" %> era obrigatoria no topo.
' O IIS suportava VBScript e JScript (JavaScript do servidor).
' VBScript era o padrao — era a linguagem do Visual Basic,
' entao quem vinha do VB6 se sentia em casa.
' JScript era usado por quem vinha do JavaScript do browser.
' ============================================================

Dim sMensagem
sMensagem = ""

If Request.ServerVariables("REQUEST_METHOD") = "POST" Then
    ' NOTA HISTORICA: Request.Form("campo") era o equivalente ao $_POST do PHP.
    ' Request.QueryString("campo") era o equivalente ao $_GET.
    ' Request("campo") pegava dos dois — perigoso, mas era muito usado.
    Dim sUsuario, sSenha
    sUsuario = Request.Form("f_usuario")
    sSenha   = Request.Form("f_senha")

    ' NOTA HISTORICA: SQL concatenado com string era o padrao absoluto.
    ' Nao existia prepared statement em ASP Classico de forma simples.
    ' Parametros ADO existiam mas eram raros no codigo do dia a dia.
    ' SQL Injection era um conceito que a maioria dos devs da epoca
    ' simplesmente nao conhecia. A OWASP Top 10 so virou mainstream depois.
    <!-- #include file="includes/conexao.asp" -->
    Dim oRS
    Set oRS = Server.CreateObject("ADODB.Recordset")
    oRS.Open "SELECT * FROM usuarios WHERE login='" & sUsuario & "'", oConn

    If oRS.EOF Then
        sMensagem = "Usuario ou senha invalidos."
    Else
        ' NOTA: oRS("campo") acessa o campo pelo nome — mais legivel que indice.
        ' oRS(0), oRS(1) tambem funcionava, igual mysqli_fetch_row no PHP.
        If oRS("senha") = sSenha Then
            Session("loginok") = "ok"
            Session("usuario") = sUsuario
            Response.Redirect "menu.asp"
            Response.End()
        Else
            sMensagem = "Usuario ou senha invalidos."
        End If
    End If

    oRS.Close
    Set oRS = Nothing
    oConn.Close
    Set oConn = Nothing
End If
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
  "http://www.w3.org/TR/html4/loose.dtd">
<!--
  NOTA HISTORICA: HTML 4.01 Transitional era o DOCTYPE padrao da epoca.
  XHTML 1.0 existia mas era considerado "avancado".
  HTML5 so virou padrao em 2014.
  "Transitional" significava que ainda aceitava tags de apresentacao
  como <font>, <center>, <b> — as "strict" nao aceitavam.
-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!--
  NOTA HISTORICA: charset=iso-8859-1 (Latin-1) era o padrao no Brasil.
  UTF-8 existia mas nao era o default — muita hospedagem nao suportava bem.
  Resultado: acentos quebravam com frequencia ao mover arquivos entre servidores.
  A guerra do charset foi um sofrimento real dos anos 2000-2010.
-->
<title>Agenda de Eventos - Login</title>
<style type="text/css">
body { background-color: #2b1a4a; color: #e0d0ff; font-family: Verdana, Arial, sans-serif; }
table { background-color: #3d2566; border: 2px solid #6a3fa0; }
td { padding: 8px; color: #e0d0ff; }
input { background: #1e0f33; color: #e0d0ff; border: 1px solid #6a3fa0; padding: 4px; }
input[type=submit] { background: #6a3fa0; color: #fff; border: none; padding: 5px 14px; cursor: pointer; }
h2 { color: #c084fc; }
.erro { color: #f87171; font-weight: bold; }
</style>
</head>
<body>
<br />
<table width="400" align="center" cellpadding="6" cellspacing="0" border="1">
  <tr><td align="center">
    <h2>Agenda de Eventos</h2>
    <p>Painel Administrativo</p>
  </td></tr>
</table>
<br />
<% If sMensagem <> "" Then %>
<table width="400" align="center" cellpadding="6" cellspacing="0" border="1">
  <tr><td align="center" class="erro"><%= sMensagem %></td></tr>
</table>
<br />
<% End If %>
<!--
  NOTA HISTORICA: layout com tabelas era a unica forma confiavel
  de centralizar e alinhar conteudo. CSS layout (float, position)
  era inconsistente entre IE6 e Firefox. Flexbox e Grid nao existiam.
  Todo site era uma hierarquia de tabelas aninhadas.
-->
<table width="400" align="center" cellpadding="6" cellspacing="0" border="1">
  <tr><td>
    <form action="login.asp" method="post" name="frmLogin">
      <p>Usuario:<br /><input type="text" name="f_usuario" size="30" /></p>
      <p>Senha:<br /><input type="password" name="f_senha" size="30" /></p>
      <p><input type="submit" value="Entrar" /></p>
    </form>
  </td></tr>
</table>
</body>
</html>
