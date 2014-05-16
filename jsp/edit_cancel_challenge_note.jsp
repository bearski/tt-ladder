<%@ page import="ttLadder.*" %>

<%@ page import="java.io.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Iterator" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">

<jsp:useBean id="ladderHandle"
  class="ttLadder.LadderHandle" scope="application"/>

<% 
  Ladder ladder = ladderHandle.getLadder();
  String playerName = (String)session.getAttribute("pName");

  if (playerName == null) {
    throw new ttLadder.MyException();
  } 

  Player player = ladder.getPlayer(playerName);
  List<Challenge> openList = ladder.getOpenChallengeList();
  Challenge challenge = ladder.getChallenge(player, openList);
%>

<html>
  <head>
    <title>Table Tennis Ladder: edit note</title>
    <meta http-equiv=Content-Type content="text/html">
    <script src="validate.js"></script>
    <link href="../css/style.css" type="text/css" rel="stylesheet" />
  </head>

  <body>

  <div id="top">
  <div class='bigheader'>Table Tennis Ladder: Cancel challenge</div>

  <span class='player'>Player: <%= playerName %></span> | <a href="ladder.jsp">TT Ladder Home</a>

  </div> 
  <div id="page">

  Edit or submit the message below to post on the Recent News section:
  <br>

<% 
  if (challenge != null) {
      out.write("<form action='cancel_challenge.jsp' " + 
      		" method='post'>");				 
      out.write("<textarea rows='3' cols='50' name='note'>" +
      	        playerName + " had to cancel the challenge against " +
		challenge.getOpponent().getName() + "." +
		"</textarea><br><br>");
      out.write("<input type='submit' value='Cancel challenge'></form>");
  } else {
    out.write("You don't have any challenges to update.");
  }
%>

  </div>
  </body>
</html>
