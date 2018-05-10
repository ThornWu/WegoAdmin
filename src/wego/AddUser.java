package wego;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.Statement;

public class AddUser extends HttpServlet {
    public void init() throws ServletException {
    }
    public void destroy(){
        super.destroy();
    }
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    }
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        SqlCoon sqlcoon = new SqlCoon();
        Connection conn = sqlcoon.GetCoon();
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        request.setCharacterEncoding("UTF-8");
        String msg = "error";
        String sql;
        String action = request.getParameter("action");
        String id = request.getParameter("userid");
        Statement stmt = null;
        try{
            conn.setAutoCommit(false);
            stmt = conn.createStatement();
            if(action.equals("del")){
                sql = "update user set isused='False' where userid="+id;
                stmt.executeUpdate(sql);
                conn.commit();
                msg = "ok";
            }else if(action.equals("recover")){
                sql = "update user set isused='True' where userid="+id;
                stmt.executeUpdate(sql);
                conn.commit();
                msg = "ok";
            }
            msg = new String(msg.getBytes("ISO-8859-1"), "utf-8");
            out.write(msg);
        }
        catch(Exception ex){
            ex.printStackTrace();
            out.write(ex.getMessage());
        }
        out.flush();
        out.close();
    }
}
