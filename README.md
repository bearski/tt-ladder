tt-ladder
=========

A web app ladder for table tennis or other sports. Forked from [code written by Cenk Gazen and Pui Anusa](http://www.anuzen.net/pub/hg/hgwebdir.cgi/ladder/stable).

### Installation

1. Install tomcat with, e.g. `apt-get install tomcat7 tomcat7-admin`.
2. Make sure `CATALINA_HOME` and `CATALINA_BASE` are set, e.g. `export CATALINA_HOME=/usr/share/tomcat7; export CATALINA_BASE=/var/lib/tomcat7`.
3. Run `./build.sh`. This compiles the code and copies it to `$CATALINA_BASE/webapps/ladder`. If you want a different endpoint than `ladder`, specify it as the argument to `build.sh`, e.g. `./build.sh pingpong`.
4. Edit `$CATALINA_BASE/conf/context.xml` and make sure `<Manager pathname="" />` is uncommented. This disables session objects to be serialized in restarts. Otherwise tomcat throws exceptions, because not all objects we store in the session are serializable.
5. Optionally edit `$CATALINA_BASE/conf/tomcat-users.xml` and add these lines: `<role rolename="manager-gui"/>` `<user username="admin" password="changeme" roles="manager-gui"/>`. This enables starting, stopping and reloading of web apps via the tomcat webapp manager.
6. Edit `$CATALINA_BASE/webapps/ladder/WEB-INF/web.xml` to set the ladder admin password.
7. Start tomcat with `$CATALINA_HOME/bin/startup.sh`.
8. Make sure SMTP is working. One way is `apt-get install mailutils`.
9. Make sure the timezone is set in `/etc/timezone` (for future shells) and in the env var `TZ` (for the current shell).

### Admin

* Most settings on the `Admin` page are fairly self-explanatory. `Extra days per open challenge` is only applicable when `Simultaneous challenges allowed` is checked. This is the extra time a challengee gets for each of his/her current open challenges when s/he gets a new challenge.
* `Page title` is part of the title and the main header of each page, and part of the subject line of each challenge email sent.
* When the `sticky` checkbox under the `Announcement` text box is checked, the announcement will stay at the top of the news for the day in which the announcement was posted.
* The `submit` button at the bottom of the admin page opens a console, in which Java expressions can be evaluated. The name `l` is bound in the console to the current instance of the class `ttLadder.Ladder`. E.g. `l.getPlayer("Fred")` evaluates to the instance of `ttPlayer.Player` for which `getName()` is `"Fred"`. A typical use of the console is to cancel or remove challenges.

### History

#### 23 May 2014

Added option to require that new players start at the bottom.

#### 18 May 2014

Added option to allow multiple simultaneous challenges. Challengees get extra time if they already have open challenges. Page titles and headers are customizable.

#### 16 May 2014

Initial [fork](http://www.anuzen.net/pub/hg/hgwebdir.cgi/ladder/stable). Changed "My Settings" so players can edit their names.
