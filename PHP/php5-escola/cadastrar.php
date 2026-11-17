<?php
include "includes/auth.php";
include "conexao.php";
include "includes/header.php";
$erro = false;
$mnome  = $_POST["f_nome"]  ?? '';
$mnivel = $_POST["f_nivel"] ?? '';
$memail = $_POST["f_email"] ?? '';
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (empty($mnome)) {
        echo "<div class='caixa erro'><b>NOME</b> nao informado!</div>";
        $erro = true;
    }
    if ($erro) {
        echo "<div class='caixa erro'>O formulario apresenta erros, favor corrigir...</div>";
    } else {
        $sql = "INSERT INTO alunos (nome, nivel, email) VALUES (?, ?, ?)";
        $stmt = mysqli_prepare($conexao, $sql);
        mysqli_stmt_bind_param($stmt, "sis", $mnome, $mnivel, $memail);
        if (mysqli_stmt_execute($stmt)) {
            $novo = mysqli_insert_id($conexao);
            echo "<div class='caixa ok'><b>Aluno</b> inserido com sucesso! (id=$novo)</div>";
        } else {
            echo "<div class='caixa erro'>Erro na insercao: " . mysqli_error($conexao) . "</div>";
        }
    }
}
?>
<div class="caixa">
<h2>Cadastrar aluno</h2>
<form method="post" action="cadastrar.php">
  <p><strong>Nome:</strong> <input type="text" name="f_nome" size="40"></p>
  <p><strong>Nível:</strong>
    <select name="f_nivel">
      <option value="1">Ed. Basica</option>
      <option value="2">Ens. Fundamental</option>
      <option value="3">Ensino Medio</option>
      <option value="4">Tecnico</option>
    </select>
  </p>
  <p><strong>Email:</strong> <input type="text" name="f_email" size="40"></p>
  <input type="submit" value="Salvar">
</form>
</div>
<?php include "includes/footer.php"; mysqli_close($conexao); ?>
