<%@ page import="ttLadder.Ladder" %>
<%@ page import="ttLadder.Player" %>
<%@ page import="ttLadder.Challenge" %>

<%@ page import="java.io.*" %>

<% 
  session.invalidate();
  response.sendRedirect("ladder.jsp");
%>

