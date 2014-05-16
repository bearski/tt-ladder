package ttLadder.dao;

import java.io.*;
import java.util.Date;

public class ChallengeV2 implements Serializable {
  private static final long serialVersionUID = 1L;

  public PlayerV2 challenger;
  public ChallengeOptionV2 option;
  public Date challengeCreatedDate;
  public Date mustCompeteDate;
  public boolean isOpenChallenge;
  public int scoreOfChallenger;
  public int scoreOfChallengee;
  public Date scoreUpdatedDate;
  public String note;
}
