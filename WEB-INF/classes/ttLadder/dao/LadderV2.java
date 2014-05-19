package ttLadder.dao;

import java.io.*;

import java.util.*;

public class LadderV2 implements Serializable {
  private static final long serialVersionUID = 1L;

  public List<PlayerV2> playerList;
  public List<ChallengeV2> challengeList;
  public int maxNumOfOpponents;
  public int numOfDaysToUpdate;
  public int numExtraDaysPerChallenge;
  public boolean simultaneousChallengesAllowed;
  public String host;

  public List<AnnouncementV2> announcements;
}
