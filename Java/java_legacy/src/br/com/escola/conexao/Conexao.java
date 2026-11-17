package br.com.escola.conexao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Conexao.java
 * Equivalente ao conexao.php - JDBC puro, sem pool, sem nada.
 * Era assim que se fazia em 2003.
 */
public class Conexao {

    private static final String DRIVER = "com.mysql.jdbc.Driver";
    private static final String URL    = "jdbc:mysql://localhost:3306/Bd164f";
    private static final String USUARIO = "root";
    private static final String SENHA   = "";

    public static Connection getConexao() {
        Connection conn = null;
        try {
            Class.forName(DRIVER); // registra o driver - obrigatorio na epoca!
            conn = DriverManager.getConnection(URL, USUARIO, SENHA);
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("Driver MySQL nao encontrado!", e);
        } catch (SQLException e) {
            throw new RuntimeException("Falha ao conectar com o banco de dados!", e);
        }
        return conn;
    }

    public static void fecharConexao(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                System.err.println("Erro ao fechar conexao: " + e.getMessage());
            }
        }
    }
}
