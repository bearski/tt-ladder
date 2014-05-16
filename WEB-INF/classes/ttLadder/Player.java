package ttLadder;

import java.util.*;
import ttLadder.dao.*;

public class Player {
  private PlayerV2 dao;
 
  public Player(PlayerV2 dao) {
    this.dao = dao;
  }

  public PlayerV2 getDao() {
    return dao;
  }

  public Player(String name, String pwd, String email) {
    dao = new PlayerV2();
    dao.name = name;
    dao.pwd = pwd;
    dao.email = email;
    dao.status = 1;
    dao.offers = new ArrayList<HandicapOfferV2>();
  }
  
  public String getName() {
    return dao.name;
  }

  public String getPwd() {
    return dao.pwd;
  }

  void setPwd(String pwd) {
    dao.pwd = pwd;
  }

  public String getEmail() {
    return dao.email;
  }

  void setEmail(String email) {
    dao.email = email;
  }

  public int getStatus() {
    return dao.status;
  }

  void setStatus(int status) {
    dao.status = status;
  }

  public boolean allowsHandicaps() {
    return dao.allowsHandicaps;
  }

  void setAllowsHandicaps(boolean v) {
    dao.allowsHandicaps = v;
  }

  public List<HandicapOffer> getOffers() {
    List<HandicapOffer> out = new ArrayList<HandicapOffer>();

    for (HandicapOfferV2 o : dao.offers) {
      out.add(new HandicapOffer(o));
    }
    
    return out;
  }

  public HandicapOffer getOfferById(String id) {
    for(Iterator<HandicapOffer> it = getOffers().iterator(); it.hasNext();) {
      HandicapOffer offer = it.next();
      if(offer.getId().toString().equals(id)) {
        return offer;
      }
    }
    return null;
  }
  
  void addOffer(HandicapOffer offer) {
    dao.offers.add(offer.getDao());
    dao.allowsHandicaps = true;
  }
  
  boolean removeOffer(HandicapOffer offer) {
    if (offer == null)
      return false;
    return dao.offers.remove(offer.getDao());
  }

  public String toString() {
    return dao.name + ":" + dao.email;
  }

  public boolean equals(Object obj) {
    if (!(obj instanceof Player))
      return false;
    return dao == ((Player)obj).dao;
  }

  public int hashCode() {
    return getName().hashCode();
  }
}
