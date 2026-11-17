-- banco.sql
-- Roda no MySQL 4.x ou 5.x
-- mysql -u root -p < banco.sql

CREATE DATABASE IF NOT EXISTS agenda_db;
USE agenda_db;

CREATE TABLE contatos (
    id    INT AUTO_INCREMENT PRIMARY KEY,
    nome  VARCHAR(100) NOT NULL,
    fone  VARCHAR(20),
    email VARCHAR(100)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
-- MyISAM era o padrao antes do InnoDB virar default no MySQL 5.5
-- InnoDB tinha transacao mas era mais lento pra leitura simples
-- Pra agenda nao precisava de transacao entao MyISAM mesmo

INSERT INTO contatos (nome, fone, email) VALUES
  ('Joao da Silva',   '(11) 9999-1111', 'joao@terra.com.br'),
  ('Maria Aparecida', '(11) 8888-2222', 'maria@bol.com.br'),
  ('Pedro Santos',    '(21) 7777-3333', 'pedro@uol.com.br'),
  ('Ana Paula',       '(31) 6666-4444', 'ana@ig.com.br');
-- Email de terra.com.br, bol.com.br e uol.com.br
-- Autenticidade historica garantida
