<?php
/*
 * buscar.php
 * Essa pagina nao e pra ser aberta no navegador diretamente.
 * Ela e chamada pelo XMLHttpRequest e retorna HTML puro.
 *
 * Nao tinha JSON. Nao tinha REST. O PHP jogava HTML no echo
 * e o JS colava direto no innerHTML. Era rapido, era feio, funcionava.
 */
include "conexao.php";

$nome = isset($_GET["nome"]) ? $_GET["nome"] : "";

// Sanitizacao da epoca - mysql_real_escape_string
// Nao tinha prepared statement no mysql_ (a funcao antiga)
// Era isso ou SQL injection na veia
$nome = mysql_real_escape_string($nome);

if (empty($nome)) {
    echo "<b>Digite um nome para buscar.</b>";
    exit;
}

$sql = "SELECT id, nome, fone, email FROM contatos
        WHERE nome LIKE '%$nome%'
        ORDER BY nome";

$res = mysql_query($sql, $conexao) or die("ERRO: " . mysql_error());
$total = mysql_num_rows($res);

if ($total == 0) {
    echo "<b>Nenhum</b> contato encontrado para: <i>$nome</i>";
    exit;
}

// Monta o HTML direto no echo - sem template, sem nada
// O JS vai jogar isso no innerHTML
echo "<p><b>$total</b> contato(s) encontrado(s):</p>";
echo "<table border='1' width='580'>";
echo "<tr>
        <th>Nome</th>
        <th>Telefone</th>
        <th>E-mail</th>
        <th>Acao</th>
      </tr>";

while ($linha = mysql_fetch_array($res)) {
    $id    = $linha["id"];
    $cnome = htmlspecialchars($linha["nome"]);
    $fone  = htmlspecialchars($linha["fone"]);
    $email = htmlspecialchars($linha["email"]);

    // O link chama funcao JS que esta la no index.php
    // Era assim que o HTML gerado pelo PHP "conversava" com o JS da pagina
    echo "<tr>
            <td>$cnome</td>
            <td>$fone</td>
            <td>$email</td>
            <td>
              <a href='javascript:excluirContato($id, \"$cnome\")'>[Excluir]</a>
            </td>
          </tr>";
}

echo "</table>";

mysql_free_result($res);
mysql_close($conexao);
?>
