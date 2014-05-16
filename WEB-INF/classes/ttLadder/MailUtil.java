package ttLadder;

import javax.mail.Session;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import java.util.Date;
import java.util.Properties;

public class MailUtil {
  public static void send(String host, String from, 
                          String[] tos, String[] ccs, String subject, 
                          String body)
    throws Exception
  {
    Properties props = new Properties();
    props.put("mail.smtp.host", host);
    
    Session session = Session.getDefaultInstance(props, null);
    
    MimeMessage msg = new MimeMessage(session);

    InternetAddress fromAddr = new InternetAddress(from);

    InternetAddress[] toAddrs = addrsFromStrings(tos);
    InternetAddress[] ccAddrs = addrsFromStrings(ccs);

    msg.setFrom(fromAddr);
    msg.setRecipients(Message.RecipientType.TO, toAddrs);
    msg.setRecipients(Message.RecipientType.CC, ccAddrs);
    msg.setSubject(subject);
    msg.setText(body);
    msg.setSentDate(new Date());
    Transport.send(msg);
  }

  private static InternetAddress[] addrsFromStrings(String[] s) 
    throws Exception 
  {
    InternetAddress[] out = new InternetAddress[s.length];
    for (int i=0; i<s.length; i++){
      out[i] = new InternetAddress(s[i]);
    }
    return out;
  }

  public static void main(String args[]) throws Exception {
    send(args[0], args[1], new String[] {args[2]}, 
         new String[] {args[3]}, args[4], args[5]);
  }
}
