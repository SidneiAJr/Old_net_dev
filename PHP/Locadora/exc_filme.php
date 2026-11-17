<?php
session_start();
if ($_SESSION['loginok'] != 'ok') { header('location: erro.html'); exit(); }
include "conexao.php";
$cod = isset($_GET["cod"]) ? (int)$_GET["cod"] : 0;
if ($cod > 0) {
    mysqli_query($conexao, "DELETE FROM filmes WHERE codigo=$cod") or die("Erro ao excluir!");
    echo "Filme excluido com sucesso! ";
} else {
    echo "Codigo invalido! ";
}
mysqli_close($conexao);
echo '<a href="listagem.php">Voltar</a>';
?>
