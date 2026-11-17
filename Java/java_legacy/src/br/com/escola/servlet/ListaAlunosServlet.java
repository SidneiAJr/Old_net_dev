package br.com.escola.servlet;

import br.com.escola.model.Aluno;
import br.com.escola.model.AlunoDAO;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * ListaAlunosServlet.java
 * Equivalente ao lista.php.
 * Faz o papel de "controller" - busca os dados e joga pro JSP renderizar.
 * Era assim o MVC caseiro de 2004: Servlet processa, JSP mostra.
 */
public class ListaAlunosServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processar(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processar(request, response);
    }

    private void processar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Verifica sessao - equivalente ao if ($_SESSION['loginok'] != 'ok')
        HttpSession session = request.getSession(false);
        if (session == null || !"ok".equals(session.getAttribute("loginok"))) {
            response.sendRedirect("erro.html");
            return;
        }

        AlunoDAO dao = new AlunoDAO();
        List<Aluno> lista;

        // Verifica parametro ?n= (filtro por nivel) - igual o $_GET["n"] do PHP
        String paramNivel = request.getParameter("n");
        String paramBusca = request.getParameter("f_busca");

        if (paramNivel != null && paramNivel.matches("\\d+")) {
            int nivel = Integer.parseInt(paramNivel);
            lista = dao.listarPorNivel(nivel);
        } else if (paramBusca != null && !paramBusca.trim().isEmpty()) {
            lista = dao.buscarPorNome(paramBusca.trim());
        } else {
            lista = dao.listarTodos();
        }

        // Coloca a lista no request pra o JSP usar - equivalente a montar o HTML inline
        request.setAttribute("listaAlunos", lista);
        request.setAttribute("totalAlunos", lista.size());

        // Forward pro JSP - o JSP e o HTML do PHP, so que separado
        request.getRequestDispatcher("/lista.jsp").forward(request, response);
    }
}
