/* ============================================================
   banco.sql  -  Agenda de Funcionarios
   Firebird 1.5 / 2.0  (ibexpert, flamerobin ou isql)
   Delphi 7 + IBX ou BDE + Interbase
   ============================================================
   Como rodar no isql:
     isql -user SYSDBA -password masterkey
     CREATE DATABASE 'C:\Delphi7\agenda.fdb';
     CONNECT 'C:\Delphi7\agenda.fdb';
     (cola o script abaixo)
   ============================================================ */

/* -- Tabela 1: Departamentos -- */
CREATE TABLE DEPARTAMENTO (
  ID_DEPTO    INTEGER      NOT NULL,
  NOME        VARCHAR(50)  NOT NULL,
  RAMAL       VARCHAR(10),
  CONSTRAINT PK_DEPTO PRIMARY KEY (ID_DEPTO)
);

/* Generator = equivalente ao AUTO_INCREMENT do MySQL na epoca */
CREATE GENERATOR GEN_DEPTO_ID;
SET GENERATOR GEN_DEPTO_ID TO 0;

/* Trigger pra simular auto-increment - todo projeto Delphi/Firebird tinha isso */
SET TERM ^ ;
CREATE TRIGGER TRG_DEPTO_BI FOR DEPARTAMENTO
ACTIVE BEFORE INSERT POSITION 0
AS BEGIN
  IF (NEW.ID_DEPTO IS NULL OR NEW.ID_DEPTO = 0) THEN
    NEW.ID_DEPTO = GEN_ID(GEN_DEPTO_ID, 1);
END^
SET TERM ; ^

/* -- Tabela 2: Funcionarios -- */
CREATE TABLE FUNCIONARIO (
  ID_FUNC     INTEGER      NOT NULL,
  NOME        VARCHAR(80)  NOT NULL,
  CARGO       VARCHAR(40),
  SALARIO     NUMERIC(10,2),
  DT_ADMISSAO DATE,
  ID_DEPTO    INTEGER,
  CONSTRAINT PK_FUNC    PRIMARY KEY (ID_FUNC),
  CONSTRAINT FK_DEPTO   FOREIGN KEY (ID_DEPTO) REFERENCES DEPARTAMENTO (ID_DEPTO)
);

CREATE GENERATOR GEN_FUNC_ID;
SET GENERATOR GEN_FUNC_ID TO 0;

SET TERM ^ ;
CREATE TRIGGER TRG_FUNC_BI FOR FUNCIONARIO
ACTIVE BEFORE INSERT POSITION 0
AS BEGIN
  IF (NEW.ID_FUNC IS NULL OR NEW.ID_FUNC = 0) THEN
    NEW.ID_FUNC = GEN_ID(GEN_FUNC_ID, 1);
END^
SET TERM ; ^

/* -- Dados de teste -- */
INSERT INTO DEPARTAMENTO (ID_DEPTO, NOME, RAMAL) VALUES (1, 'Informatica',    '201');
INSERT INTO DEPARTAMENTO (ID_DEPTO, NOME, RAMAL) VALUES (2, 'Administrativo', '100');
INSERT INTO DEPARTAMENTO (ID_DEPTO, NOME, RAMAL) VALUES (3, 'Financeiro',     '150');

INSERT INTO FUNCIONARIO (ID_FUNC, NOME, CARGO, SALARIO, DT_ADMISSAO, ID_DEPTO)
  VALUES (1, 'Joao Carlos Silva',   'Analista',      1800.00, '15.03.2001', 1);
INSERT INTO FUNCIONARIO (ID_FUNC, NOME, CARGO, SALARIO, DT_ADMISSAO, ID_DEPTO)
  VALUES (2, 'Maria Aparecida',     'Secretaria',    1200.00, '01.07.2000', 2);
INSERT INTO FUNCIONARIO (ID_FUNC, NOME, CARGO, SALARIO, DT_ADMISSAO, ID_DEPTO)
  VALUES (3, 'Roberto Figueiredo',  'Programador',   1600.00, '10.11.2003', 1);
INSERT INTO FUNCIONARIO (ID_FUNC, NOME, CARGO, SALARIO, DT_ADMISSAO, ID_DEPTO)
  VALUES (4, 'Ana Paula Souza',     'Aux. Contabil', 950.00,  '22.02.2004', 3);

COMMIT;
