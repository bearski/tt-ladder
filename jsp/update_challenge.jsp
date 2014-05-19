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
  List<Challenge> challenges = ladder.getChallenges(player, openList);

  List<String> cancelTags = new ArrayList<String>();
  for (Challenge ch : challenges) {
    String cN = ch.getChallenger().getName();
    String oN = ch.getOption().getOpponent().getName();

    if (cN.equals(playerName)) {
      cancelTags.add(" (<a href='edit_cancel_challenge_note.jsp?cName=" + cN + "&oName=" + oN + "'>Cancel challenge</a>)");
    } else {
      cancelTags.add("");
    }
  }

  List<String> challengeOffers = new ArrayList<String>();
  for (Challenge ch : challenges) {
    if (ch.getOption().getOffer() != null) {
      String rule = StringUtil.encodeHtml(ch.getOption().getOffer().getRule());
      challengeOffers.add("<br>(" +  ch.getOption().getTypeTxt() + " offer: " + rule + ")");
    } else {
      challengeOffers.add("");
    }
  }

  List<String> advanceNoteTmpls = new ArrayList<String>();
  List<String> failNoteTmpls = new ArrayList<String>();
  for (Challenge ch : challenges) {
    String[] noteTmpl = ladder.getDefaultNotes(ch);
    failNoteTmpls.add(noteTmpl[0]);
    advanceNoteTmpls.add(noteTmpl[1]);
  }

  Challenge challenge = null;
  String cName="", oName="";

  if (challenges.size() > 0) {
    challenge = challenges.get(0);
    cName = challenge.getChallenger().getName();
    oName = challenge.getOption().getOpponent().getName();
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
var challengeIndex = 0;

var advanceTemplates = [
<%
  for (String t : advanceNoteTmpls) {
    out.write("\"" + t + "\", ");
  }
%>
];

var failTemplates = [
<%
  for (String t : failNoteTmpls) {
    out.write("\"" + t + "\", ");
  }
%>
];

function scorechanged() {
  var a = document.getElementById("cScore").value;
  var b = document.getElementById("oScore").value;

  if (auto) {
    var s1=parseInt(a);
    var s2=parseInt(b);

    if (!isNaN(s1) && !isNaN(s2)) {
      var note = s1 <= s2 ? failTemplates[challengeIndex] : advanceTemplates[challengeIndex];
      document.getElementById("note").value =
         note.replace(/#a#/g, a).replace(/#b#/g, b);
    }
  } else {
    document.getElementById("note").value =
      template.replace(/#a#/g, a).replace(/#b#/g, b);
  }

};

function textchanged() {
  auto=false;

  var a = document.getElementById("cScore").value;
  var b = document.getElementById("oScore").value;

  var note = document.getElementById("note").value;

  if (note == null || /^\s*$/.test(note)) {
    auto=true;
    template="";
  } else {
    template=c.replace(new RegExp(a, "g"), "#a#")
              .replace(new RegExp(b, "g"), "#b#");
  }
};

var cNames = [
<%
  for (Challenge ch : challenges) {
    String cN = ch.getChallenger().getName();
    out.write("\"" + cN + "\", ");
  }
%>
];

var oNames = [
<%
  for (Challenge ch : challenges) {
    String oN = ch.getOption().getOpponent().getName();
    out.write("\"" + oN + "\", ");
  }
%>
];

var offers = [
<%
  for (String offer : challengeOffers) {
    out.write("\"" + offer + "\", ");
  }
%>
];

var cancels = [
<%
  for (String cancelTag : cancelTags) {
    out.write("\"" + cancelTag + "\", ");
  }
%>
];

function challengeChanged(sel) {
  challengeIndex = sel.selectedIndex;

  var cName = cNames[challengeIndex];
  var oName = oNames[challengeIndex];

  document.getElementById("cName").value = cName;
  document.getElementById("oName").value = oName;

  document.getElementById("cScoreName").innerHTML = cName;
  document.getElementById("oScoreName").innerHTML = oName;

  document.getElementById("cScore").value = "";
  document.getElementById("oScore").value = "";
  document.getElementById("note").value = "";

  auto = true;
  template = "";

  document.getElementById("cancel").innerHTML = cancels[challengeIndex];
  document.getElementById("offer").innerHTML = offers[challengeIndex];
};

</script>
</head>

<body>

<div id="top">
  <div class='bigheader'>Table Tennis Ladder</div>
  <span class="player"> Player: <%= playerName %></span> | <a href="ladder.jsp">TT Ladder Home</a>
</div> 

<div id="page">

<form action='update_ladder.jsp' onsubmit='return validate_form(this)' method='post'>
<b> Challenge: </b>
<select onchange='challengeChanged(this);'>
  <% 
    for (Challenge ch : challenges) {
      String cN = ch.getChallenger().getName();
      String oN = ch.getOption().getOpponent().getName();
      out.write("<option>" + cN + " - " + oN + "</option>");
    }
  %>
</select>

<span id='cancel'>
  <%
    if (cancelTags.size() > 0) {
      out.write(cancelTags.get(0));
    }
  %>
</span>

<span id='offer'>
  <%
    if (challengeOffers.size() > 0) {
      out.write(challengeOffers.get(0));
    }
  %>
</span>

<br><br>
<table>
  <tr>		
    <td><span id='cScoreName'><%= cName %></span>'s score:</td>
    <td><input id='cScore' name='cScore' type='text' onchange='scorechanged();'></td>
  </tr>
  <tr>				
    <td><span id='oScoreName'><%= oName %></span>'s score:</td>
    <td><input id='oScore' name='oScore' type='text' onchange='scorechanged();'></td>
  </tr>
  <tr>
    <td colspan=2>
    Edit or submit the message below to post on the Recent News section:
    </td>
  </tr>
  <tr>
    <td colspan=2>
    <textarea id='note' rows='3' cols='50' name='note' 
            onchange='textchanged();'></textarea>
    </td>
  </tr>
</table>

<input type='hidden' id='cName' name='cName' value='<%= cName %>'>
<input type='hidden' id='oName' name='oName' value='<%= oName %>'>

<br><input type='submit' value='Update challenge'>
</form>

  </div>
  </body>
</html>
