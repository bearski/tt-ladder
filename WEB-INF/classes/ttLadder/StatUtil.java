package ttLadder;

import java.util.*;
import java.io.*;

public class StatUtil {

  public static Map<Player, PlayerStats> getStats
    (List<Challenge> cList, List<Player> pList) {

    Map<Player, PlayerStats> map = new LinkedHashMap<Player, PlayerStats>();
    for(Player p: pList) {
      map.put(p, new PlayerStats(p));
    }

    for (Challenge c : cList) {
      // as a challenger
      Player challenger = c.getChallenger();
      PlayerStats s1 = map.get(challenger);

      if(s1 != null) {
        s1.matches++;
        if(c.hasWon(challenger.getName())) {
          s1.matchesWon++;
        } else {
          s1.matchesLost++;
        }
        s1.gamesWon += c.getScoreOfChallenger();
        s1.gamesLost += c.getScoreOfChallengee();
        s1.beChallenger++;
      
        //// finding a streak as a challenger
        boolean isChWonInThisChallenge = c.hasWon(s1.player.getName());
        
        if(!s1.streakComplete) {
          if(s1.streakType == null) {
            if(isChWonInThisChallenge) {
              s1.streakType = true;
            } else {
              s1.streakType = false;
            }
            s1.streak++;
          } else if((s1.streakType == true && isChWonInThisChallenge) ||
                    (s1.streakType == false && !isChWonInThisChallenge)) {
            s1.streak++;
          } else if((s1.streakType == true && !isChWonInThisChallenge) ||
                    (s1.streakType == false && isChWonInThisChallenge)) {
            s1.streakComplete = true;
          }
        }
        map.put(challenger, s1);
      }

      // as an opponents
      Player opponent = c.getOpponent();
      PlayerStats s2 = map.get(opponent);

      if(s2 != null) {
        s2.matches++;
        if(c.hasWon(opponent.getName())) {
          s2.matchesWon++;
        } else {
          s2.matchesLost++;
        }
        s2.gamesWon += c.getScoreOfChallengee();
        s2.gamesLost += c.getScoreOfChallenger();
        s2.beOpponent++;
      
        //// finding a streak as an opponent
        boolean isOpWonInThisChallenge = c.hasWon(s2.player.getName());
        
        if(!s2.streakComplete) {
          if(s2.streakType == null) {
            if(isOpWonInThisChallenge) {
              s2.streakType = true;
            } else {
              s2.streakType = false;
            }
            s2.streak++;
          } else if((s2.streakType == true && isOpWonInThisChallenge) ||
                    (s2.streakType == false && !isOpWonInThisChallenge)) {
            s2.streak++;
          } else if((s2.streakType == true && !isOpWonInThisChallenge) ||
                    (s2.streakType == false && isOpWonInThisChallenge)) {
            s2.streakComplete = true;
          }
        }
        map.put(opponent, s2);
      }
    }
    return map;
  }

  public static void print(Map<Player, PlayerStats> map) {
    for (Map.Entry<Player, PlayerStats> e : map.entrySet()) {
      System.out.println(e.getKey().getName() + 
                         "  :matches =" + e.getValue().matches + "\n" +
                         "  :matchesWon =" + e.getValue().matchesWon + "\n" +
                         "  :matchesLost =" + e.getValue().matchesLost + "\n" +
                         "  :gamesWon =" + e.getValue().gamesWon + "\n" +
                         "  :gamesLost =" + e.getValue().gamesLost + "\n" +
                         "  :be CH =" + e.getValue().beChallenger + "\n" +
                         "  :be OP =" + e.getValue().beOpponent + "\n");
    }
  }

  public static void main (String[] args) throws Exception{
    Ladder l = Ladder.loadLadderFile(new File(args[0]));
    print(getStats(l.getPlayedCloseChallengeList(), 
                             l.getPlayerList()));
  }
  

}
