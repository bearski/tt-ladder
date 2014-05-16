<% 
  String message = (String)session.getAttribute("err_msg"); 
%>

<html>
  <head>
    <title>Table Tennis Ladder Guidelines</title>
    <meta http-equiv=Content-Type content="text/html">
    <link href="../css/style.css" type="text/css" rel="stylesheet" />
  </head>

  <body>

  <div id="top">
  <div class='bigheader'>Table Tennis Ladder</div>

   [ <a href="ladder.jsp">TT Ladder Home</a> ]
  </div> 
  <div id="page">
   <%= message %>
 </div>
 </body> 
</html>
