<%@ page import="ttLadder.Ladder" %>
<%@ page import="ttLadder.Player" %>
<%@ page import="ttLadder.Challenge" %>

<%@ page import="java.io.*" %>

<jsp:useBean id="ladderHandle"
  class="ttLadder.LadderHandle" scope="application"/>

<% 
  Ladder ladder = ladderHandle.getLadder();
  String pageTitle = ladder.getPageTitle();
  String name = request.getParameter("name");
  String pwd = request.getParameter("pwd");
  String email = request.getParameter("email");
  StringBuffer message = new StringBuffer();
  
  
  try {
    int pos = Integer.parseInt(request.getParameter("pos")); 
    String result = ladder.addPlayer(name, pwd, email, pos);
    if(result.length() == 0) {
      session.setAttribute("pName", name);
      response.sendRedirect("../index.jsp");
    } else {
      message.append(result);
    }
  } catch (NumberFormatException e) {
    message.append(e);
  }

%>

<html>
  <head>
    <title><%= pageTitle %>: Create Player</title>
    <meta http-equiv=Content-Type content="text/html">
    <link href="../css/style.css" type="text/css" rel="stylesheet" />
  </head>

  </body>

  <div id="top">
  <div class='bigheader'><%= pageTitle %>: Create Player</div>

   [ <a href="ladder.jsp">Ladder Home</a> ]
  </div> 
  <div id="page">

  <%= message %>

  </div>
  </body>
</html>
