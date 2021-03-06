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

  Player challenger = ladder.getPlayer(request.getParameter("cName"));
  Player opponent   = ladder.getPlayer(request.getParameter("oName"));
  Challenge challenge = ladder.getSpecificChallenge(challenger, opponent, ladder.getOpenChallengeList());

  StringBuffer message =  new StringBuffer(); 

  try {
    String s = request.getParameter("cScore");
    int cScore = Integer.parseInt(s);
    s = request.getParameter("oScore");
    int oScore = Integer.parseInt(s);

    String note = request.getParameter("note");

    if (cScore < 0 || oScore < 0) {
      message.append("Scores cannot be negative.");
    } else if (challenge == null) {
      message.append("There is an error. Please try again.");
    } else {
      ladder.updateChallenge(challenge, cScore, oScore, note);
      response.sendRedirect("../index.jsp");
    }
  } catch (NumberFormatException e) {
    message.append("Score is not an integer.");  

  }
%>

<html>
  <head>
    <title><%= pageTitle %>: Update Challenge</title>
    <meta http-equiv=Content-Type content="text/html">
    <link href="../css/style.css" type="text/css" rel="stylesheet" />
  </head>

  <body>

  <div id="top">
  <div class='bigheader'><%= pageTitle %>: Update Challenge</div>

   [ <a href="ladder.jsp">Ladder Home</a> ]
  </div> 
  <div id="page">
  <%= message %>

  </div>
  </body>
</html>