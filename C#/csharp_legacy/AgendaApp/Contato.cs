using System;

namespace AgendaApp
{
    /// <summary>
    /// Contato.cs
    /// Classe de modelo - o "JavaBean" do C# 1.0
    /// 
    /// Nao tinha:
    /// - Propriedades automaticas (veio no C# 3.0, 2007):  public string Nome { get; set; }
    /// - Records (C# 9.0, 2020)
    /// - Nullable reference types (C# 8.0, 2019)
    /// 
    /// Tinha que escrever campo privado + propriedade na mao.
    /// Todo mundo escrevia, todo mundo odiava, mas era o jeito.
    /// O Visual Studio tinha snippet "prop" mas gerava tudo na mao mesmo.
    /// </summary>
    public class Contato
    {
        // Campos privados - a convencao da epoca era underscore + minuscula
        // Hoje seria _nome, mas em 2003 tinha guerra entre _nome e m_nome (m de member)
        private int    _id;
        private string _nome;
        private string _fone;
        private string _email;

        // Construtor vazio - obrigatorio pra funcionar com DataGrid e databinding
        public Contato()
        {
            _id    = 0;
            _nome  = string.Empty;  // string.Empty era "mais correto" que ""
            _fone  = string.Empty;  // causava debate eterno em forum
            _email = string.Empty;
        }

        // Construtor com parametros - pra criar ja populado
        public Contato(int id, string nome, string fone, string email)
        {
            _id    = id;
            _nome  = nome;
            _fone  = fone;
            _email = email;
        }

        // Propriedades - getter e setter escritos a mao
        // Em C# 3.0 (2007) isso virou: public int Id { get; set; }
        // Em 2003 era isso aqui. Linhas e linhas de codigo boilerplate.
        
        public int Id
        {
            get { return _id; }
            set { _id = value; }
        }

        public string Nome
        {
            get { return _nome; }
            set { _nome = value; }
        }

        public string Fone
        {
            get { return _fone; }
            set { _fone = value; }
        }

        public string Email
        {
            get { return _email; }
            set { _email = value; }
        }

        /// <summary>
        /// ToString() - sobrescrito pra debug e para usar em ListBox
        /// Em 2003 nao tinha expression bodied members (C# 6.0):
        ///   public override string ToString() => _nome;
        /// Tinha que ser o bloco completo.
        /// </summary>
        public override string ToString()
        {
            return _nome;
        }
    }
}
