package dao;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {
    

    private static Connection conn = null;

    public static Connection getConnection() {
        System.out.println("BillingServlet called");

        try {
            if (conn == null || conn.isClosed()) {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(
                        "jdbc:mysql://localhost:3306/grocery_db",  // ✅ correct DB name
                        "root",   // ✅ MySQL username
                        "root123"        // ✅ password (put actual password if you set one, else leave empty)
                );
                System.out.println("✅ Database connected successfully!");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return conn;
    }
}
