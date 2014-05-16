package ttLadder;

import java.io.File;

public class LadderHandle {
  final private Ladder m_ladder;

  public LadderHandle() {
    throw new Error("Can't use default constructor!");
  }

  LadderHandle(String fn) {
    try {
      m_ladder = Ladder.loadLadderFile(new File(fn));
    } catch (Throwable e) {
      throw new RuntimeException(e);
    }
  }

  public Ladder getLadder() throws Exception {
    return m_ladder;
  }
}
