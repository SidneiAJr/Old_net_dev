<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="br.com.escola.model.Aluno" %>
<%@ page import="java.util.List" %>
<%--
    lista.jsp
    Equivalente ao HTML gerado dinamicamente pelo lista.php.
    Scriplet Java no meio do HTML - era assim, todo mundo fazia, funcionava.
    O Struts tentou acabar com isso mas nunca foi tao pratico quanto PHP inline.
--%>
<%
    // Recupera os dados que o Servlet colocou no request
    List<Aluno> lista = (List<Aluno>) request.getAttribute("listaAlunos");
    int total = (Integer) request.getAttribute("totalAlunos");
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <title>Escola XYZ - Lista de Alunos</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body>

<h2>Sistema de Alunos - Escola XYZ</h2>

<table border="1" cellpadding="4">
  <tr>
    <td><a href="ListaAlunosServlet">Todos</a></td>
    <td><a href="ListaAlunosServlet?n=1">Ed. Basica</a></td>
    <td><a href="ListaAlunosServlet?n=2">Fundamental</a></td>
    <td><a href="ListaAlunosServlet?n=3">Ensino Medio</a></td>
    <td><a href="ListaAlunosServlet?n=4">Tecnico</a></td>
  </tr>
</table>

<br>

<form method="post" action="ListaAlunosServlet">
    Buscar: <input type="text" name="f_busca" />
    <input type="submit" value="Buscar" />
</form>

<br>

<%
    if (total == 0) {
        out.println("<b>Nenhum</b> aluno encontrado");
    } else {
        for (Aluno aluno : lista) {
%>
<p>
    Codigo: <%= aluno.getId() %> |
    Nome: <%= aluno.getNome() %> |
    Nivel: <%= aluno.getNivelTexto() %> |
    <a href="ExcluirAlunoServlet?cod=<%= aluno.getId() %>"
       onclick="return confirm('Excluir aluno <%= aluno.getNome() %>?')">
       [Excluir]
    </a>
</p>
<%
        }
    }
%>

<br>
<a href="GravaAlunoServlet">[ Cadastrar Novo Aluno ]</a>
&nbsp;|&nbsp;
<a href="LoginServlet">[ Logout ]</a>

</body>
</html>
