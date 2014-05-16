package ttLadder;

import ttLadder.dao.AnnouncementV2;
import java.util.Date;

class Announcement implements NewsItem {
  private AnnouncementV2 dao;

  Announcement(AnnouncementV2 dao) {
    this.dao = dao;
  }

  Announcement(String note, boolean isSticky) {
    dao = new AnnouncementV2();
    dao.m_date = new Date();
    dao.m_note = note;
    dao.m_sticky = isSticky;
  }

  AnnouncementV2 getDao() {
    return dao;
  }

  public Date getDate() {
    return dao.m_date;
  }

  public String getNoteHtml() {
    return dao.m_note;
  }

  public boolean isSticky() {
    return dao.m_sticky;
  }

  void setSticky(boolean v) {
    dao.m_sticky = v;
  }
}