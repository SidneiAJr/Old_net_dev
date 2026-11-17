# Agenda de Contatos - PHP + AJAX Raiz (2005)

AJAX antes do jQuery existir. XMLHttpRequest na mão. PHP respondendo HTML puro.  
**Sem fetch. Sem axios. Sem JSON. Sem REST. Sem absolutamente nada.**

---

## Como funcionava o AJAX da época

```
[Usuário digita]
      ↓
[JavaScript cria XMLHttpRequest manualmente]
      ↓
[Abre conexão GET/POST pro PHP]
      ↓
[PHP roda, faz query, faz echo de HTML puro]
      ↓
[JavaScript pega o responseText]
      ↓
[Joga direto no innerHTML da div]
      ↓
[Usuário vê o resultado SEM recarregar a página]
```

Isso em 2005 era **mágica**. As pessoas achavam impossível.  
O Google usou essa técnica no Gmail (2004) e no Google Maps (2005)  
e o mundo da web nunca mais foi o mesmo.

---

## O problema do IE vs Firefox

O maior pesadelo da época: IE6 não tinha `XMLHttpRequest` nativo.  
Tinha que usar `ActiveXObject`:

```javascript
// Firefox, Opera, Chrome (quando surgiu)
xhr = new XMLHttpRequest();

// Internet Explorer 6 - a gambiarra necessária
xhr = new ActiveXObject("Msxml2.XMLHTTP");
// ou se esse falhasse...
xhr = new ActiveXObject("Microsoft.XMLHTTP");
```

Todo projeto AJAX tinha esse `if/else` no começo. Todo mundo copiava do mesmo tutorial.

---

## O "protocolo" texto puro

Não tinha JSON padronizado no browser (JSON.parse só veio no ES5, 2009).  
A comunicação era texto puro com **convenção manual**:

- PHP retorna `"ERRO: mensagem"` → JS verifica se tem a palavra "ERRO"
- PHP retorna qualquer outra coisa → sucesso

```javascript
if (xhr.responseText.indexOf("ERRO") == -1) {
    // sucesso
} else {
    // erro
}
```

Sim. Era isso. Funcionava. Não era bonito, mas funcionava.

---

## Por que `mysql_` e não `mysqli_`?

- `mysql_connect()` foi **removido no PHP 7** (2015)
- `mysqli_` chegou no PHP 5 (2004), mas demorou pra pegar
- Em 2003/2004 todo tutorial usava `mysql_` e continuou por anos
- Esse código é de 2003/2004, então `mysql_` mesmo, pra ser fiel

---

## Autenticidade histórica garantida

- ✅ `mysql_connect()` — removido no PHP 7
- ✅ `mysql_real_escape_string()` — a "segurança" da época
- ✅ `ActiveXObject` pro IE6
- ✅ `readyState == 4 && status == 200` — a checagem clássica
- ✅ HTML retornado no `echo` jogado no `innerHTML`
- ✅ `bgcolor=` no `<tr>` em vez de CSS
- ✅ `Content-Length` no header do POST (IE exigia)
- ✅ `ENGINE=MyISAM` no SQL
- ✅ Emails de terra.com.br, bol.com.br e uol.com.br nos dados de teste
- ✅ `onload` no `<body>` em vez de `addEventListener`
- ✅ Comentários HTML em volta do JavaScript (`<!-- // -->`)

---

## Requisitos

- PHP 4.x ou 5.x (NÃO roda no PHP 7+, mysql_ foi removido)
- MySQL 4.x ou 5.x
- Apache com mod_php
- XAMPP 1.4 ou similar da época

```bash
mysql -u root -p < banco.sql
# Coloca os arquivos no htdocs
# Acessa http://localhost/php_ajax_legacy/
```
