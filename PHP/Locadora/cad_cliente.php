<?php
session_start();
if ($_SESSION['loginok'] != 'ok') { header('location: erro.html'); exit(); }
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>FilmMax - Cadastrar Cliente</title>
<style type="text/css">
body{background-color:#1a1a2e;color:#e0e0e0;font-family:Verdana,Arial,sans-serif;}
table{background-color:#16213e;border-color:#0f3460;}
td{color:#e0e0e0;padding:8px;}
input[type=text]{background:#0f3460;color:#e0e0e0;border:1px solid #533483;padding:4px;}
input[type=submit]{background:#533483;color:#fff;border:none;padding:5px 14px;cursor:pointer;}
input[type=reset]{background:#0f3460;color:#e0e0e0;border:1px solid #533483;padding:5px 14px;cursor:pointer;}
select{background:#0f3460;color:#e0e0e0;border:1px solid #533483;padding:3px;}
a{color:#e94560;} h2{color:#e94560;}
</style>
</head>
<body>
<table width="600" border="2">
  <tr><td><h2>Locadora FilmMax &mdash; Cadastrar Cliente</h2></td></tr>
</table>
<?php
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $mnome      = $_POST["f_nome"];
    $mtelefone  = $_POST["f_telefone"];
    $mcategoria = $_POST["f_categoria"];
    $erro = false;
    if (empty($mnome)) { echo "<b>NOME</b> nao informado!<br />"; $erro = true; }
    if ($erro) {
        echo "<br />Formulario com erros, favor corrigir...<br />";
    } else {
        include "conexao.php";
        $sql = "INSERT INTO clientes (nome, telefone, categoria) VALUES ('$mnome', '$mtelefone', $mcategoria)";
        mysqli_query($conexao, $sql) or die("Erro na insercao!");
        echo "<b>Cliente</b> cadastrado com sucesso!<br />";
        mysqli_close($conexao);
    }
}
?>
<table width="600" border="2">
  <tr>
    <td>
      <form action="cad_cliente.php" method="post" name="frmCadCliente">
        <p>Nome:<br /><input type="text" name="f_nome" size="50" placeholder="Nome completo" /></p>
        <p>Telefone:<br /><input type="text" name="f_telefone" size="20" placeholder="(00) 00000-0000" /></p>
        <p>Categoria:<br />
          <select name="f_categoria">
            <option value="1">Comum</option>
            <option value="2">VIP</option>
            <option value="3">Estudante</option>
          </select>
        </p>
        <p><input type="submit" value="Cadastrar" /> <input type="reset" value="Limpar" /></p>
      </form>
    </td>
  </tr>
</table>
<table width="600" border="2"><tr><td><a href="menu.php">Voltar ao Menu</a></td></tr></table>
</body>
</html>
