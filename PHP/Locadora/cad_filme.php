<?php
session_start();
if ($_SESSION['loginok'] != 'ok') { header('location: erro.html'); exit(); }
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>FilmMax - Cadastrar Filme</title>
<style type="text/css">
body{background-color:#1a1a2e;color:#e0e0e0;font-family:Verdana,Arial,sans-serif;}
table{background-color:#16213e;border-color:#0f3460;}
td{color:#e0e0e0;padding:8px;}
input[type=text]{background:#0f3460;color:#e0e0e0;border:1px solid #533483;padding:4px;}
input[type=submit]{background:#533483;color:#fff;border:none;padding:5px 14px;cursor:pointer;}
input[type=reset]{background:#0f3460;color:#e0e0e0;border:1px solid #533483;padding:5px 14px;cursor:pointer;}
select{background:#0f3460;color:#e0e0e0;border:1px solid #533483;padding:3px;}
textarea{background:#0f3460;color:#e0e0e0;border:1px solid #533483;padding:4px;}
a{color:#e94560;} h2{color:#e94560;}
</style>
</head>
<body>
<table width="600" border="2">
  <tr><td><h2>Locadora FilmMax &mdash; Cadastrar Filme</h2></td></tr>
</table>
<?php
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $mtitulo  = $_POST["f_titulo"];
    $mgenero  = (int)$_POST["f_genero"];
    $mano     = (int)$_POST["f_ano"];
    $mpreco   = $_POST["f_preco"];
    $msinopse = $_POST["f_sinopse"];
    $erro = false;
    if (empty($mtitulo)) { echo "<b>TITULO</b> nao informado!<br />"; $erro = true; }
    if ($erro) {
        echo "<br />Formulario com erros, favor corrigir...<br />";
    } else {
        include "conexao.php";
        $sql = "INSERT INTO filmes (titulo, genero, ano, preco, sinopse) VALUES ('$mtitulo', $mgenero, $mano, '$mpreco', '$msinopse')";
        mysqli_query($conexao, $sql) or die("Erro na insercao do filme!");
        echo "<b>Filme</b> cadastrado com sucesso!<br />";
        mysqli_close($conexao);
    }
}
?>
<table width="600" border="2">
  <tr>
    <td>
      <form action="cad_filme.php" method="post" name="frmCadFilme">
        <p>Titulo:<br /><input type="text" name="f_titulo" size="50" placeholder="Titulo do filme" /></p>
        <p>Genero:<br />
          <select name="f_genero">
            <option value="1">Acao</option>
            <option value="2">Comedia</option>
            <option value="3">Romance</option>
            <option value="4">Terror</option>
            <option value="5">Documentario</option>
          </select>
        </p>
        <p>Ano:<br /><input type="text" name="f_ano" size="6" placeholder="2024" /></p>
        <p>Preco (R$):<br /><input type="text" name="f_preco" size="8" placeholder="9.90" /></p>
        <p>Sinopse:<br /><textarea name="f_sinopse" rows="4" cols="50"></textarea></p>
        <p><input type="submit" value="Cadastrar" /> <input type="reset" value="Limpar" /></p>
      </form>
    </td>
  </tr>
</table>
<table width="600" border="2"><tr><td><a href="menu.php">Voltar ao Menu</a></td></tr></table>
</body>
</html>
