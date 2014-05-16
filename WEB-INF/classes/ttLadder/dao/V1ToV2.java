package ttLadder.dao;

import ttLadder.*;
import java.io.*;
import java.util.*;

public class V1ToV2 {
  public static void main(String args[]) throws Exception {
    FileInputStream fis = new FileInputStream(args[0]);
    ObjectInputStream ois = new ObjectInputStream(fis);
    LadderV1 l0 = ((LadderV1) ois.readObject());
    ois.close();

    LadderV2 l1 = new LadderV2();

    IdentityHashMap<PlayerV1, PlayerV2> playerMap = 
      new IdentityHashMap<PlayerV1, PlayerV2>();

    l1.playerList = new ArrayList<PlayerV2>();
    for (PlayerV1 p0 : l0.playerList) {
      PlayerV2 p1 = new PlayerV2();
      p1.name = p0.name;
      p1.pwd = p0.pwd;
      p1.email = p0.email;
      p1.status = p0.status;
      p1.offers = new ArrayList<HandicapOfferV2>();
      p1.allowsHandicaps = false;

      l1.playerList.add(p1);

      playerMap.put(p0, p1);
    }

    l1.challengeList = new ArrayList<ChallengeV2>();
    for (ChallengeV1 c0 : l0.challengeList) {
      ChallengeV2 c1 = new ChallengeV2();
      c1.challenger = playerMap.get(c0.challenger);
      c1.option = new ChallengeOptionV2();
      c1.option.opponent = playerMap.get(c0.opponent);
      c1.option.offer = null;
      c1.option.type = -1;
      c1.challengeCreatedDate = c0.challengeCreatedDate;
      c1.mustCompeteDate = c0.mustCompeteDate;
      c1.isOpenChallenge = c0.isOpenChallenge;
      c1.scoreOfChallenger = c0.scoreOfChallenger;
      c1.scoreOfChallengee = c0.scoreOfChallengee;
      c1.scoreUpdatedDate = c0.scoreUpdatedDate;
      c1.note = null;
      l1.challengeList.add(c1);
    }

    l1.maxNumOfOpponents = l0.maxNumOfOpponents;
    l1.numOfDaysToUpdate = l0.numOfDaysToUpdate;
    l1.host = l0.host;

    l1.announcements = new ArrayList<AnnouncementV2>();

    ByteArrayOutputStream buf = new ByteArrayOutputStream();
    ObjectOutputStream oos = new ObjectOutputStream(buf);
    oos.writeObject(l1);
    oos.close();

    IOUtil.writeBytesToFile(new File(args[1]), buf.toByteArray());
  }
}
