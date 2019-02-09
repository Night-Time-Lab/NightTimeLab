import java.util.Scanner;

public class Square {

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        // Read the scanner
        while(scanner.hasNext()){
            // Read the input
            int i = scanner.nextInt();
            // Print the square
            System.out.println(i * i);
        }
        scanner.close();
    }
}

