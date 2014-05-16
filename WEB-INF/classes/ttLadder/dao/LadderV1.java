package ttLadder.dao;

import java.io.*;

import java.util.*;

public class LadderV1 implements Serializable {
  private static final long serialVersionUID = 1L;

  public List<PlayerV1> playerList;
  public List<ChallengeV1> challengeList;
  public int maxNumOfOpponents;
  public int numOfDaysToUpdate;
  public String host;
}
