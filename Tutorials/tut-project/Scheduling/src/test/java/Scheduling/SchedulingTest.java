package Scheduling;

import org.apache.commons.io.FileUtils;
import org.junit.Assert;
import org.junit.Test;
import java.io.File;

public class SchedulingTest {

    @Test
    public void EmptyModules() {
        String[] args = new String[3];
        args[0] = "src/test/java/resources/EmptyModules.txt";
        args[1] = "src/test/java/resources/venues1.txt";
        args[2] = "src/main/java/resources/EmptyModules.txt";
        try {
            File file = new File(args[2]);
            if (file.createNewFile()) {
                Scheduling.main(args);
            } else {
                Scheduling.main(args);
            }
            File expectedFile = new File("src/test/java/test_files/EmptyModules.txt");
            Assert.assertTrue(FileUtils.contentEquals(file, expectedFile));
        } catch (Exception e) {
            // TODO: handle exception
        }
    }

    @Test
    public void EmptyVenues() {
        String[] args = new String[3];
        args[0] = "src/test/java/resources/modules1.txt";
        args[1] = "src/test/java/resources/EmptyVenues.txt";
        args[2] = "src/main/java/resources/EmptyVenues.txt";
        try {
            File file = new File(args[2]);
            if (file.createNewFile()) {
                Scheduling.main(args);
            } else {
                Scheduling.main(args);
            }
            File expectedFile = new File("src/test/java/test_files/EmptyVenues.txt");
            Assert.assertTrue(FileUtils.contentEquals(file, expectedFile));
        } catch (Exception e) {
            // TODO: handle exception
        }
    }

    @Test
    public void EmptyModulesandVenues() {
        String[] args = new String[3];
        args[0] = "src/test/java/resources/EmptyModules.txt";
        args[1] = "src/test/java/resources/EmptyVenues.txt";
        args[2] = "src/main/java/resources/EmptyModulesandVenues.txt";
        try {
            File file = new File(args[2]);
            if (file.createNewFile()) {
                Scheduling.main(args);
            } else {
                Scheduling.main(args);
            }
            File expectedFile = new File("src/test/java/test_files/EmptyModulesandVenues.txt");
            Assert.assertTrue(FileUtils.contentEquals(file, expectedFile));
        } catch (Exception e) {
        }
    }

    @Test
    public void MainTest1() {
        String[] args = new String[3];
        args[0] = "src/test/java/resources/modules1.txt";
        args[1] = "src/test/java/resources/venues1.txt";
        args[2] = "src/main/java/resources/Scheduled1.txt";
        try {
            File file = new File(args[2]);
            if (file.createNewFile()) {
                Scheduling.main(args);
            } else {
                Scheduling.main(args);
            }
            File expectedFile = new File("src/test/java/test_files/Scheduling1.txt");
            Assert.assertTrue(FileUtils.contentEquals(file, expectedFile));
        } catch (Exception e) {
        }
    }

    @Test
    public void MainTest2() {
        String[] args = new String[3];
        args[0] = "src/test/java/resources/modules2.txt";
        args[1] = "src/test/java/resources/venues2.txt";
        args[2] = "src/main/java/resources/Scheduled2.txt";
        try {
            File file = new File(args[2]);
            if (file.createNewFile()) {
                Scheduling.main(args);
            } else {
                Scheduling.main(args);
            }
            File expectedFile = new File("src/test/java/test_files/Scheduling2.txt");
            Assert.assertTrue(FileUtils.contentEquals(file, expectedFile));
        } catch (Exception e) {
        }
    }

    @Test
    public void MainTest3() {
        String[] args = new String[3];
        args[0] = "src/test/java/resources/modules3.txt";
        args[1] = "src/test/java/resources/venues3.txt";
        args[2] = "src/main/java/resources/Scheduled3.txt";
        try {
            File file = new File(args[2]);
            if (file.createNewFile()) {
                Scheduling.main(args);
            } else {
                Scheduling.main(args);
            }
            File expectedFile = new File("src/test/java/test_files/Scheduling3.txt");
            Assert.assertTrue(FileUtils.contentEquals(file, expectedFile));
        } catch (Exception e) {
        }
    }

    @Test
    public void MainTest4() {
        String[] args = new String[3];
        args[0] = "src/test/java/resources/modules4.txt";
        args[1] = "src/test/java/resources/venues4.txt";
        args[2] = "src/main/java/resources/Scheduled4.txt";
        try {
            File file = new File(args[2]);
            if (file.createNewFile()) {
                Scheduling.main(args);
            } else {
                Scheduling.main(args);
            }
            File expectedFile = new File("src/test/java/test_files/Scheduling4.txt");
            Assert.assertTrue(FileUtils.contentEquals(file, expectedFile));
        } catch (Exception e) {
        }
    }

    @Test
    public void MainTest5() {
        String[] args = new String[3];
        args[0] = "src/test/java/resources/modules5.txt";
        args[1] = "src/test/java/resources/venues4.txt";
        args[2] = "src/main/java/resources/Scheduled5.txt";
        try {
            File file = new File(args[2]);
            if (file.createNewFile()) {
                Scheduling.main(args);
            } else {
                Scheduling.main(args);
            }
            File expectedFile = new File("src/test/java/test_files/Scheduling5.txt");
            Assert.assertTrue(FileUtils.contentEquals(file, expectedFile));
        } catch (Exception e) {
        }
    }

    @Test
    public void Not_Available() {
        String[] args = new String[3];
        args[0] = "src/test/java/resources/modules_not_available.txt";
        args[1] = "src/test/java/resources/venues_not_available.txt";
        args[2] = "src/main/java/resources/Not_available.txt";
        try {
            File file = new File(args[2]);
            if (file.createNewFile()) {
                Scheduling.main(args);
            } else {
                Scheduling.main(args);
            }
            File expectedFile = new File("src/test/java/test_files/Not_available.txt");
            Assert.assertTrue(FileUtils.contentEquals(file, expectedFile));
        } catch (Exception e) {
        }
    }
}
