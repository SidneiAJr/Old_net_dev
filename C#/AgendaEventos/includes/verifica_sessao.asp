<%
' ============================================================
' includes/verifica_sessao.asp
' ============================================================
' NOTA HISTORICA:
' Autenticacao em ASP Classico era 100% baseada em Session.
' Nao existia JWT, nao existia OAuth, nao existia middleware de auth.
' Voce gravava algo na Session no login e checava em cada pagina.
' Este include era colocado no topo de cada pagina protegida.
' Se o usuario nao estava logado, redirecionava pro login.
'
' Response.Redirect era o "Location: header" do ASP.
' O Response.End() era necessario pra parar a execucao —
' sem ele o resto da pagina continuava executando mesmo apos o redirect.
' ============================================================

If Session("loginok") <> "ok" Then
    Response.Redirect "login.asp"
    Response.End()
End If
%>
