<%@ page import="ttLadder.Ladder" %>
<%@ page import="ttLadder.Player" %>
<%@ page import="ttLadder.Challenge" %>

<%@ page import="java.io.*" %>

<jsp:useBean id="ladderHandle"
  class="ttLadder.LadderHandle" scope="application"/>

<% 
  Ladder ladder = ladderHandle.getLadder();
  String cName = (String)session.getAttribute("pName"); 
   
  if (cName == null) {
    throw new ttLadder.MyException();
  }

  Player challenger = ladder.getPlayer(cName);
  StringBuffer message =  new StringBuffer(); 

  String note = request.getParameter("note");

  ladder.cancelChallenge(challenger, note);

  response.sendRedirect("../index.jsp");
%>
