<%@ page import="ttLadder.Ladder" %>
<%@ page import="ttLadder.Player" %>
<%@ page import="ttLadder.Challenge" %>

<%@ page import="java.io.*" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">

<jsp:useBean id="ladderHandle"
  class="ttLadder.LadderHandle" scope="application"/>

<html>
  <head>
    <title>Table Tennis Ladder Guidelines</title>
    <meta http-equiv=Content-Type content="text/html">
    <link href="../css/style.css" type="text/css" rel="stylesheet" />
  </head>

  <body>



<% 
  Ladder ladder = ladderHandle.getLadder();
  String name = request.getParameter("name");
  String adminPwd = application.getInitParameter("adminpwd");
  String pwd = request.getParameter("pwd");
  StringBuffer message = new StringBuffer();

  Player player = ladder.getPlayer(name);
  if (player == null) {
    message.append("Player " + name + " doesn't exist.");
  } else if(!player.getPwd().equals(pwd) && !adminPwd.equals(pwd)) {
    message.append(" The password is incorrect.");
  } else {  
    session.setAttribute("pName", name);
    response.sendRedirect("../index.jsp");
  }

%>

  <div id="top">
  <div class='bigheader'>Table Tennis Ladder</div>

   [ <a href="ladder.jsp">TT Ladder Home</a> ]
  </div> 
  <div id="page">

  Name = <%= name %><br> 
  Pwd = <%=pwd %><br>
  Error: <%= message %><br>

 </div>
 </body> 
</html>
