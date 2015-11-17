import java.util.Hashtable;
import java.util.Enumeration;
import java.util.PriorityQueue;
import java.util.Comparator;
import java.util.Map;

public class HuffmanTranslator{
  private Hashtable<String, Integer> frequencies = new Hashtable<String, Integer>();
  private Tree encoder = new Tree();

  public HuffmanTranslator() {
    frequencies.put("A", 19);
    frequencies.put("B", 16);
    frequencies.put("C", 17);
    frequencies.put("D", 11);
    frequencies.put("E", 42);
    frequencies.put("F", 12);
    frequencies.put("G", 14);
    frequencies.put("H", 17);
    frequencies.put("I", 16);
    frequencies.put("J", 5);
    frequencies.put("K", 10);
    frequencies.put("L", 20);
    frequencies.put("M", 19);
    frequencies.put("N", 24);
    frequencies.put("O", 18);
    frequencies.put("P", 13);
    frequencies.put("Q", 1);
    frequencies.put("R", 25);
    frequencies.put("S", 35);
    frequencies.put("T", 25);
    frequencies.put("U", 15);
    frequencies.put("V", 5);
    frequencies.put("W", 21);
    frequencies.put("X", 2);
    frequencies.put("Y", 8);
    frequencies.put("Z", 3);
  }

  public void printFrequencies() {
    Enumeration names;
    String str;

    names = frequencies.keys();
    while(names.hasMoreElements()) {
      str = (String) names.nextElement();
      System.out.println(str + ": " + frequencies.get(str));
    }
    System.out.println();
  }

  public void buildEncoderTree() {
    Enumeration names;
    String str;
    MinQueue queue = new MinQueue();

    names = frequencies.keys();
    while(names.hasMoreElements()) {
      str = (String) names.nextElement();
      queue.insert(str, (int) frequencies.get(str));
      //queue.print();
      //System.out.println();
    }

    queue.print();

  }
}