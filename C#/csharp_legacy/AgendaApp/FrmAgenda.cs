using System;
using System.Collections;   // ArrayList - sem generics
using System.Data;
using System.Drawing;
using System.Windows.Forms;

namespace AgendaApp
{
    /// <summary>
    /// FrmAgenda.cs
    /// Formulario principal - Windows Forms, C# 1.0 / .NET 1.1 (2003)
    /// 
    /// Usa DataGrid - o controle de grade do .NET 1.x.
    /// Em .NET 2.0 (2005) ele foi substituido pelo DataGridView
    /// que era muito mais flexivel. O DataGrid era bonzao mas limitado.
    /// 
    /// Usava DataSet + DataTable pra popular o grid via databinding.
    /// DataSet era a estrela do .NET 1.0: um banco de dados em memoria,
    /// com tabelas, relacionamentos e tudo mais.
    /// A Microsoft apostava tudo nele. Hoje quase ninguem usa.
    /// </summary>
    public class FrmAgenda : System.Windows.Forms.Form
    {
        // Controles
        private System.Windows.Forms.GroupBox   grpCadastro;
        private System.Windows.Forms.Label      lblNome;
        private System.Windows.Forms.Label      lblFone;
        private System.Windows.Forms.Label      lblEmail;
        private System.Windows.Forms.TextBox    txtNome;
        private System.Windows.Forms.TextBox    txtFone;
        private System.Windows.Forms.TextBox    txtEmail;
        private System.Windows.Forms.Button     btnNovo;
        private System.Windows.Forms.Button     btnSalvar;
        private System.Windows.Forms.Button     btnExcluir;
        private System.Windows.Forms.GroupBox   grpBusca;
        private System.Windows.Forms.TextBox    txtBusca;
        private System.Windows.Forms.Button     btnBuscar;
        private System.Windows.Forms.Button     btnListarTodos;
        private System.Windows.Forms.DataGrid   dgContatos;  // o DataGrid do .NET 1.x!
        private System.Windows.Forms.StatusBar  statusBar;   // barra de status classica
        private System.Windows.Forms.StatusBarPanel pnlStatus;

        // DAO e estado
        private ContatoDAO _dao;
        private int        _idSelecionado = 0;

        public FrmAgenda()
        {
            _dao = new ContatoDAO();
            InitializeComponent();
        }

        private void InitializeComponent()
        {
            this.grpCadastro   = new System.Windows.Forms.GroupBox();
            this.lblNome       = new System.Windows.Forms.Label();
            this.lblFone       = new System.Windows.Forms.Label();
            this.lblEmail      = new System.Windows.Forms.Label();
            this.txtNome       = new System.Windows.Forms.TextBox();
            this.txtFone       = new System.Windows.Forms.TextBox();
            this.txtEmail      = new System.Windows.Forms.TextBox();
            this.btnNovo       = new System.Windows.Forms.Button();
            this.btnSalvar     = new System.Windows.Forms.Button();
            this.btnExcluir    = new System.Windows.Forms.Button();
            this.grpBusca      = new System.Windows.Forms.GroupBox();
            this.txtBusca      = new System.Windows.Forms.TextBox();
            this.btnBuscar     = new System.Windows.Forms.Button();
            this.btnListarTodos= new System.Windows.Forms.Button();
            this.dgContatos    = new System.Windows.Forms.DataGrid();
            this.statusBar     = new System.Windows.Forms.StatusBar();
            this.pnlStatus     = new System.Windows.Forms.StatusBarPanel();

            // GroupBox Cadastro
            this.grpCadastro.Text     = "Dados do Contato";
            this.grpCadastro.Location = new Point(8, 8);
            this.grpCadastro.Size     = new Size(776, 112);

            // Labels e TextBoxes
            this.lblNome.Text     = "Nome:";
            this.lblNome.Location = new Point(16, 24);
            this.lblNome.Size     = new Size(48, 16);
            this.txtNome.Location = new Point(72, 20);
            this.txtNome.Size     = new Size(240, 20);
            this.txtNome.TabIndex = 0;

            this.lblFone.Text     = "Telefone:";
            this.lblFone.Location = new Point(16, 56);
            this.lblFone.Size     = new Size(56, 16);
            this.txtFone.Location = new Point(72, 52);
            this.txtFone.Size     = new Size(120, 20);
            this.txtFone.TabIndex = 1;

            this.lblEmail.Text     = "E-mail:";
            this.lblEmail.Location = new Point(320, 24);
            this.lblEmail.Size     = new Size(48, 16);
            this.txtEmail.Location = new Point(376, 20);
            this.txtEmail.Size     = new Size(240, 20);
            this.txtEmail.TabIndex = 2;

            // Botoes
            this.btnNovo.Text     = "&Novo";
            this.btnNovo.Location = new Point(624, 20);
            this.btnNovo.Size     = new Size(64, 24);
            this.btnNovo.TabIndex = 3;
            this.btnNovo.Click   += new EventHandler(this.btnNovo_Click);

            this.btnSalvar.Text     = "&Salvar";
            this.btnSalvar.Location = new Point(624, 52);
            this.btnSalvar.Size     = new Size(64, 24);
            this.btnSalvar.TabIndex = 4;
            this.btnSalvar.Click   += new EventHandler(this.btnSalvar_Click);

            this.btnExcluir.Text     = "E&xcluir";
            this.btnExcluir.Location = new Point(700, 20);
            this.btnExcluir.Size     = new Size(64, 24);
            this.btnExcluir.TabIndex = 5;
            this.btnExcluir.Click   += new EventHandler(this.btnExcluir_Click);

            // Adiciona ao GroupBox
            this.grpCadastro.Controls.AddRange(new System.Windows.Forms.Control[] {
                lblNome, txtNome, lblFone, txtFone, lblEmail, txtEmail,
                btnNovo, btnSalvar, btnExcluir
            });
            // AddRange era o jeito de adicionar varios de uma vez - util!

            // GroupBox Busca
            this.grpBusca.Text     = "Buscar";
            this.grpBusca.Location = new Point(8, 128);
            this.grpBusca.Size     = new Size(776, 48);
            
            this.txtBusca.Location  = new Point(72, 16);
            this.txtBusca.Size      = new Size(240, 20);
            this.txtBusca.TabIndex  = 6;

            this.btnBuscar.Text     = "&Buscar";
            this.btnBuscar.Location = new Point(320, 14);
            this.btnBuscar.Size     = new Size(64, 24);
            this.btnBuscar.TabIndex = 7;
            this.btnBuscar.Click   += new EventHandler(this.btnBuscar_Click);

            this.btnListarTodos.Text     = "Listar &Todos";
            this.btnListarTodos.Location = new Point(392, 14);
            this.btnListarTodos.Size     = new Size(88, 24);
            this.btnListarTodos.TabIndex = 8;
            this.btnListarTodos.Click   += new EventHandler(this.btnListarTodos_Click);

            this.grpBusca.Controls.AddRange(new Control[] {
                txtBusca, btnBuscar, btnListarTodos
            });

            // DataGrid - o controle estrela do .NET 1.x
            // Fazia databinding automatico com DataTable
            this.dgContatos.Location        = new Point(8, 184);
            this.dgContatos.Size            = new Size(776, 320);
            this.dgContatos.TabIndex        = 9;
            this.dgContatos.ReadOnly        = true;   // somente leitura
            this.dgContatos.CaptionText     = "Contatos";
            this.dgContatos.CaptionVisible  = true;
            this.dgContatos.AllowSorting    = true;   // ordenacao por coluna gratis!
            // AllowSorting no DataGrid fazia sort automatico - era magica em 2003
            this.dgContatos.Click          += new EventHandler(this.dgContatos_Click);

            // StatusBar - barra de status classica do Windows
            this.pnlStatus.Text  = "Pronto";
            this.pnlStatus.Width = 400;
            this.statusBar.Panels.Add(this.pnlStatus);
            this.statusBar.ShowPanels = true;

            // Form
            this.Controls.AddRange(new Control[] {
                grpCadastro, grpBusca, dgContatos, statusBar
            });
            this.Text          = "Agenda de Contatos v1.0  [.NET 1.1 - 2003]";
            this.Size          = new Size(800, 580);
            this.StartPosition = FormStartPosition.CenterScreen;
            this.Load         += new EventHandler(this.FrmAgenda_Load);
            this.FormClosing  += new FormClosingEventHandler(this.FrmAgenda_FormClosing);
        }

        // ============================================================
        // FrmAgenda_Load - carrega os dados ao abrir o form
        // ============================================================
        private void FrmAgenda_Load(object sender, EventArgs e)
        {
            CarregarGrid(string.Empty);
        }

        // ============================================================
        // CarregarGrid - popula o DataGrid via DataTable
        // DataTable = tabela em memoria, o coração do .NET 1.x
        // ============================================================
        private void CarregarGrid(string filtro)
        {
            ArrayList lista;

            if (filtro == string.Empty)
                lista = _dao.ListarTodos();
            else
                lista = _dao.BuscarPorNome(filtro);

            // Monta um DataTable em memoria com os dados
            // DataGrid faz binding com DataTable automaticamente
            // Sem DataTable, o DataGrid nao funcionava com coleção customizada no .NET 1.x
            DataTable dt = new DataTable("Contatos");
            dt.Columns.Add("ID",       typeof(int));
            dt.Columns.Add("Nome",     typeof(string));
            dt.Columns.Add("Telefone", typeof(string));
            dt.Columns.Add("E-mail",   typeof(string));

            // Popula o DataTable iterando o ArrayList
            // Sem foreach tipado - tinha que fazer cast: (Contato)lista[i]
            foreach (object obj in lista)
            {
                Contato c = (Contato)obj;  // cast obrigatorio - sem generics!
                                           // se errasse o tipo: InvalidCastException
                DataRow row = dt.NewRow();
                row["ID"]       = c.Id;
                row["Nome"]     = c.Nome;
                row["Telefone"] = c.Fone;
                row["E-mail"]   = c.Email;
                dt.Rows.Add(row);
            }

            // Faz o binding - uma linha e o DataGrid se atualiza
            dgContatos.DataSource = dt;

            // Atualiza status
            pnlStatus.Text = lista.Count + " contato(s) encontrado(s)";
        }

        // ============================================================
        // dgContatos_Click - seleciona contato ao clicar no grid
        // ============================================================
        private void dgContatos_Click(object sender, EventArgs e)
        {
            DataTable dt = (DataTable)dgContatos.DataSource;
            if (dt == null) return;

            // CurrentRowIndex = linha selecionada no DataGrid
            int linha = dgContatos.CurrentRowIndex;
            if (linha < 0 || linha >= dt.Rows.Count) return;

            DataRow row    = dt.Rows[linha];
            _idSelecionado = Convert.ToInt32(row["ID"]);
            txtNome.Text   = row["Nome"].ToString();
            txtFone.Text   = row["Telefone"].ToString();
            txtEmail.Text  = row["E-mail"].ToString();

            pnlStatus.Text = "Selecionado: " + txtNome.Text;
        }

        // ============================================================
        // Eventos dos botoes
        // ============================================================

        private void btnNovo_Click(object sender, EventArgs e)
        {
            _idSelecionado = 0;
            txtNome.Text   = string.Empty;
            txtFone.Text   = string.Empty;
            txtEmail.Text  = string.Empty;
            txtNome.Focus();
            pnlStatus.Text = "Novo contato";
        }

        private void btnSalvar_Click(object sender, EventArgs e)
        {
            string nome  = txtNome.Text.Trim();
            string fone  = txtFone.Text.Trim();
            string email = txtEmail.Text.Trim();

            if (nome == string.Empty)
            {
                MessageBox.Show("Nome obrigatorio!", "Aviso",
                    MessageBoxButtons.OK, MessageBoxIcon.Warning);
                txtNome.Focus();
                return;
            }

            try
            {
                Contato c = new Contato(_idSelecionado, nome, fone, email);

                if (_idSelecionado == 0)
                {
                    int novoId = _dao.Inserir(c);
                    MessageBox.Show("Contato salvo! Codigo: " + novoId,
                        "Sucesso", MessageBoxButtons.OK, MessageBoxIcon.Information);
                }
                else
                {
                    _dao.Atualizar(c);
                    MessageBox.Show("Contato atualizado!",
                        "Sucesso", MessageBoxButtons.OK, MessageBoxIcon.Information);
                }

                CarregarGrid(string.Empty);
                btnNovo_Click(sender, e);
            }
            catch (Exception ex)
            {
                MessageBox.Show("Erro ao salvar: " + ex.Message, "Erro",
                    MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void btnExcluir_Click(object sender, EventArgs e)
        {
            if (_idSelecionado == 0)
            {
                MessageBox.Show("Selecione um contato na lista!", "Aviso",
                    MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            DialogResult resp = MessageBox.Show(
                "Excluir o contato " + txtNome.Text + "?",
                "Confirmar Exclusao",
                MessageBoxButtons.YesNo,
                MessageBoxIcon.Question
            );
            // DialogResult era o enum dos botoes do MessageBox
            // YesNo, OKCancel, AbortRetryIgnore, YesNoCancel...

            if (resp == DialogResult.No) return;

            try
            {
                bool ok = _dao.Excluir(_idSelecionado);
                if (ok)
                    MessageBox.Show("Contato excluido!", "OK",
                        MessageBoxButtons.OK, MessageBoxIcon.Information);
                else
                    MessageBox.Show("Contato nao encontrado!", "Aviso",
                        MessageBoxButtons.OK, MessageBoxIcon.Warning);

                CarregarGrid(string.Empty);
                btnNovo_Click(sender, e);
            }
            catch (Exception ex)
            {
                MessageBox.Show("Erro ao excluir: " + ex.Message, "Erro",
                    MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void btnBuscar_Click(object sender, EventArgs e)
        {
            string busca = txtBusca.Text.Trim();
            if (busca == string.Empty)
            {
                MessageBox.Show("Digite algo pra buscar!", "Aviso",
                    MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }
            CarregarGrid(busca);
        }

        private void btnListarTodos_Click(object sender, EventArgs e)
        {
            txtBusca.Text = string.Empty;
            CarregarGrid(string.Empty);
        }

        private void FrmAgenda_FormClosing(object sender, FormClosingEventArgs e)
        {
            DialogResult resp = MessageBox.Show("Deseja sair?", "Sair",
                MessageBoxButtons.YesNo, MessageBoxIcon.Question);
            if (resp == DialogResult.No)
            {
                e.Cancel = true;  // cancela o fechamento
                return;
            }
            Conexao.FecharConexao();
        }
    }
}
