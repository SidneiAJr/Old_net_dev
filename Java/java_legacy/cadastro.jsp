<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    cadastro.jsp
    Formulario de cadastro de aluno - equivalente ao form que chama gravaaluno.php.
--%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <title>Escola XYZ - Cadastrar Aluno</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body>

<h2>Cadastrar Novo Aluno</h2>

<form method="post" action="GravaAlunoServlet" enctype="multipart/form-data">

    <table border="0" cellpadding="4">
        <tr>
            <td><b>Nome:</b></td>
            <td><input type="text" name="f_nome" size="40" /></td>
        </tr>
        <tr>
            <td><b>Nivel:</b></td>
            <td>
                <select name="f_nivel">
                    <option value="1">Ed. Basica</option>
                    <option value="2">Ens. Fundamental</option>
                    <option value="3">Ensino Medio</option>
                    <option value="4">Tecnico</option>
                </select>
            </td>
        </tr>
        <tr>
            <td><b>Foto:</b></td>
            <td><input type="file" name="f_foto" /></td>
        </tr>
        <tr>
            <td colspan="2">
                <input type="submit" value="Gravar" />
                &nbsp;
                <a href="ListaAlunosServlet">Cancelar</a>
            </td>
        </tr>
    </table>

</form>

</body>
</html>
