<?php
session_start();
if ($_SESSION['loginok'] != 'ok') { header('location: erro.html'); exit(); }
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>FilmMax - Lista de Clientes</title>
<style type="text/css">
body{background-color:#1a1a2e;color:#e0e0e0;font-family:Verdana,Arial,sans-serif;}
table{background-color:#16213e;border-color:#0f3460;}
td{color:#e0e0e0;padding:6px;}
a{color:#e94560;text-decoration:none;} a:hover{text-decoration:underline;}
h2{color:#e94560;}
input[type=text]{background:#0f3460;color:#e0e0e0;border:1px solid #533483;padding:4px;}
input[type=submit]{background:#533483;color:#fff;border:none;padding:4px 12px;cursor:pointer;}
</style>
<script type="text/javascript">
function confirmaExclusao() {
    return confirm("Confirma a exclusao deste cliente?");
}
</script>
</head>
<body>
<table width="600" border="2">
  <tr><td><h2>Locadora FilmMax &mdash; Lista de Clientes</h2></td></tr>
</table>
<br />
<table width="600" border="2">
  <tr>
    <td>
      <form action="lista_clientes.php" method="post" name="frmBusca">
        Buscar por nome:
        <input type="text" name="f_busca" size="30" />
        <input type="submit" value="Buscar" />
      </form>
    </td>
  </tr>
</table>
<br />
<?php
include "conexao.php";
$busca = isset($_POST["f_busca"]) ? $_POST["f_busca"] : null;
if (isset($busca)) {
    $sql = "SELECT id, nome, telefone, categoria FROM clientes WHERE nome LIKE '%$busca%' ORDER BY nome";
} else {
    $sql = "SELECT id, nome, telefone, categoria FROM clientes ORDER BY nome";
}
$res   = mysqli_query($conexao, $sql) or die("Falha ao selecionar clientes!");
$total = mysqli_num_rows($res);
if ($total == 0) {
    echo "<b>Nenhum</b> cliente encontrado!";
} else {
    while ($linha = mysqli_fetch_row($res)) {
        switch ($linha[3]) {
            case 1: $cat = "Comum";     break;
            case 2: $cat = "VIP";       break;
            case 3: $cat = "Estudante"; break;
            default: $cat = "Outro";
        }
?>
<table width="600" border="2">
  <tr>
    <td width="80">Codigo</td><td><?php echo $linha[0]; ?></td>
  </tr>
  <tr>
    <td>Nome</td><td><?php echo $linha[1]; ?></td>
  </tr>
  <tr>
    <td>Telefone</td><td><?php echo $linha[2]; ?></td>
  </tr>
  <tr>
    <td>Categoria</td><td><?php echo $cat; ?></td>
  </tr>
  <tr>
    <td colspan="2">
      <a href="exc_cliente.php?cod=<?php echo $linha[0]; ?>" onclick="return confirmaExclusao();">Excluir</a>
      &nbsp;|&nbsp;
      <a href="alt_cliente.php?cod=<?php echo $linha[0]; ?>">Alterar</a>
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
