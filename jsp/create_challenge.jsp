<%@ page import="ttLadder.*" %>

<%@ page import="java.io.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Iterator" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">

<jsp:useBean id="ladderHandle"
  class="ttLadder.LadderHandle" scope="application"/>

<script type="text/javascript">
  function validate_form(thisform) {
    with (thisform)
    {
      if (validate_required(opponentName, "Select your opponent.") == false) {
        opponentName.focus(); return false;
      } 
	return confirm('Make sure to update the score by "Must compete date", or the challenger moves up by forfeit.') 
      
    }
  }
</script>

<% 
  Ladder ladder = ladderHandle.getLadder();
  List<Player> playerList = ladder.getPlayerList();
  String playerName = (String)session.getAttribute("pName");

  if (playerName == null) {
    throw new ttLadder.MyException();
  }

  Player challenger = ladder.getPlayer(playerName);
  Object[] obj = ladder.getOpponents(challenger);
  List<ChallengeOption> options = (List<ChallengeOption>)obj[0];
  session.setAttribute("optionList", options);
  String notes = (String)obj[1];
%>


<html>
  <head>
    <title>Table Tennis Ladder: create challenge</title>
    <meta http-equiv=Content-Type content="text/html">
    <script src="validate.js"></script>
    <link href="../css/style.css" type="text/css" rel="stylesheet" />
  </head>
  <body>

  <div id="top">
  <div class='bigheader'>Table Tennis Ladder</div>

  <span class='player'>Player: <%= playerName %></span> | <a href="ladder.jsp">TT Ladder Home</a> 

  </div> 
  <div id="page">

<% 
  if (options.size() != 0) {

    out.write("<form action='add_challenge.jsp'");
    out.write(" onsubmit='return validate_form(this)'");
    out.write(" method='post'>");
    out.write("<span class='header'>Eligible opponents:</span><br>");
    out.write("<div class='indent'>");
    out.write("<table>");

    int i = 0;
    boolean hasHandicapOffers=false;
    for(Iterator it= options.iterator(); it.hasNext();) {
      ChallengeOption c = (ChallengeOption)it.next();
      Player p = c.getOpponent();
      HandicapOffer offer = c.getOffer();
      int index = playerList.indexOf(p) + 1;

      out.write("<tr>");		
      out.write("<td>");
      out.write("<input name='option' type='radio' ");
      out.write("value='"+ i + "'></input> ");
      out.write(p.getName() + " (#" + index + "): ");
      out.write("with " + c.getTypeTxt() + " play");
      if(offer!=null) {
        out.write(" (" + StringUtil.encodeHtml(offer.getRule()) + ")");
        hasHandicapOffers=true;
      } 
      out.write("</td></tr>");
      i++;
    } 

    out.write("</table>");
    out.write("<br>");
    out.write("The mail notification will be sent to your opponent");
    out.write(" with your message below:<br>");
    out.write("<textarea name='msg' cols=55 rows=3></textarea>");

    if (hasHandicapOffers) {
      out.write("<br><br>Note: If you take up on a handicap offer, you will " +
                "start participating in " +
                "handicaps automatically.");
    }
    out.write("<br><br><input type='submit' value='Add a new challenge'>");
    out.write("</form>");

    if (notes != null && notes.length() > 0) {
      out.write("<br>Notes: <ul>" + notes + "</ul>");
    }

  } else {
    out.write("You don't have anyone to challenge.");
    out.write("<br>");
    out.write(notes);
  }
%>
    </div>
  </div>
  </body>
</html>
