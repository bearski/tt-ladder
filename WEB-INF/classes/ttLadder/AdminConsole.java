package ttLadder;

import javax.script.*;
import java.io.*;
import java.util.*;

class AdminConsole {
  static Object[] execute(Ladder l, String cmd, Object state) 
  {
    try {
      Bindings b = (Bindings)state;
      ScriptEngineManager m = new ScriptEngineManager();
      ScriptEngine engine = m.getEngineByName("javascript");
      if (b == null) {
        b = engine.createBindings();
      }
      Bindings global = engine.createBindings();
      global.put("l", l); 

      engine.setBindings(global, ScriptContext.GLOBAL_SCOPE);
      Object lastResult = engine.eval(cmd, b);
      b.put("_r", lastResult);

      return new Object[] {
        b, mapToString(b)
      };
    } catch (Throwable t) {
      return new Object[] {
        state, t.toString()
      };
    }
  }

  static String mapToString(Map<String, Object> b) {
    StringBuilder sb = new StringBuilder();
    for (Map.Entry<String, Object> entry : b.entrySet()) {
      Object v = entry.getValue();
      String vs = toString(v);
      if (vs != null) {
        sb.append(entry.getKey() + ": " + vs + "\n");
      }
    }
    return sb.toString();
  }

  static String toString(Object o) {
    if (o.getClass().getCanonicalName().startsWith("sun.org")) {
      return null;
    }

    StringBuilder sb = new StringBuilder();
    if (o instanceof List) {
      sb.append("[");
      for (int i=0; i<((List)o).size(); i++) {
        if (i > 0) {
          sb.append(", ");
        }
        sb.append(i + ". " + toString(((List)o).get(i)));
      }
      sb.append("]");
    } else {
      sb.append(o.toString());
    }

    return sb.toString();
  }

  public static void main(String args[]) throws Exception {
    Ladder l = Ladder.loadLadderFile(new File(args[0]));
    Object bindings = null;
    BufferedReader read = new BufferedReader(new InputStreamReader(System.in));
    String cmd;
    while ((cmd=read.readLine()) != null) {
      Object[] r = execute(l, cmd, bindings);
      bindings = r[0];
      System.out.println(r[1]);
    }
  }
}