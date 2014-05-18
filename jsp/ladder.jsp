<%@ page import="ttLadder.*" %>

<%@ page import="java.io.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.Date" %>

<jsp:useBean id="ladderHandle"
  class="ttLadder.LadderHandle" scope="application"/>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
  <head>
    <title>Table Tennis Ladder Application</title>
    <meta http-equiv=Content-Type content="text/html">
    <script src="validate.js"></script>
    <link href="../css/style.css" type="text/css" rel="stylesheet" />
  </head>

  <body>

  <div id="top">
  <div class='bigheader'>Table Tennis Ladder</div>
<%
  Ladder ladder = ladderHandle.getLadder();
  String dFormat = "MMM d hh:mm a";
  String playerName = (String)session.getAttribute("pName");
  Player player = null;
	
  if (playerName != null) {
    player = ladder.getPlayer(playerName);
    if (player == null) {
      session.invalidate();
      playerName = null;
    }
  }

  if (playerName != null) {
    
    out.write("<span class='player'>Player: " + playerName + "</span>");
    out.write(" | <a href='logout.jsp'>Log-out</a>");

    if(ladder.isInOpenChallenge(player)) {
     out.write(" | <a href='update_challenge.jsp'>Update Challenge</a>");
    }
    if (player.getStatus() == 1 && (ladder.getSimultaneousChallengesAllowed() || !ladder.isInOpenChallenge(player))) {
     out.write(" | <a href='create_challenge.jsp'>Create Challenge</a>");
    }
    out.write(" | <a href='user_handicap.jsp'>Handicaps</a>");
    out.write(" | <a href='user_setting.jsp'>My Settings</a>");

  } else {
    out.write("<a href='login.html'>Log-in</a>");	
    out.write(" | <a href='new_player.jsp'>Become a Player</a>");
  }
  out.write(" || <a href='stats.jsp'>Stats</a>");
  out.write(" | <a href='admin.jsp'>Admin</a>");
  out.write(" | <a href='guidelines.html'>Ladder Guidelines</a>");
%>
  </div>
  
  <div id="leftcolumn">
  <span class="header">Current TT Ladder: </span>
  <ol>	
<%
  for(Iterator it = (ladder.getPlayerList()).iterator(); it.hasNext();) {
    Player p = (Player)it.next();	
    if(p.getStatus() == 1) {
      if(ladder.isInOpenChallenge(p)) {
        out.write("<li><span class='inChallenge'>" + p.getName() + "</span></li>");
      } else {
        out.write("<li>" + p.getName() + "</li>");
      }	
    } else {
      out.write("<font color=gray><li>" + p.getName());	
      out.write(" (inactive)</font>");  
    } 
  }
%>
  </ol> 
  </div>
  <div id="content">
<%
  List<Challenge> cOpenList = ladder.getOpenChallengeList(); 	
  if(cOpenList.size() != 0) {
%>
  <span class="header">Current challenges:</span> 
    <table class="challenge" border=1>
      <th>Created date</th>
      <th>Challenger</th>
      <th>Opponent</th>
      <th>Type</th>
      <th>Must compete by</th>
<%
    for(Iterator it = cOpenList.iterator(); it.hasNext();) {
      Challenge c = (Challenge)it.next();
      Date createdDate =  c.getCreatedDate(); 
      String cName = c.getChallenger().getName();
      String oName = c.getOption().getOpponent().getName();
      HandicapOffer offer = c.getOption().getOffer();
      Date competeDate =  c.getMustCompeteDate(); 

      out.write("<tr>");
      out.write("<td>" + DateUtil.formatDate(createdDate, dFormat) + "</td>");
      out.write("<td>" + cName + "</td>");
      out.write("<td>" + oName + "</td>");
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
      out.write("<td>" + DateUtil.formatDate(competeDate, "EEE, MMM d"));
      out.write("</td>");
      out.write("</tr>");
    }
    out.write("</table>");
  } else {
    out.write("  <span class='header'>No current challenges.</span><br><br>");
  }
%>

    <span class="header">Recent news: </span> 
    <table class="news">
      <tr><td>

<%
  List<NewsItem> news = ladder.getRecentNews();
    
  
  if(!news.isEmpty()) {
    Date currentDate = news.get(0).getDate();
    if (news.get(0).isSticky()) {
      currentDate = new Date();
    }
    out.write("<ul>");
    out.write("<li><b>");
    out.write(DateUtil.formatDate(currentDate, "EEEE, MMM d"));
    out.write(": </b><ul>");

    for(NewsItem item : news) {
      Date updatedDate = item.getDate();

      if (!item.isSticky() && 
          !DateUtil.isSameDay(currentDate, updatedDate)) {
        out.write("</ul></li>");
        out.write("<li><b>");
        out.write(DateUtil.formatDate(updatedDate, "EEEE, MMM d"));
        out.write(": </b><ul>");
        currentDate = updatedDate;
      }

      out.write("<li>" + item.getNoteHtml() + "</li>");
    }
    out.write("</ul></li></ul>");
  }
%>
      </td></tr>
    </table>

    </div>
    <div id="rightcolumn">
    <span class="header">Recent  (<a href='all_challenges.jsp'>all</a>) results: </span> 
    <table class='ridge'>
      <tr><td>      
<%
  List<Challenge> cRecentCloseList = ladder.getRecentCloseChallenges(5);
  if(cRecentCloseList.size() != 0) {
    Date currentDate = null;

    for(Iterator it = cRecentCloseList.iterator(); it.hasNext();) {
      Challenge c = (Challenge)it.next();
      String cName = c.getChallenger().getName();
      String oName = c.getOption().getOpponent().getName();
      HandicapOffer offer = c.getOption().getOffer();
      int score1 = c.getScoreOfChallenger();
      int score2 = c.getScoreOfChallengee();
      Date updatedDate = c.getScoreUpdatedDate();
      String cancelTxt = "<div title='cancel'>C</div>";
   
      if (currentDate == null || 
          !DateUtil.isSameDay(currentDate, updatedDate)) 
      {
        out.write("<div id='datebox'>" +
		   DateUtil.formatDate(updatedDate, "EEEE, MMM d") +
		  "</div>");
        currentDate = updatedDate;
      }  
      out.write("<table class='inner' border=0><tr>");

      out.write("<td width=15 align=middle>");
      if(c.getOption().getType() == 1) {
         String rule = 
	   StringUtil.encodeHtml(c.getOption().getOffer().getRule());
         out.write("<span class='popup' id='ruleTxt' title='" + rule + "'");
	 out.write(" onmouseover='javascript:hilite(this, \"FFFF70\");' ");
	 out.write(" onmouseout='javascript:hilite(this, \"FFFFFF\");'>");
	 out.write(" H " + "</span>");
      } else {
        out.write("&nbsp;");
      }
      out.write("</td>");
      out.write("<td width=140>");
      out.write((c.hasWon(oName) ? "<b>" : ""));
      out.write(oName + "</td>");
      out.write("<td width=10>");
      out.write((c.hasWon(oName) ? "<b>" : ""));
      out.write((c.getWinner() != null ? score2 : cancelTxt) + "</td>");
 
      out.write("<tr><td>&nbsp;</td><td>");
      out.write((c.hasWon(cName) ? "<b>" : ""));
      out.write(cName + "</td>");
      out.write("<td>");
      out.write((c.hasWon(cName) ? "<b>" : ""));
      out.write((c.getWinner() != null ? score1 :  cancelTxt) + "</td>");
      out.write("</tr>");
      out.write("</table>");
    }

  }
%>
    </td></tr><table>
    
    </div>
  </body>
</html>


