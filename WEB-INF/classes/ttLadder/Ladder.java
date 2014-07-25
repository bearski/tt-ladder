package ttLadder;

import java.util.*;
import java.util.regex.*;
import java.io.*;

import ttLadder.dao.*;

public class Ladder {
  private LadderV2 dao;

  private File ladderFile;

  private Ladder(LadderV2 dao) {
    this.dao = dao;
  }

  private Ladder() {
    dao = new LadderV2();
    dao.playerList = new ArrayList<PlayerV2>();
    dao.challengeList = new ArrayList<ChallengeV2>();
    dao.maxNumOfOpponents = 2;
    dao.numOfDaysToUpdate = 3;
    dao.numExtraDaysPerChallenge = 1;
    dao.simultaneousChallengesAllowed = false;
    dao.newPlayersAtBottom = true;
    dao.forfeitScore = 3;
    dao.host = "localhost";
    dao.pageTitle = "Table Tennis Ladder";
    dao.announcements = new ArrayList<AnnouncementV2>();
  }

  public LadderV2 getDao() {
    return dao;
  }

  /******* Settings *******/

  synchronized public int getMaxNumOfOpponents() {
    return dao.maxNumOfOpponents;
  }

  synchronized public void setMaxNumOfOpponents(int i) {
    dao.maxNumOfOpponents = i;
    saveLadderFile(ladderFile, this);
  }

  synchronized public int getNumOfDaysToUpdate() {
    return dao.numOfDaysToUpdate;
  }

  synchronized public void setNumOfDaysToUpdate(int i) {
    dao.numOfDaysToUpdate = i;
    saveLadderFile(ladderFile, this);
  }

  synchronized public int getNumExtraDaysPerChallenge() {
    return dao.numExtraDaysPerChallenge;
  }

  synchronized public void setNumExtraDaysPerChallenge(int i) {
    dao.numExtraDaysPerChallenge = i;
    saveLadderFile(ladderFile, this);
  }

  synchronized public boolean getSimultaneousChallengesAllowed() {
    return dao.simultaneousChallengesAllowed;
  }

  synchronized public void setSimultaneousChallengesAllowed(boolean b) {
    dao.simultaneousChallengesAllowed = b;
    saveLadderFile(ladderFile, this);
  }

  synchronized public boolean getNewPlayersAtBottom() {
    return dao.newPlayersAtBottom;
  }

  synchronized public void setNewPlayersAtBottom(boolean b) {
    dao.newPlayersAtBottom = b;
    saveLadderFile(ladderFile, this);
  }

  synchronized public int getForfeitScore() {
    return dao.forfeitScore;
  }

  synchronized public void setForfeitScore(int i) {
    dao.forfeitScore = i;
    saveLadderFile(ladderFile, this);
  }

  synchronized public String getHostName() {
    return dao.host;
  }

  synchronized public void setHostName(String s) {
    dao.host = s;
    saveLadderFile(ladderFile, this);
  }

  synchronized public String getPageTitle() {
    return dao.pageTitle;
  }

  synchronized public void setPageTitle(String s) {
    dao.pageTitle = s;
    saveLadderFile(ladderFile, this);
  }

  synchronized public void updateAppSetting(int numOfOpponent, int numOfDays, int extraDays,
                                            boolean simultaneous, boolean newAtBottom, int forfeitScore, String host, String pageTitle) 
  {
    setMaxNumOfOpponents(numOfOpponent);
    setNumOfDaysToUpdate(numOfDays);
    setNumExtraDaysPerChallenge(extraDays);
    setSimultaneousChallengesAllowed(simultaneous);
    setNewPlayersAtBottom(newAtBottom);
    setForfeitScore(forfeitScore);
    setHostName(host);
    setPageTitle(pageTitle);
  }

  /******* Auto update *******/
  private void autoUpdate() {
    List<Challenge> openList = getOpenChallengeList();

    for(Iterator it = openList.iterator(); it.hasNext();) {
      Challenge c = (Challenge)it.next();
      if(DateUtil.isPast(c.getMustCompeteDate())) {

        String note = 
          String.format("%s forfeited the match against %s.",
                        c.getOpponent().getName(),
                        c.getChallenger().getName());
        updateChallenge(c, getForfeitScore(), 0, note);
      }
    }
  }

  /******* Player *******/

  private String validatePlayerName(String name) {
    StringBuffer errMsg = new StringBuffer();
    
    if(getPlayer(name) != null) {
      errMsg.append("Cannot create a new player. The specified name, ");
      errMsg.append(name);
      errMsg.append(", already exists. "); 
    } else if (!name.matches("[a-zA-Z0-9 .,?]+")) {
      errMsg.append("Name should match [a-zA-Z0-9 .,?]+");
    }
    return errMsg.toString();
  }

  synchronized public String addPlayer(String name, String pwd, 
                                       String email, int position) 
  {
    String errMsg = validatePlayerName(name);
    if(errMsg.length() == 0) {
      Player p = new Player(name, pwd, email);

      if(position <= 0) {
        dao.playerList.add(0, p.getDao());     
      } else if(position >= dao.playerList.size()) {
        dao.playerList.add(p.getDao());     
      } else {
        dao.playerList.add(position - 1, p.getDao());     
      }
      saveLadderFile(ladderFile, this);
    }
    return errMsg;
  }

  synchronized public String removePlayer(String name) {

    String errMsg = null;
    Player player = getPlayer(name);
    List<Challenge> openList = getOpenChallengeList();

    if(player == null) {
      errMsg = "Player does not exist."; 
    } else {
      Challenge c = getChallenge(player, openList);
      if(c == null) {
        dao.playerList.remove(player.getDao());     
        saveLadderFile(ladderFile, this);
      } else {
        errMsg = "Player is in challenge. Cannot delete the player."; 
      }
    }
    return errMsg;
  }

  synchronized public List<Player> getPlayerList() {
    autoUpdate();

    List out = new ArrayList<Player>();
    for (PlayerV2 p1 : dao.playerList) {
      out.add(new Player(p1));
    }
    return out;
  }

  synchronized public Player getPlayer(String name) {
    PlayerV2 p = null;
    int index = getPlayerIndex(name);
    if (index != -1) {
      p = dao.playerList.get(index);
    }
    return p == null ? null : new Player(p);
  }

  synchronized public boolean isTheLastInRank(Player player) {

    int pIndex = getPlayerIndex(player.getName()) + 1;
    return (pIndex == dao.playerList.size() ? true : false);
  }

  private int getPlayerIndex(String name) {
    PlayerV2 p = null;
    for(int i = 0; i < dao.playerList.size(); i++) {
      p = dao.playerList.get(i);
      if(new Player(p).getName().equals(name)) {
        return i;
      } 
    }
    return -1;
  }

  synchronized public Player updatePlayerSetting(String playerName, String newName, String pwd, 
                                                 String email, int status) 
  {
    Player player = getPlayer(playerName);
    if (player != null) {
        if(!playerName.equals(newName) && validatePlayerName(newName).length() == 0) {
        player.setName(newName);
      }
      player.setPwd(pwd);
      player.setEmail(email);
      player.setStatus(status);

      saveLadderFile(ladderFile, this);
    }
    return player;
  }

  synchronized public boolean addPlayerOffer(Player player, String rule, 
                                             int min, int max) 
  {
    if( (player == null) || (rule == null) ||
        (rule.trim().equals(""))) {
      return false;
    }
    
    player.addOffer(new HandicapOffer(rule, min, max));
    saveLadderFile(ladderFile, this);
    return true;
  }

  synchronized public boolean removePlayerOffer(Player player, String offerId) 
  {
    HandicapOffer offer = player.getOfferById(offerId);
    if(offer == null) {
      return false;
    }
    player.removeOffer(offer);
    saveLadderFile(ladderFile, this);
    return true;
  }

  synchronized public List<Player> getLowerRankedPlayers(Player player) {
    int index = dao.playerList.indexOf(player.getDao()) + 1;
    List<Player> lowerRankedPlayers = new ArrayList<Player>();    

    for(int i=index; i<dao.playerList.size(); i++) {
      Player p =  new Player(dao.playerList.get(i));
      lowerRankedPlayers.add(p);
    }
    return lowerRankedPlayers;
  }

  synchronized public String updatePlayerRanking(Player player, int position) {
    String errMsg = null;
    if (dao.playerList.remove(player.getDao())) {
      dao.playerList.add(position, player.getDao());
      saveLadderFile(ladderFile, this);
    } else {
      errMsg = "Player is invalid.";
    }

    return errMsg;
  }

  /******* Challenge *******/

  synchronized public List<Challenge> getChallengeList() {
    List<Challenge> out = new ArrayList<Challenge>();

    for (ChallengeV2 c1 : dao.challengeList) {
      out.add(new Challenge(c1));
    }

    return out;
  }

  synchronized public List<Challenge> getOpenChallengeList() {
    return getChallengeListByType(0);
  }

  synchronized public List<Challenge> getCloseChallengeList() {
    return getChallengeListByType(1);
  }

  synchronized public List<Challenge> getPlayedCloseChallengeList() {
    List<Challenge> list = getCloseChallengeList();
    for (Iterator it=list.iterator(); it.hasNext(); ) {
      Challenge c = (Challenge)it.next();
      if(c.getScoreOfChallenger() < 0) {
        it.remove();
      }
    }
    return list;
  }

  private List<Challenge> getChallengeListByType(int type) {
    List<Challenge> list = new ArrayList<Challenge>();

    for (Challenge c : getChallengeList()) {
      // open list (already sorted by challengeCreatedDate)
      if(type == 0) {
        if(c.isOpenChallenge()) {
          list.add(c);
        }
      } 

      // close list, need to sort by ScoreUpdatedDate
      if(type == 1) {
        if(!c.isOpenChallenge()) {
          list.add(c);
        } 
      }   
    }

    if (type == 1) {
      sortChallengesByScoreDate(list);
    }
    return list;
  }

  private void sortChallengesByScoreDate(List<Challenge> list) {
    Collections.sort(list, new Comparator() {
        public int compare(Object obj1, Object obj2) {
          Challenge c1 = (Challenge)obj1;
          Challenge c2 = (Challenge)obj2;
          return c2.getScoreUpdatedDate().
            compareTo(c1.getScoreUpdatedDate());
        }
      });
  }

  synchronized public List<Challenge> getRecentCloseChallenges(int days) {
    long daysInMilli = new Date().getTime() - 
      (days * 24 * 60 * 60 * 1000);
 
    List<Challenge> closeList = getCloseChallengeList();
    List<Challenge> recentCloseList = new ArrayList<Challenge>();
    
    for(Iterator it = closeList.iterator(); it.hasNext();) {
      Challenge c = (Challenge)it.next();

      if(c.getScoreUpdatedDate().getTime() > daysInMilli) {
        recentCloseList.add(c);
      } 
    }
  
    sortChallengesByScoreDate(recentCloseList);
    return recentCloseList;
  }
  
  synchronized public Object[] getOpponents(Player challenger) 
  {
    StringBuffer reasons = new StringBuffer();
    List<Player> regOpponents = new ArrayList<Player>();
    List<Player> handicapOpponents = new ArrayList<Player>();
    List<ChallengeOption> allOpponents = new ArrayList<ChallengeOption>();

    // check if the challenger is in open challenge or is an active player
    if ((!getSimultaneousChallengesAllowed() && isInOpenChallenge(challenger)) ||
        (challenger.getStatus() == 0)) {
      reasons.append("<li>" + challenger.getName() + 
                     " is not active or not eligible. ");
      return new Object[] {allOpponents, reasons.toString()};
    }
    
    int index = getPlayerIndex(challenger.getName());
    if (index <= 0) {
      return new Object[] {allOpponents, ""};
    }

    int maxNumOfOpponents = getMaxNumOfOpponents();
    int numOfOpponents = 0;

    // 1. get active opponents w/ max num of opponents && !in a challenge
    // 2. get active handicapOpponents && !in a challenge
    // 3. add list 1 & 2 to allOpponents:
    //      - list 1: add that opponent even though no offer
    //      - list 2: do not add that opponent if no offer
    //      - both 1&2: add if player has one or more offer within range 
    //      - both 1&2: not add to allOpponents list if offer is out of range

   
    // 1.get a list of regOpponents
    for(int i=index-1; (i>= 0) && (numOfOpponents < maxNumOfOpponents); i--) {
      Player p = new Player(dao.playerList.get(i));
      if(p.getStatus() == 1) {
        numOfOpponents++;
        if(areInOpenChallenge(challenger, p)) {
          reasons.append("<li>" + p.getName() + " is already in a challenge with you.");
        } else if(getSimultaneousChallengesAllowed() || !isInOpenChallenge(p)) {
          regOpponents.add(p);
        } else {
          reasons.append("<li>" + p.getName() + " is already in a challenge.");
        }
      } else {
        reasons.append("<li>" + p.getName() + " is inactive.");
      }
    }
    Collections.reverse(regOpponents);

    // 2.get a list of handicapOpponents above regular challengers
    // (handicap play)
    int minIndex = (index-1)-maxNumOfOpponents;
    for(int i = minIndex; (i>= 0) ; i--) {
      Player p = new Player(dao.playerList.get(i));
      if(p.getStatus() == 1) { // active player
          if(getSimultaneousChallengesAllowed() || !isInOpenChallenge(p)) { // not in open challenge
          handicapOpponents.add(p);
        } 
      }
    }
    Collections.reverse(handicapOpponents);

    //3. add regOpponents and handicapOpponents to allOpponents
    for(Iterator it=handicapOpponents.iterator(); it.hasNext();) {
      Player op = (Player)it.next();
      allOpponents.addAll(getChallengeOptions(challenger, op, 1));
    }
    for(Iterator it=regOpponents.iterator(); it.hasNext();) {
      Player op = (Player)it.next();
      allOpponents.addAll(getChallengeOptions(challenger, op, -1));
    }

    return new Object[] {allOpponents, reasons.toString()};
  }

  synchronized public boolean isInOpenChallenge(Player player) {

    // check whether (either active & inactive) player 
    // is in the open challenge list 
    List<Challenge> openList = getOpenChallengeList();
    Challenge c = getChallenge(player, openList);
    return c != null;
  }

  synchronized public boolean areInOpenChallenge(Player player1, Player player2) {
    String name1 = player1.getName();
    String name2 = player2.getName();
    List<Challenge> openList = getOpenChallengeList();
    for (Iterator it = openList.iterator(); it.hasNext(); ) {
      Challenge c = (Challenge)it.next();
      String tname1 = c.getChallenger().getName();
      String tname2 = c.getOption().getOpponent().getName();
      if((name1.equals(tname1) && name2.equals(tname2)) ||
         (name1.equals(tname2) && name2.equals(tname1))) {
          return true;
      }
    }
    return false;
  }

  synchronized public List<ChallengeOption> 
    getChallengeOptions(Player challenger, Player opponent, int type) 
  {
    // check if challenger's in range of the handicap offered by opponent
    // if regular play (type==-1) w/o offer, include that opponent to list
    // if handicap play (type == 1) w/o offer, don't add that opponent to list
    List<ChallengeOption> options = new ArrayList<ChallengeOption>();
    int challengerIndex = dao.playerList.indexOf(challenger.getDao());
    int opponentIndex = dao.playerList.indexOf(opponent.getDao());
    int indexDiff = challengerIndex - opponentIndex;
    List<HandicapOffer> offers = opponent.getOffers();

    if(type == -1) {
      options.add(new ChallengeOption(opponent, null, type));
    }

    if(offers != null) {
      for(Iterator it=offers.iterator(); it.hasNext();) {
        HandicapOffer offer = (HandicapOffer)it.next();
        int min = offer.getMin();
        int max = offer.getMax();
        if((indexDiff >= min) && (indexDiff <= max)) {
          options.add(new ChallengeOption(opponent, offer, 1));
        }
      }
    } 

    return options;
  }

  /* this method is to find a challenge by player from an open list 
     which expected to have only one challenge return */
  synchronized public Challenge getChallenge(Player player, 
                                             List<Challenge> list) 
  {

    for (Iterator it = list.iterator(); it.hasNext(); ) {
      Challenge  c = (Challenge)it.next();
      if (c.getChallenger().getName().equals(player.getName()) ||
          c.getOption().getOpponent().getName().equals(player.getName())) {
        return c;
      } 
    }
    return null;
  }

  /* this method is to find all challenges from a list
     where the player can be an opponent or challenger */
  synchronized public List<Challenge> getChallenges(Player player, 
                                                    List<Challenge> list) 
  {
    List<Challenge> challenges = new ArrayList<Challenge>(); 
    for (Iterator it = list.iterator(); it.hasNext(); ) {
      Challenge  c = (Challenge)it.next();
      if (c.getChallenger().getName().equals(player.getName()) ||
          c.getOption().getOpponent().getName().equals(player.getName())) {
        challenges.add(c);
      } 
    }
    return challenges;
  }

  synchronized public Challenge getSpecificChallenge(Player challenger, Player opponent,
                                                     List<Challenge> list) 
  {
    String cName = challenger.getName();
    String oName = opponent.getName();

    for (Iterator it = list.iterator(); it.hasNext(); ) {
      Challenge  c = (Challenge)it.next();
      if (c.getChallenger().getName().equals(cName) &&
          c.getOption().getOpponent().getName().equals(oName)) {
        return c;
      } 
    }
    return null;
  }


  /* count number of positions between ranks from and to 
     skipping inactive players */

  private int countActivePlayers(int from, int to) {
    if (to < from) {
      return countActivePlayers(to, from);
    }

    if (from == to)
      return 0;

    int count = 1;

    for (int i=from+1; i<to; i++) {
      Player p = new Player(dao.playerList.get(i));
      if (p.getStatus() == 1) {
        ++count;
      }
    }

    return count;
  }

  synchronized public String addChallenge(Player challenger, 
                                          ChallengeOption option,
                                          String messageBody) 
    throws Exception
  {
    StringBuffer errMsg = new StringBuffer();
    int cIdx = dao.playerList.indexOf(challenger.getDao());
    int oIdx = dao.playerList.indexOf(option.getOpponent().getDao());

    if (areInOpenChallenge(challenger, option.getOpponent())) {
      return "You are already in a challenge with " +
        option.getOpponent().getName() + ".";
    }

    List<Challenge> challengeList = getOpenChallengeList();

    if (!getSimultaneousChallengesAllowed()) {
      Challenge currentChallenge = getChallenge(challenger, challengeList);
      if (currentChallenge != null) {
        return "You are already in a challenge with " + 
          currentChallenge.getOpponentOf(challenger).getName() + ".";
      }

      currentChallenge = getChallenge(option.getOpponent(), challengeList);
      if (currentChallenge != null) {
        return option.getOpponent().getName() + 
          " is already in a challenge with " + 
          currentChallenge.getOpponentOf(option.getOpponent()).getName() + ".";
      }
    }

    if (challenger.getStatus() != 1 || cIdx < 0 || oIdx < 0) {
      errMsg.append("Challenger or opponent is not an active player.");
      return errMsg.toString();
    }

    // if normal play, chk if within maxNumOfOpponents
    if(option.getType() == -1) {
      if(countActivePlayers(cIdx, oIdx) > getMaxNumOfOpponents()) {
        errMsg.append("Challenger is out of range to challenge the opponent.");
        return errMsg.toString();
      }
    }   
    
    // if handicap, chk if offer within range
    if(option.getType() == 1) {
      if(option.getOffer() != null) {
        int min = option.getOffer().getMin();
        int max = option.getOffer().getMax();
        if(((cIdx - oIdx) < min) || ((cIdx - oIdx) > max)) {
          errMsg.append("Challenger is not within the handicap offer range.");
          return errMsg.toString();
        }
      } else {
        errMsg.append("The opponent doesn't have the handicap offer.");
        return errMsg.toString();
      }
      challenger.setAllowsHandicaps(true);
    }

    int numOpponentChallenges = getChallenges(option.getOpponent(), challengeList).size();
    int extraDays = getNumExtraDaysPerChallenge();
    int numOfDays = getNumOfDaysToUpdate();
    Date competeDate =  DateUtil.addWorkDays(new Date(), numOfDays + extraDays * numOpponentChallenges); 
    //competeDate = new Date(System.currentTimeMillis() + 2 * 60 * 1000);
      
    Challenge challenge = new Challenge(challenger, option, competeDate);
    dao.challengeList.add(challenge.getDao());
    removeChallengeOption(option);
    saveLadderFile(ladderFile, this);

    StringBuffer subject = new StringBuffer();
    subject.append(getPageTitle() + ": " + challenger.getName());
    if(option.getType() == -1) {
      subject.append(" has challenged you.");
    } else {
      subject.append(" has taken up on your handicap offer.");
    }

    StringBuffer note = new StringBuffer();
    if(option.getOffer() != null) {
      note.append("Handicap offer: " + option.getOffer().getRule() + "\n");
    }
    note.append("Note: you must compete and update the challenge by ");
    note.append(competeDate);
    note.append(", or the challenger moves up by forfeit.\n"); 
    note.append("----------------------------------------\n");

    sendMailNotification(challenger.getEmail(), 
                         new String[] {option.getOpponent().getEmail()},
                         new String[] {challenger.getEmail()}, 
                         subject.toString(), note.toString() + messageBody); 

    return "";
  }
  
  synchronized public void updateChallenge(Challenge challenge,
                                           int challengerScore, 
                                           int opponentScore,
                                           String note)
  {
    if (challenge != null) {
      updateChallengeScore(challenge, challengerScore, opponentScore, note);
      updateRanking(dao.playerList, challengerScore, opponentScore, challenge);
      Player opponent = challenge.getOption().getOpponent();
      int opponentIndex = dao.playerList.indexOf(opponent.getDao());
      if (opponentIndex==0) {
        opponent.incrDefendTop();
      }
      saveLadderFile(ladderFile, this);
    }
  }

  synchronized public void removeChallenge(Challenge challenge)
  {
    if (challenge != null) {
      dao.challengeList.remove(challenge.getDao());
      saveLadderFile(ladderFile, this);
    }
  }

  synchronized public String[] getDefaultNotes(Challenge c) {
    String challenger = c.getChallenger().getName();
    String opponent = c.getOpponent().getName();

    List<PlayerV2> cWins = new ArrayList<PlayerV2>(dao.playerList);
    updateRanking(cWins, 1, 0, c);

    String cWinsNote;

    if (cWins.indexOf(c.getChallenger().getDao()) <
        dao.playerList.indexOf(c.getChallenger().getDao())) {
      cWinsNote = challenger + " advanced by defeating " + 
        opponent + " #a#-#b#.";
    } else {
      cWinsNote = challenger + " defeated " + opponent + " #a#-#b#.";
    }
    
    return new String[] {
      opponent + " defended by defeating " + challenger + " #b#-#a#.",
      cWinsNote
    };
  }

  private void updateChallengeScore(Challenge challenge,
                                         int challengerScore, 
                                         int opponentScore,
                                         String note)
 
  {
    if (challenge != null) {
      challenge.setScores(challengerScore, opponentScore, note);
      saveLadderFile(ladderFile, this);
    }
  }    

  private static int moveUpOverInactive(List<PlayerV2> l, int index) {
    while (index > 0) {
      Player nextPlayerUp = new Player(l.get(index-1));
      if (nextPlayerUp.getStatus() != 0) {
        break;
      }
      Collections.swap(l, index, index-1);
      index--;
    }
    return index;
  }

  private static void movePlayerUp(List<PlayerV2> in, int index) {
    List<PlayerV2> l = new ArrayList<PlayerV2>(in);

    index = moveUpOverInactive(l, index);

    Player next = new Player(l.get(index-1));
    if (next.allowsHandicaps()) {
      Collections.swap(l, index, index-1);
      index--;
      moveUpOverInactive(l, index);
      in.clear();
      in.addAll(l);
    }
  }

  private static void movePlayerDown(List<PlayerV2> in, int index) {
    int j=index+1;

    while (j < in.size()) {
      Player prev = new Player(in.get(j));
      if (prev.getStatus() == 1) {
        Collections.swap(in, index, j);
        return;
      }
      j++;
    }
  }

  private static void updateRanking(List<PlayerV2> l, 
                                    int challengerScore,
                                    int opponentScore,
                                    Challenge challenge) 
  {
    if (challengerScore > opponentScore) {
      Player challenger = challenge.getChallenger();
      Player opponent = challenge.getOption().getOpponent();

      int challengerIndex = l.indexOf(challenger.getDao());
      int opponentIndex0 = l.indexOf(opponent.getDao());

      HandicapOffer offer = challenge.getOption().getOffer();
      if (offer != null) {
        movePlayerUp(l, challengerIndex);

        int opponentIndex = l.indexOf(opponent.getDao());
        if (opponentIndex == opponentIndex0) {
          movePlayerDown(l, opponentIndex);
        }
      } else {
        if (challengerIndex > opponentIndex0) {
          l.remove(challenger.getDao());
          l.add(opponentIndex0, challenger.getDao());
          moveUpOverInactive(l, opponentIndex0);
        }
      }
    } 
  }

  synchronized public void cancelChallenge(Challenge challenge, String note)
  {
    if (challenge != null) {
      HandicapOffer offer = challenge.getOption().getOffer();
      if (offer != null) {
        challenge.getOpponent().addOffer(offer);
      }
      challenge.cancelChallenge(note);
      saveLadderFile(ladderFile, this);
    }
  }

  /******* News *******/

  public synchronized void addAnnouncement(String note, boolean sticky) {
    Announcement a = new Announcement(note, sticky);
    dao.announcements.add(a.getDao());
    saveLadderFile(ladderFile, this);
  }

  public synchronized List<Announcement> getAnnouncements() {
    List<Announcement> out = new ArrayList<Announcement>();

    for (AnnouncementV2 a : dao.announcements) {
      Announcement a1 = new Announcement(a);
      out.add(a1);
    }    

    return out;
  }

  public synchronized void setSticky(Announcement a, boolean sticky) {
    a.setSticky(sticky);
    saveLadderFile(ladderFile, this);
  }

  public synchronized List<NewsItem> getRecentNews() {
    int days = 5;
    long daysInMilli = new Date().getTime() - 
      (days * 24 * 60 * 60 * 1000);

    List<NewsItem> out = new ArrayList<NewsItem>();

    List<Challenge> cRecentCloseList = getRecentCloseChallenges(days);

    for (AnnouncementV2 a : dao.announcements) {
      Announcement a1 = new Announcement(a);
      if (a1.isSticky() || (a1.getDate().getTime() > daysInMilli)) {
        out.add(a1);
      }
    }

    for(Iterator it = cRecentCloseList.iterator(); it.hasNext();) {
      Challenge c = (Challenge)it.next();

      if (c.getNote() != null) {
        out.add(new DefaultNewsItem(c.getScoreUpdatedDate(), 
                                    StringUtil.encodeHtml(c.getNote()),
                                    false));
      }
    }

    Collections.sort(out, new Comparator<NewsItem>() {
        public int compare(NewsItem i1, NewsItem i2) {
          if (i1.isSticky() && !i2.isSticky()) {
            return -1;
          }
          if (!i1.isSticky() && i2.isSticky()) {
            return 1;
          }
          return i2.getDate().compareTo(i1.getDate());
        }
      });        

    return out;
  }

  /******* Statistics *******/
  
  synchronized public Map<Player, PlayerStats> getAllPlayerStats() {
    return StatUtil.getStats(getPlayedCloseChallengeList(), getPlayerList());
  }

  /******* Challenge option *******/

  private boolean removeChallengeOption(ChallengeOption option) {

    Player offeredPlayer = option.getOpponent();
    boolean b = offeredPlayer.removeOffer(option.getOffer());
    saveLadderFile(ladderFile, this);
    return b;
  }


  /******* email notification *******/

  private void sendMailNotification(String from, 
                                    String[] to, 
                                    String[] cc,
                                    String subject, 
                                    String body) 
    throws Exception
  {
    MailUtil.send(getHostName(), from, to, cc, subject, body);
  }


  /******** Admin ********/

  synchronized public Object[] runAdminCmd(String cmd, Object state) {
    Object[] r = AdminConsole.execute(this, cmd, state);
    saveLadderFile(ladderFile, this);
    return r;
  }


  /******* Ladder file *******/

  synchronized public static Ladder loadLadderFile(File ladderFile) 
    throws Exception 
  {
    Ladder ladder;
    if (ladderFile.exists()) {
      FileInputStream fis = new FileInputStream(ladderFile);
      ObjectInputStream ois = new ObjectInputStream(fis);
      ladder = new Ladder((LadderV2) ois.readObject());
      ois.close();
    } else {
      ladder = new Ladder();
    }
    ladder.ladderFile = ladderFile;
    return ladder;
  }

  private static void saveLadderFile(File ladderFile, Ladder ladder) 
  {
    try {
      ByteArrayOutputStream buf = new ByteArrayOutputStream();
      ObjectOutputStream oos = new ObjectOutputStream(buf);
      oos.writeObject(ladder.dao);
      oos.close();

      IOUtil.writeBytesToFile(ladderFile, buf.toByteArray());
    } catch (IOException e) {
      throw new RuntimeException(e);
    }
  }

  public static void main(String[] args) throws Exception {

    /*
    File ladderFile = new File("ladder.bin");
    Ladder ladder = null;    

    if (!ladderFile.exists()) {
      ladder = new Ladder();
    } else {
      ladder = loadLadderFile(ladderFile);
    }

    System.out.println(ladder.playerList);
    System.out.println(ladder.challengeList);
    System.out.println("-------------");

    saveLadderFile(ladderFile, ladder);
    */
  }
}
