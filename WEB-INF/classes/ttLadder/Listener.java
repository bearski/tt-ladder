package ttLadder;

import javax.servlet.*;

public class Listener implements ServletContextListener {
  public void contextDestroyed(ServletContextEvent sce) {
  }

  public void contextInitialized(ServletContextEvent sce) {
    ServletContext application = sce.getServletContext();

    String fn = application.getRealPath("data/ladder.bin");
      
    synchronized(application) {
      application.setAttribute("ladderHandle", new LadderHandle(fn));
    }
  }
}
