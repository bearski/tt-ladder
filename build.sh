javac -cp "WEB-INF/classes:WEB-INF/lib/mail.jar:WEB-INF/lib/activation.jar:$CATALINA_HOME/lib/servlet-api.jar" WEB-INF/classes/ttLadder/*.java WEB-INF/classes/ttLadder/dao/*.java
touch WEB-INF/web.xml
WEBAPP_TARGET=$CATALINA_BASE/webapps/ladder
sudo mkdir -p $WEBAPP_TARGET
sudo cp `find . -name .git -prune -or -name '*.java' -prune -or -type f -print` --parents -t $WEBAPP_TARGET
