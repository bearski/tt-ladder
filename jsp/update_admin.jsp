<%@ page import="ttLadder.Ladder" %>
<%@ page import="ttLadder.Player" %>
<%@ page import="ttLadder.Challenge" %>

<%@ page import="java.io.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Iterator" %>

<jsp:useBean id="ladderHandle"
  class="ttLadder.LadderHandle" scope="application"/>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">

<html>
  <head>
    <title>Table Tennis Ladder: Update challenge</title>
    <meta http-equiv=Content-Type content="text/html">
    <link href="../css/style.css" type="text/css" rel="stylesheet" />
  </head>

  <body>


<%
  Ladder ladder = ladderHandle.getLadder(); 
  StringBuffer message = new StringBuffer();  
  String pwd = application.getInitParameter("adminpwd");
  String adminPwd = request.getParameter("adminPwd");	
  String actionType = request.getParameter("cmd");
%>

<% 
  if (pwd == null || pwd.length() < 6) {
    message.append("Set your admin password (length>5) in web.xml first.");
  } else if(adminPwd.equals(pwd)) {
    try {
      
      if(actionType.equals("Update settings")) {
        String numOfOpTxt = request.getParameter("numOfOpponents");	
        int numOfOp = Integer.parseInt(numOfOpTxt);
        String numOfDaysTxt = request.getParameter("daysToUpdate");
        int numOfDays = Integer.parseInt(numOfDaysTxt);
        String hostName = request.getParameter("host");
        ladder.updateAppSetting(numOfOp, numOfDays, hostName);
        response.sendRedirect("../index.jsp");
      }

      if(actionType.equals("Update rank")) {
        String name = request.getParameter("name");	
        String rankTxt = request.getParameter("rank");
        int rank = Integer.parseInt(rankTxt);
        String result = 
	  ladder.updatePlayerRanking(ladder.getPlayer(name), rank-1);
        if(result == null) { 
          response.sendRedirect("../index.jsp");
        } else {
	  message.append(result);
        }
      }

      if(actionType.equals("Remove player")) {
        String name = request.getParameter("name");
        String result = ladder.removePlayer(name);
        if(result == null) { 
          response.sendRedirect("../index.jsp");
        } else {
	  message.append(result);
        }
      }

      if (actionType.equals("Add Announcement")) {
        String text = request.getParameter("announcement");
	boolean sticky = request.getParameter("sticky") != null;
	ladder.addAnnouncement(text, sticky);	
      }

    } catch (NumberFormatException e) {
      message.append(e);
    }
  } else {
    message.append("Admin password is incorrect.");   
  }
%>

  <div id="top">
  <div class='bigheader'>Table Tennis Ladder: Admin update</div>

   [ <a href="ladder.jsp">TT Ladder Home</a> ]
  </div> 
  <div id="page">

   <%= message %>

  </div>
  </body>
</html>