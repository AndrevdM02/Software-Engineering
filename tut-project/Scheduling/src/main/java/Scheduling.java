import java.io.File;
import java.io.FileNotFoundException;
import java.util.Arrays;
import java.util.Scanner;
import java.io.FileWriter;

public class Scheduling {

    private static class Subject {
        String name;
        String lecturer;
        int code;
        int size;
        boolean[] assigned_venue = new boolean[5];
        boolean[] has_time = new boolean[5];
        Time[] available_time = new Time[5];
        Time[] not_available_time = new Time[5];
    }

    private static class Venue {
        String name;
        String building;
        int size_of_venue;
        Time[] available_times = new Time[5];
        Time[] not_available_times = new Time[5];
    }

    private static class Time {
        int[] startTime = new int[9];
        String day;
        Assigned[] assigned = new Assigned[9];
    }

    private static class Assigned {
        String name;
        String lecturer;
        int code;
    }

    static Subject[] subjects = new Subject[10000];
    static int number_of_subjects = 0;
    static Venue[] venues = new Venue[10000];
    static int number_of_venues = 0;

    public static void main(String[] args) {
        File f;
        File file;
        Arrays.fill(subjects, null);
        Arrays.fill(venues, null);
        number_of_subjects = 0;
        number_of_venues = 0;

        f = new File(args[0]);
        file = new File(args[1]);
        if (f.length() == 0 && file.length() == 0) {
            printEmptyError(args[2], true, true);
        } else if (f.length() == 0) {
            printEmptyError(args[2], true, false);
        } else if (file.length() == 0) {
            printEmptyError(args[2], false, true);
        } else {
            allModules(f);
            allVenues(file);
    
            for(int i = 0; i < number_of_subjects; i++) {
                for(int j = 0; j < number_of_venues; j++) {
                    check_size(i, j);
                }
            }
            printSchedule(args[2]);
        }
    }

    public static void allModules(File f) {
        try {
            Scanner scanner = new Scanner(f);
            String lector = new String();
            String day = new String();
            int weekDay;
            while (scanner.hasNextLine()) {
                Subject s = new Subject();
                if (lector.isEmpty()) {
                    s.lecturer = scanner.next();
                } else {
                    s.lecturer = lector;
                }
                s.name = scanner.next();
                s.code = scanner.nextInt();
                s.size = scanner.nextInt();

                for (int i = 0; i < 6; i++) {
                    if (scanner.hasNext()) {
                        day = scanner.next();
                        if (isDayOfWeek(day)) {
                            Time t = new Time();
                            Time T = new Time();
                            t.day = day;
                            T.day = day;
                            while (scanner.hasNextInt()) {
                                int time = scanner.nextInt();
                                int index = time_index(time);
                                t.startTime[index] = time;
                                s.assigned_venue[i] = false;
                                s.has_time[i] = true;
                            }
                            weekDay = dayOfWeek(day);
                            s.available_time[weekDay] = t;
                            s.not_available_time[weekDay] = T;
                        } else {
                            /* TODO */
                            lector = day;
                        }
                    }
                }
                subjects[number_of_subjects] = s;
                number_of_subjects++;
            }
            scanner.close();
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
        
    }

    public static void allVenues(File file) {
        try {
            Scanner scanner = new Scanner(file);
            String build = new String();
            String day = new String();
            int weekDay;
            while (scanner.hasNextLine()) {
                Venue v = new Venue();
                if (build.isEmpty()) {
                    v.building = scanner.next();
                } else {
                    v.building = build;
                }
                v.name = scanner.next();
                v.size_of_venue = scanner.nextInt();
                for (int i = 0; i < 6; i++) {
                    if (scanner.hasNext()) {
                        day = scanner.next();
                        if (isDayOfWeek(day)) {
                            Time t = new Time();
                            Time T = new Time();
                            t.day = day;
                            while (scanner.hasNextInt()) {
                                int time = scanner.nextInt();
                                int index = time_index(time);
                                t.startTime[index] = time;
                            }
                            weekDay = dayOfWeek(day);
                            v.available_times[weekDay] = t;
                            v.not_available_times[weekDay] = T;
                        } else {
                            /* TODO */
                            build = day;
                        }
                    }
                }
                venues[number_of_venues] = v;
                number_of_venues++;
            }
            scanner.close();
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
    }

    public static void check_size(int num_sub, int num_ven) {
        if(subjects[num_sub].size <= venues[num_ven].size_of_venue) {
            is_available(num_sub, num_ven);
        }
    }

    public static void is_available(int num_sub, int num_ven) {
        for (int i = 0; i < 5; i++) {
            if(subjects[num_sub].available_time[i] != null && venues[num_ven].available_times[i] != null) {
                for(int j = 0; j < 9; j++) {
                    for(int k = 0; k < 9; k++) {
                        int subject_time = subjects[num_sub].available_time[i].startTime[j];
                        int venue_time = venues[num_ven].available_times[i].startTime[k];
                        if(subject_time != 0 && venue_time != 0) {
                            if(subject_time == venue_time) {
                                if(not_available_times(num_ven, num_sub, venue_time, i)) {
                                    j = 8;
                                    k = 8;
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    public static boolean not_available_times(int num_ven, int num_sub, int venue_time, int day) {
        int index = time_index(venue_time);
        Assigned a = new Assigned();
        String curr_day = scheduledDay(day);

        if (!subjects[num_sub].assigned_venue[day]) {
            if (venues[num_ven].not_available_times[day].startTime[index] == 0 && subjects[num_sub].not_available_time[day].startTime[index] == 0) {
                venues[num_ven].not_available_times[day].startTime[index] = venue_time;
                venues[num_ven].not_available_times[day].day = curr_day;
                subjects[num_sub].not_available_time[day].startTime[index] = venue_time;
                subjects[num_sub].assigned_venue[day] = true;

                a.name = subjects[num_sub].name;
                a.lecturer = subjects[num_sub].lecturer;
                a.code = subjects[num_sub].code;

                venues[num_ven].not_available_times[day].assigned[index] = a;
                return true;
            }
        }
        return false;
    }

    public static int time_index(int venue_time) {
        switch(venue_time) {
            case 8:
                return 0;
            case 9: 
                return 1;
            case 10:
                return 2;
            case 11:
                return 3;
            case 12: 
                return 4;
            case 13:
                return 5;
            case 14:
                return 6;
            case 15: 
                return 7;
            case 16:
                return 8;
            default:
                System.out.println("Error in input file! Time of day can only be between 8-16");
                System.exit(0);
                return 10;
        }
    }

    public static String scheduledDay(int day) {
        switch (day) {
            case 0:
                return "Monday";
            case 1:
                return "Tuesday";
            case 2:
                return "Wednesday";
            case 3:
                return "Thursday";
            case 4:
                return "Friday";
            default:
                return null;
        }
    }

    public static boolean isDayOfWeek(String day) {
        switch (day) {
            case "Monday":
                return true;
            case "Tuesday":
                return true;
            case "Wednesday":
                return true;
            case "Thursday":
                return true;
            case "Friday":
                return true;
            default:
                return false;
        }
    }

    public static int dayOfWeek(String day) {
        switch (day) {
            case "Monday":
                return 0;
            case "Tuesday":
                return 1;
            case "Wednesday":
                return 2;
            case "Thursday":
                return 3;
            case "Friday":
                return 4;
            default:
                return 5;
        }
    }

    public static void printSchedule(String filepath) {
        try {
            FileWriter writer = new FileWriter(filepath);

            for (int i = 0; i < number_of_venues; i++) {
                writer.write(venues[i].building + " " + venues[i].name + "\n");
                for (int k = 0; k < 5; k++) {
                    if (venues[i].not_available_times[k] != null && venues[i].not_available_times[k].day != null) {
                        writer.write("\t" + venues[i].not_available_times[k].day + ":\n");
                        for (int j = 0; j < 9; j++) {
                            if (venues[i].not_available_times[k].startTime[j] != 0) {
                                writer.write("\t\t" + venues[i].not_available_times[k].startTime[j] + ":\n");
                                writer.write("\t\t\t" + venues[i].not_available_times[k].assigned[j].name + " " 
                                + venues[i].not_available_times[k].assigned[j].code + "\n");
                                writer.write("\t\t\t" + venues[i].not_available_times[k].assigned[j].lecturer + "\n");
                            }
                        }
                    }
                }
            }
            for (int i = 0; i < number_of_subjects; i++)  {
                for (int k = 0; k < 5; k++) {
                    if (subjects[i].assigned_venue[k] == false && subjects[i].has_time[k] == true) {
                        writer.write("Could not assign venue to " + subjects[i].name + " " + subjects[i].code + " " + subjects[i].available_time[k].day + "\n");
                    }
                }
            }
            writer.close();
        } catch (Exception e) {
            // TODO: handle exception
        }
    }

    public static void printEmptyError(String filepath, boolean module, boolean venue) {
        try {
            if (module && venue) {
                FileWriter writer = new FileWriter(filepath);
                writer.write("Error in input files! Both the module and venue file is empty.");
                writer.close();
            } else if (module) {
                FileWriter writer = new FileWriter(filepath);
                writer.write("Error in input file! Module file is empty.");
                writer.close();
            } else {
                FileWriter writer = new FileWriter(filepath);
                writer.write("Error in input file! Venue file is empty.");
                writer.close();
            }
        } catch (Exception e) {
            // TODO: handle exception
        }
    }
}