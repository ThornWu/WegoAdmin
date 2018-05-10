package wego;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.Date;

public class AddLocation extends HttpServlet {
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
        String id = request.getParameter("venueid");
        String name = request.getParameter("venuename");
        String category = request.getParameter("category");
        String lat = request.getParameter("latitude");
        String lon = request.getParameter("longitude");
        String address = request.getParameter("address");
        String city = request.getParameter("localcity");
        String citylabel = request.getParameter("citylabel");
        Statement stmt=null;
        try{
            stmt=conn.createStatement();
            if(action.equals("add")){
                SimpleDateFormat nt = new SimpleDateFormat ("yyMMddHHmmss");
                String newid = nt.format(new Date());
                if(citylabel.equals("LA")){
                    sql="insert into venue (venueid,venuename,category,latitude,longitude,address,localcity,la_label) values("+newid+",'"+name+"','"+category+"',"+lat+",'"+lon+"','"+address+"','"+city+"',-1)";
                }else{
                    sql="insert into venue (venueid,venuename,category,latitude,longitude,address,localcity,ny_label) values("+newid+",'"+name+"','"+category+"',"+lat+",'"+lon+"','"+address+"','"+city+"',-1)";
                }
                stmt.executeUpdate(sql);
                msg ="ok";
            }else if(action.equals("edit")){
                if(citylabel.equals("LA")){
                    sql="update venue set venuename='"+name+"',category='"+category+"',latitude='"+lat+"',longitude='"+lon+"',address='"+address+"',localcity='"+city+"',la_label=-1,ny_label=-2 where venueid='"+id+"'";
                }else{
                    sql="update venue set venuename='"+name+"',category='"+category+"',latitude='"+lat+"',longitude='"+lon+"',address='"+address+"',localcity='"+city+"',la_label=-2,ny_label=-1 where venueid='"+id+"'";
                }
                stmt.executeUpdate(sql);
                msg ="ok";
            }else if(action.equals("del")){
                sql="update venue set isused='False' where venueid='"+id+"'";
                stmt.executeUpdate(sql);
                msg ="ok";
            }else if(action.equals("recover")){
                sql="update venue set isused='True' where venueid='"+ id +"'";
                stmt.executeUpdate(sql);
                msg ="ok";
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
