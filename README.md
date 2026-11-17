# 🖥️ Dead Stack Museum

> *"Código que já foi pra produção, já sustentou empresa, e hoje não compila mais."*

---

## O que é isso aqui?

Um acervo técnico de sistemas escritos com tecnologias que a internet já enterrou.  
Não é tutorial. Não é exemplo de boas práticas. É registro histórico.

Cada pasta é uma peça de museu: tem contexto de época, comentários explicando por que era assim, e o código exatamente do jeito que era feito — gambiarras inclusas.

---

## Acervo

| Tecnologia | Sistema | Período | Status |
|---|---|---|---|
| PHP 4 + `mysql_*` | Cadastro de Alunos | ~2003 | ☠️ Removido no PHP 7 |
| PHP 5 + AJAX puro | Agenda com `XMLHttpRequest` | ~2005 | ☠️ Pré-jQuery |
| Java Puro + Servlet + JSP | Cadastro de Alunos | ~2004 | 🪦 Sem Spring, sem nada |
| Visual Basic 6 | Agenda de Contatos | ~2000 | 🪦 Suporte encerrado em 2008 |
| C# 1.0 + .NET 1.1 + ADO.NET | Agenda de Contatos | ~2003 | 🪦 Sem generics, sem LINQ |

---

## Como ler o código

Cada projeto tem comentários explicando:

- **Por que era assim** — contexto técnico da época
- **O que não existia ainda** — o que a galera não tinha disponível
- **O equivalente moderno** — o que substituiu aquilo hoje
- **As gambiarras clássicas** — as soluções que todo mundo copiava do mesmo tutorial

Lê os comentários. É onde está o museu de verdade.

---

## Linha do tempo das tecnologias

```
1998  │  Visual Basic 6.0 lançado
      │  SQL Server 7.0
2000  │  PHP 4 — mysql_connect() vira padrão
      │  ASP clássico no auge
2002  │  .NET 1.0 e C# 1.0 lançados
2003  │  Java Servlets + JSP — o "enterprise" da época
      │  ADO.NET 1.1 — DataSet é a estrela
2004  │  Gmail lança com AJAX — o mundo muda
2005  │  XMLHttpRequest vira buzzword
      │  jQuery 1.0 lançado — acaba com o XMLHttpRequest manual
      │  .NET 2.0 — chegam os generics (List<T> finalmente!)
2007  │  C# 3.0 — LINQ, var, lambdas, auto-properties
2008  │  Microsoft encerra suporte ao VB6
      │  Entity Framework 1.0
2009  │  Servlet 3.0 — @WebServlet, adeus web.xml obrigatório
2012  │  PHP remove mysql_* (deprecado) — finalizado no PHP 7 (2015)
2014  │  Spring Boot 1.0 — adeus Servlet puro
2017  │  .NET Core — SDK-style csproj, adeus XML verboso
2020  │  C# 9.0 — records, top-level statements
      │
hoje  │  Você está aqui. O código acima está no museu.
```

---

## Por que preservar isso?

Porque entender de onde veio ajuda a entender onde está.

O `try/catch` do C# parece óbvio hoje. Menos óbvio quando você lembra que antes era `On Error GoTo Label` no VB6.  
O `fetch()` parece simples. Menos simples quando você viu o `ActiveXObject("Msxml2.XMLHTTP")` pro IE6.  
O Spring Boot sobe em segundos. Menos impressionante quando você nunca configurou um `web.xml` na mão.

Cada abstração moderna existe porque alguém sofreu com o que veio antes.

---

## Contribuindo

Tem algum sistema legado pra adicionar ao acervo? Abre uma issue ou PR com:

- A tecnologia e o período aproximado
- O sistema (pode ser simples — um CRUD já resolve)
- Comentários explicando o contexto técnico da época

Quanto mais velho e mais esquecido, melhor.

---

<sub>Nenhum sistema foi prejudicado na criação deste repositório. Alguns já estavam bem prejudicados antes.</sub>
