<%@ page import="ttLadder.Ladder" %>

<jsp:useBean id="ladderHandle"
  class="ttLadder.LadderHandle" scope="application"/>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">

<%
  Ladder ladder = ladderHandle.getLadder();
  String pageTitle = ladder.getPageTitle();
%>

<html>
  <head>
    <title><%= pageTitle %>: Guidelines</title>
    <meta http-equiv=Content-Type content="text/html">
    <link href="../css/style.css" type="text/css" rel="stylesheet" />
  </head>

  <body>

  <div id="top">
  <div class='bigheader'><%= pageTitle %>: Guidelines</div>

   [ <a href="ladder.jsp">Ladder Home</a> ]
  </div> 
  <div id="page">

    <li>To move up in the ladder, a person can challenge players one
or more positions above them. The limit is configured by the ladder
admin.

    <li>Challenges have to be played and the scored entered to the
ladder within a reasonable length of time or the challenger moves up
by forfeit. The exact length of time is configured by the ladder
admin. After this period, the ladder automatically moves the
challenger up the ladder.

    <li>Challenge matches are usually best of five games to 11 points. 

    <li>A successful challenger moves above the challengee, but
everyone else's order stays the same.

  </div>
  </body>
</html>