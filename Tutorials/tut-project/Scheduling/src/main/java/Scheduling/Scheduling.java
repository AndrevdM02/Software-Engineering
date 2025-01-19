package Scheduling;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.Arrays;
import java.util.Scanner;
import java.io.FileWriter;

public class Scheduling {

    private static class Subject {
        String name;
        String lecturer;
        String faculty;
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
        boolean has_lecture = false;
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
    static boolean[][] ems_faculty = new boolean[5][9];
    static boolean[][] ems_faculty_maths = new boolean[5][9];
    static boolean[][] bsc_faculty_compsci = new boolean[5][9];
    static boolean[][] bsc_faculty = new boolean[5][9];
    static boolean[][] arts_faculty = new boolean[5][9];

    
    /** 
     * Main function responisble for running the program.
     * 
     * @param args  an array of strings that contains the command line arguments.
     */
    public static void main(String[] args) {
        File f;
        File file;
        //Resets the arrays.
        Arrays.fill(subjects, null);
        Arrays.fill(venues, null);
        for (int i = 0; i < 5; i++) {
            Arrays.fill(ems_faculty[i], false);
            Arrays.fill(ems_faculty_maths[i], false);
            Arrays.fill(bsc_faculty_compsci[i], false);
            Arrays.fill(bsc_faculty[i], false);
            Arrays.fill(arts_faculty[i], false);
        }
        number_of_subjects = 0;
        number_of_venues = 0;

        //Creates a file object for the modules and venues file.
        f = new File(args[0]);
        file = new File(args[1]);
        //Checks if files is empty.
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
            //Prints to file.
            printSchedule(args[2]);
        }
    }

    
    /** 
     * Takes all of the information from the modules input file and
     * assigns the information to the appropriate fields.
     * 
     * @param f  the modules file obtained from the command line argument.
     */
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
                s.faculty = scanner.next();
                s.code = scanner.nextInt();
                s.size = scanner.nextInt();

                for (int i = 0; i < 6; i++) {
                    if (scanner.hasNext()) {
                        day = scanner.next();
                        if (isDayOfWeek(day)) {
                            //Assigns all the times a module is available on a day.
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
                            //If the lecturers name has been read in above code searching for all the days.
                            lector = day;
                        }
                    }
                }
                //Assign the new Subjects object to the appropriate index of the subjects array.
                subjects[number_of_subjects] = s;
                number_of_subjects++;
            }
            scanner.close();
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
        
    }

    
    /** 
     * Takes all of the information from the venues input file and
     * assigns the information to the appropriate fields.
     * 
     * @param file  the venues file obtained from the command line argument.
     */
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
                            //Assigns all the times a module is available on a day.
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
                            //If the building's name has been read in above code searching for all the days.
                            build = day;
                        }
                    }
                }
                //Assign the new Venues object to the appropriate index of the venues array.
                venues[number_of_venues] = v;
                number_of_venues++;
            }
            scanner.close();
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
    }

    
    /** 
     * Checks if the number of students enrolled into a module is less than the
     * the size of the venue.
     * 
     * @param num_sub  The current index of the subjects array.
     * @param num_ven  The current index of the venues array.
     */
    public static void check_size(int num_sub, int num_ven) {
        if(subjects[num_sub].size <= venues[num_ven].size_of_venue) {
            is_available(num_sub, num_ven);
        }
    }

    
    /** 
     * Checks if the venue's available times has a match with the modules available time.
     * 
     * @param num_sub  The current index of the subjects array.
     * @param num_ven  The current index of the venues array.
     */
    public static void is_available(int num_sub, int num_ven) {
        int index = 0;
        for (int i = 0; i < 5; i++) {
            //Checks if the times have been assigned to both the venues and subjects array.
            if(subjects[num_sub].available_time[i] != null && venues[num_ven].available_times[i] != null) {
                for(int j = 0; j < 9; j++) {
                    for(int k = 0; k < 9; k++) {
                        int subject_time = subjects[num_sub].available_time[i].startTime[j];
                        int venue_time = venues[num_ven].available_times[i].startTime[k];
                        if(subject_time != 0 && venue_time != 0) {
                            //Checks if the times of the venue and module of a given day matches.
                            if(subject_time == venue_time) {
                                if (same_faculty(num_sub, subject_time, i)) {
                                    //Checks the faculty of a module and if that time is available.
                                    if(not_available_times(num_ven, num_sub, venue_time, i)) {
                                        index = time_index(subject_time);
                                        //Sets the faculties times as true to ensure no clashes.
                                        if (subjects[num_sub].faculty.equals("ArtsSciences")) {
                                            arts_faculty[i][index] = true;
                                        } else if (subjects[num_sub].faculty.equals("EMS")) {
                                            ems_faculty[i][index] = true;
                                        } else if (subjects[num_sub].faculty.equals("EMS_maths")) {
                                            ems_faculty_maths[i][index] = true;
                                        } else if (subjects[num_sub].faculty.equals("BSC_compsci")) {
                                            bsc_faculty_compsci[i][index] = true;
                                        } else {
                                            bsc_faculty[i][index] = true;
                                        }
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
    }

    
    /** 
     * Checks if the module has already been assigned a venue on a given day and assigns 
     * a venue to a module if this is not the case.
     * 
     * @param num_ven  The current index of the venues array.
     * @param num_sub  The current index of the subjects array.
     * @param venue_time  The time of day that both of the module and venue is available.
     * @param day   The day of the week.
     * @return true if the module has been assigned a venue and false if not.
     */
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
                venues[num_ven].has_lecture = true;
                return true;
            }
        }
        return false;
    }

    
    /** 
     * Checks if the module time does not clash with another module of the same faculty.
     * 
     * @param num_sub  The current index of the subjects array.
     * @param subject_time  The time of the current module being checked for clashes.
     * @param day   The day of the week.
     * @return true if the module has no clashes in its faculty. false if there is a clash with another module at the same time.
     */
    public static boolean same_faculty (int num_sub, int subject_time, int day) {
        int index = time_index(subject_time);
        if (subjects[num_sub].faculty.equals("ArtsSciences")) {
            if (!arts_faculty[day][index]) {
                return true;
            } else {
                return false;
            }
        } else if (subjects[num_sub].faculty.equals("EMS")) {
            if (!ems_faculty[day][index]) {
                return true;
            } else {
                return false;
            }
        } else if (subjects[num_sub].faculty.equals("EMS_maths")) {
            if (!ems_faculty_maths[day][index]) {
                return true;
            } else {
                return false;
            }
        } else if (subjects[num_sub].faculty.equals("BSC_compsci")) {
            if (!bsc_faculty_compsci[day][index]) {
                return true;
            } else {
                return false;
            }
        } else {
            if (!bsc_faculty[day][index]) {
                return true;
            } else {
                return false;
            }
        }
    }

    
    /** 
     * Chekcs the current time of the venue and converts it to the appropriate index in the time array.
     * 
     * @param venue_time  The available time of the venue.
     * @return  the index of the array given the time.
     */
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

    
    /** 
     * Checks the number assigned to a given day and returns the corrosonding day.
     * 
     * @param day   The day of the week.
     * @return the day of the week corrosponding their assigned integers.
     */
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

    
    /** 
     * Checks if the day from the input file is a valid day.
     * 
     * @param day  The day of the week.
     * @return true if it is a valid day else returns false.
     */
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

    
    /** 
     * Gets the integer that each day of the week is assigned to.
     * 
     * @param day  The day of the week.
     * @return the corrosponding integer assigned to a day of the week.
     */
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

    
    /** 
     * Creates a new file and then prints the venues and the modules assigned to each module on a given day.
     * 
     * @param filepath  the third command line integer that contains the path and name needed to create the output file.
     */
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
                if (!venues[i].has_lecture) {
                    writer.write("\tVenue has not been assigned any lecture.\n");
                }
                writer.write("________________________________________________________________________________________________________\n");
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
        }
    }

    
    /** 
     * Creates a new file and then prints an error if either the modules input file is empty,
     * or the venues input file is empty, or if both of the input files is empty
     * 
     * @param filepath  the third command line integer that contains the path and name needed to create the output file.
     * @param module   a boolean that contains true if the modules input file is empty.
     * @param venue    a boolean that contains true if the venues input file is empty.
     */
    public static void printEmptyError(String filepath, boolean module, boolean venue) {
        try {
            if (module && venue) {
                //If both files are empty.
                FileWriter writer = new FileWriter(filepath);
                writer.write("Error in input files! Both the module and venue file is empty.");
                writer.close();
            } else if (module) {
                //If only the modules file is empty.
                FileWriter writer = new FileWriter(filepath);
                writer.write("Error in input file! Module file is empty.");
                writer.close();
            } else {
                //If only the venues file is empty.
                FileWriter writer = new FileWriter(filepath);
                writer.write("Error in input file! Venue file is empty.");
                writer.close();
            }
        } catch (Exception e) {
        }
    }
}