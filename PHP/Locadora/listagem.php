<?php
session_start();
if ($_SESSION['loginok'] != 'ok') { header('location: erro.html'); exit(); }
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>FilmMax - Listagem de Filmes</title>
<style type="text/css">
body{background-color:#1a1a2e;color:#e0e0e0;font-family:Verdana,Arial,sans-serif;}
table{background-color:#16213e;border-color:#0f3460;}
td{color:#e0e0e0;padding:6px;}
a{color:#e94560;text-decoration:none;} a:hover{text-decoration:underline;}
h2{color:#e94560;}
input[type=text]{background:#0f3460;color:#e0e0e0;border:1px solid #533483;padding:4px;}
input[type=submit]{background:#533483;color:#fff;border:none;padding:4px 12px;cursor:pointer;}
</style>
</head>
<body>
<table width="600" border="2">
  <tr><td><h2>Locadora FilmMax &mdash; Listagem de Filmes</h2></td></tr>
</table>
<br />
<table width="600" border="2">
  <tr>
    <td>
      <form action="listagem.php" method="post" name="frmBusca">
        Buscar por titulo:
        <input type="text" name="f_busca" size="30" />
        <input type="submit" value="Buscar" />
      </form>
    </td>
  </tr>
</table>
<br />
<?php
include "conexao.php";
$gen   = isset($_GET["gen"])      ? (int)$_GET["gen"]      : null;
$busca = isset($_POST["f_busca"]) ? $_POST["f_busca"]       : null;
if (isset($gen) && $gen > 0) {
    $sql = "SELECT codigo, titulo, genero, ano, preco, sinopse FROM filmes WHERE genero=$gen ORDER BY titulo";
} elseif (isset($busca)) {
    $sql = "SELECT codigo, titulo, genero, ano, preco, sinopse FROM filmes WHERE titulo LIKE '%$busca%' ORDER BY titulo";
} else {
    $sql = "SELECT codigo, titulo, genero, ano, preco, sinopse FROM filmes ORDER BY titulo";
}
$res   = mysqli_query($conexao, $sql) or die("Falha ao selecionar filmes!");
$total = mysqli_num_rows($res);
if ($total == 0) {
    echo "<b>Nenhum</b> filme encontrado!";
} else {
    while ($linha = mysqli_fetch_row($res)) {
        switch ($linha[2]) {
            case 1: $gen_txt = "Acao";         break;
            case 2: $gen_txt = "Comedia";      break;
            case 3: $gen_txt = "Romance";      break;
            case 4: $gen_txt = "Terror";       break;
            case 5: $gen_txt = "Documentario"; break;
            default: $gen_txt = "Outro";
        }
?>
<table width="600" border="2">
  <tr>
    <td width="80">Codigo</td><td><?php echo $linha[0]; ?></td>
  </tr>
  <tr>
    <td>Titulo</td><td><?php echo $linha[1]; ?></td>
  </tr>
  <tr>
    <td>Genero</td><td><?php echo $gen_txt; ?></td>
  </tr>
  <tr>
    <td>Ano</td><td><?php echo $linha[3]; ?></td>
  </tr>
  <tr>
    <td>Preco</td><td>R$ <?php echo number_format($linha[4], 2, ',', '.'); ?></td>
  </tr>
  <tr>
    <td>Sinopse</td><td><?php echo $linha[5]; ?></td>
  </tr>
  <tr>
    <td colspan="2">
      <a href="exc_filme.php?cod=<?php echo $linha[0]; ?>" onclick="return confirm('Confirma exclusao?');">Excluir</a>
      &nbsp;|&nbsp;
      <a href="alt_filme.php?cod=<?php echo $linha[0]; ?>">Alterar</a>
    </td>
  </tr>
</table>
<br />
<?php
    }
}
mysqli_close($conexao);
?>
<table width="600" border="2"><tr><td><a href="menu.php">Voltar ao Menu</a></td></tr></table>
</body>
</html>
