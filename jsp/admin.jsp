<%@ page import="ttLadder.Ladder" %>
<%@ page import="ttLadder.Player" %>
<%@ page import="ttLadder.Challenge" %>

<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">

<script type="text/javascript">
  function validate_form(thisform) {
    with (thisform)
    {
      if (validate_required(adminPwd, "Password is blank") == false) {
        adminPwd.focus(); return false;
      }
      if (validate_required(name, "Name is blank") == false) {
        name.focus(); return false;
      }
      if (validate_required(pwd, "pwd is blank") == false) {
        pwd.focus(); return false;
      }
    }
  }
</script>

<jsp:useBean id="ladderHandle"
  class="ttLadder.LadderHandle" scope="application"/>

<% 
  Ladder ladder = ladderHandle.getLadder();
  int numOfOpponents = ladder.getMaxNumOfOpponents();
  int daysToUpdate = ladder.getNumOfDaysToUpdate();
  int extraDays = ladder.getNumExtraDaysPerChallenge();
  String simultaneousChecked = (ladder.getSimultaneousChallengesAllowed() ? "checked" : "");
  String host = ladder.getHostName();
  String pageTitle = ladder.getPageTitle();
  List<Player> players = ladder.getPlayerList();
  int numOfPlayers = players.size();
%>

<html>
  <head>
    <title><%= pageTitle %>: Admin</title>
    <meta http-equiv=Content-Type content="text/html">
    <script src="validate.js"></script>
    <link href="../css/style.css" type="text/css" rel="stylesheet" />
  </head>

  <body>

  <div id="top">
  <div class='bigheader'><%= pageTitle %>: Admin</div>

   [ <a href="ladder.jsp">Ladder Home</a> ]
  </div> 
  <div id="page">

   <form action="update_admin.jsp" 
         onsubmit="return validate_form(this)" 
         method="post">
   <table border=1>
     <tr>
       <td>Admin password:</td>
       <td><input type="password" name="adminPwd"></td>
     </tr>
     <tr>
       <td>Max rungs up the ladder to challenge:</td>
       <td><input type="text" name="numOfOpponents" 
                  value="<%= numOfOpponents %>"></td>
     </tr>
     <tr>
       <td>Days to complete the challenge:</td>
       <td><input type="text" name="daysToUpdate"
                  value="<%= daysToUpdate %>"></td>
     </tr>
     <tr>
       <td>Extra days per open challenge:</td>
       <td><input type="text" name="extraDays"
                  value="<%= extraDays %>"></td>
     </tr>
     <tr>
       <td>Simultaneous challenges allowed:</td>
       <td><input type="checkbox" name="simultaneousChallengesAllowed"
                  <%= simultaneousChecked %>></td>
     </tr>
     <tr>
       <td>Host name:</td>
       <td><input type="text" name="host"
                  value="<%= host %>"></td>
     </tr>
     <tr>
       <td>Page title:</td>
       <td><input type"text" name="pageTitle"
                  value="<%= pageTitle %>"</td>
     </tr>
   </table>
   <br>
   <input type="submit" name="cmd" value="Update settings"></td>
   </form>

   <form action="update_admin.jsp" 
         onsubmit="return validate_form(this)" 
         method="post">
   <table border=1>
     <tr>
       <td>Admin password:</td>
       <td><input type="password" name="adminPwd"></td>
     </tr>
     <tr>
       <td>Player:</td>
       <td><select name = "name">

<% 
  for(Iterator it = players.iterator(); it.hasNext(); ) {
    Player p = (Player)it.next();
    out.write("<option value='" + p.getName() + "'>");
    out.write(p.getName() + "</option>"); 
  }
%>
        </select></td>
     </tr>
     <tr>
       <td>Rank:</td>
       <td><select name = "rank">
<%       
  for(int i=1; i <= numOfPlayers ; i++) {
  out.write("<option value='" + i + "'>" + i + "</option>");
  }
%>
       </select></td>
     </tr>
   </table>
   <br>
   <input type="submit" name="cmd" value="Update rank"></td>
   </form>

  <form action="update_admin.jsp" 
         onsubmit="return validate_form(this)" 
         method="post">
   <table border=1>
     <tr>
       <td>Admin password:</td>
       <td><input type="password" name="adminPwd"></td>
     </tr>
     <tr>
       <td>Player:</td>
       <td><select name = "name">

<% 
  for(Iterator it = players.iterator(); it.hasNext(); ) {
    Player p = (Player)it.next();
    out.write("<option value='" + p.getName() + "'>");
    out.write(p.getName() + "</option>"); 
  }
%>
        </select></td>
     </tr>
   </table>
   <br>
   <input type="submit" name="cmd" value="Remove player"></td>
   </form>

  <form action="update_admin.jsp" 
         method="post">
   <table border=1>
     <tr>
       <td>Admin password:</td>
       <td><input type="password" name="adminPwd"></td>
     </tr>
     <tr>
       <td>Announcement:</td>
       <td><textarea name="announcement" cols=60 rows=5></textarea></td>
     </tr>
     <tr>
       <td>Sticky:</td>
       <td><input type="checkbox" name="sticky"></td>
     </tr>
   </table>
   <br>
   <input type="submit" name="cmd" value="Add Announcement"></td>
   </form>

  <form action="admin_console.jsp" 
         method="post">
   <table border=1>
     <tr>
       <td>Admin password:</td>
       <td><input type="password" name="adminPwd"></td>
     </tr>
   </table>
   <br>
   <input type="submit"></td>
   </form>

  </div>
  </body>
</html>
