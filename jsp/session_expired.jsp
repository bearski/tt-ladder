<%@ page import="ttLadder.Ladder" %>

<jsp:useBean id="ladderHandle"
  class="ttLadder.LadderHandle" scope="application"/>

<% 
  Ladder ladder = ladderHandle.getLadder();
  String pageTitle = ladder.getPageTitle();

  response.setStatus(response.SC_OK); 
  session.invalidate();
%>

<html>
  <head>
    <title><%= pageTitle %></title>
    <meta http-equiv=Content-Type content="text/html">
    <link href="../css/style.css" type="text/css" rel="stylesheet" />
  </head>

  <body>

  <div id="top">
  <div class='bigheader'><%= pageTitle %></div>

   [ <a href="ladder.jsp">Ladder Home</a> ]
  </div> 
  <div id="page">

  Session has expired.

 </div>
 </body> 
</html>
