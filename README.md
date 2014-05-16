tt-ladder
=========

A table tennis ladder web app. Forked from [here](http://www.anuzen.net/pub/hg/hgwebdir.cgi/ladder/stable).

### Installation

1. Install tomcat with, e.g. `apt-get install tomcat7 tomcat7-admin`.
2. Make sure `CATALINA_HOME` and `CATALINA_BASE` are set, e.g. `export CATALINA_HOME=/usr/share/tomcat7; export CATALINA_BASE=/var/lib/tomcat7`.
3. Run `build.sh`. This compiles the code and copies it to `$CATALINA_BASE/webapps/ladder`.
4. Edit `$CATALINA_BASE/conf/context.xml` and make sure `<Manager pathname="" />` is uncommented. This disables session objects to be serialized in restarts. Otherwise tomcat throws exceptions, because not all objects we store in the session are serializable.
5. Optionally edit `$CATALINA_BASE/conf/tomcat-users.xml` and add these lines: `<role rolename="manager-gui"/>` `<user username="admin" password="changeme" roles="manager-gui"/>`. This enables starting, stopping and reloading of web apps via the tomcat webapp manager.
6. Edit `$CATALINA_BASE/webapps/ladder/WEB-INF/web.xml` to set the ladder admin password.
7. Start tomcat with `$CATALINA_HOME/bin/startup.sh`.
8. Make sure SMTP is working. One way is `apt-get install mailutils`.
9. Go to the admin page in the ladder to set the mail server.

### History

#### 16 May 2014

Players can now change their names.

