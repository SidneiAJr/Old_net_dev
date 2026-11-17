<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Locadora FilmMax - Login</title>
<style type="text/css">
body{background-color:#1a1a2e;color:#e0e0e0;font-family:Verdana,Arial,sans-serif;}
table{background-color:#16213e;border-color:#0f3460;}
td{color:#e0e0e0;padding:8px;}
input[type=text],input[type=password]{background:#0f3460;color:#e0e0e0;border:1px solid #533483;padding:4px;}
input[type=submit]{background:#533483;color:#fff;border:none;padding:5px 14px;cursor:pointer;}
h2{color:#e94560;}
</style>
</head>
<body>
<table width="400" border="2" align="center">
  <tr><td align="center"><h2>Locadora FilmMax</h2><p>Acesso Administrativo</p></td></tr>
</table>
<br />
<table width="400" border="2" align="center">
  <tr>
    <td>
      <form action="processa_login.php" method="post" name="frmLogin">
        <p>Usuário:<br /><input type="text" name="f_usuario" size="30" /></p>
        <p>Senha:<br /><input type="password" name="f_senha" size="30" /></p>
        <p><input type="submit" value="Entrar" /> <input type="reset" value="Limpar" /></p>
      </form>
    </td>
  </tr>
</table>
</body>
</html>
