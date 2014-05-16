package ttLadder;

import ttLadder.dao.*;

import java.util.Date;
import java.util.UUID;

public class HandicapOffer {
  private HandicapOfferV2 dao;

  public HandicapOffer(String rule, int min, int max) {
    dao = new HandicapOfferV2();

    dao.rule = rule;
    dao.min = min;
    dao.max = max;
    dao.createdDate = new Date();
    dao.id = UUID.randomUUID();
  }

  public HandicapOffer(HandicapOfferV2 dao) {
    this.dao = dao;
  }

  public HandicapOfferV2 getDao() {
    return dao;
  }

  public String getRule() {
    return dao.rule;
  }

  public int getMin() {
    return dao.min;
  }

  public int getMax() {
    return dao.max;
  }

  public String getId() {
    return dao.id.toString();
  }

  public Date getCreatedDate() {
    return dao.createdDate;
  }
}