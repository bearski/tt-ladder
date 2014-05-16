<%@ page import="ttLadder.*" %>

<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">

<jsp:useBean id="ladderHandle"
  class="ttLadder.LadderHandle" scope="application"/>

<% 
  Ladder ladder = ladderHandle.getLadder();
%>

<html>
  <head>
    <title>Table Tennis Ladder: Player matches</title>
    <meta http-equiv=Content-Type content="text/html">
    <script src="validate.js"></script>
    <link href="../css/style.css" type="text/css" rel="stylesheet" />
  </head>

  <body>

  <div id="top">
  <div class='bigheader'>Table Tennis Ladder: Player matches</div>

   <a href="ladder.jsp">TT Ladder Home</a> | <a href="stats.jsp">Stats</a>
  </div>
  <div id='page'>

<% 
  String p = request.getParameter("p");
  Player player = ladder.getPlayer(p);
  List<Challenge> cCloseList = ladder.getCloseChallengeList();	

  if(cCloseList.size() != 0 && player != null) {
    List<Challenge> list = ladder.getChallenges(player, cCloseList);
%>
  <div class='indent'> 
  <table border=0 class='matches'>
    <tr>
      <th class='caption' colspan=5><%= player.getName() %>'s matches</th>
    </tr>
    <tr>
      <th class='p'>Challenger</th>
      <th class='p'>Opponent</th>
      <th>Score</th>
      <th>Type</th>
      <th>Updated date</th>
    </tr>

<%
    int i = 1;
    for(Iterator it = list.iterator(); it.hasNext();) {
      Challenge c = (Challenge)it.next();
      String cName = c.getChallenger().getName();
      String oName = c.getOption().getOpponent().getName();
      int score1 = c.getScoreOfChallenger();
      int score2 = c.getScoreOfChallengee();
      String score = "";
      if( score1 < 0) {
        score = "Cancelled"; 
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
   out.write("</table>");
  }
%>
   </div>
 </body> 
</html>
