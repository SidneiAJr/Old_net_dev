-- NOTA: Este SQL e referencia apenas.
-- Na epoca voce criava o banco clicando no Microsoft Access 2000/XP,
-- salvava como .mdb e fazia upload via FTP pro servidor IIS.
-- Nao existia "rodar migration" — era tudo na mao.

-- Estrutura da tabela eventos:
-- id        AutoNumeracao  (AutoIncrement do Access, nao e INT AUTO_INCREMENT)
-- titulo    Texto(100)     NOT NULL
-- descricao Memorando      (campo longo, equivalente ao TEXT do MySQL)
-- local     Texto(100)
-- data_ev   Data/Hora
-- horario   Texto(10)      ex: "19:30"
-- categoria Texto(30)      ex: "Show", "Palestra", "Festa"
-- contato   Texto(100)

-- Estrutura da tabela usuarios:
-- id     AutoNumeracao
-- login  Texto(50)
-- senha  Texto(50)

-- Dados iniciais:
-- usuario: admin / senha: 1234
-- 3 eventos de exemplo
