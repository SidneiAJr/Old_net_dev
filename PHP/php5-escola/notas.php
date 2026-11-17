<?php
include "includes/auth.php";
include "conexao.php";
include "includes/header.php";
$sql = "SELECT a.nome, t.descricao, n.nota
        FROM notas n
        JOIN alunos a ON a.id = n.aluno_id
        JOIN turmas t ON t.id = n.turma_id
        ORDER BY a.nome, t.codigo";
$res = mysqli_query($conexao, $sql) or die("falha ao listar notas!");
?>
<div class="caixa">
<h2>Notas</h2>
<table>
<tr><th>Aluno</th><th>Turma</th><th>Nota</th></tr>
<?php while ($l = mysqli_fetch_row($res)): ?>
<tr>
  <td><?= htmlspecialchars($l[0]) ?></td>
  <td><?= htmlspecialchars($l[1]) ?></td>
  <td><?= number_format($l[2], 1) ?></td>
</tr>
<?php endwhile; ?>
</table>
</div>
<?php include "includes/footer.php"; mysqli_close($conexao); ?>
