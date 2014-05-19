<%@ page import="ttLadder.*" %>

<%@ page import="java.io.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.Date" %>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">

<jsp:useBean id="ladderHandle"
  class="ttLadder.LadderHandle" scope="application"/>

<% 
  Ladder ladder = ladderHandle.getLadder();
  String pageTitle = ladder.getPageTitle();
%>

<html>
  <head>
    <title><%= pageTitle %>: All Results</title>
    <meta http-equiv=Content-Type content="text/html">
    <script src="validate.js"></script>
    <link href="../css/style.css" type="text/css" rel="stylesheet" />
  </head>

  <body>

  <div id="top">
  <div class='bigheader'><%= pageTitle %>: All Results</div>

  <a href="ladder.jsp">Ladder Home</a> | <a href="stats.jsp">Stats</a>
  </div> 
  <div id="page">

   <div class="header">All results:</div>

    <table border=0 class='matches'>
      <th class='p'>Challenger</th>
      <th class='p'>Opponent</th>
      <th>Score</th>
      <th>Type</th>
      <th>Updated date</th>
      
<%

List<Challenge> cCloseList = ladder.getCloseChallengeList();

  if(cCloseList.size() != 0) {

    int i = 1;
    for(Iterator it = cCloseList.iterator(); it.hasNext();) {
      Challenge c = (Challenge)it.next();
      String cName = c.getChallenger().getName();
      String oName = c.getOption().getOpponent().getName();
      int score1 = c.getScoreOfChallenger();
      int score2 = c.getScoreOfChallengee();
      String score = "";
      if (score1 < 0 || score2 < 0) {
	score = "Cncl";
      } else {
        score = score1 + " - " + score2;
      }
      Date updatedDate = c.getScoreUpdatedDate();

      if(i%2==0) {
        out.print("<tr class='e'>");
      } else {
        out.print("<tr class='o'>");
      }
      i++;

      out.write("<td>");
      if(c.hasWon(cName)) {
        out.write("<b>");
      }
      out.write(cName + "</td><td>");
      if(c.hasWon(oName)) { 
        out.write("<b>");
      }
      out.write(oName + "</td>");
      out.write("<td>" + score + "</td>");
      out.write("<td>");
      if(c.getOption().getType() == 1) {
        String rule = 
	  StringUtil.encodeHtml(c.getOption().getOffer().getRule());
        out.write("<span class='popup' id='ruleTxt' title='" + rule + "'");
	out.write(" onmouseover='javascript:hilite(this, \"FFFF70\");' ");
	out.write(" onmouseout='javascript:hilite(this, \"FFFFFF\");'>");
	out.write(c.getOption().getTypeTxt() + "</span>");
      } else {
      out.write(c.getOption().getTypeTxt());
      }
      out.write("</td>");
      out.write("<td>" + DateUtil.formatDate(updatedDate, "EEE, MMM d"));
      out.write("</td>");
      out.write("</tr>");
    }
  }
%>
    </table>

  </div>
  </body>
</html>


