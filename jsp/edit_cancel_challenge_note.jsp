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
  String pageTitle = ladder.getPageTitle();
  String playerName = (String)session.getAttribute("pName");

  if (playerName == null) {
    throw new ttLadder.MyException();
  } 

  String cName = request.getParameter("cName");
  String oName = request.getParameter("oName");

  Player challenger = ladder.getPlayer(cName);
  Player opponent   = ladder.getPlayer(oName);
  Challenge challenge = ladder.getSpecificChallenge(challenger, opponent, ladder.getOpenChallengeList());
%>

<html>
  <head>
    <title><%= pageTitle %>: Cancel Challenge</title>
    <meta http-equiv=Content-Type content="text/html">
    <script src="validate.js"></script>
    <link href="../css/style.css" type="text/css" rel="stylesheet" />
  </head>

  <body>

  <div id="top">
  <div class='bigheader'><%= pageTitle %>: Cancel Challenge</div>

  <span class='player'>Player: <%= playerName %></span> | <a href="ladder.jsp">Ladder Home</a>

  </div> 
  <div id="page">

  Edit or submit the message below to post on the Recent News section:
  <br>

<% 
  if (challenge != null) {
      out.write("<form action='cancel_challenge.jsp' method='post'>");				 
      out.write("<textarea rows='3' cols='50' name='note'>" +
      	        challenger.getName() + " had to cancel the challenge against " +
                opponent.getName() + "." +
		            "</textarea><br><br>");
      out.write("<input type='hidden' name='cName' value='" + cName + "'>");
      out.write("<input type='hidden' name='oName' value='" + oName + "'>");
      out.write("<input type='submit' value='Cancel challenge'></form>");
  } else {
    out.write("There is an error. Please try again.");
  }
%>

  </div>
  </body>
</html>
