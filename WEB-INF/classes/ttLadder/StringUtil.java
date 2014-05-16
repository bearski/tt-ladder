package ttLadder;

import java.io.*;

public class StringUtil {

  public static int[] getMinMaxValues(String[] values) {

    if((values == null) || (values.length==0)) {
      return null;
    }
   
    int min = Integer.parseInt(values[0]);
    int max = Integer.parseInt(values[0]);

    for(int i=1; i<values.length; i++) {
      int value = Integer.parseInt(values[i]);
      if(value < min) {
        min = value;
      }
      if(value > max) {
        max = value;
      }
    }     
    return new int[] {min, max};
  } 

  public static String encodeHtml(String s) {
    StringBuilder out = new StringBuilder();

    for (char c : s.toCharArray()) {
      switch(c) {
      case '&':
        out.append("&amp;");
        break;
      case '"':
        out.append("&quot;");
        break;
      case '<':
        out.append("&lt;");
        break;
      case '>':
        out.append("&gt;");
        break;
      default:
        out.append(c);
      }
    }

    return out.toString();
  }

  public static void main (String[] args) {
    String[] s = {"2"};
    int[] result = getMinMaxValues(s);
    
    if(result == null) {
      System.out.println("null");
    } else {
      System.out.println("min=" + result[0]);
      System.out.println("max=" + result[1]);
    }

  }

}
