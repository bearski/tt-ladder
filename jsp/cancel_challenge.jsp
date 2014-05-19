<%@ page import="ttLadder.Ladder" %>
<%@ page import="ttLadder.Player" %>
<%@ page import="ttLadder.Challenge" %>

<%@ page import="java.io.*" %>

<jsp:useBean id="ladderHandle"
  class="ttLadder.LadderHandle" scope="application"/>

<% 
  Ladder ladder = ladderHandle.getLadder();
  String playerName = (String)session.getAttribute("pName"); 
   
  if (playerName == null) {
    throw new ttLadder.MyException();
  }

  String cName = request.getParameter("cName");
  String oName = request.getParameter("oName");

  Player challenger = ladder.getPlayer(cName);
  Player opponent   = ladder.getPlayer(oName);
  Challenge challenge = ladder.getSpecificChallenge(challenger, opponent, ladder.getOpenChallengeList());

  StringBuffer message =  new StringBuffer(); 

  String note = request.getParameter("note");

  ladder.cancelChallenge(challenge, note);

  response.sendRedirect("../index.jsp");
%>
