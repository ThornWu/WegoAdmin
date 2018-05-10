package wego;
import java.sql.*;
public class SqlCoon {
    private String sqldriver;
    private String sqlurl;

    public SqlCoon(){
        this.sqldriver ="org.sqlite.JDBC";
        this.sqlurl = "jdbc:sqlite::resource:wego.db";
    }

    public Connection GetCoon(){
        Connection con=null;
        try {
            Class.forName(this.sqldriver);
        } catch (ClassNotFoundException e1) {
            e1.printStackTrace();
        }
        try {
            con=DriverManager.getConnection(this.sqlurl);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return con;
    }
}
