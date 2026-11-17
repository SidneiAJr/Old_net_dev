using System;
using System.Collections;    // ArrayList - sem generics no .NET 1.1!
using System.Data;
using System.Data.SqlClient;

namespace AgendaApp
{
    /// <summary>
    /// ContatoDAO.cs
    /// Data Access Object - todo o SQL fica aqui.
    /// 
    /// C# 1.0 / .NET 1.1 - 2003
    /// 
    /// Sem generics = sem List<T>. Usava ArrayList que guardava "object".
    /// Pra usar o objeto tinha que fazer cast: (Contato)lista[0]
    /// Se errasse o cast: InvalidCastException em runtime. Sem aviso em compile time.
    /// 
    /// Generics (List<T>) vieram no C# 2.0 / .NET 2.0 em 2005.
    /// LINQ veio no C# 3.0 em 2007. Eram outros tempos.
    /// </summary>
    public class ContatoDAO
    {
        // -------------------------------------------------------
        // ListarTodos - SELECT * com SqlDataReader
        // SqlDataReader = cursor forward-only, leitura rapida
        // Equivalente ao mysqli_fetch_row() do PHP
        // -------------------------------------------------------
        public ArrayList ListarTodos()
        {
            ArrayList lista = new ArrayList();  // sem generics, guarda object
            
            SqlConnection conn = Conexao.GetConexao();
            SqlCommand cmd = null;
            SqlDataReader dr = null;

            try
            {
                cmd = new SqlCommand(
                    "SELECT id, nome, fone, email FROM contatos ORDER BY nome",
                    conn
                );

                dr = cmd.ExecuteReader();  // executa e retorna o reader

                while (dr.Read())  // avanca linha a linha - igual o MoveNext do VB6
                {
                    Contato c = new Contato();
                    c.Id    = dr.GetInt32(0);           // coluna 0 = id (int)
                    c.Nome  = dr.GetString(1);           // coluna 1 = nome
                    c.Fone  = dr.IsDBNull(2) ? "" : dr.GetString(2);   // trata NULL
                    c.Email = dr.IsDBNull(3) ? "" : dr.GetString(3);   // trata NULL
                    // IsDBNull era OBRIGATORIO - sem isso NullReferenceException
                    // Era o & "" do VB6, so que mais verboso

                    lista.Add(c);  // adiciona como "object" no ArrayList
                }
            }
            catch (SqlException ex)
            {
                // Sem using() ainda (bem, tinha, mas muita gente nao usava)
                // Sem throw com expression - verboso na veia
                throw new Exception("Erro ao listar contatos: " + ex.Message, ex);
            }
            finally
            {
                // finally SEMPRE fechava o reader e o command
                // Era o bloco mais repetido de qualquer codigo ADO.NET 1.1
                // Hoje seria: using (var cmd = new SqlCommand(...))
                if (dr  != null && !dr.IsClosed) dr.Close();
                if (cmd != null) cmd.Dispose();
            }

            return lista;
        }

        // -------------------------------------------------------
        // BuscarPorNome - usa SqlParameter pra evitar SQL Injection
        // SqlParameter = o PreparedStatement do C# / ADO.NET
        // -------------------------------------------------------
        public ArrayList BuscarPorNome(string nome)
        {
            ArrayList lista = new ArrayList();
            
            SqlConnection conn = Conexao.GetConexao();
            SqlCommand cmd = null;
            SqlDataReader dr = null;

            try
            {
                cmd = new SqlCommand(
                    "SELECT id, nome, fone, email FROM contatos " +
                    "WHERE nome LIKE @nome ORDER BY nome",
                    conn
                );

                // SqlParameter - evita SQL Injection
                // Era a grande diferenca do C#/.NET em relacao ao PHP/VB6 da epoca:
                // a cultura de usar parametros era mais forte no mundo .NET
                cmd.Parameters.Add(new SqlParameter("@nome", "%" + nome + "%"));
                // Em C# 2.0 veio: cmd.Parameters.AddWithValue("@nome", "%" + nome + "%")
                // Que era mais curto. Em 1.1 era o New SqlParameter() na mao.

                dr = cmd.ExecuteReader();

                while (dr.Read())
                {
                    Contato c = new Contato();
                    c.Id    = dr.GetInt32(0);
                    c.Nome  = dr.GetString(1);
                    c.Fone  = dr.IsDBNull(2) ? "" : dr.GetString(2);
                    c.Email = dr.IsDBNull(3) ? "" : dr.GetString(3);
                    lista.Add(c);
                }
            }
            catch (SqlException ex)
            {
                throw new Exception("Erro ao buscar contatos: " + ex.Message, ex);
            }
            finally
            {
                if (dr  != null && !dr.IsClosed) dr.Close();
                if (cmd != null) cmd.Dispose();
            }

            return lista;
        }

        // -------------------------------------------------------
        // Inserir - retorna o ID gerado
        // -------------------------------------------------------
        public int Inserir(Contato contato)
        {
            SqlConnection conn = Conexao.GetConexao();
            SqlCommand cmd = null;
            int idGerado = 0;

            try
            {
                // SCOPE_IDENTITY() retorna o ultimo ID gerado na sessao atual
                // Era o mysql_insert_id() do PHP, so que SQL Server
                cmd = new SqlCommand(
                    "INSERT INTO contatos (nome, fone, email) " +
                    "VALUES (@nome, @fone, @email); " +
                    "SELECT SCOPE_IDENTITY();",   // pega o ID em um unico roundtrip
                    conn
                );

                cmd.Parameters.Add(new SqlParameter("@nome",  contato.Nome));
                cmd.Parameters.Add(new SqlParameter("@fone",  contato.Fone));
                cmd.Parameters.Add(new SqlParameter("@email", contato.Email));

                // ExecuteScalar = executa e retorna o primeiro valor da primeira coluna
                // Perfeito pro SELECT SCOPE_IDENTITY()
                object resultado = cmd.ExecuteScalar();
                
                if (resultado != null && resultado != DBNull.Value)
                {
                    // Convert.ToInt32 era mais seguro que cast direto
                    // (int)resultado explodia se fosse decimal
                    idGerado = Convert.ToInt32(resultado);
                }
            }
            catch (SqlException ex)
            {
                throw new Exception("Erro ao inserir contato: " + ex.Message, ex);
            }
            finally
            {
                if (cmd != null) cmd.Dispose();
            }

            return idGerado;
        }

        // -------------------------------------------------------
        // Atualizar
        // -------------------------------------------------------
        public void Atualizar(Contato contato)
        {
            SqlConnection conn = Conexao.GetConexao();
            SqlCommand cmd = null;

            try
            {
                cmd = new SqlCommand(
                    "UPDATE contatos SET " +
                    "nome  = @nome, " +
                    "fone  = @fone, " +
                    "email = @email " +
                    "WHERE id = @id",
                    conn
                );

                cmd.Parameters.Add(new SqlParameter("@nome",  contato.Nome));
                cmd.Parameters.Add(new SqlParameter("@fone",  contato.Fone));
                cmd.Parameters.Add(new SqlParameter("@email", contato.Email));
                cmd.Parameters.Add(new SqlParameter("@id",    contato.Id));

                // ExecuteNonQuery = INSERT, UPDATE, DELETE - nao retorna linhas
                int linhasAfetadas = cmd.ExecuteNonQuery();
                
                if (linhasAfetadas == 0)
                {
                    // Nenhuma linha afetada = ID nao existe
                    throw new Exception("Contato nao encontrado para atualizacao!");
                }
            }
            catch (SqlException ex)
            {
                throw new Exception("Erro ao atualizar contato: " + ex.Message, ex);
            }
            finally
            {
                if (cmd != null) cmd.Dispose();
            }
        }

        // -------------------------------------------------------
        // Excluir
        // -------------------------------------------------------
        public bool Excluir(int id)
        {
            SqlConnection conn = Conexao.GetConexao();
            SqlCommand cmd = null;

            try
            {
                cmd = new SqlCommand(
                    "DELETE FROM contatos WHERE id = @id",
                    conn
                );
                cmd.Parameters.Add(new SqlParameter("@id", id));

                int linhasAfetadas = cmd.ExecuteNonQuery();
                return linhasAfetadas > 0;  // true = excluiu, false = nao encontrou
            }
            catch (SqlException ex)
            {
                throw new Exception("Erro ao excluir contato: " + ex.Message, ex);
            }
            finally
            {
                if (cmd != null) cmd.Dispose();
            }
        }
    }
}
