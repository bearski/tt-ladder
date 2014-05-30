<%@ page import="ttLadder.Ladder" %>
<%@ page import="ttLadder.Player" %>
<%@ page import="ttLadder.Challenge" %>

<%@ page import="java.io.*" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">

<jsp:useBean id="ladderHandle"
  class="ttLadder.LadderHandle" scope="application"/>

<% 
  Ladder ladder = ladderHandle.getLadder();
  String pageTitle = ladder.getPageTitle();
  String name = request.getParameter("name");
  String adminPwd = application.getInitParameter("adminpwd");
  String pwd = request.getParameter("pwd");
  StringBuffer message = new StringBuffer();

  Player player = ladder.getPlayer(name);
  if (player == null) {
    message.append("Player " + name + " doesn't exist.");
  } else if(player.getPwdHash() != pwd.hashCode() && !player.getPwd().equals(pwd) && !adminPwd.equals(pwd)) {
    message.append(" The password is incorrect.");
  } else {  
    session.setAttribute("pName", name);
    response.sendRedirect("../index.jsp");
  }
%>

<html>
  <head>
    <title><%= pageTitle %>: Log-in</title>
    <meta http-equiv=Content-Type content="text/html">
    <link href="../css/style.css" type="text/css" rel="stylesheet" />
  </head>

  <body>

  <div id="top">
  <div class='bigheader'><%= pageTitle %>: Log-in</div>

   [ <a href="ladder.jsp">Ladder Home</a> ]
  </div> 
  <div id="page">

  Name = <%= name %><br> 
  Error: <%= message %><br>

 </div>
 </body> 
</html>
