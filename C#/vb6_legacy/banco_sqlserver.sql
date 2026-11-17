-- banco_sqlserver.sql
-- SQL Server 2000 - o banco que todo sistema VB6 usava
-- Roda no Query Analyzer (a ferramenta da epoca, antes do SSMS)

-- Cria o banco
CREATE DATABASE AgendaDB
GO

USE AgendaDB
GO

-- Tabela de usuarios
CREATE TABLE tab_usuario (
    usu_login VARCHAR(50)  NOT NULL,
    usu_senha VARCHAR(50)  NOT NULL  -- senha em texto puro, era normal em 2000
)
GO

-- Tabela de contatos
-- Nao tinha AUTO_INCREMENT no SQL Server - era IDENTITY
CREATE TABLE contatos (
    id    INT           IDENTITY(1,1) PRIMARY KEY,  -- IDENTITY = AUTO_INCREMENT
    nome  VARCHAR(100)  NOT NULL,
    fone  VARCHAR(20)   NULL,
    email VARCHAR(100)  NULL
)
GO

-- Dados de teste
INSERT INTO tab_usuario VALUES ('admin', '1234')
GO

INSERT INTO contatos (nome, fone, email) VALUES ('Joao da Silva',   '(11) 9999-1111', 'joao@terra.com.br')
INSERT INTO contatos (nome, fone, email) VALUES ('Maria Aparecida', '(11) 8888-2222', 'maria@bol.com.br')
INSERT INTO contatos (nome, fone, email) VALUES ('Pedro Santos',    '(21) 7777-3333', 'pedro@uol.com.br')
GO
-- GO separava os batches no SQL Server - sem GO as vezes nao executava
-- Era o ; do MySQL mas separava blocos inteiros, nao statements
