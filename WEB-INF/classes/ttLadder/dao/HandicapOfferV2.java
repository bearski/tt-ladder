package ttLadder.dao;

import java.util.*;
import java.util.UUID;
import java.io.Serializable;

public class HandicapOfferV2 implements Serializable {
  private static final long serialVersionUID = 1L;

  public String rule;
  public int min;
  public int max;
  public Date createdDate;
  public UUID id;
}
