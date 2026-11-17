<%@ Language="VBScript" %>
<!-- #include file="includes/verifica_sessao.asp" -->
<!--
  NOTA HISTORICA: #include era o mecanismo de modularizacao do ASP Classico.
  Era processado ANTES do codigo VBScript — o servidor substituia a tag
  pelo conteudo do arquivo antes de qualquer execucao.
  Nao era um import dinamico — era um copy/paste estatico feito pelo IIS.
  Nao existia autoload, nao existia namespace, nao existia DI container.
  Se voce incluia dois arquivos com variaveis de mesmo nome: conflito.
  A solucao era prefixar variaveis. Ex: oConn_usuarios, oConn_eventos.
-->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
  "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Agenda de Eventos - Menu</title>
<style type="text/css">
body { background-color: #2b1a4a; color: #e0d0ff; font-family: Verdana, Arial, sans-serif; }
table { background-color: #3d2566; border: 2px solid #6a3fa0; }
td { padding: 10px; color: #e0d0ff; }
a { color: #c084fc; text-decoration: none; }
a:hover { text-decoration: underline; }
h2 { color: #c084fc; }
li { margin-bottom: 8px; }
</style>
</head>
<body>
<table width="600" align="center" cellpadding="6" cellspacing="0" border="1">
  <tr><td>
    <h2>Agenda de Eventos &mdash; Menu Principal</h2>
    <!--
      NOTA HISTORICA: &mdash; era o jeito certo de colocar em dash em HTML 4.
      Colocar o caractere direto (—) dependia do charset estar correto,
      e com iso-8859-1 era uma roleta-russa de acento quebrado.
      Entidades HTML (&mdash; &ccedil; &atilde;) eram a forma segura.
    -->
    <p>Bem-vindo, <strong><%= Session("usuario") %></strong></p>
    <!--
      NOTA HISTORICA: <%= variavel %> era o "echo" / "print" do ASP.
      <%= ... %> era abreviacao de <% Response.Write(...) %>.
      Response.Write era a funcao que mandava texto pro browser.
      Nao existia template engine, nao existia Blade, nao existia Razor (ainda).
      Era PHP puro mas em VBScript — HTML misturado com codigo o tempo todo.
    -->
  </td></tr>
</table>
<br />
<table width="600" align="center" cellpadding="6" cellspacing="0" border="1">
  <tr><td>
    <ul>
      <li><a href="cad_evento.asp">Cadastrar Evento</a></li>
      <li><a href="lista_eventos.asp">Listar Todos os Eventos</a></li>
      <li><a href="lista_eventos.asp?cat=Show">Shows e Concerts</a></li>
      <li><a href="lista_eventos.asp?cat=Palestra">Palestras</a></li>
      <li><a href="lista_eventos.asp?cat=Festa">Festas</a></li>
      <li><a href="lista_eventos.asp?cat=Esporte">Esportes</a></li>
      <li><a href="sair.asp">Sair</a></li>
    </ul>
  </td></tr>
</table>
</body>
</html>
