# Agenda de Funcionários — Delphi 7 + IBX + Firebird 1.5 (2003)

CRUD de funcionários com cadastro de departamentos.  
Dois forms. Dois DBGrids. Uma transação. Zero ORM. Zero framework.  
**Do jeito que era.**

---

## A stack da época

```
Delphi 7 (2002)
  └── IBX (InterBase Express) — componentes visuais de banco
        └── Firebird 1.5 — banco gratuito derivado do InterBase
              └── Firebird.exe rodando como serviço no Windows
```

IBX vinha **dentro do Delphi**. Você arrastava do palette pra o form.  
Sem `npm install`. Sem `pip install`. Sem nada.  
Era só arrastar, clicar duas vezes, escrever Pascal.

---

## Como o IBX funcionava

```
TIBDatabase  →  TIBTransaction  →  TIBQuery
                                        ↓
                                   TDataSource
                                        ↓
                              DBGrid / DBEdit / DBComboBox
```

Os componentes `DB*` (DBGrid, DBEdit) **se ligavam direto ao dataset**.  
Você mudava um campo no DBEdit, o registro já estava em modo `dsEdit`.  
Dava `.Post()` e `.Commit()` — gravado no banco.

Sem ViewModel. Sem binding manual. Sem `setState`.  
O componente **era** o binding.

---

## Generators + Triggers = AUTO_INCREMENT do Firebird

No MySQL você escrevia `AUTO_INCREMENT` e acabava.  
No Firebird 1.5 não tinha isso. O "auto-increment" era:

```sql
-- 1. Criar o generator (sequência)
CREATE GENERATOR GEN_FUNC_ID;

-- 2. Criar trigger BEFORE INSERT
CREATE TRIGGER TRG_FUNC_BI FOR FUNCIONARIO
ACTIVE BEFORE INSERT POSITION 0
AS BEGIN
  IF (NEW.ID_FUNC IS NULL OR NEW.ID_FUNC = 0) THEN
    NEW.ID_FUNC = GEN_ID(GEN_FUNC_ID, 1);
END
```

Todo projeto Delphi/Firebird da época tinha esse par  
Generator + Trigger pra cada tabela com PK inteira.  
Todo mundo copiava do mesmo livro do Fabrício Araújo.

---

## A transação manual

No Delphi 7 + IBX você **gerenciava a transação na mão**:

```pascal
IBTransaction1.Commit;
IBTransaction1.StartTransaction;  // obrigatorio abrir nova apos commit
```

Se esquecesse o `StartTransaction` depois do `Commit`,  
o próximo `.Post()` explodia com `"transaction not started"`.  
Todo programador Delphi da época já viu esse erro pelo menos 10 vezes.

---

## Form Modal — o jeito certo de abrir o form filho

```pascal
var fDepto: TfrmDepto;
fDepto := TfrmDepto.Create(Self);
try
  fDepto.Banco     := IBDatabase1;   // passa a conexão
  fDepto.Transacao := IBTransaction1;
  fDepto.ShowModal;                  // trava até fechar
finally
  fDepto.Free;                       // libera memória — obrigatorio
end;
```

O erro clássico: colocar o form filho no `Application.CreateForm`  
junto com o principal. Aí abria os dois na inicialização.  
Metade dos projetos de faculdade da época fazia isso.

---

## Charset WIN1252

```pascal
IBDatabase1.Params.Add('lc_ctype=WIN1252');
```

Sem isso, acentos viravam `???????` ou `ÃÃÃ` no Firebird.  
O charset correto pra Windows Brasil era `WIN1252`.  
No Linux era `ISO8859_1`. Ninguém sabia direito a diferença.

---

## Estrutura do banco (2 tabelas)

```
DEPARTAMENTO
  ID_DEPTO   INTEGER  PK  (via Generator GEN_DEPTO_ID)
  NOME       VARCHAR(50)
  RAMAL      VARCHAR(10)

FUNCIONARIO
  ID_FUNC    INTEGER  PK  (via Generator GEN_FUNC_ID)
  NOME       VARCHAR(80)
  CARGO      VARCHAR(40)
  SALARIO    NUMERIC(10,2)
  DT_ADMISSAO DATE
  ID_DEPTO   INTEGER  FK → DEPARTAMENTO
```

---

## Autenticidade histórica garantida

- ✅ `TIBDatabase` / `TIBTransaction` / `TIBQuery` — IBX puro, sem ADO
- ✅ `{$R *.dfm}` — a diretiva que incluía o form visual compilado
- ✅ `{$R *.res}` — incluía o ícone .ico no .exe
- ✅ `Application.Initialize` antes de `CreateForm` — obrigatório no D7
- ✅ Generator + Trigger pra auto-increment no Firebird
- ✅ `lc_ctype=WIN1252` — charset Brasil
- ✅ `IBTransaction1.StartTransaction` após cada `Commit`
- ✅ `try/finally fDepto.Free` — gestão manual de memória
- ✅ `ModalResult := mrOk` pra liberar o `ShowModal`
- ✅ `ReadOnly := not aEdit` nos DBEdit — controle de estado visual
- ✅ `UPPER(F.NOME) LIKE :PBUSCA` — busca case-insensitive no Firebird
- ✅ `LEFT JOIN` na query da grade — sem ORM, SQL na mão
- ✅ Emails de terra, bol e uol nos dados de teste (autenticidade garantida)

---

## Requisitos

- Delphi 7 Enterprise ou Professional (IBX vinha com o Enterprise)
- Firebird 1.5 instalado como serviço no Windows
- IBExpert ou FlameRobin pra criar o banco (ou isql na linha de comando)

```bash
# Criar o banco e rodar o script pelo isql:
isql -user SYSDBA -password masterkey
CREATE DATABASE 'C:\Delphi7\agenda.fdb';
CONNECT 'C:\Delphi7\agenda.fdb';
# cola o banco.sql aqui

# Colocar os arquivos:
C:\Delphi7\AgendaFunc\     ← pasta do projeto
  ├── AgendaFunc.dpr
  ├── UnitFuncionario.pas + .dfm
  ├── UnitDepto.pas + .dfm
  └── agenda.fdb           ← banco fica junto com o exe
```

---

## O que falta no repositório (propositalmente)

Os arquivos `.dfm` (definição visual dos forms) **não estão aqui** —  
o DFM é binário/texto gerado pelo Form Designer do Delphi.  
Incluir um DFM falso quebraria a compilação.  
No projeto real você montava tudo arrastando componentes do palette.

Essa era a magia do Delphi: **RAD — Rapid Application Development**.  
Em 2 horas você tinha um CRUD funcionando.  
Em 2003, nenhuma outra ferramenta chegava perto disso.
