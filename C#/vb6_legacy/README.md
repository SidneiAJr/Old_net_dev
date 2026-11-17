# Agenda de Contatos - Visual Basic 6 (1998~2005)

Sistema desktop de agenda feito em VB6 puro com ADO e SQL Server 2000.  
**Sem .NET. Sem C#. Sem nada que veio depois.**

---

## A stack da época

| Camada | Tecnologia |
|---|---|
| Linguagem | Visual Basic 6.0 (1998) |
| IDE | Visual Basic 6 IDE |
| UI | Windows Forms nativos (Win32) |
| Dados | ADO (ActiveX Data Objects) — `msado15.dll` |
| Banco | SQL Server 2000 / Access 2000 |
| Grid | MSFlexGrid Control (`MSFLXGRD.OCX`) |
| Deploy | Setup com Cabinet Files (.cab) + VB6 Runtime |

---

## Conceitos que não existiam

- ❌ `Try/Catch` → era `On Error GoTo Label`
- ❌ Classes tipadas → era Recordset solto
- ❌ NULL safety → `& ""` em todo campo pra não explodir
- ❌ Prepared Statement → concatenação de string + `Replace("'", "''")`
- ❌ Async → tudo síncrono, UI travava enquanto consultava o banco
- ❌ Git → era disquete ou pasta compartilhada na rede
- ❌ NuGet / npm → era registrar `.OCX` e `.DLL` no Registry do Windows

---

## O pesadelo do deploy

Distribuir um sistema VB6 era uma aventura épica:

1. Compilar → gera `Agenda.exe`
2. Usar o **Package and Deployment Wizard** (vinha com o VB6)
3. Ele gerava `.cab` files com o setup
4. Copiar o setup pro cliente (CD, disquete, pen drive se era moderno)
5. Instalar no cliente
6. Rezar pra `MSFLXGRD.OCX` registrar certo
7. Rezar pra versão do ADO ser compatível
8. Receber ligação às 17h: *"Deu erro de Component not registered"*
9. Ir pessoalmente com o CD de runtime na mão

---

## Arquivos do projeto

| Arquivo | O que é |
|---|---|
| `Agenda.vbp` | Arquivo de projeto — abre no VB6 IDE |
| `Module1.bas` | Módulo global — conexão e funções utilitárias |
| `frmLogin.frm` | Formulário de login |
| `frmAgenda.frm` | Formulário principal — CRUD completo |
| `banco_sqlserver.sql` | Script pra criar o banco no SQL Server 2000 |

---

## Como rodar (se tiver coragem)

- Windows XP ou Windows 98/2000
- Visual Basic 6.0 instalado (a licença era cara em 1998)
- SQL Server 2000 ou MSDE (versão grátis e limitada do SQL Server)
- Registrar os componentes: `regsvr32 MSFLXGRD.OCX`
- Abrir `Agenda.vbp` no VB6 IDE e dar F5

Ou roda numa VM com Windows XP. Funciona até hoje.  
Tem empresa usando VB6 em produção em 2024. É verdade. Não é mito.
