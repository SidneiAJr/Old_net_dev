<?php
/*
 * excluir.php
 * Recebe ?id= via GET e exclui o contato.
 * Retorna texto puro pro JS mostrar na divMensagem.
 */
include "conexao.php";

$id = isset($_GET["id"]) ? $_GET["id"] : null;

if (!isset($id)) {
    echo "ERRO: ID nao informado!";
    exit;
}

if (!is_numeric($id)) {
    echo "ERRO: Parametro invalido!";
    exit;
}

$id = intval($id);

// Verifica se existe
$res = mysql_query("SELECT nome FROM contatos WHERE id = $id", $conexao);
if (mysql_num_rows($res) == 0) {
    echo "ERRO: Contato nao encontrado!";
    mysql_close($conexao);
    exit;
}

$linha = mysql_fetch_array($res);
$nome  = htmlspecialchars($linha["nome"]);

$ok = mysql_query("DELETE FROM contatos WHERE id = $id", $conexao);

if ($ok) {
    echo "Contato <b>$nome</b> excluido com sucesso!";
} else {
    echo "ERRO ao excluir: " . mysql_error($conexao);
}

mysql_close($conexao);
?>
