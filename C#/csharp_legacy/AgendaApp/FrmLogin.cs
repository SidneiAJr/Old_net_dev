using System;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Windows.Forms;

namespace AgendaApp
{
    /// <summary>
    /// FrmLogin.cs
    /// Formulario de Login - Windows Forms, C# 1.0 / .NET 1.1
    /// 
    /// No .NET 1.1 nao tinha "partial class" (veio no C# 2.0 / .NET 2.0).
    /// Todo o codigo do Form ficava em UM arquivo .cs:
    /// o codigo gerado pelo designer (InitializeComponent) E o codigo do programador.
    /// Era uma zona. O Visual Studio gerava umas 200 linhas de InitializeComponent
    /// e ficava tudo misturado.
    /// 
    /// A partir do .NET 2.0 (2005) separou em FrmLogin.cs + FrmLogin.Designer.cs
    /// </summary>
    public class FrmLogin : System.Windows.Forms.Form
    {
        // Controles do formulario - declarados como campos da classe
        // O designer gerava essa lista automaticamente
        private System.Windows.Forms.Label      lblUsuario;
        private System.Windows.Forms.Label      lblSenha;
        private System.Windows.Forms.TextBox    txtUsuario;
        private System.Windows.Forms.TextBox    txtSenha;
        private System.Windows.Forms.Button     btnOK;
        private System.Windows.Forms.Button     btnCancelar;
        private System.Windows.Forms.GroupBox   grpDados;

        // Propriedade publica pra o Program.cs saber se o login foi ok
        public bool LoginOK { get; private set; }  
        // "auto-property" com private set - na verdade em 1.0 era campo + property manual
        // Mas deixa assim pra ficar legivel

        public FrmLogin()
        {
            LoginOK = false;
            InitializeComponent();  // monta a interface - gerado pelo designer
        }

        // ============================================================
        // InitializeComponent - gerado pelo Visual Studio Designer
        // O programador NAO escrevia isso na mao - era gerado.
        // Aqui ta escrito pra documentar como o arquivo ficava.
        // ============================================================
        private void InitializeComponent()
        {
            // Instancia todos os controles
            this.grpDados    = new System.Windows.Forms.GroupBox();
            this.lblUsuario  = new System.Windows.Forms.Label();
            this.lblSenha    = new System.Windows.Forms.Label();
            this.txtUsuario  = new System.Windows.Forms.TextBox();
            this.txtSenha    = new System.Windows.Forms.TextBox();
            this.btnOK       = new System.Windows.Forms.Button();
            this.btnCancelar = new System.Windows.Forms.Button();

            // Configura o GroupBox
            this.grpDados.Text     = "Identificacao";
            this.grpDados.Location = new System.Drawing.Point(12, 12);
            this.grpDados.Size     = new System.Drawing.Size(360, 120);

            // Label Usuario
            this.lblUsuario.Text     = "Usuario:";
            this.lblUsuario.Location = new System.Drawing.Point(16, 28);
            this.lblUsuario.Size     = new System.Drawing.Size(64, 20);

            // TextBox Usuario
            this.txtUsuario.Location = new System.Drawing.Point(88, 24);
            this.txtUsuario.Size     = new System.Drawing.Size(256, 20);
            this.txtUsuario.TabIndex = 0;

            // Label Senha
            this.lblSenha.Text     = "Senha:";
            this.lblSenha.Location = new System.Drawing.Point(16, 64);
            this.lblSenha.Size     = new System.Drawing.Size(64, 20);

            // TextBox Senha - PasswordChar = '*' esconde o texto
            this.txtSenha.Location     = new System.Drawing.Point(88, 60);
            this.txtSenha.Size         = new System.Drawing.Size(256, 20);
            this.txtSenha.PasswordChar = '*';
            this.txtSenha.TabIndex     = 1;
            // Evento KeyPress conectado manualmente
            this.txtSenha.KeyPress += new System.Windows.Forms.KeyPressEventHandler(
                this.txtSenha_KeyPress
            );
            // += new EventHandler(...) era OBRIGATORIO em C# 1.0
            // Lambda (=>) so veio no C# 3.0 (2007):
            //   this.btnOK.Click += (s, e) => btnOK_Click(s, e);
            // Em 2003 era o delegate na mao. Era muito mais verboso.

            // Botao OK
            this.btnOK.Text        = "&OK";
            this.btnOK.Location    = new System.Drawing.Point(216, 148);
            this.btnOK.Size        = new System.Drawing.Size(72, 24);
            this.btnOK.TabIndex    = 2;
            this.btnOK.Click      += new System.EventHandler(this.btnOK_Click);

            // Botao Cancelar
            this.btnCancelar.Text     = "&Cancelar";
            this.btnCancelar.Location = new System.Drawing.Point(300, 148);
            this.btnCancelar.Size     = new System.Drawing.Size(72, 24);
            this.btnCancelar.TabIndex = 3;
            this.btnCancelar.Click   += new System.EventHandler(this.btnCancelar_Click);

            // Adiciona controles ao GroupBox e ao Form
            this.grpDados.Controls.Add(this.lblUsuario);
            this.grpDados.Controls.Add(this.txtUsuario);
            this.grpDados.Controls.Add(this.lblSenha);
            this.grpDados.Controls.Add(this.txtSenha);

            this.Controls.Add(this.grpDados);
            this.Controls.Add(this.btnOK);
            this.Controls.Add(this.btnCancelar);

            // Configuracoes do Form
            this.Text            = "Login - Agenda de Contatos";
            this.Size            = new System.Drawing.Size(400, 220);
            this.StartPosition   = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
            this.MaximizeBox     = false;
            this.MinimizeBox     = false;
            this.AcceptButton    = this.btnOK;      // Enter = clicar OK
            this.CancelButton    = this.btnCancelar; // Esc = clicar Cancelar
        }

        // ============================================================
        // Eventos - escritos pelo PROGRAMADOR, nao pelo designer
        // ============================================================

        private void btnOK_Click(object sender, System.EventArgs e)
        {
            string usuario = txtUsuario.Text.Trim();
            string senha   = txtSenha.Text.Trim();

            if (usuario == string.Empty)
            {
                MessageBox.Show("Digite o usuario!", "Aviso",
                    MessageBoxButtons.OK, MessageBoxIcon.Warning);
                txtUsuario.Focus();
                return;
            }

            if (senha == string.Empty)
            {
                MessageBox.Show("Digite a senha!", "Aviso",
                    MessageBoxButtons.OK, MessageBoxIcon.Warning);
                txtSenha.Focus();
                return;
            }

            SqlConnection conn = Conexao.GetConexao();
            SqlCommand    cmd  = null;
            SqlDataReader dr   = null;

            try
            {
                cmd = new SqlCommand(
                    "SELECT usu_senha FROM tab_usuario WHERE usu_login = @login",
                    conn
                );
                cmd.Parameters.Add(new SqlParameter("@login", usuario));

                dr = cmd.ExecuteReader();

                if (!dr.Read())
                {
                    MessageBox.Show("Usuario nao encontrado!", "Login",
                        MessageBoxButtons.OK, MessageBoxIcon.Warning);
                    dr.Close();
                    txtUsuario.Focus();
                    return;
                }

                string senhaDb = dr.GetString(0);
                dr.Close();

                if (senhaDb != senha)
                {
                    MessageBox.Show("Senha incorreta!", "Login",
                        MessageBoxButtons.OK, MessageBoxIcon.Warning);
                    txtSenha.Text = string.Empty;
                    txtSenha.Focus();
                    return;
                }

                // Login OK!
                LoginOK = true;
                this.Hide();  // esconde o form de login
            }
            catch (Exception ex)
            {
                // catch (Exception ex) generico - era o "pega tudo" da epoca
                // Hoje seria: catch (SqlException ex) mais especifico
                MessageBox.Show("Erro: " + ex.Message, "Erro",
                    MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
            finally
            {
                // finally pra garantir que fecha sempre
                if (dr  != null && !dr.IsClosed) dr.Close();
                if (cmd != null) cmd.Dispose();
            }
        }

        private void btnCancelar_Click(object sender, System.EventArgs e)
        {
            Application.Exit();  // encerra o processo inteiro
        }

        private void txtSenha_KeyPress(object sender, System.Windows.Forms.KeyPressEventArgs e)
        {
            if (e.KeyChar == (char)13)  // Enter
            {
                btnOK_Click(sender, e);
                e.Handled = true;  // consome o evento
            }
        }
    }
}
