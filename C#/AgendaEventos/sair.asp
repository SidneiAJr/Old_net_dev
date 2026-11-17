<%@ Language="VBScript" %>
<%
' NOTA HISTORICA: Session.Abandon() destruia a sessao imediatamente.
' Era o "logout" do ASP — sem tokens pra invalidar, sem nada.
' So destruia o objeto Session no servidor.
Session.Abandon()
Response.Redirect "login.asp"
Response.End()
%>
