package br.com.escola.servlet;

import br.com.escola.model.Aluno;
import br.com.escola.model.AlunoDAO;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * GravaAlunoServlet.java
 * Equivalente ao gravaaluno.php.
 * Recebe POST do formulario de cadastro e grava no banco.
 *
 * Nota sobre upload de foto:
 * Em Java pre-Servlet 3.0 nao tinha getPart() - tinha que usar
 * Apache Commons FileUpload. Aqui deixamos o campo preparado mas
 * o upload de arquivo fica como comentario pra mostrar como era feito.
 */
public class GravaAlunoServlet extends HttpServlet {

    // Pasta onde salvar fotos - equivalente a "imagem/" do PHP
    private static final String PASTA_FOTOS = "/imagem/";

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Verifica sessao - igual o session_start() + if do PHP
        HttpSession session = request.getSession(false);
        if (session == null || !"ok".equals(session.getAttribute("loginok"))) {
            response.sendRedirect("erro.html");
            return;
        }

        response.setContentType("text/html; charset=UTF-8");
        PrintWriter out = response.getWriter();

        String nome  = request.getParameter("f_nome");
        String nivel = request.getParameter("f_nivel");

        // Validacao basica - equivalente ao if (empty($mnome)) do PHP
        boolean erro = false;

        if (nome == null || nome.trim().isEmpty()) {
            out.println("<b>NOME</b> nao informado!");
            erro = true;
        }

        if (nivel == null || !nivel.matches("\\d+")) {
            out.println("<br><b>NIVEL</b> invalido!");
            erro = true;
        }

        if (erro) {
            out.println("<br>O formulario apresenta erros, favor corrigir...");
            out.println("<br><a href='javascript:history.back()'>Voltar</a>");
            return;
        }

        Aluno aluno = new Aluno();
        aluno.setNome(nome.trim());
        aluno.setNivel(Integer.parseInt(nivel));

        AlunoDAO dao = new AlunoDAO();
        int idGerado = dao.inserir(aluno);

        if (idGerado > 0) {
            out.println("<b>Aluno</b> inserido com sucesso! Codigo: " + idGerado);

            /*
             * Upload de foto - era assim com Apache Commons FileUpload 1.x:
             *
             * DiskFileItemFactory factory = new DiskFileItemFactory();
             * factory.setRepository(new File(System.getProperty("java.io.tmpdir")));
             * ServletFileUpload upload = new ServletFileUpload(factory);
             * List<FileItem> items = upload.parseRequest(request);
             * for (FileItem item : items) {
             *     if (!item.isFormField() && item.getFieldName().equals("f_foto")) {
             *         if (item.getContentType().equals("image/jpeg")) {
             *             String caminho = getServletContext().getRealPath(PASTA_FOTOS)
             *                             + idGerado + ".jpg";
             *             item.write(new File(caminho));
             *             out.println("<br><b>Foto inserida com sucesso!</b>");
             *         } else {
             *             out.println("<br><b>Formato invalido! Necessario .JPEG</b>");
             *         }
             *     }
             * }
             */
            out.println("<br><b>Nenhuma foto enviada.</b>");
        } else {
            out.println("Erro na insercao do aluno.");
        }

        out.println("<br><br><a href='ListaAlunosServlet'>Ver lista de alunos</a>");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // GET exibe o formulario
        HttpSession session = request.getSession(false);
        if (session == null || !"ok".equals(session.getAttribute("loginok"))) {
            response.sendRedirect("erro.html");
            return;
        }
        request.getRequestDispatcher("/cadastro.jsp").forward(request, response);
    }
}
