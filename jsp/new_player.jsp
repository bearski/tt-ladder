<%@ page import="ttLadder.Ladder" %>
<%@ page import="ttLadder.Player" %>
<%@ page import="ttLadder.Challenge" %>

<%@ page import="java.io.*" %>

<jsp:useBean id="ladderHandle"
  class="ttLadder.LadderHandle" scope="application"/>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">

<script type="text/javascript">
  function validate_form(thisform) {
    with (thisform)
    {
      if (validate_required(name, "Name cannot be blank") == false) {
        name.focus(); return false;
      }
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
  String pageTitle = ladder.getPageTitle();
  int size = (ladder.getPlayerList()).size();
%>

<html>
  <head>
    <title><%= pageTitle %>: Create Player</title>
    <meta http-equiv=Content-Type content="text/html">
    <link href="../css/style.css" type="text/css" rel="stylesheet" />
  </head>

  <body>

  <div id="top">
  <div class='bigheader'><%= pageTitle %>: Create Player</div>

   [ <a href="ladder.jsp">Ladder Home</a> ]
  </div> 
  <div id="page">

   <form action="create_player.jsp" 
         onsubmit="return validate_form(this)"
         method="post">

   <span class='header'>Sign up:</span><br>
   <div class='indent'>
   <table border=1>
     <tr>
       <td>Player's name:</td>
       <td><input type="text" name="name"></td>
     </tr>
     <tr>
       <td>Password:</td>
       <td><input type="password" name="pwd"></td>
     </tr>
     <tr>
       <td>Email:</td>
       <td><input type="text" name="email"></td>
     </tr>
     <tr>
       <td>Position in the Ladder:</td>
       <td><select name = "pos">
<%       
  for(int i=1; i <= size+1 ; i++) {
    out.write("<option value='" + i + "'"); 
    if(i==size+1) {
      out.write(" selected='selected'");
    } 
    out.write(">" + i + "</option>");
  }
%>
       </select></td>
     </tr>
   </table>
   <br>Note: Email address is used for notification when a new challenge is created.
   <br><br>
   <input type="submit" value="Create a new player"></td>
   </form>

    </div>
  </div>
  </body>
</html>
