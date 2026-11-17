<?php
// conexao.php
// Igual sempre foi. Sem PDO, sem nada. mysql_ mesmo.
// mysql_connect foi REMOVIDO no PHP 7. Era assim no PHP 4/5.

$conexao = mysql_connect("localhost", "root", "")
    or die("ERRO: Falha ao conectar com MySQL");

mysql_select_db("agenda_db", $conexao)
    or die("ERRO: Falha ao selecionar banco");

mysql_query("SET NAMES 'utf8'"); // pra nao vir tudo com ? no lugar do acento
?>
