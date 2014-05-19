<%@ page import="ttLadder.Ladder" %>

<jsp:useBean id="ladderHandle"
  class="ttLadder.LadderHandle" scope="application"/>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">

<script type="text/javascript">
  function validate_required(field, alerttxt) { 
    with (field) 
    {
      if (value==null||value=="") {
        alert(alerttxt);return false;
      } else {
        return true
      }
    }
  } 

  function validate_form(thisform) {
    with (thisform)
    {
      if (validate_required(name, "Name is blank") == false) {
        name.focus(); return false;
      }
      if (validate_required(pwd, "pwd is blank") == false) {
        pwd.focus(); return false;
      }
    }
  }
</script>

<% 
  Ladder ladder = ladderHandle.getLadder();
  String pageTitle = ladder.getPageTitle();
%>

<html>
  <head>
    <title><%= pageTitle %>: Log-in</title>
    <meta http-equiv=Content-Type content="text/html">
    <link href="../css/style.css" type="text/css" rel="stylesheet" />
  </head>

  <body>
  <div id="top">
  <div class='bigheader'><%= pageTitle %>: Log-in</div>

   [ <a href="../index.jsp">Ladder Home</a> ]
   </div>
   <div id="page">
 
   <form action="login_response.jsp" 
         onsubmit="return validate_form(this)" 
         method="post">
   <table border=1>
     <tr>
       <td>Player name:</td>
       <td><input type="text" name="name"></td>
     </tr>
     <tr>
       <td>Password:</td>
       <td><input type="password" name="pwd"></td>
     </tr>
   </table>
   <br>
   <input type="submit" value="Log-in"></td>
   </form>

  </div>
  </body>
</html>
