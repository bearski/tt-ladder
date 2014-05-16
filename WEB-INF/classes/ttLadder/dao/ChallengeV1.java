package ttLadder.dao;

import java.io.*;
import java.util.Date;

public class ChallengeV1 implements Serializable {
  private static final long serialVersionUID = 1L;

  public PlayerV1 challenger;
  public PlayerV1 opponent;
  public int type;
  public Date challengeCreatedDate;
  public Date mustCompeteDate;
  public boolean isOpenChallenge;
  public int scoreOfChallenger;
  public int scoreOfChallengee;
  public Date scoreUpdatedDate;
}
