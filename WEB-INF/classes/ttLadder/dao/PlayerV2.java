package ttLadder.dao;

import java.io.*;
import java.util.List;

public class PlayerV2 implements Serializable {
  private static final long serialVersionUID = 1L;
 
  public String name;
  public String pwd;
  public String email;
  public int status;
  public List<HandicapOfferV2> offers;
  public boolean allowsHandicaps;
  public int defendTop;
  public int defendTopStreak;
}
