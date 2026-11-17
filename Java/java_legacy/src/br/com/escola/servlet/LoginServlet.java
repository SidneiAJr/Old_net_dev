package br.com.escola.servlet;

import br.com.escola.conexao.Conexao;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * LoginServlet.java
 * Equivalente ao login.php.
 * HttpServlet puro - sem Spring MVC, sem annotation de rota (pre-Servlet 3.0).
 * O mapeamento vai no web.xml, do jeito antigo.
 */
public class LoginServlet extends HttpServlet {

    // GET - exibe o formulario de login (igual o HTML inline do login.php)
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Na epoca era comum redirecionar pro JSP ou ter HTML inline no Servlet
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    // POST - processa o login
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String usuario = request.getParameter("f_usuario");
        String senha   = request.getParameter("f_senha");

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = Conexao.getConexao();
            String sql = "SELECT usu_login, usu_senha FROM tab_usuario WHERE usu_login = ?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, usuario);
            rs = ps.executeQuery();

            if (!rs.next()) {
                // Nenhum usuario encontrado - equivalente ao header('location:erro.html')
                response.sendRedirect("erro.html");
                return;
            }

            String senhaDb = rs.getString("usu_senha");
            if (!senhaDb.equals(senha)) {
                response.sendRedirect("erro.html");
                return;
            }

            // Login ok - cria sessao, equivalente ao $_SESSION['loginok'] = 'ok'
            HttpSession session = request.getSession();
            session.setAttribute("loginok", "ok");
            response.sendRedirect("ListaAlunosServlet");

        } catch (SQLException e) {
            throw new ServletException("Erro ao verificar login!", e);
        } finally {
            fechar(rs, ps);
            Conexao.fecharConexao(conn);
        }
    }

    private void fechar(ResultSet rs, PreparedStatement ps) {
        if (rs != null) try { rs.close(); } catch (SQLException e) {}
        if (ps != null) try { ps.close(); } catch (SQLException e) {}
    }
}
