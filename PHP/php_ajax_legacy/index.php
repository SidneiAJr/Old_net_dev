<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <title>Agenda de Contatos - AJAX Raiz 2005</title>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <style type="text/css">
    body       { font-family: Verdana, Arial, sans-serif; font-size: 12px; background: #eeeeee; }
    h2         { color: #336699; }
    table      { border-collapse: collapse; width: 600px; background: #ffffff; }
    th         { background: #336699; color: #ffffff; padding: 5px; }
    td         { border: 1px solid #cccccc; padding: 4px; }
    tr:hover   { background: #f0f0ff; }
    input[type=text]   { border: 1px solid #999; padding: 2px; width: 200px; }
    input[type=submit] { background: #336699; color: #fff; border: 1px solid #224477; padding: 3px 10px; cursor: pointer; }
    #divResultado { margin-top: 10px; }
    #divMensagem  { color: green; font-weight: bold; margin: 5px 0; }
    #divErro      { color: red;   font-weight: bold; margin: 5px 0; }
    #divLoading   { display: none; color: #666; font-style: italic; }
  </style>

  <script type="text/javascript">
  <!--
  /*
   * AJAX RAIZ - 2005
   * Sem jQuery. Sem fetch. Sem axios. Sem absolutamente nada.
   * XMLHttpRequest na mao, do jeito que Deus e Brendan Eich mandaram.
   *
   * O problema classico da epoca: IE usava ActiveXObject,
   * Firefox/Opera usavam XMLHttpRequest nativo.
   * Tinha que tratar os dois - era o "cross-browser" da epoca.
   */

  // Cria o objeto XMLHttpRequest - compativel com IE6 e Firefox
  function criarXHR() {
    var xhr = null;
    if (window.XMLHttpRequest) {
      // Firefox, Opera, Safari, Chrome - o jeito certo
      xhr = new XMLHttpRequest();
    } else if (window.ActiveXObject) {
      // Internet Explorer 6 e abaixo - a gambiarra necessaria
      try {
        xhr = new ActiveXObject("Msxml2.XMLHTTP");
      } catch(e) {
        try {
          xhr = new ActiveXObject("Microsoft.XMLHTTP");
        } catch(e2) {
          xhr = null;
        }
      }
    }
    if (!xhr) {
      alert("Seu navegador nao suporta AJAX! Usa o Firefox cara.");
    }
    return xhr;
  }

  // -------------------------------------------------------
  // Busca contatos pelo nome via AJAX
  // Chama buscar.php e joga o resultado na div
  // -------------------------------------------------------
  function buscarContato() {
    var nome = document.getElementById("f_busca").value;

    if (nome.length < 2) {
      document.getElementById("divErro").innerHTML = "Digite pelo menos 2 letras!";
      document.getElementById("divResultado").innerHTML = "";
      return;
    }

    document.getElementById("divErro").innerHTML     = "";
    document.getElementById("divMensagem").innerHTML = "";
    document.getElementById("divLoading").style.display = "block";

    var xhr = criarXHR();

    // onreadystatechange - o "then()" da epoca, so que horrivel
    xhr.onreadystatechange = function() {
      /*
       * readyState:
       * 0 = nao iniciado
       * 1 = abrindo conexao
       * 2 = conexao aberta
       * 3 = recebendo dados (parcial)
       * 4 = concluido
       *
       * So processa quando chega no 4!
       */
      if (xhr.readyState == 4) {
        document.getElementById("divLoading").style.display = "none";
        if (xhr.status == 200) {
          // responseText = o que o PHP imprimiu com echo
          document.getElementById("divResultado").innerHTML = xhr.responseText;
        } else {
          document.getElementById("divErro").innerHTML = "Erro na requisicao: " + xhr.status;
        }
      }
    };

    // GET com parametro na URL - igual chamar uma pagina normal
    xhr.open("GET", "buscar.php?nome=" + encodeURIComponent(nome), true);
    xhr.send(null); // null porque e GET, sem body
  }

  // -------------------------------------------------------
  // Salva contato via AJAX com POST
  // Manda os dados pro gravar.php sem recarregar a pagina
  // -------------------------------------------------------
  function salvarContato() {
    var nome  = document.getElementById("n_nome").value;
    var fone  = document.getElementById("n_fone").value;
    var email = document.getElementById("n_email").value;

    if (nome == "") {
      alert("Nome obrigatorio!");
      return;
    }

    document.getElementById("divLoading").style.display = "block";
    document.getElementById("divMensagem").innerHTML    = "";
    document.getElementById("divErro").innerHTML        = "";

    var xhr = criarXHR();

    xhr.onreadystatechange = function() {
      if (xhr.readyState == 4) {
        document.getElementById("divLoading").style.display = "none";
        if (xhr.status == 200) {
          var resposta = xhr.responseText;
          if (resposta.indexOf("ERRO") == -1) {
            // Nao tem a palavra ERRO na resposta = sucesso
            // Era assim o "protocolo" da epoca: texto puro com convenção manual
            document.getElementById("divMensagem").innerHTML = resposta;
            document.getElementById("n_nome").value  = "";
            document.getElementById("n_fone").value  = "";
            document.getElementById("n_email").value = "";
            // Recarrega a lista depois de salvar
            listarTodos();
          } else {
            document.getElementById("divErro").innerHTML = resposta;
          }
        } else {
          document.getElementById("divErro").innerHTML = "Falha ao salvar!";
        }
      }
    };

    // POST - os dados vao no body, nao na URL
    var params = "nome=" + encodeURIComponent(nome)
               + "&fone=" + encodeURIComponent(fone)
               + "&email=" + encodeURIComponent(email);

    xhr.open("POST", "gravar.php", true);
    // Header obrigatorio pra o PHP receber $_POST corretamente
    xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    xhr.setRequestHeader("Content-Length", params.length); // IE exigia isso
    xhr.send(params);
  }

  // -------------------------------------------------------
  // Lista todos os contatos
  // -------------------------------------------------------
  function listarTodos() {
    document.getElementById("f_busca").value = "";
    document.getElementById("divLoading").style.display = "block";

    var xhr = criarXHR();
    xhr.onreadystatechange = function() {
      if (xhr.readyState == 4) {
        document.getElementById("divLoading").style.display = "none";
        if (xhr.status == 200) {
          document.getElementById("divResultado").innerHTML = xhr.responseText;
        }
      }
    };
    xhr.open("GET", "listar.php", true);
    xhr.send(null);
  }

  // -------------------------------------------------------
  // Exclui contato - chama excluir.php e atualiza a lista
  // Funcao chamada pelo link gerado pelo PHP dentro da div
  // -------------------------------------------------------
  function excluirContato(id, nome) {
    // confirm() bloqueava a thread inteira - nao tinha modal bonito
    if (!confirm("Excluir o contato " + nome + "?")) {
      return;
    }

    var xhr = criarXHR();
    xhr.onreadystatechange = function() {
      if (xhr.readyState == 4 && xhr.status == 200) {
        document.getElementById("divMensagem").innerHTML = xhr.responseText;
        listarTodos(); // recarrega a lista
      }
    };
    xhr.open("GET", "excluir.php?id=" + id, true);
    xhr.send(null);
  }

  // Carrega a lista quando a pagina abre
  // onload no body era o addEventListener("DOMContentLoaded") da epoca
  //-->
  </script>
</head>

<body onload="listarTodos()">

<h2>&#128222; Agenda de Contatos</h2>
<small><i>AJAX Raiz &copy; 2005 - Sem jQuery, Sem Framework, Sem Frescura</i></small>

<hr>

<!-- FORMULARIO DE CADASTRO -->
<table width="600" border="1">
  <tr>
    <th colspan="2">Novo Contato</th>
  </tr>
  <tr>
    <td width="100"><b>Nome:</b></td>
    <td><input type="text" id="n_nome" /></td>
  </tr>
  <tr>
    <td><b>Telefone:</b></td>
    <td><input type="text" id="n_fone" /></td>
  </tr>
  <tr>
    <td><b>E-mail:</b></td>
    <td><input type="text" id="n_email" /></td>
  </tr>
  <tr>
    <td colspan="2">
      <input type="submit" value="Salvar" onclick="salvarContato()" />
    </td>
  </tr>
</table>

<br>

<!-- BUSCA -->
<b>Buscar:</b>
<input type="text" id="f_busca" onkeyup="if(this.value.length>=2) buscarContato()" />
<input type="submit" value="Buscar" onclick="buscarContato()" />
<input type="submit" value="Listar Todos" onclick="listarTodos()" />

<br>

<!-- FEEDBACK -->
<div id="divLoading">&#9203; Aguarde, carregando...</div>
<div id="divMensagem"></div>
<div id="divErro"></div>

<!-- AQUI O PHP VAI JOGAR O HTML DA LISTA -->
<div id="divResultado"></div>

</body>
</html>
