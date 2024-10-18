import java.util.concurrent.Semaphore;
import java.util.Random;

public class SenateBusProblem {
    // Shared variables
    private static int waiting = 0; // Number of waiting riders
    private static final Semaphore mutex = new Semaphore(1); // To protect waiting count
    private static final Semaphore bus = new Semaphore(0); // Signaled when bus arrives
    private static final Semaphore boarded = new Semaphore(0); // Signaled when rider boards

    private static final Random random = new Random();
    private static final double BUS_MEAN_INTER_ARRIVAL = 20 * 60; // 20 minutes in seconds
    private static final double RIDER_MEAN_INTER_ARRIVAL = 30; // 30 seconds

    // Rider thread
    static class Rider extends Thread {
        @Override
        public void run() {
            try {
                // Lock to update the number of waiting riders
                mutex.acquire();
                waiting += 1;
                mutex.release();

                // Wait for the bus to signal that it's ready to board
                bus.acquire();

                // After receiving the bus signal, board the bus
                board();
                boarded.release(); // Signal that rider has boarded
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
        }

        private void board() {
            // Simulate boarding the bus
            System.out.println("Rider has boarded the bus.");
        }
    }

    // Bus thread
    static class Bus extends Thread {
        private static int MAX_RIDERS; // Maximum number of riders the bus can carry

        public Bus(int maxRiders) {
            MAX_RIDERS = maxRiders; // Set the maximum number of riders the bus can carry
        }

        @Override
        public void run() {
            try {
                // Bus arrives
                mutex.acquire();
                int n = Math.min(waiting, MAX_RIDERS); // Limit number of riders boarding to MAX_RIDERS
                for (int i = 0; i < n; i++) {
                    bus.release(); // Signal riders to board
                    boarded.acquire(); // Wait for rider to board
                }

                waiting = Math.max(waiting - MAX_RIDERS, 0); // Update the number of remaining riders
                mutex.release();

                // Depart after all boarding is done
                depart();
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
        }

        private void depart() {
            // Simulate the bus departing
            System.out.println("Bus is departing.");
        }
    }

    public static void main(String[] args) {
        // Test case - Simulate the test case where the busses and riders will continue
        // to arrive throughout the day.
        // Assume inter-arrival time of busses and riders are exponentially distributed
        // with a mean of 20 min and 30 sec, respectively.

        // Start thread to continuously generate riders
        new Thread(() -> {
            while (true) {
                try {
                    // Create a new rider and start the thread
                    new Rider().start();

                    // Wait for the next rider to arrive based on exponential distribution
                    double riderArrivalTime = getExponentialRandom(RIDER_MEAN_INTER_ARRIVAL);
                    Thread.sleep((long) (riderArrivalTime * 1000)); // Convert to milliseconds
                } catch (InterruptedException e) {
                    Thread.currentThread().interrupt();
                }
            }
        }).start();

        // Start thread to continuously generate buses
        new Thread(() -> {
            while (true) {
                try {
                    // Create a new bus and start the thread
                    new Bus(50).start();

                    // Wait for the next bus to arrive based on exponential distribution
                    double busArrivalTime = getExponentialRandom(BUS_MEAN_INTER_ARRIVAL);
                    Thread.sleep((long) (busArrivalTime * 1000)); // Convert to milliseconds
                } catch (InterruptedException e) {
                    Thread.currentThread().interrupt();
                }
            }
        }).start();

    }

    // Method to generate exponentially distributed inter-arrival time
    private static double getExponentialRandom(double mean) {
        return -mean * Math.log(random.nextDouble());
    }
}
