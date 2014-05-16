package ttLadder;

import java.util.*;
import java.text.*;

public class DateUtil {
  /*
    Adds (or subtracts) days to the given date, skipping weekends and
    rounds to midnight.
  */

  public static Date addWorkDays(Date date, int days) {
    int step = days >= 0 ? 1 : -1;
    days = Math.abs(days);

    Calendar c = Calendar.getInstance();
    c.setTime(date);

    while (days > 0) {
      c.add(Calendar.DATE, step);
      int dayOfWeek = c.get(Calendar.DAY_OF_WEEK);
      if ((dayOfWeek!=Calendar.SATURDAY) && (dayOfWeek!=Calendar.SUNDAY) ) {
        days -= 1;
      }
    }

    if (step > 0) {
      c.set(Calendar.HOUR_OF_DAY, 23);
      c.set(Calendar.MINUTE, 59);
      c.set(Calendar.SECOND, 59);
    } else {
      c.set(Calendar.HOUR_OF_DAY, 0);
      c.set(Calendar.MINUTE, 0);
      c.set(Calendar.SECOND, 0);
    }
    return c.getTime();
  }

  /*
    For pattern - see
    http://java.sun.com/javase/6/docs/api/java/text/SimpleDateFormat.html
  */


  public static String formatDate(Date date, String pattern) {
    SimpleDateFormat f = new SimpleDateFormat(pattern);
    return f.format(date);
  }

  /*
    Returns true if given date is in the past
  */

  public static boolean isPast(Date d) {
    Date now = new Date();
    return d.before(now);
  }

  public static boolean isSameDay(Date d1, Date d2) {
    Calendar c1 = Calendar.getInstance();
    c1.setTime(d1);

    Calendar c2 = Calendar.getInstance();
    c2.setTime(d2);

    return c1.get(Calendar.YEAR) == c2.get(Calendar.YEAR) &&
      c1.get(Calendar.MONTH) == c2.get(Calendar.MONTH) &&
      c1.get(Calendar.DATE) == c2.get(Calendar.DATE);
  }

  public static void main(String args[]) throws Exception {
    Calendar c = Calendar.getInstance();
    c.set(Calendar.MONTH, Integer.parseInt(args[0]));
    c.set(Calendar.DAY_OF_MONTH, Integer.parseInt(args[1]));

    System.out.println(formatDate(c.getTime(), "EEE, MMM d"));
    Date d = addWorkDays(c.getTime(), Integer.parseInt(args[2]));
    System.out.println(formatDate(d, "EEE, MMM d"));
    System.out.println(d);
    System.out.println(isPast(d));
  }
}
