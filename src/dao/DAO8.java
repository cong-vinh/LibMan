package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Date;

/** Shared JDBC holder for the DAO classes in the class diagram. */
public class DAO8 {
    private Connection con;

    private static final String DEFAULT_URL =
            "jdbc:mysql://localhost:3306/libman?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Bangkok";
    private static final String URL = configured("libman.jdbc.url", "LIBMAN_DB_URL", DEFAULT_URL);
    private static final String USER = configured("libman.jdbc.user", "LIBMAN_DB_USER", "root");
    private static final String PASSWORD = configured("libman.jdbc.password", "LIBMAN_DB_PASSWORD", "");

    public DAO8() {
    }

    private static String configured(String property, String environment, String fallback) {
        String value = System.getProperty(property);
        if (value == null || value.trim().isEmpty()) {
            value = System.getenv(environment);
        }
        return value == null || value.trim().isEmpty() ? fallback : value;
    }

    public Connection getConnection() {
        try {
            if (con == null || con.isClosed()) {
                Class.forName("com.mysql.cj.jdbc.Driver");
                con = DriverManager.getConnection(URL, USER, PASSWORD);
            }
            return con;
        } catch (ClassNotFoundException e) {
            throw new IllegalStateException("MySQL JDBC driver com.mysql.cj.jdbc.Driver is not available", e);
        } catch (SQLException e) {
            throw new IllegalStateException("Cannot connect to MySQL database libman", e);
        }
    }

    public void closeConnection() {
        if (con != null) {
            try {
                con.close();
            } catch (SQLException e) {
                throw new IllegalStateException("Cannot close MySQL connection", e);
            } finally {
                con = null;
            }
        }
    }

    protected java.sql.Date toSqlDate(Date date) {
        return date == null ? null : new java.sql.Date(date.getTime());
    }
}
