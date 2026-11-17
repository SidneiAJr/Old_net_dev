CREATE DATABASE IF NOT EXISTS bd_locadora;
USE bd_locadora;

CREATE TABLE IF NOT EXISTS tab_usuario (
    id INT AUTO_INCREMENT PRIMARY KEY,
    login VARCHAR(50) NOT NULL,
    senha VARCHAR(50) NOT NULL
);
INSERT INTO tab_usuario (login, senha) VALUES ('admin', '1234');

CREATE TABLE IF NOT EXISTS filmes (
    codigo INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(100) NOT NULL,
    genero INT NOT NULL,
    ano INT NOT NULL,
    preco DECIMAL(5,2) NOT NULL,
    sinopse TEXT
);
INSERT INTO filmes (titulo, genero, ano, preco, sinopse) VALUES
('Batalha nas Estrelas', 1, 1999, 8.50, 'Nave espacial enfrenta invasores galacticos.'),
('O Detetive Fantasma', 2, 2003, 7.00, 'Detetive resolve crimes apos sua propria morte.'),
('Amor em Paris', 3, 2010, 6.50, 'Casal se apaixona durante viagem pela Europa.'),
('Corrida Mortal', 1, 2007, 9.00, 'Piloto corre para sobreviver em pista armadilhada.'),
('O Palhaco Maldito', 4, 2015, 8.00, 'Palhaco aterroriza pequena cidade no interior.'),
('Viagem ao Centro', 1, 2008, 7.50, 'Grupo descobre mundo desconhecido no subsolo.'),
('A Ultima Risada', 2, 2001, 6.00, 'Comedia policial com reviravolta inesperada.'),
('Flores de Outono', 3, 2012, 6.50, 'Drama romantico sobre segundas chances.');

CREATE TABLE IF NOT EXISTS clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    telefone VARCHAR(20),
    categoria INT NOT NULL DEFAULT 1
);
INSERT INTO clientes (nome, telefone, categoria) VALUES
('Fulano Teste', '(51) 99999-0001', 1),
('Ciclana Teste', '(51) 99999-0002', 2),
('Beltrano Teste', '(51) 99999-0003', 3);
