<%@ page import="ttLadder.*" %>

<%@ page import="java.io.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Iterator" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">

<jsp:useBean id="ladderHandle"
  class="ttLadder.LadderHandle" scope="application"/>

<% 
  Ladder ladder = ladderHandle.getLadder();
  StringBuffer message = new StringBuffer();
  String playerName = (String)session.getAttribute("pName");
   
%>

<html>
  <head>
    <title>Table Tennis Ladder: Handicaps</title>
    <meta http-equiv=Content-Type content="text/html">
    <link href="../css/style.css" type="text/css" rel="stylesheet" />
  </head>

  <body>

 <div id="top">
  <div class='bigheader'>Table Tennis Ladder</div>

  <span class='player'>Player: <%= playerName %></span> | <a href="ladder.jsp">TT Ladder Home</a>
  </div> 
  <div id="page">

<%
  if (playerName == null) {
    throw new ttLadder.MyException();
  }
	
  Player player = ladder.getPlayer(playerName);

  if(player == null) {
    message.append("Player " + playerName + " doesn't exist.");
  } else {

    out.write("<form action='update_offer.jsp' method='post'>");
    out.write("<span class='header'>Handicap offers:</span><br><br>");

    List<HandicapOffer> offers = player.getOffers();

    if(!offers.isEmpty()) {
      out.write("<span class='s_header'>Exisitng offers:</span><br>");
      out.write("<div class='indent'>");
      out.write("(Each offer will be automatically used up");
      out.write(" once someone challenges it.\n)");
      out.write("<table>");
      for(Iterator it = offers.iterator(); it.hasNext();) {
        HandicapOffer offer = (HandicapOffer)it.next();	
	String rule = StringUtil.encodeHtml(offer.getRule());
	int min = offer.getMin();
	int max = offer.getMax();
        String id = offer.getId();

        out.write("<tr><td>");
	out.write("<input type='checkbox' name ='ruleId' value='" + id + "'>");
	out.write(rule + ": available to players within " + min);
        out.write(" to " + max + " positions below you.");
	out.write("</td></tr>");
      }
      out.write("</table><br>");
      out.write("<input type='submit' name='cmd' value='remove offer'>");
      out.write("</div><br>");
    }


    out.write("<span class='s_header'>Add new offer:</span>");
    out.write("<div class='indent'>");

    // cannot add new offer if player is the last in rank.
    if(!ladder.isTheLastInRank(player)) {
  
      List<Player> lowerRankedPlayers = ladder.getLowerRankedPlayers(player);
      List<Player> playerList = ladder.getPlayerList();
      int index = playerList.indexOf(player)+1;
      int boxSize = lowerRankedPlayers.size();

      out.write("<table border=1><tr>");
      out.write("<td>Rule:</td>");
      out.write("<td><input type='text' size='40' name='nRule' value=''>");
      out.write("</td></tr><tr>");
      out.write("<td colspan=2>Make the offer available to players:");
      out.write("</td></tr>");
      out.write("<tr><td valign=top>(select range)</td>");
      out.write("<td><select size=" + boxSize + " multiple name='minmax'>");
    
      int i = index+1;
      int j = 1;
      for(Iterator it=lowerRankedPlayers.iterator(); it.hasNext();) {
        Player lowerPlayer = (Player)it.next();
        String name = lowerPlayer.getName();

        out.write("<option value=" + j);
        if(j < 3) {
          out.write(" selected "); 
        }
        out.write("> #" + i + " " + lowerPlayer.getName() + "</option>");
        i++;
        j++;
      }
      out.write("</select></td></tr></table><br>");
      out.write("Note: If you add an offer, you will start participating in " +
                "handicaps automatically.<br><br>");
      out.write("<input type='submit' name='cmd' value='add offer'>");
      out.write("</form>");

    } else {
      out.write("Please try again when you move up the ladder.");
    }

    out.write("</div>");
  }
%>

  <%= message %>

 </div>
 </body> 
</html>
