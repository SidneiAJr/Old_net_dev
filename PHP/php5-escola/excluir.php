<?php
include "includes/auth.php";
include "conexao.php";
include "includes/header.php";
$cod = $_GET['cod'] ?? null;
if (!is_numeric($cod)) {
    echo "<div class='caixa erro'>Parametro invalido!</div>";
} else {
    $sql = "DELETE FROM alunos WHERE id=?";
    $stmt = mysqli_prepare($conexao, $sql);
    mysqli_stmt_bind_param($stmt, "i", $cod);
    mysqli_stmt_execute($stmt);
    echo "<div class='caixa ok'>Aluno excluido com sucesso!</div>";
    echo "<div class='caixa'><a href='listar.php'>Voltar</a></div>";
}
include "includes/footer.php"; mysqli_close($conexao);
?>
