package ttLadder;

public class Test {
 
  public static void main(String[] args) {

    StringBuffer sb = new StringBuffer("a");


    if(sb == null) {
      System.out.println("null");
    }

    if(sb.toString().equals("a")) {
      System.out.println("xx");
    }

    StringBuffer sb2 = new StringBuffer();

    if(sb2 == null) {
      System.out.println("sb2 = null");
    }

    if(sb2.toString().equals("")) {
      System.out.println("xxx");
    }
    
  }

}
