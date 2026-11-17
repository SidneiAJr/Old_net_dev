using System;
using System.Data.SqlClient;  // SqlClient = SQL Server. Sem ORM, ADO.NET puro.

namespace AgendaApp
{
    /// <summary>
    /// Conexao.cs
    /// Gerencia a conexao com o banco de dados.
    /// C# 1.0 / .NET 1.1 - 2003
    /// 
    /// Era assim antes do Entity Framework (2008), antes do Dapper (2011),
    /// antes de qualquer coisa. ADO.NET puro na veia.
    /// 
    /// A Microsoft vendia o .NET como "o VB6 evolved" -
    /// mas era muito mais complicado que o VB6. A galera reclamou.
    /// </summary>
    public class Conexao
    {
        // Connection string hard-coded - appsettings.json nao existia
        // .NET 1.1 tinha app.config (XML) mas muita gente ignorava
        // e deixava hard-coded mesmo
        private const string CONNECTION_STRING =
            "Server=localhost;" +
            "Database=AgendaDB;" +
            "User Id=sa;" +
            "Password=;";
        // "sa" sem senha - heranca do SQL Server 2000 instalado no modo rapido
        // Isso ia parar em producao. Era 2003, era assim.

        // Instancia unica da conexao - Singleton manual sem nenhum padrao formal
        // Singleton Pattern era o buzzword de 2003, todo mundo implementava na mao
        private static SqlConnection _instancia = null;

        /// <summary>
        /// Retorna a conexao aberta. Abre se estiver fechada.
        /// </summary>
        public static SqlConnection GetConexao()
        {
            // Sem lock, sem thread-safety - era aplicacao desktop single-thread
            // Em web seria desastre, mas pra Windows Forms tava bom
            if (_instancia == null)
            {
                _instancia = new SqlConnection(CONNECTION_STRING);
            }

            // Reabre se tiver fechada (timeout, queda de rede, etc)
            if (_instancia.State == System.Data.ConnectionState.Closed)
            {
                try
                {
                    _instancia.Open();
                }
                catch (SqlException ex)
                {
                    // Sem logging framework. Sem Serilog. Sem NLog.
                    // Console.WriteLine em aplicacao Windows Forms - ninguem via
                    // Era assim: ou MessageBox ou nada
                    throw new Exception("Falha ao conectar com o banco: " + ex.Message);
                }
            }

            return _instancia;
        }

        /// <summary>
        /// Fecha a conexao ao encerrar o programa.
        /// </summary>
        public static void FecharConexao()
        {
            if (_instancia != null && 
                _instancia.State != System.Data.ConnectionState.Closed)
            {
                _instancia.Close();
            }
        }
    }
}
