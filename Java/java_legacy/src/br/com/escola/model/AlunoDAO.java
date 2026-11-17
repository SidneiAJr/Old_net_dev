package br.com.escola.model;

import br.com.escola.conexao.Conexao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

/**
 * AlunoDAO.java
 * DAO = Data Access Object - padrao que era a "bola da vez" em 2003/2004.
 * Todo o SQL fica aqui, igual os arquivos PHP separados por funcao.
 * PreparedStatement puro - sem Hibernate, sem JPA, sem absolutamente nada.
 */
public class AlunoDAO {

    // -------------------------------------------------------
    // Equivalente ao lista.php - SELECT todos os alunos
    // -------------------------------------------------------
    public List<Aluno> listarTodos() {
        List<Aluno> lista = new ArrayList<Aluno>();
        Connection conn   = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = Conexao.getConexao();
            String sql = "SELECT id, nome, nivel FROM alunos ORDER BY nome";
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                Aluno a = new Aluno();
                a.setId(rs.getInt("id"));
                a.setNome(rs.getString("nome"));
                a.setNivel(rs.getInt("nivel"));
                lista.add(a);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Falha ao listar alunos!", e);
        } finally {
            // finally era OBRIGATORIO antes do try-with-resources (Java 7)
            fechar(rs, ps);
            Conexao.fecharConexao(conn);
        }
        return lista;
    }

    // -------------------------------------------------------
    // Busca por nome - equivalente ao f_busca do lista.php
    // -------------------------------------------------------
    public List<Aluno> buscarPorNome(String nome) {
        List<Aluno> lista = new ArrayList<Aluno>();
        Connection conn   = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = Conexao.getConexao();
            String sql = "SELECT id, nome, nivel FROM alunos WHERE nome LIKE ? ORDER BY nome";
            ps = conn.prepareStatement(sql);
            ps.setString(1, "%" + nome + "%");
            rs = ps.executeQuery();

            while (rs.next()) {
                Aluno a = new Aluno();
                a.setId(rs.getInt("id"));
                a.setNome(rs.getString("nome"));
                a.setNivel(rs.getInt("nivel"));
                lista.add(a);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Falha ao buscar alunos!", e);
        } finally {
            fechar(rs, ps);
            Conexao.fecharConexao(conn);
        }
        return lista;
    }

    // -------------------------------------------------------
    // Filtra por nivel - equivalente ao ?n= do lista.php
    // -------------------------------------------------------
    public List<Aluno> listarPorNivel(int nivel) {
        List<Aluno> lista = new ArrayList<Aluno>();
        Connection conn   = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = Conexao.getConexao();
            String sql = "SELECT id, nome, nivel FROM alunos WHERE nivel = ? ORDER BY nome";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, nivel);
            rs = ps.executeQuery();

            while (rs.next()) {
                Aluno a = new Aluno();
                a.setId(rs.getInt("id"));
                a.setNome(rs.getString("nome"));
                a.setNivel(rs.getInt("nivel"));
                lista.add(a);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Falha ao listar por nivel!", e);
        } finally {
            fechar(rs, ps);
            Conexao.fecharConexao(conn);
        }
        return lista;
    }

    // -------------------------------------------------------
    // Inserir aluno - equivalente ao gravaaluno.php
    // -------------------------------------------------------
    public int inserir(Aluno aluno) {
        Connection conn  = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        int idGerado = 0;

        try {
            conn = Conexao.getConexao();
            String sql = "INSERT INTO alunos (nome, nivel) VALUES (?, ?)";
            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, aluno.getNome());
            ps.setInt(2, aluno.getNivel());
            ps.executeUpdate();

            // Pega o ID gerado - equivalente ao mysqli_insert_id do PHP
            rs = ps.getGeneratedKeys();
            if (rs.next()) {
                idGerado = rs.getInt(1);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Falha ao inserir aluno!", e);
        } finally {
            fechar(rs, ps);
            Conexao.fecharConexao(conn);
        }
        return idGerado;
    }

    // -------------------------------------------------------
    // Excluir aluno - equivalente ao exc_alunos.php
    // -------------------------------------------------------
    public boolean excluir(int id) {
        Connection conn  = null;
        PreparedStatement ps = null;

        try {
            conn = Conexao.getConexao();

            // Verifica se existe antes - igual o SELECT antes do DELETE do PHP
            String sqlCheck = "SELECT id FROM alunos WHERE id = ?";
            ps = conn.prepareStatement(sqlCheck);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (!rs.next()) {
                return false; // Aluno nao localizado
            }
            rs.close();
            ps.close();

            String sql = "DELETE FROM alunos WHERE id = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ps.executeUpdate();
            return true;
        } catch (SQLException e) {
            throw new RuntimeException("Falha ao excluir aluno!", e);
        } finally {
            fechar(null, ps);
            Conexao.fecharConexao(conn);
        }
    }

    // -------------------------------------------------------
    // Metodo utilitario pra fechar ResultSet e PreparedStatement
    // Era repetido em todo DAO da epoca
    // -------------------------------------------------------
    private void fechar(ResultSet rs, PreparedStatement ps) {
        if (rs != null) {
            try { rs.close(); } catch (SQLException e) { /* ignora */ }
        }
        if (ps != null) {
            try { ps.close(); } catch (SQLException e) { /* ignora */ }
        }
    }
}
