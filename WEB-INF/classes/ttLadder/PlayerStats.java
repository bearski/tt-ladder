package ttLadder;

public class PlayerStats {
    
  Player player;
  public int matches;
  public int matchesWon;
  public int matchesLost;
  public int gamesWon;
  public int gamesLost;
  public int beChallenger;
  public int beOpponent;

  public Boolean streakType;
  public int streak;
  public boolean streakComplete;

  PlayerStats(Player player, 
              int matches,
              int matchesWon,
              int matchesLost,
              int gamesWon,
              int gamesLost,
              int beChallenger,
              int beOpponent,
              Boolean streakType,
              int streak)
  {
    this.player = player;
    this.matches = matches;
    this.matchesWon = matchesWon;
    this.matchesLost = matchesLost;
    this.gamesWon = gamesWon;
    this.gamesLost = gamesLost;
    this.beChallenger = beChallenger;
    this.beOpponent = beOpponent;
    this.streakType = streakType;
    this.streak = streak;
  }

  PlayerStats(Player player) {
    this(player, 0, 0, 0, 0, 0, 0, 0, null, 0);
  }



}
