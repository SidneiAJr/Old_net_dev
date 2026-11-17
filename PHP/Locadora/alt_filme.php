<?php
session_start();
if ($_SESSION['loginok'] != 'ok') { header('location: erro.html'); exit(); }
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>FilmMax - Alterar Filme</title>
<style type="text/css">
body{background-color:#1a1a2e;color:#e0e0e0;font-family:Verdana,Arial,sans-serif;}
table{background-color:#16213e;border-color:#0f3460;}
td{color:#e0e0e0;padding:8px;}
input[type=text]{background:#0f3460;color:#e0e0e0;border:1px solid #533483;padding:4px;}
input[type=submit]{background:#533483;color:#fff;border:none;padding:5px 14px;cursor:pointer;}
select{background:#0f3460;color:#e0e0e0;border:1px solid #533483;padding:3px;}
textarea{background:#0f3460;color:#e0e0e0;border:1px solid #533483;padding:4px;}
a{color:#e94560;} h2{color:#e94560;}
</style>
</head>
<body>
<table width="600" border="2">
  <tr><td><h2>Locadora FilmMax &mdash; Alterar Filme</h2></td></tr>
</table>
<?php
include "conexao.php";
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $cod      = (int)$_POST["f_cod"];
    $mtitulo  = $_POST["f_titulo"];
    $mgenero  = (int)$_POST["f_genero"];
    $mano     = (int)$_POST["f_ano"];
    $mpreco   = $_POST["f_preco"];
    $msinopse = $_POST["f_sinopse"];
    $sql = "UPDATE filmes SET titulo='$mtitulo', genero=$mgenero, ano=$mano, preco='$mpreco', sinopse='$msinopse' WHERE codigo=$cod";
    mysqli_query($conexao, $sql) or die("Erro ao alterar filme!");
    echo "<b>Filme</b> alterado com sucesso!<br />";
} else {
    $cod = isset($_GET["cod"]) ? (int)$_GET["cod"] : 0;
    $res = mysqli_query($conexao, "SELECT codigo,titulo,genero,ano,preco,sinopse FROM filmes WHERE codigo=$cod");
    if (mysqli_num_rows($res) == 0) {
        echo "Filme nao encontrado!";
    } else {
        $l = mysqli_fetch_row($res);
?>
<table width="600" border="2">
  <tr>
    <td>
      <form action="alt_filme.php" method="post" name="frmAlt">
        <input type="hidden" name="f_cod" value="<?php echo $l[0]; ?>" />
        <p>Titulo:<br /><input type="text" name="f_titulo" size="50" value="<?php echo $l[1]; ?>" /></p>
        <p>Genero:<br />
          <select name="f_genero">
            <option value="1" <?php if($l[2]==1) echo 'selected="selected"'; ?>>Acao</option>
            <option value="2" <?php if($l[2]==2) echo 'selected="selected"'; ?>>Comedia</option>
            <option value="3" <?php if($l[2]==3) echo 'selected="selected"'; ?>>Romance</option>
            <option value="4" <?php if($l[2]==4) echo 'selected="selected"'; ?>>Terror</option>
            <option value="5" <?php if($l[2]==5) echo 'selected="selected"'; ?>>Documentario</option>
          </select>
        </p>
        <p>Ano:<br /><input type="text" name="f_ano" size="6" value="<?php echo $l[3]; ?>" /></p>
        <p>Preco:<br /><input type="text" name="f_preco" size="8" value="<?php echo $l[4]; ?>" /></p>
        <p>Sinopse:<br /><textarea name="f_sinopse" rows="4" cols="50"><?php echo $l[5]; ?></textarea></p>
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
<table width="600" border="2"><tr><td><a href="listagem.php">Voltar</a></td></tr></table>
</body>
</html>
