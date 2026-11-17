using System;
using System.Windows.Forms;

namespace AgendaApp
{
    /// <summary>
    /// Program.cs
    /// Ponto de entrada do executavel.
    ///
    /// C# 1.0 / .NET 1.1 - 2003
    ///
    /// Em .NET 6+ (2021) isso virou uma linha:
    ///   Application.Run(new FrmAgenda());
    /// Com "top-level statements" ficou:
    ///   Application.Run(new FrmAgenda());
    /// sem nem a classe Main.
    ///
    /// Em 2003 tinha que ter a classe + o static Main + tudo.
    /// </summary>
    class Program
    {
        /// <summary>
        /// Ponto de entrada - equivalente ao main() do C
        /// [STAThread] era OBRIGATORIO pra Windows Forms funcionar
        /// STA = Single Thread Apartment - modelo de threading do COM
        /// Sem essa annotation: InvalidOperationException ao criar controles
        /// </summary>
        [STAThread]
        static void Main(string[] args)
        {
            // Abre a conexao antes de qualquer Form
            try
            {
                Conexao.GetConexao();
            }
            catch (Exception ex)
            {
                MessageBox.Show(
                    "Nao foi possivel conectar ao banco de dados!\n\n" + ex.Message,
                    "Erro Fatal",
                    MessageBoxButtons.OK,
                    MessageBoxIcon.Error
                );
                return;  // encerra sem abrir nenhum form
            }

            // Mostra o form de login
            FrmLogin frmLogin = new FrmLogin();
            frmLogin.ShowDialog();
            // ShowDialog() = modal - bloqueia ate o form fechar
            // Show() = modeless - nao bloqueia

            // So abre a agenda se o login foi ok
            if (frmLogin.LoginOK)
            {
                // Application.Run() = loop de eventos do Windows Forms
                // Fica rodando ate o form fechar
                // Era o "event loop" do Windows - o coração de toda app Windows
                Application.Run(new FrmAgenda());
            }

            // Chega aqui quando o FrmAgenda fechar
            Conexao.FecharConexao();
        }
    }
}
