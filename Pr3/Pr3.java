import java.sql.*;
import java.util.Scanner;

//Bradley Harper
//CSC 3300-001
//Project 3

public class Pr3
{
    //make variables we will use through the entire program

    public static final Scanner input = new Scanner(System.in);
    private static String user = null;
    private static String pass = null;
    private static Connection conn = null;
    private static Statement stmt = null;
    private static ResultSet rset = null;

    public static void main(String[] args) //loop program until valid username and pass entered
    {
        boolean flag = false;

        do
        {
            System.out.print("\nEnter Username: "); //get username
            user = input.nextLine();
            System.out.print("Enter Password: "); //get username
            pass = input.nextLine();
            flag = connection(user, pass);
        } while(!flag);

        System.out.print("WELCOME ");
        System.out.print(user);
        menu();

        input.close();
    }

    public static boolean connection(String user, String pass) //connect the sql database to the java program
    {
        boolean flag = false;

        try
        {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager
                    .getConnection("jdbc:mysql://localhost:3306/university", user, pass);
            stmt = conn.createStatement();
            flag = true;
        } catch (Exception e)
        {
            System.out.print("Incorrect username or password. Please try again.");
            //e.printStackTrace();
        }
        return flag;
    }

    public static void menu() // displays main menu gets choice
    {
        String choice;
        int choiceCheck = 0;

        do
        {
            mainMenu(); //display options

            System.out.print("\n\nPlease Choose an Option From Above: ");
            choice = input.next();
            checkInt(choice);
            choiceCheck = Integer.parseInt(choice);

            if(choiceCheck < 1 | choiceCheck > 4)
            {
                mainMenu();
                System.out.print("\n\nPlease enter a VALID OPTION (1-4): ");
                choice = input.next();
            }
            else if(choiceCheck == 1)
            {
                deptMenu();
            }
            else if (choiceCheck == 2)
            {
                courseMenu();
            }
            else if (choiceCheck == 3)
            {
                prereqMenu();
            }
        } while(choiceCheck != 4);
    }

    public static void mainMenu() //function to display the main menu
    {
        System.out.print("\n\n-----MENU OPTIONS-----");
        System.out.print("\n1. Department Menu");
        System.out.print("\n2. Course Menu");
        System.out.print("\n3. Prerequisite Menu");
        System.out.print("\n4. Exit");
    }

    public static void deptMenu() //department menu options
    {
        String choice;
        int choiceCheck = 0;

        System.out.println("\n-----Department menu-----");
        System.out.println("\n1. Retrieve Department Name and Building.");
        if(choiceCheck < 1 | choiceCheck > 1)
        {
            System.out.println("Please press 1 to Display Departments Information: ");
            choice = input.next();
        }

        getDepts();
    }

    public static void getDepts() //display departments information
    {
        System.out.println("Department Name, Building");
        try
        {
            rset = stmt.executeQuery("select dept_name, building from department;");
            while (rset.next())
            {
                System.out.println(rset.getString("dept_name") + ", " + rset.getString("building"));
            }
        } catch (SQLException e){}
    }

    public static void courseMenu() //menu to work on courses
    {
        String choice;
        int choiceCheck;
        do
        {
            System.out.println("\n-----Course Menu-----");
            System.out.println("1. Add a course.");
            System.out.println("2. Retrieve all info about courses.");
            System.out.println("3. Delete a course.");
            System.out.println("4. Update a course's title.");
            System.out.println("5. Return to Main Menu.");
            System.out.print("\nEnter your selection from above: ");
            choice = input.next();
            checkInt(choice);
            choiceCheck = Integer.parseInt(choice);

            if(choiceCheck < 1 | choiceCheck > 5)
            {
                System.out.println("\nPlease enter a VALID OPTION (1-5): ");
            }
            else if(choiceCheck == 1)
            {
                addCourse();
            }
            else if(choiceCheck == 2)
            {
                getCourses();
            }
            else if(choiceCheck == 3)
            {
                deleteCourse();
            }
            else if(choiceCheck == 4)
            {
                changeCourseTitle();
            }
        } while(choiceCheck != 5);
    }

    public static void addCourse()
    {
        String course_id;
        String title;
        String dept_name;
        String credits;

        System.out.print("Enter a course id: ");
        course_id = input.next();
        if(!course_id.matches("[A-Z]{2,3}[-][0-9]{3}"))
        {
            System.out.println("Please enter a valid ID: ");
            course_id = input.next();
            checkIDInput(course_id);
        }
        //checkIDInput(course_id);

        System.out.print("Enter course's title: ");
        title = input.next();
        input.nextLine();

        System.out.print("Enter department name: ");
        dept_name = input.nextLine();

        System.out.print("Enter number of credits: ");
        credits = input.nextLine();
        checkInt(credits);

        insertCourse(course_id, title, dept_name, credits);
    }

    public static void insertCourse(String course_id, String title, String dept_name, String credits)
    {
        try
        {
            stmt.executeUpdate("insert into course(course_id, title, dept_name, credits) values ('" + course_id + "', '" + title + "', '" + dept_name + "', " + credits + ");");
        } catch(SQLIntegrityConstraintViolationException e)
        {
            System.out.println("Please enter a department name from this list: "); //get new Department
            try
            {
                rset = stmt.executeQuery("select dept_name from department;");
                while (rset.next()) {
                    System.out.println(rset.getString("dept_name"));
                }
            } catch (SQLException b)
            {
                System.out.println("ERROR");;
            }
            System.out.println("");
            System.out.print(": ");
            dept_name = input.next();
            insertCourse(course_id, title, dept_name, credits);
        } catch(SQLException e){
            e.printStackTrace();
        }
    }

    public static void getCourses()
    {
        try
        {
            System.out.println("");
            rset = stmt.executeQuery("select * from course;");
            System.out.println("Course ID, Title, Department Name, Credits");
            while (rset.next()){
                System.out.println(rset.getString("course_id") + ", " + rset.getString("title") + ", " + rset.getString("dept_name") + ", " + rset.getString("credits"));
            }
        } catch (SQLException e){
            e.printStackTrace();
        }
        System.out.println("");
    }

    public static void deleteCourse()
    {
        String course_id;

        getCourses();
        System.out.print("Choose a course id from above to delete: ");
        course_id = input.next();
        try
        {
            stmt.executeUpdate("delete from course where course_id = '" + course_id + "';");
        } catch (SQLException e){
            e.printStackTrace();
            System.out.print("There is no course with that ID.");
        }
        System.out.println("");
        System.out.println("Course " + course_id + " deleted. ");
    }

    public static void changeCourseTitle()
    {
        String course_id;
        String title;

        getCourses();

        System.out.print("Enter the course id you want to change the title of: ");
        course_id = input.next();

        System.out.print("Enter the NEW title: ");
        title = input.next();
        try{
            stmt.executeUpdate("update course set title = '" + title + "' where course_id = '" + course_id + "';");
        } catch(SQLException e){
            e.printStackTrace();
        }
    }

    public static void prereqMenu()
    {
        String choice;
        int choiceCheck;

        do
        {
            System.out.print("\n\n-----Prereq Menu-----");
            System.out.print("\n1. Add a prerequisite to a course");
            System.out.print("\n2. Retrieve all info about prerequisites");
            System.out.print("\n3. Delete a prerequisite from a course");
            System.out.print("\n4. Return to Main Menu");
            System.out.print("\n\nEnter your selection from above: ");
            choice = input.next();
            choiceCheck = Integer.parseInt(choice);

            if(choiceCheck < 1 | choiceCheck > 4)
            {
                System.out.print("Please enter a VALID OPTION (1-5): ");
                choice = input.next();
            }
            else if(choiceCheck == 1)
            {
                addPrereq();
            }
            else if(choiceCheck == 2)
            {
                retrievePrereq();
            }
            else if(choiceCheck == 3)
            {
                deletePrereq();
            }
        } while(choiceCheck != 4);
    }

    public static void addPrereq()
    {
        String course_id;
        String prereq_id;
        boolean flag = false;
        do
        {
            System.out.print("Enter the course ID you want to add a prereq to: ");
            course_id = input.next();
            checkIDInput(course_id);

            System.out.print("Enter the prerequisite ID: ");
            prereq_id = input.next();
            checkIDInput(prereq_id);

            flag = insertPrereq(course_id, prereq_id);
        } while(flag == false);
    }

    public static boolean insertPrereq(String course_id, String prereq_id)
    {
        boolean flag = false;
        try
        {
            stmt.executeUpdate("insert into prereq(course_id, prereq_id) values ('" + course_id + "', '" + prereq_id + "');");
            flag = true;
        } catch (Exception e)
        {
            getCourses();
            System.out.println("Please enter course IDs that already exist or enter E to exit.");
        }
        return flag;
    }

    public static void retrievePrereq()
    {
        try
        {
            System.out.println("");
            rset = stmt.executeQuery("select * from prereq;");
            System.out.println("Prereq_id, Course_id");
            while (rset.next()){
                System.out.println(rset.getString("prereq_id") + ", " + rset.getString("course_id"));
            }
        } catch (SQLException e) {}
    }

    public static void deletePrereq()
    {
        String course_id;
        String prereq_id;

        System.out.print("Enter the course ID: ");
        course_id = input.next();
        checkIDInput(course_id);

        System.out.print("Enter the prereq ID: ");
        prereq_id = input.next();
        checkIDInput(prereq_id);

        deletePrereqSQL(course_id, prereq_id);
    }

    public static void deletePrereqSQL(String course_id, String prereq_id)
    {
        try
        {
            System.out.println("in delete");
            stmt.executeUpdate("delete from prereq where course_id = '" + course_id + "' and prereq_id = '" + prereq_id + "';");
        } catch (SQLException e)
        {
            System.out.println("There is no course with that prerequisite.");
        }
        System.out.println("Deleted course: " + course_id + " with prerequisite: " + prereq_id);
    }


    public static void checkInt(String in)
    {
        if(!in.matches("[0-9]+")){
            System.out.print("Please enter a number: ");
            in = input.next();
            checkInt(in);
        }
    }

    public static void checkIDInput(String id)
    {

        if(!id.matches("[A-Z]{2,3}[-][0-9]{3}"))
        {
            System.out.println("Please enter a valid ID: ");
            id = input.next();
            checkIDInput(id);
        }
    }

}