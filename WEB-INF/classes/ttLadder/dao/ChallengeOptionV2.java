package ttLadder.dao;

import ttLadder.dao.*;
import java.util.*;
import java.io.Serializable;


public class ChallengeOptionV2 implements Serializable  {
  private static final long serialVersionUID = 1L;

  public PlayerV2 opponent;
  public HandicapOfferV2 offer;
  public int type;
}
