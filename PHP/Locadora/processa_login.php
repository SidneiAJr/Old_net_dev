<?php
include "conexao.php";
$usuario = $_POST["f_usuario"];
$senha   = $_POST["f_senha"];
$sql = "SELECT * FROM tab_usuario WHERE login = '$usuario'";
$res = mysqli_query($conexao, $sql) or die("Erro ao consultar usuario");
if (mysqli_num_rows($res) == 0) {
    header('location: erro.html'); exit();
} else {
    $linha = mysqli_fetch_row($res);
    if ($linha[2] == $senha) {
        session_start();
        $_SESSION['loginok'] = 'ok';
        header('location: menu.php'); exit();
    } else {
        header('location: erro.html'); exit();
    }
}
mysqli_close($conexao);
?>
