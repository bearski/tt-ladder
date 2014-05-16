package ttLadder.dao;

import ttLadder.*;
import java.io.*;
import java.util.*;

public class V0ToV1 {
  public static void main(String args[]) throws Exception {
    Ladder l0 = Ladder.loadLadderFile(new File(args[0]));

    LadderV1 l1 = new LadderV1();

    IdentityHashMap<Player, PlayerV1> playerMap = 
      new IdentityHashMap<Player, PlayerV1>();

    l1.playerList = new ArrayList<PlayerV1>();
    for (Player p0 : l0.getPlayerList()) {
      PlayerV1 p1 = new PlayerV1();
      p1.name = p0.getName();
      p1.pwd = p0.getPwd();
      p1.email = p0.getEmail();
      p1.status = p0.getStatus();
      l1.playerList.add(p1);

      playerMap.put(p0, p1);
    }

    l1.challengeList = new ArrayList<ChallengeV1>();
    for (Challenge c0 : l0.getChallengeList()) {
      ChallengeV1 c1 = new ChallengeV1();
      c1.challenger = playerMap.get(c0.getChallenger());
      c1.opponent = playerMap.get(c0.getOpponent());
      c1.type = c0.getType();
      c1.challengeCreatedDate = c0.getCreatedDate();
      c1.mustCompeteDate = c0.getMustCompeteDate();
      c1.isOpenChallenge = c0.isOpenChallenge();
      c1.scoreOfChallenger = c0.getScoreOfChallenger();
      c1.scoreOfChallengee = c0.getScoreOfChallengee();
      c1.scoreUpdatedDate = c0.getScoreUpdatedDate();
      l1.challengeList.add(c1);
    }

    l1.maxNumOfOpponents = l0.getMaxNumOfOpponents();
    l1.numOfDaysToUpdate = l0.getNumOfDaysToUpdate();
    l1.host = l0.getHostName();

    ByteArrayOutputStream buf = new ByteArrayOutputStream();
    ObjectOutputStream oos = new ObjectOutputStream(buf);
    oos.writeObject(l1);
    oos.close();

    IOUtil.writeBytesToFile(new File(args[1]), buf.toByteArray());
  }
}
