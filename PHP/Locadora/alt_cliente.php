<?php
session_start();
if ($_SESSION['loginok'] != 'ok') { header('location: erro.html'); exit(); }
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>FilmMax - Alterar Cliente</title>
<style type="text/css">
body{background-color:#1a1a2e;color:#e0e0e0;font-family:Verdana,Arial,sans-serif;}
table{background-color:#16213e;border-color:#0f3460;}
td{color:#e0e0e0;padding:8px;}
input[type=text]{background:#0f3460;color:#e0e0e0;border:1px solid #533483;padding:4px;}
input[type=submit]{background:#533483;color:#fff;border:none;padding:5px 14px;cursor:pointer;}
select{background:#0f3460;color:#e0e0e0;border:1px solid #533483;padding:3px;}
a{color:#e94560;} h2{color:#e94560;}
</style>
</head>
<body>
<table width="600" border="2">
  <tr><td><h2>Locadora FilmMax &mdash; Alterar Cliente</h2></td></tr>
</table>
<?php
include "conexao.php";
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $cod        = (int)$_POST["f_cod"];
    $mnome      = $_POST["f_nome"];
    $mtelefone  = $_POST["f_telefone"];
    $mcategoria = (int)$_POST["f_categoria"];
    $sql = "UPDATE clientes SET nome='$mnome', telefone='$mtelefone', categoria=$mcategoria WHERE id=$cod";
    mysqli_query($conexao, $sql) or die("Erro ao alterar cliente!");
    echo "<b>Cliente</b> alterado com sucesso!<br />";
} else {
    $cod = isset($_GET["cod"]) ? (int)$_GET["cod"] : 0;
    $sql = "SELECT id, nome, telefone, categoria FROM clientes WHERE id=$cod";
    $res = mysqli_query($conexao, $sql) or die("Erro ao buscar cliente!");
    if (mysqli_num_rows($res) == 0) {
        echo "Cliente nao encontrado!";
    } else {
        $linha = mysqli_fetch_row($res);
?>
<table width="600" border="2">
  <tr>
    <td>
      <form action="alt_cliente.php" method="post" name="frmAlt">
        <input type="hidden" name="f_cod" value="<?php echo $linha[0]; ?>" />
        <p>Nome:<br /><input type="text" name="f_nome" size="50" value="<?php echo $linha[1]; ?>" /></p>
        <p>Telefone:<br /><input type="text" name="f_telefone" size="20" value="<?php echo $linha[2]; ?>" /></p>
        <p>Categoria:<br />
          <select name="f_categoria">
            <option value="1" <?php if($linha[3]==1) echo 'selected="selected"'; ?>>Comum</option>
            <option value="2" <?php if($linha[3]==2) echo 'selected="selected"'; ?>>VIP</option>
            <option value="3" <?php if($linha[3]==3) echo 'selected="selected"'; ?>>Estudante</option>
          </select>
        </p>
        <p><input type="submit" value="Salvar" /></p>
      </form>
    </td>
  </tr>
</table>
<?php
    }
}
mysqli_close($conexao);
?>
<table width="600" border="2"><tr><td><a href="lista_clientes.php">Voltar</a></td></tr></table>
</body>
</html>
