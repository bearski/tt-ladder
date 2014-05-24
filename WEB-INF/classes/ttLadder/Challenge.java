package ttLadder;

import java.util.*;
import ttLadder.dao.*;

public class Challenge  {
  private ChallengeV2 dao;
  
  public Challenge(ChallengeV2 dao) {
    this.dao = dao;
  }

  public Challenge(Player challenger, ChallengeOption option, 
                   Date mustCompeteDate) {
    dao = new ChallengeV2();

    dao.challenger = challenger.getDao();
    dao.option = option.getDao();
    dao.challengeCreatedDate = new Date();
    dao.mustCompeteDate =  mustCompeteDate;
    dao.isOpenChallenge = true;
    dao.scoreOfChallenger = -1;
    dao.scoreOfChallengee = -1;
    dao.scoreUpdatedDate = null;
   }

  public ChallengeV2 getDao() {
    return dao;
  }

  public Player getChallenger() {
    return new Player(dao.challenger);
  }

  public Player getOpponent() {
    return getOption().getOpponent();
  }

  public Player getOpponentOf(Player p) {
    if (p.equals(getChallenger())) {
      return getOpponent();
    } else if (p.equals(getOpponent())) {
      return getChallenger();
    }
    return null;
  }

  public ChallengeOption getOption() {
    return new ChallengeOption(dao.option);
  }

  public int getType() {
    return getOption().getDao().type;
  }

  public boolean isOpenChallenge() {
    return dao.isOpenChallenge;
  }

  public Player getWinner() {
    if ((dao.scoreOfChallenger != -1) && (dao.scoreOfChallengee != -1)) {
      return (dao.scoreOfChallenger > dao.scoreOfChallengee)? 
        getChallenger() : getOpponent(); 
    }
    return null;
  }

  public boolean hasWon(String name) {
    boolean b = true;
    Player winner = getWinner();

    return winner != null && winner.getName().equals(name);
  }

  public Date getCreatedDate() {
    return dao.challengeCreatedDate;
  }

  public Date getMustCompeteDate() {
    return dao.mustCompeteDate;
  }

  public Date getScoreUpdatedDate() {
    return dao.scoreUpdatedDate;
  }

  public int getScoreOfChallenger() {
    return dao.scoreOfChallenger;
  }

  public void setScoreOfChallenger(int score) {
    dao.scoreOfChallenger = score;
  }

  public int getScoreOfChallengee() {
    return dao.scoreOfChallengee;
  }

  public void setScoreOfChallengee(int score) {
    dao.scoreOfChallengee = score;
  }

  public void setScores(int challenger, int opponent, String note) {
    dao.isOpenChallenge = false;
    dao.scoreOfChallenger = challenger;
    dao.scoreOfChallengee = opponent;
    dao.scoreUpdatedDate = new Date();
    if (note != null && !note.matches("\\s*")) {
      dao.note = note;
    }
  }

  public String getNote() {
    return dao.note;
  }

  void cancelChallenge(String note) {
    if (note != null && !note.matches("\\s*")) {
      dao.note = note;
    }
    dao.isOpenChallenge = false;
    dao.scoreOfChallengee = -1;
    dao.scoreOfChallenger = -1;
    dao.scoreUpdatedDate = new Date();
  }

  public String toString() {
    return getCreatedDate() + " " + getChallenger().getName() + " " + 
      getOpponent().getName() + " " +
      getScoreOfChallenger() + "-" + getScoreOfChallengee();
  }
}
