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

  <div id="top">
  <div class='bigheader'>Table Tennis Ladder: Admin update</div>

   [ <a href="ladder.jsp">TT Ladder Home</a> ]
  </div> 
  <div id="page">

<%
  StringBuffer message = new StringBuffer();  

  Ladder ladder = ladderHandle.getLadder(); 
  String cmd = request.getParameter("cmd");
  Object state = session.getAttribute("admin_state");
  Object adminPwdAccepted = session.getAttribute("admin_pwd_accepted");

  String pwd = application.getInitParameter("adminpwd");
  String adminPwd = request.getParameter("adminPwd");	

  if (pwd == null || pwd.length() < 6) {
    message.append("Set your admin password (length>5) in web.xml first.");
  } else if ((adminPwd != null && adminPwd.equals(pwd)) || 
              adminPwdAccepted != null) {
    session.setAttribute("admin_pwd_accepted", Boolean.TRUE);
    message.append("Logged in as admin.");
    if (cmd != null) {
      Object[] r = ladder.runAdminCmd(cmd, state);
      session.setAttribute("admin_state", r[0]);
      out.write("<pre>" + (String)r[1] + "</pre>");
    }
  } else {
    message.append("Wrong password.");
  }
%>

  <%= message %>
  <form action="admin_console.jsp" 
        method="post">
  <table>
     <tr>
       <td>Commands:</td>
     </tr>
     </tr>
       <td><textarea name="cmd" cols=60 rows=5></textarea></td>
     </tr>
 </table>
 <br>
 <input type="submit" name="cmd" value="Run"></td>
 </form>

 </div>
 </body>
</html>
