DROP DATABASE IF EXISTS Bd164f;
CREATE DATABASE Bd164f CHARACTER SET utf8 COLLATE utf8_general_ci;
USE Bd164f;

CREATE TABLE tab_usuario (
  id        INT AUTO_INCREMENT PRIMARY KEY,
  usu_login VARCHAR(50) NOT NULL,
  usu_senha VARCHAR(50) NOT NULL
) ENGINE=MyISAM;

CREATE TABLE alunos (
  id    INT AUTO_INCREMENT PRIMARY KEY,
  nome  VARCHAR(100) NOT NULL,
  nivel TINYINT NOT NULL,
  email VARCHAR(120) DEFAULT NULL,
  foto  VARCHAR(255) DEFAULT NULL
) ENGINE=MyISAM;

CREATE TABLE turmas (
  id        INT AUTO_INCREMENT PRIMARY KEY,
  codigo    VARCHAR(20) NOT NULL,
  descricao VARCHAR(100) NOT NULL
) ENGINE=MyISAM;

CREATE TABLE notas (
  id       INT AUTO_INCREMENT PRIMARY KEY,
  aluno_id INT NOT NULL,
  turma_id INT NOT NULL,
  nota     DECIMAL(4,1) NOT NULL
) ENGINE=MyISAM;

INSERT INTO tab_usuario (usu_login, usu_senha) VALUES
  ('admin','admin'),('professor','1234'),('secretaria','senha');

INSERT INTO alunos (nome, nivel, email, foto) VALUES
  ('Aluno Teste 01',1,'aluno01@teste.local',NULL),
  ('Aluno Teste 02',2,'aluno02@teste.local',NULL),
  ('Aluno Teste 03',3,'aluno03@teste.local',NULL),
  ('Aluno Teste 04',4,'aluno04@teste.local',NULL),
  ('Aluno Teste 05',1,'aluno05@teste.local',NULL),
  ('Aluno Teste 06',2,'aluno06@teste.local',NULL),
  ('Aluno Teste 07',3,'aluno07@teste.local',NULL),
  ('Aluno Teste 08',4,'aluno08@teste.local',NULL),
  ('Aluno Teste 09',1,'aluno09@teste.local',NULL),
  ('Aluno Teste 10',2,'aluno10@teste.local',NULL),
  ('Aluno Teste 11',3,'aluno11@teste.local',NULL),
  ('Aluno Teste 12',4,'aluno12@teste.local',NULL),
  ('Aluno Teste 13',1,'aluno13@teste.local',NULL),
  ('Aluno Teste 14',2,'aluno14@teste.local',NULL),
  ('Aluno Teste 15',3,'aluno15@teste.local',NULL),
  ('Aluno Teste 16',4,'aluno16@teste.local',NULL);

INSERT INTO turmas (codigo, descricao) VALUES
  ('T01','Ed. Basica - Manha'),('T02','Ens. Fundamental - Tarde'),
  ('T03','Ensino Medio - Manha'),('T04','Tecnico - Noite');

INSERT INTO notas (aluno_id, turma_id, nota) VALUES
  (1,1,8.5),(2,2,7.0),(3,3,9.2),(4,4,6.5),
  (5,1,10.0),(6,2,5.5),(7,3,8.0),(8,4,7.8),
  (9,1,9.5),(10,2,6.0),(11,3,7.2),(12,4,8.9),
  (13,1,4.5),(14,2,7.7),(15,3,9.9),(16,4,6.8);
