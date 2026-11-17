package br.com.escola.servlet;

import br.com.escola.model.AlunoDAO;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * ExcluirAlunoServlet.java
 * Equivalente ao exc_alunos.php.
 * Recebe o ?cod= pela URL e exclui o aluno - GET mesmo, do jeito errado
 * que todo mundo fazia na epoca. REST era coisa de artigo academico.
 */
public class ExcluirAlunoServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Verifica sessao - equivalente ao session_start() + if do PHP
        HttpSession session = request.getSession(false);
        if (session == null || !"ok".equals(session.getAttribute("loginok"))) {
            response.sendRedirect("erro.html");
            return;
        }

        response.setContentType("text/html; charset=UTF-8");
        PrintWriter out = response.getWriter();

        String paramCod = request.getParameter("cod");

        // Equivalente ao if (!isset($idaluno)) do PHP
        if (paramCod == null) {
            out.println("Aluno nao informado!");
            return;
        }

        // Equivalente ao elseif (!is_numeric($idaluno)) do PHP
        if (!paramCod.matches("\\d+")) {
            out.println("Parametro invalido!");
            return;
        }

        int id = Integer.parseInt(paramCod);

        AlunoDAO dao = new AlunoDAO();
        boolean excluido = dao.excluir(id);

        if (excluido) {
            out.println("Aluno excluido com sucesso!");
        } else {
            out.println("Aluno nao localizado!");
        }

        out.println("<br><br><a href='ListaAlunosServlet'>Voltar para lista</a>");
    }
}
