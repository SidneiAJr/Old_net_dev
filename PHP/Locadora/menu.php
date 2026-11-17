<?php
session_start();
if ($_SESSION['loginok'] != 'ok') { header('location: erro.html'); exit(); }
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>FilmMax - Menu</title>
<style type="text/css">
body{background-color:#1a1a2e;color:#e0e0e0;font-family:Verdana,Arial,sans-serif;}
table{background-color:#16213e;border-color:#0f3460;}
td{color:#e0e0e0;padding:10px;}
a{color:#e94560;text-decoration:none;} a:hover{text-decoration:underline;}
h2{color:#e94560;} li{margin-bottom:8px;}
</style>
</head>
<body>
<table width="600" border="2">
  <tr><td><h2>Locadora FilmMax &mdash; Menu Principal</h2></td></tr>
</table>
<br />
<table width="600" border="2">
  <tr>
    <td>
      <ul>
        <li><a href="cad_cliente.php">Cadastrar Cliente</a></li>
        <li><a href="lista_clientes.php">Listar Clientes</a></li>
        <li><a href="cad_filme.php">Cadastrar Filme</a></li>
        <li><a href="listagem.php">Listar Todos os Filmes</a></li>
        <li><a href="listagem.php?gen=1">Filmes de A&ccedil;&atilde;o</a></li>
        <li><a href="listagem.php?gen=2">Filmes de Com&eacute;dia</a></li>
        <li><a href="listagem.php?gen=3">Filmes de Romance</a></li>
        <li><a href="listagem.php?gen=4">Filmes de Terror</a></li>
        <li><a href="sair.php">Sair</a></li>
      </ul>
    </td>
  </tr>
</table>
</body>
</html>
