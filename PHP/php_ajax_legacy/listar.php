<?php
/*
 * listar.php
 * Retorna HTML puro com todos os contatos.
 * Chamado pelo AJAX quando a pagina carrega ou apos salvar/excluir.
 */
include "conexao.php";

$sql = "SELECT id, nome, fone, email FROM contatos ORDER BY nome";
$res = mysql_query($sql, $conexao) or die("ERRO: " . mysql_error());
$total = mysql_num_rows($res);

if ($total == 0) {
    echo "<i>Nenhum contato cadastrado ainda.</i>";
    mysql_close($conexao);
    exit;
}

echo "<p><b>$total</b> contato(s) na agenda:</p>";
echo "<table border='1' width='580'>";
echo "<tr>
        <th>Nome</th>
        <th>Telefone</th>
        <th>E-mail</th>
        <th>Acao</th>
      </tr>";

while ($linha = mysql_fetch_array($res)) {
    $id    = $linha["id"];
    $nome  = htmlspecialchars($linha["nome"]);
    $fone  = htmlspecialchars($linha["fone"]);
    $email = htmlspecialchars($linha["email"]);

    // Cor alternada nas linhas - era o "zebra striping" da epoca
    // Hoje e CSS :nth-child(even), em 2005 era contador manual
    static $i = 0;
    $cor = ($i % 2 == 0) ? "#ffffff" : "#f0f0ff";
    $i++;

    echo "<tr bgcolor='$cor'>
            <td>$nome</td>
            <td>$fone</td>
            <td><a href='mailto:$email'>$email</a></td>
            <td>
              <a href='javascript:excluirContato($id, \"$nome\")'>[Excluir]</a>
            </td>
          </tr>";
}

echo "</table>";

mysql_free_result($res);
mysql_close($conexao);
?>
