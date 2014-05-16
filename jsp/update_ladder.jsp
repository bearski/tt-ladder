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
  String cName = (String)session.getAttribute("pName"); 
   
  if (cName == null) {
    throw new ttLadder.MyException();
  }

  Player challenger = ladder.getPlayer(cName);
  StringBuffer message =  new StringBuffer(); 

  try {
    String s = request.getParameter("cScore");
    int cScore = Integer.parseInt(s);
    s = request.getParameter("oScore");
    int oScore = Integer.parseInt(s);

    String note = request.getParameter("note");

    if (cScore < 0 || oScore < 0) {
      message.append("Scores cannot be negative.");
    } else if(challenger == null) {
      message.append("There is an error. Please try again.");
    } else {
      ladder.updateChallenge(challenger, cScore, oScore, note);
      response.sendRedirect("../index.jsp");
    }
  } catch (NumberFormatException e) {
    message.append("Score is not an integer.");  

  }
%>

  <div id="top">
  <div class='bigheader'>Table Tennis Ladder: Guidelines</div>

   [ <a href="ladder.jsp">TT Ladder Home</a> ]
  </div> 
  <div id="page">
  <%= message %>

  </div>
  </body>
</html>