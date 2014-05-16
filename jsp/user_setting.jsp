<%@ page import="ttLadder.Ladder" %>
<%@ page import="ttLadder.Player" %>
<%@ page import="ttLadder.Challenge" %>
<%@ page import="ttLadder.HandicapOffer" %>

<%@ page import="java.io.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Iterator" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">

<jsp:useBean id="ladderHandle"
  class="ttLadder.LadderHandle" scope="application"/>

<script type="text/javascript">
  function validate_form(thisform) {
    with (thisform)
    {
      if (validate_required(pwd, "pwd cannot be blank") == false) {
        pwd.focus(); return false;
      }
      if (validate_email(email, "Email is invalid") == false) {
        email.focus(); return false;
      }
    }
  }
</script>

<% 
  Ladder ladder = ladderHandle.getLadder();
%>

<html>
  <head>
    <title>Table Tennis Ladder: User settings</title>
    <meta http-equiv=Content-Type content="text/html">
    <script src="validate.js"></script>
    <link href="../css/style.css" type="text/css" rel="stylesheet" />
  </head>

  <body>

  <div id="top">
  <div class='bigheader'>Table Tennis Ladder</div>

   [ <a href="ladder.jsp">TT Ladder Home</a> ]
  </div> 
  <div id="page">


<% 
  StringBuffer message = new StringBuffer();
  String playerName = (String)session.getAttribute("pName");
   
  if (playerName == null) {
    throw new ttLadder.MyException();
  }
	
  Player player = ladder.getPlayer(playerName);

  if(player == null) {
    message.append("Player " + playerName + " doesn't exist.");
  } else {
    String p = player.getPwd();
    String e = player.getEmail();
    int s = player.getStatus();   

    out.write("<span class='header'>Settings:</span><br>");
    out.write("<div class='indent'>");
    out.write("<form action='update_setting.jsp'"); 
    out.write("onsubmit='return validate_form(this)' method='post'>");
    out.write("<table border=1>");
    out.write("<tr>");
    out.write("<td>Player's name:</td>");
    out.write("<td>" + playerName + "</td>");
    out.write("</tr>");
    out.write("<tr>");
    out.write("<td>Password:</td>");
    out.write("<td><input type='password' name='pwd' value='" + p + "'></td>");
    out.write("</tr>");
    out.write("<tr>");
    out.write("<td>Email:</td>");
    out.write("<td><input type='text' name='email' value='" + e + "'></td>");
    out.write("</tr>");
    out.write("<tr>");
    out.write("<td>Status:</td>");
    out.write("<td><input type='radio' name='status' value=1");
    if(s==1) out.write(" checked='checked'");
    out.write(">active");
    out.write("<br><input type='radio' name='status' value=0");
    if(s==0) out.write(" checked='checked'");
    out.write(">inactive</td>");
    out.write("</tr>");
    out.write("</table><br>");
    out.write("<input type='submit' value='update settings'>");
    out.write("</form>");
  }
%>

  <%= message %>
   </div>
 </div>
 </body> 
</html>
