<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    login.jsp
    Equivalente ao HTML inline do login.php.
    JSP era o "template engine" da epoca - misturava Java com HTML igual o PHP.
    Hoje a gente usa React, Thymeleaf, etc. Em 2003 era isso aqui.
--%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <title>Escola XYZ - Login</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body>

<table width="712" height="93" border="2" cellpadding="4" cellspacing="0">
  <tr>
    <td width="182" rowspan="2">
      <%-- Sem a imagem aqui, mas o espaco ta reservado igual o PHP --%>
      <b>[Logo Escola]</b>
    </td>
    <td width="512"><strong>Escola XYZ</strong></td>
  </tr>
  <tr>
    <td>
      <%-- action aponta pro Servlet - equivalente ao action="login.php" --%>
      <form id="form1" name="form1" method="post" action="LoginServlet">
        <p><strong>Usuario: <input type="text" name="f_usuario" /></strong></p>
        <p><strong>Senha:   <input type="password" name="f_senha" /></strong>
          <input type="submit" value="OK" />
        </p>
      </form>
    </td>
  </tr>
</table>

</body>
</html>
