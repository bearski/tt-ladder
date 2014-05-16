package ttLadder;

import java.util.Date;

public interface NewsItem {
  public Date getDate();
  public String getNoteHtml();
  public boolean isSticky();
}