<?php
session_start();
if ($_SESSION['loginok'] != 'ok') { header('location: erro.html'); exit(); }
include "conexao.php";
$cod = isset($_GET["cod"]) ? (int)$_GET["cod"] : 0;
if ($cod > 0) {
    $sql = "DELETE FROM clientes WHERE id = $cod";
    mysqli_query($conexao, $sql) or die("Erro ao excluir cliente!");
    echo "Cliente excluido com sucesso! ";
} else {
    echo "Codigo invalido! ";
}
mysqli_close($conexao);
echo '<a href="lista_clientes.php">Voltar</a>';
?>
