<?php
include "includes/auth.php";
include "conexao.php";
include "includes/header.php";
$cod = $_GET['cod'] ?? null;
if (!is_numeric($cod)) { echo "<div class='caixa erro'>Parametro invalido!</div>"; include "includes/footer.php"; exit; }
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $nome  = $_POST['f_nome'];
    $nivel = $_POST['f_nivel'];
    $email = $_POST['f_email'];
    $sql = "UPDATE alunos SET nome=?, nivel=?, email=? WHERE id=?";
    $stmt = mysqli_prepare($conexao, $sql);
    mysqli_stmt_bind_param($stmt, "sisi", $nome, $nivel, $email, $cod);
    mysqli_stmt_execute($stmt);
    echo "<div class='caixa ok'>Aluno atualizado!</div>";
}
$sql = "SELECT nome, nivel, email FROM alunos WHERE id=?";
$stmt = mysqli_prepare($conexao, $sql);
mysqli_stmt_bind_param($stmt, "i", $cod);
mysqli_stmt_execute($stmt);
$res = mysqli_stmt_get_result($stmt);
if (mysqli_num_rows($res) == 0) { echo "<div class='caixa erro'>Aluno nao localizado!</div>"; include "includes/footer.php"; exit; }
$l = mysqli_fetch_row($res);
?>
<div class="caixa">
<h2>Editar aluno #<?= $cod ?></h2>
<form method="post" action="editar.php?cod=<?= $cod ?>">
  <p><strong>Nome:</strong> <input type="text" name="f_nome" value="<?= htmlspecialchars($l[0]) ?>" size="40"></p>
  <p><strong>Nível:</strong>
    <select name="f_nivel">
      <?php foreach ([1=>"Ed. Basica",2=>"Ens. Fundamental",3=>"Ensino Medio",4=>"Tecnico"] as $v=>$t): ?>
        <option value="<?= $v ?>" <?= $v==$l[1]?'selected':'' ?>><?= $t ?></option>
      <?php endforeach; ?>
    </select>
  </p>
  <p><strong>Email:</strong> <input type="text" name="f_email" value="<?= htmlspecialchars($l[2] ?? '') ?>" size="40"></p>
  <input type="submit" value="Atualizar">
</form>
</div>
<?php include "includes/footer.php"; mysqli_close($conexao); ?>
