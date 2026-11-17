# Agenda de Contatos - C# 1.0 / .NET 1.1 (2003)

Sistema desktop em C# puro com ADO.NET e Windows Forms.  
**Sem Entity Framework. Sem LINQ. Sem generics. Sem nada moderno.**

---

## A evolução que não existia ainda

| Feature | Chegou em |
|---|---|
| `List<T>` (generics) | C# 2.0 / .NET 2.0 — **2005** |
| `var`, LINQ, lambdas | C# 3.0 / .NET 3.5 — **2007** |
| `dynamic`, `async/await` | C# 4.0/5.0 — **2010/2012** |
| Auto-properties `{ get; set; }` | C# 3.0 — **2007** |
| `partial class` | C# 2.0 — **2005** |
| Entity Framework | .NET 3.5 SP1 — **2008** |
| `using` statement seguro | Existia, mas pouco usado em 1.1 |
| SDK-style `.csproj` | .NET Core 2.0 — **2017** |
| Top-level statements | C# 9.0 / .NET 5 — **2020** |

---

## VB6 vs C# 1.0 — a briga da época

| | VB6 (1998) | C# 1.0 (2002) |
|---|---|---|
| Tipagem | Fraca (Variant era o coringa) | Forte (mas sem generics) |
| Exceções | `On Error GoTo Label` | `try/catch/finally` ✅ |
| OOP | Limitada (sem herança real) | Completa ✅ |
| IDE | VB6 IDE | Visual Studio 2003 ✅ |
| Deploy | OCX + DLLs no Registry 💀 | .NET Runtime na máquina |
| Curva | Baixa, qualquer um aprendia | Maior, mas mais poderoso |
| Legado | Roda até hoje em empresa | Roda até hoje em empresa |

A Microsoft criou o C# pra matar o VB6 e atrair o povo do Java.  
Funcionou. Mas o VB6 ainda tá por aí em produção. Silenciosamente. Vivo.

---

## Arquivos do projeto

| Arquivo | O que é |
|---|---|
| `AgendaApp.csproj` | Projeto Visual Studio 2003 — XML verboso de 100 linhas |
| `Program.cs` | `static void Main()` — ponto de entrada com `[STAThread]` |
| `Conexao.cs` | Singleton de conexão ADO.NET — `SqlConnection` puro |
| `Contato.cs` | Classe de modelo com campos privados + properties na mão |
| `ContatoDAO.cs` | DAO com `SqlCommand`, `SqlDataReader`, `ArrayList` |
| `FrmLogin.cs` | Windows Form de login — `InitializeComponent()` manual |
| `FrmAgenda.cs` | Windows Form principal — `DataGrid` + `DataTable` binding |

---

## As bizarrices documentadas no código

- `ArrayList` em vez de `List<T>` — sem generics, guardava `object`, precisava de cast
- `(Contato)lista[i]` — cast manual que explodia em runtime se errasse
- `dr.IsDBNull(2) ? "" : dr.GetString(2)` — sem isso: `NullReferenceException`
- `new EventHandler(this.btnOK_Click)` — sem lambda, delegate na mão
- `[STAThread]` obrigatório — herança do modelo COM do Windows
- `.csproj` com 100 linhas de XML — antes do SDK-style project
- `Application.Run()` — o event loop explícito do Windows Forms
- `ShowDialog()` vs `Show()` — modal vs modeless, decisão importante
- `DataGrid` (não `DataGridView`) — o controle original do .NET 1.x
- `SCOPE_IDENTITY()` no SQL — o `AUTO_INCREMENT` do SQL Server

---

## Como rodar

- Visual Studio 2003 (ou 2005 com modo de compatibilidade)
- .NET Framework 1.1
- SQL Server 2000 ou superior
- Usar o `banco_sqlserver.sql` do projeto VB6 (mesmo banco)
