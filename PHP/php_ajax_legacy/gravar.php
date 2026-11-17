<?php
/*
 * gravar.php
 * Recebe os dados via POST do XMLHttpRequest e salva no banco.
 *
 * Nao retorna JSON. Retorna texto puro.
 * O JS la no index.php verifica se tem a palavra "ERRO" na resposta
 * pra saber se deu certo ou nao. Era esse o "protocolo". KKKKK
 */
include "conexao.php";

$nome  = isset($_POST["nome"])  ? trim($_POST["nome"])  : "";
$fone  = isset($_POST["fone"])  ? trim($_POST["fone"])  : "";
$email = isset($_POST["email"]) ? trim($_POST["email"]) : "";

if (empty($nome)) {
    echo "ERRO: Nome nao informado!";
    exit;
}

// Sanitizacao - mysql_real_escape_string em todos os campos
$nome  = mysql_real_escape_string($nome);
$fone  = mysql_real_escape_string($fone);
$email = mysql_real_escape_string($email);

$sql = "INSERT INTO contatos (nome, fone, email)
        VALUES ('$nome', '$fone', '$email')";

$ok = mysql_query($sql, $conexao);

if ($ok) {
    $id = mysql_insert_id($conexao);
    // Resposta de sucesso - texto puro sem a palavra ERRO
    echo "Contato <b>$nome</b> salvo com sucesso! (Codigo: $id)";
} else {
    echo "ERRO ao salvar: " . mysql_error($conexao);
}

mysql_close($conexao);
?>
