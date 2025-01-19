import java.util.Scanner;

public class Greeter {
    public static void main(String[] args) {
        // System.out.println("Hi " + getName());
        String name = args[0];
        greeter(name);
        goodbye(name);
    }

    /**
      * Greets the person running the program, by asking for their name.
      */
    // public static String getName() {
    //      Scanner myObj = new Scanner(System.in);
    //      String name = myObj.nextLine();
    //      return name;
    // }

     /**
      * Greets the person running the program.
      * @param name The user's name
      */
    public static void greeter(String name) {
        System.out.println("Hi " + name + " how was your day?");
    }

    public static void goodbye(String name) {
        System.out.println("Goodbye " + name + " have a great day!");
    }

}
