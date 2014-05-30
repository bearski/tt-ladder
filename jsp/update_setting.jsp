<%@ page import="ttLadder.Ladder" %>
<%@ page import="ttLadder.Player" %>
<%@ page import="ttLadder.Challenge" %>

<%@ page import="java.io.*" %>

<jsp:useBean id="ladderHandle"
  class="ttLadder.LadderHandle" scope="application"/>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">

<% 
  Ladder ladder = ladderHandle.getLadder();
  String pageTitle = ladder.getPageTitle();
  String playerName = (String)session.getAttribute("pName");

  if (playerName == null) {
    throw new ttLadder.MyException();
  }

  String newName = request.getParameter("newName");
  int pwd = request.getParameter("pwd").hashCode();
  String email = request.getParameter("email");
  int status = Integer.parseInt(request.getParameter("status"));

  StringBuffer message = new StringBuffer();
  
  Player player = 
    ladder.updatePlayerSetting(playerName, newName, pwd, email, status);

  if (player != null) {
     session.setAttribute("pName", newName);
     response.sendRedirect("../index.jsp");
   } else {
     message.append("There is an error. Please try again.");
   }

%>

<html>
  <head>
    <title><%= pageTitle %>: User Settings</title>
    <meta http-equiv=Content-Type content="text/html">
    <link href="../css/style.css" type="text/css" rel="stylesheet" />
  </head>

  <body>

  <div id="top">
  <div class='bigheader'><%= pageTitle %>: User Settings</div>

   [ <a href="ladder.jsp">Ladder Home</a> ]
  </div> 
  <div id="page">

  <%= message %>
  </div>
  </body>
</html>