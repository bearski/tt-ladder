<%@ page import="ttLadder.Ladder" %>
<%@ page import="ttLadder.Player" %>
<%@ page import="ttLadder.Challenge" %>
<%@ page import="ttLadder.ChallengeOption" %>

<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>

<jsp:useBean id="ladderHandle"
  class="ttLadder.LadderHandle" scope="application"/>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">

<% 
  Ladder ladder = ladderHandle.getLadder();
  String pageTitle = ladder.getPageTitle();
  String cName = (String)session.getAttribute("pName"); 
  List<ChallengeOption> options = 
	(List<ChallengeOption>)session.getAttribute("optionList");
  StringBuffer message = new StringBuffer();

  if (cName == null || options == null) {
    throw new ttLadder.MyException();
  } 

  String optionTxt = request.getParameter("option");
  if( optionTxt == null || optionTxt == "") {
    session.removeAttribute("err_msg");
    String err_msg = "Cannot create a new challenge. " + 
                     "The opponent is not selected.";
    session.setAttribute("err_msg", err_msg);
    response.sendRedirect("error.jsp");
  } 

  Player challenger = ladder.getPlayer(cName);
  
  try {
    int option = Integer.parseInt(optionTxt);
    ChallengeOption chOption = (ChallengeOption)options.get(option);
    String msg = request.getParameter("msg");

    if(chOption == null) {
      message.append("Cannot find the challenge by the given option.");
    } else {
      String result = ladder.addChallenge(challenger, chOption, msg);
      session.setAttribute("optionList", null);

      if(result.length() != 0) {
        message.append(result);
      } else {
        response.sendRedirect("../index.jsp"); 
      }
    }
    
  } catch (NumberFormatException e) {
    message.append(e);	
  }

%>

<html>
  <head>
    <title><%= pageTitle %>: Create Challenge</title>
    <meta http-equiv=Content-Type content="text/html">
    <link href="../css/style.css" type="text/css" rel="stylesheet" />
  </head>

  <body>

  <div id="top">
  <div class='bigheader'><%= pageTitle %>: Create Challenge</div>

   [ <a href="ladder.jsp">Ladder Home</a> ]
  </div> 
  <div id="page">

  <%= message %>

  </div>
  </body>
</html>


