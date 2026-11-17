# Sistema Escola - Java Legado (2003/2004)

Equivalente Java do sistema PHP de cadastro de alunos.  
Feito do jeito antigo: **sem Spring, sem JPA, sem Maven, sem nada**.  
Era assim antes do Spring Boot existir. Funciona até hoje.

---

## Mapeamento PHP → Java

| PHP | Java |
|-----|------|
| `conexao.php` | `Conexao.java` — JDBC puro com `DriverManager` |
| `login.php` | `LoginServlet.java` + `login.jsp` |
| `lista.php` | `ListaAlunosServlet.java` + `lista.jsp` |
| `gravaaluno.php` | `GravaAlunoServlet.java` + `cadastro.jsp` |
| `exc_alunos.php` | `ExcluirAlunoServlet.java` |
| `.htaccess / action="arquivo.php"` | `web.xml` |
| `$_SESSION['loginok']` | `HttpSession.setAttribute("loginok", "ok")` |
| `$_POST["campo"]` | `request.getParameter("campo")` |
| `$_GET["n"]` | `request.getParameter("n")` |
| `mysqli_prepare + bind_param` | `PreparedStatement + setString/setInt` |
| `mysqli_insert_id` | `Statement.RETURN_GENERATED_KEYS` |
| `header('location:xxx')` | `response.sendRedirect("xxx")` |
| HTML inline no .php | JSP com `<%= variavel %>` e `<% codigo %>` |

---

## Estrutura do Projeto

```
/
├── login.jsp          ← formulario de login
├── lista.jsp          ← lista de alunos
├── cadastro.jsp       ← formulario de cadastro
├── erro.html          ← pagina de erro (criar manualmente)
├── WEB-INF/
│   └── web.xml        ← deployment descriptor (mapeamento de Servlets)
└── src/
    └── br/com/escola/
        ├── conexao/
        │   └── Conexao.java        ← equivalente ao conexao.php
        ├── model/
        │   ├── Aluno.java          ← JavaBean (get/set puros)
        │   └── AlunoDAO.java       ← todo o SQL aqui
        └── servlet/
            ├── LoginServlet.java
            ├── ListaAlunosServlet.java
            ├── GravaAlunoServlet.java
            └── ExcluirAlunoServlet.java
```

---

## Como rodar

**Requisitos da epoca:**
- JDK 1.4 ou 1.5
- Tomcat 4.x ou 5.x
- MySQL 4.x
- mysql-connector-java-3.x.jar no `/WEB-INF/lib/`

**Deploy:**
1. Compilar os `.java` com `javac` apontando pro `servlet-api.jar` do Tomcat
2. Copiar os `.class` para `WEB-INF/classes/br/com/escola/...`
3. Copiar o `mysql-connector.jar` para `WEB-INF/lib/`
4. Fazer o deploy do WAR no Tomcat
5. Acessar `http://localhost:8080/escola/LoginServlet`

**SQL para criar as tabelas:**
```sql
CREATE DATABASE Bd164f;
USE Bd164f;

CREATE TABLE tab_usuario (
    usu_login VARCHAR(50) NOT NULL,
    usu_senha VARCHAR(50) NOT NULL
);

CREATE TABLE alunos (
    id    INT AUTO_INCREMENT PRIMARY KEY,
    nome  VARCHAR(100) NOT NULL,
    nivel INT NOT NULL
);

INSERT INTO tab_usuario VALUES ('admin', '1234');
```

---

## Por que era assim?

- **Spring Framework** só virou popular ~2004/2005. Spring Boot chegou em 2014.
- **JPA/Hibernate** existia mas era pesado e difícil de configurar.
- **JDBC puro** era o padrão de fato pra sistemas pequenos/médios.
- **JSP com scriptlet** era a forma natural — igual PHP mas em Java.
- **web.xml** era obrigatório; `@WebServlet` só veio no Servlet 3.0 (2009).
- O padrão **DAO** era o "design pattern da moda" ensinado nas faculdades.
- Upload de arquivo exigia **Apache Commons FileUpload** — não tinha nativo.

Isso rodava em produção em banco, hospital, escola, prefeitura.  
**Era legado antes de virar legado.**
