# Agenda de Eventos — ASP Clássico + VBScript + ADO + Access

**Período:** ~2001  
**Stack:** ASP Clássico / VBScript / ADO (ActiveX Data Objects) / Microsoft Access (.mdb)  
**Servidor:** IIS 5.0 (Windows 2000 Server) ou IIS 6.0 (Windows Server 2003)  
**Status:** ?? Morto — Jet.OLEDB.4.0 não funciona em Windows 64-bit moderno

---

## Contexto histórico

Em 2001, o mercado web corporativo no Brasil se dividia em dois mundos:

- **PHP + Apache + MySQL** — open source, barato, rodava em qualquer hospedagem Linux
- **ASP Clássico + IIS + Access/SQL Server** — stack Microsoft, mais "enterprise", mais caro

O ASP Clássico era a escolha natural de empresas que já usavam VB6 e Office — a linguagem era VBScript, praticamente igual ao Visual Basic, e o banco padrão em hospedagens pequenas era o Access, que a secretária já conhecia. Pagar uma licença SQL Server era pra empresa grande.

---

## O que não existia ainda

| O que é hoje | Como era em 2001 |
|---|---|
| `.env` / variáveis de ambiente | String de conexão hardcoded no `global.asa` |
| ORM (Eloquent, Entity Framework) | SQL concatenado com string, na mão |
| Framework MVC | Lógica, banco e HTML misturados na mesma `.asp` |
| `try/catch` | `On Error Resume Next` + checar `Err.Number` depois |
| `import` / `require` | `<!-- #include file="..." -->` — copy/paste pelo servidor |
| `input type="date"` | Campo de texto, usuário digitava a data na mão |
| Prepared statements | Não usava. SQL Injection era desconhecido por 90% |
| jQuery / AJAX | Nada. Cada ação recarregava a página inteira |

---

## Gambiarras clássicas da época

**`On Error Resume Next`** — a mais famosa. Desligava todos os erros. O código continuava
rodando mesmo se o banco caísse, se o SQL falhasse, se qualquer coisa explodisse.
Você checava `Err.Number` depois. Ou não checava e ficava sem saber que tinha erro.

**Datas entre `# #`** — Access usava `#12/25/2001#` em vez de `'2001-12-25'`.
Formato americano, sempre. Muita aplicação quebrava ao mudar de hospedagem porque
o servidor em PT-BR interpretava diferente.

**`Set oObj = Nothing`** — liberar memória explicitamente. O garbage collector do VBScript
era fraco. Se você não dava `Nothing` nos objetos ADO, a memória vazava. Em um servidor
com 50 usuários simultâneos, isso derrubava o IIS.

**`Response.End()` depois de `Redirect`** — sem ele, o código continuava executando
mesmo após o redirect. A página enviava o header de redirecionamento E continuava
gerando HTML que nunca seria visto. Causava bugs bizarros.

---

## Como rodar hoje (se quiser sofrer)

1. Windows com IIS habilitado (Painel de Controle ? Recursos do Windows)
2. Habilitar ASP em IIS ? Handler Mappings ? ASP
3. Criar o banco `eventos.mdb` no Microsoft Access com as tabelas da estrutura em `banco.sql`
4. Ajustar o caminho em `global.asa` ou `includes/conexao.asp`
5. Configurar o IIS em modo 32-bit (o driver Jet.OLEDB.4.0 é 32-bit)
6. Rezar

Alternativa: usar o driver `Microsoft.ACE.OLEDB.12.0` (Access Database Engine 2010),
que tem versão 64-bit. Instalar separado, mudar a string de conexão.

---

## O que substituiu

| Peça | Substituto |
|---|---|
| ASP Clássico | ASP.NET WebForms (2002), depois ASP.NET MVC (2009) |
| VBScript | C# / VB.NET |
| ADO (COM) | ADO.NET, depois Entity Framework |
| Access (.mdb) | SQL Server Express, MySQL, PostgreSQL |
| `global.asa` | `Web.config`, depois `appsettings.json` |
| `#include` | `using` / `@using`, namespaces, DI container |

---

*Reconstituído com auxílio do Claude (Anthropic) para fins de registro histórico.*
