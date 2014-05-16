package ttLadder;

import java.io.*;
import java.util.Arrays;

public class IOUtil {
  static public void writeBytesToFile(File f, byte[] d) throws IOException
  {
    FileOutputStream os = new FileOutputStream(f);
    os.write(d);
    os.close();

    FileInputStream is = new FileInputStream(f);
    byte[] dIn = readBytes(is);
    is.close();
    
    if (!Arrays.equals(d, dIn)) {
      throw new IOException("File is corrupt: " + f.getName());
    }
  }

  static public byte[] readBytes(InputStream i) throws IOException
  {
    ByteArrayOutputStream outBuf = new ByteArrayOutputStream();

    byte[] inBuf = new byte[1024];
    int c;

    while ( (c=i.read(inBuf)) >= 0) {
      outBuf.write(inBuf, 0, c);
    }

    return outBuf.toByteArray();
  }
}
