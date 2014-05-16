<%@ page import="ttLadder.Ladder" %>
<%@ page import="ttLadder.Player" %>
<%@ page import="ttLadder.PlayerStats" %>
<%@ page import="ttLadder.Challenge" %>

<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" 
    prefix="c" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">

<jsp:useBean id="ladderHandle"
  class="ttLadder.LadderHandle" scope="application"/>

<% 
  Ladder ladder = ladderHandle.getLadder();
%>

<html>
  <head>
    <title>Table Tennis Ladder: Statistics</title>
    <meta http-equiv=Content-Type content="text/html">
    <script src="validate.js"></script>
    <link href="../css/style.css" type="text/css" rel="stylesheet" />
  </head>

  <body>

  <div id="top">
  <div class='bigheader'>Table Tennis Ladder: Statistics</div>

   [ <a href="ladder.jsp">TT Ladder Home</a> ]
  </div>
  <div id='page'>

<% 

  Map<Player, PlayerStats> map = ladder.getAllPlayerStats();
%>

  <div class='indent'> 
  <table class='stats'>
    <tr>
      <th class='caption' colspan=9>Players Stats:</th>
    </tr>
    <tr>
      <th class='p'>Player</th>
      <th>MP</th>
      <th>W</th>
      <th>L</th>
      <th>GW</th>
      <th>GL</th>
      <th>Ch</th>
      <th>Op</th>
      <th>Streak</th>
    </tr>
<%
  int i = 1;
  for (Map.Entry<Player, PlayerStats> e : map.entrySet()) {
    String player = e.getKey().getName();
    int m = e.getValue().matches;
    int m_w = e.getValue().matchesWon;
    int m_l = e.getValue().matchesLost;
    int g_w = e.getValue().gamesWon;
    int g_l = e.getValue().gamesLost;
    int c = e.getValue().beChallenger;
    int o = e.getValue().beOpponent;
    Boolean st_type = e.getValue().streakType;
    int st_v = e.getValue().streak;
    String st = "";
    if(st_type != null) {
      if(st_type.booleanValue() == true) {
	  st = "Won " + st_v;
      } else {
	  st = "Lost " + st_v;
      }
    }

    if(i%2==0) {
      out.print("<tr class='e'>");
    } else {
      out.print("<tr class='o'>");
    }
    i++;
%>	

      <c:url var="url" value="player_matches.jsp" >
	<c:param name="p" value="<%=player%>" />
      </c:url>
      <td class='p'><a href="${url}"><%= player %></a></td>
      <td><%= m %></td>
      <td><%= m_w %></td>
      <td><%= m_l %></td>
      <td><%= g_w %></td>
      <td><%= g_l %></td>
      <td><%= c %></td>
      <td><%= o %></td>
      <td><%= st %></td>
    </tr>
<%
  }
%>
  <table>


    </div>
   </div>
 </body> 
</html>
