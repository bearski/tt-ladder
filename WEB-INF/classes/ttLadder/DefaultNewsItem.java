package ttLadder;

import java.util.Date;

class DefaultNewsItem implements NewsItem {
  Date m_date;
  String m_note;
  boolean m_sticky;

  DefaultNewsItem(Date date, String note, boolean sticky) {
    m_date = date;
    m_note = note;
    m_sticky = sticky;
  }

  public Date getDate() {
    return m_date;
  }

  public String getNoteHtml() {
    return m_note;
  }

  public boolean isSticky() {
    return m_sticky;
  }

}