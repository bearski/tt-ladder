<%@ page import="ttLadder.Ladder" %>
<%@ page import="ttLadder.Player" %>
<%@ page import="ttLadder.Challenge" %>
<%@ page import="ttLadder.HandicapOffer" %>
<%@ page import="ttLadder.StringUtil" %>

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
  StringBuffer message = new StringBuffer(); 
  String actionType = request.getParameter("cmd");	
  Player player = ladder.getPlayer(playerName);
%>

<html>
  <head>
    <title><%= pageTitle %>: Update Player Offer</title>
    <meta http-equiv=Content-Type content="text/html">
    <link href="../css/style.css" type="text/css" rel="stylesheet" />
  </head>

 <body>

  <div id="top">
  <div class='bigheader'><%= pageTitle %>: Update Player Offer</div>

   [ <a href="ladder.jsp">Ladder Home</a> ]
  </div> 
  <div id="page">

<% 
  if(player!= null) {
    try {
       if(actionType.equals("add offer")) {
         String newRule = request.getParameter("nRule");		
         String[] minmax = request.getParameterValues("minmax");
  
         int[] minMax = StringUtil.getMinMaxValues(minmax);
         if  (minMax != null) {
           ladder.addPlayerOffer(player, newRule, minMax[0], minMax[1]);
         }
         response.sendRedirect("user_handicap.jsp");
      }

      if(actionType.equals("remove offer")) {
        String offerId = request.getParameter("ruleId");
        ladder.removePlayerOffer(player, offerId);
	//if result from remove==null, nothing will be removed 
        response.sendRedirect("user_handicap.jsp");
      }
    } catch (NumberFormatException e) {
      message.append(e);
    }
  } else {
    message.append("Cannot access player.");   
  }
%>
 
   <%= message %>

  </div>
  </body>
</html>
