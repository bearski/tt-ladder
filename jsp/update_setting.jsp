<%@ page import="ttLadder.Ladder" %>
<%@ page import="ttLadder.Player" %>
<%@ page import="ttLadder.Challenge" %>

<%@ page import="java.io.*" %>

<jsp:useBean id="ladderHandle"
  class="ttLadder.LadderHandle" scope="application"/>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
  <head>
    <title>Table Tennis Ladder</title>
    <meta http-equiv=Content-Type content="text/html">
    <link href="../css/style.css" type="text/css" rel="stylesheet" />
  </head>

  <body>



<% 
  Ladder ladder = ladderHandle.getLadder();
  String playerName = (String)session.getAttribute("pName");

  if (playerName == null) {
    throw new ttLadder.MyException();
  }

  String name = request.getParameter("name");
  String pwd = request.getParameter("pwd");
  String email = request.getParameter("email");
  int status = Integer.parseInt(request.getParameter("status"));

  StringBuffer message = new StringBuffer();
  
  Player player = 
    ladder.updatePlayerSetting(playerName, pwd, email, status);

  if (player != null) {
     response.sendRedirect("../index.jsp");
   } else {
     message.append("There is an error. Please try again.");
   }

%>

  <div id="top">
  <div class='bigheader'>Table Tennis Ladder</div>

   [ <a href="ladder.jsp">TT Ladder Home</a> ]
  </div> 
  <div id="page">

  <%= message %>
  </div>
  </body>
</html>