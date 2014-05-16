package ttLadder;

import ttLadder.dao.*;

public class ChallengeOption {
  private ChallengeOptionV2 dao;

  public ChallengeOption() {
    dao = new ChallengeOptionV2();
  }

  public ChallengeOption(ChallengeOptionV2 dao) {
    this.dao = dao;
  }

  public ChallengeOption(Player opponent, HandicapOffer offer, int type) 
  { 
    dao = new ChallengeOptionV2();
    dao.opponent = opponent.getDao();
    dao.offer = offer == null ? null : offer.getDao();
    dao.type = type;
  }

  public ChallengeOptionV2 getDao() {
    return dao;
  }

  public Player getOpponent() {
    return new Player(dao.opponent);
  }

  public HandicapOffer getOffer() {
    return dao.offer == null ? null : new HandicapOffer(dao.offer);
  }

  public int getType() {
    return dao.type;
  }

  public String getTypeTxt() {
    String typeTxt = "";
    if(dao.type == -1) {
      typeTxt = "normal";
    } 
    if (dao.type == 1) {
      typeTxt = "handicap";
    }
    return typeTxt;
  }
}