<?php
include "includes/auth.php";
include "conexao.php";
include "includes/header.php";
$sql = "SELECT id, nome, nivel, email FROM alunos ORDER BY nome";
$res = mysqli_query($conexao, $sql) or die("falha ao selecionar alunos!");
$niveis = [1=>"Ed. Basica",2=>"Ens. Fundamental",3=>"Ensino Medio",4=>"Tecnico"];
?>
<div class="caixa">
<h2>Alunos cadastrados (<?= mysqli_num_rows($res) ?>)</h2>
<table>
<tr><th>Cód</th><th>Nome</th><th>Nível</th><th>Email</th><th>Ações</th></tr>
<?php while ($l = mysqli_fetch_row($res)): ?>
<tr>
  <td><?= $l[0] ?></td>
  <td><?= htmlspecialchars($l[1]) ?></td>
  <td><?= $niveis[$l[2]] ?? '?' ?></td>
  <td><?= htmlspecialchars($l[3] ?? '') ?></td>
  <td>
    <a href="editar.php?cod=<?= $l[0] ?>">Editar</a> |
    <a href="excluir.php?cod=<?= $l[0] ?>" onclick="return confirm('Excluir?')">Excluir</a>
  </td>
</tr>
<?php endwhile; ?>
</table>
</div>
<?php include "includes/footer.php"; mysqli_close($conexao); ?>
