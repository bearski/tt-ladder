<%@ page import="ttLadder.*" %>

<%@ page import="java.io.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Iterator" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">


<jsp:useBean id="ladderHandle"
  class="ttLadder.LadderHandle" scope="application"/>

<% 
  Ladder ladder = ladderHandle.getLadder();
  String playerName = (String)session.getAttribute("pName");

  if (playerName == null) {
    throw new ttLadder.MyException();
  } 

  Player player = ladder.getPlayer(playerName);
  List<Challenge> openList = ladder.getOpenChallengeList();
  Challenge challenge = ladder.getChallenge(player, openList);

  String cName="", oName="";
  String[] noteTmpl=new String[]{"", ""};

  if (challenge != null) {
    cName = challenge.getChallenger().getName();
    oName = challenge.getOption().getOpponent().getName();
    noteTmpl = ladder.getDefaultNotes(challenge);
  }
%>

<html>
  <head>
    <title>Table Tennis Ladder</title>
    <meta http-equiv=Content-Type content="text/html">
    <link href="../css/style.css" type="text/css" rel="stylesheet" />

<script type="text/javascript">

function validate_form(thisform) {
  with (thisform)
  {
    if (validate_required(cScore, "Enter challenger's score.") == false) 
    {
      cScore.focus(); return false;
    } else if (validate_required(oScore, "Enter opponent's score.") == false)
    {
      oScore.focus(); return false;
    } 

    return confirm('Please confirm the scores.'); 

  }
}

var auto=true;
var template="";
var opponent="<%=oName%>";
var challenger="<%=cName%>";

function scorechanged() {
  var a = document.getElementById("cscore").value;
  var b = document.getElementById("oscore").value;

  if (auto) {
    var s1=parseInt(a);
    var s2=parseInt(b);
    var note;
    if (!isNaN(s1) && !isNaN(s2)) {
      if (s1 <= s2) {
	note = "<%=noteTmpl[0]%>";
      } else {
	note = "<%=noteTmpl[1]%>";
      }
      document.getElementById("note").value=note.replace(/#a#/g, a)
        .replace(/#b#/g, b);
    }
  } else {
    document.getElementById("note").value=
      template.replace(/#a#/g, a).replace(/#b#/g, b);
  }

};

function textchanged() {
  auto=false;

  var a = document.getElementById("cscore").value;
  var b = document.getElementById("oscore").value;
  var c = document.getElementById("note").value;

  if (c == null || /^\s*$/.test(c)) {
    auto=true;
    template="";
  } else {
    template=c.replace(new RegExp(a, "g"), "#a#")
              .replace(new RegExp(b, "g"), "#b#");
  }
};


</script>

  </head>

  <body>

 <div id="top">
  <div class='bigheader'>Table Tennis Ladder</div>

  <span class="player"> Player: <%= playerName %></span> | <a href="ladder.jsp">TT Ladder Home</a>

  </div> 
  <div id="page">

<% 
  if (challenge != null) {
    out.write("<form action='update_ladder.jsp'");
    out.write(" onsubmit='return validate_form(this)'");
    out.write(" method='post'>");
    out.write("<b> Challenge: ");
    out.write(oName + " - " + cName + "</b>");
    if (challenge.getChallenger().equals(player)) {
      out.write(" (<a href='edit_cancel_challenge_note.jsp'>");
      out.write("Cancel challenge</a>)");
    }
 
    if(challenge.getOption().getOffer() != null) {
      out.write("<br>(" +  challenge.getOption().getTypeTxt() + " offer: ");
      String rule = 
        StringUtil.encodeHtml(challenge.getOption().getOffer().getRule());
      out.write(rule + ")"); 
    }
%>
<br><br>
<table>
  <tr>		
    <td><%= oName %>'s score:</td>
    <td><input id='oscore' name='oScore' type='text' 
           onchange='javascript:scorechanged();'></td>
  </tr>
  <tr>				
    <td><%= cName %>'s score:</td>
    <td><input id='cscore' name='cScore' type='text' 
           onchange='javascript:scorechanged();'></td>
  </tr>
  <tr>
    <td colspan=2>
    Edit or submit the message below to post on the Recent News section:
    </td>
  </tr>
  <tr>
    <td colspan=2>
    <textarea id='note' rows='3' cols='50' name='note' 
            onchange='javascript:textchanged();'></textarea>
    </td>
  </tr>
</table>

<br><input type='submit' value='Update challenge'>
</form>

<%
   
  } else {
    out.write("You don't have any challenges to update.");
  }
%>

  </div>
  </body>
</html>
