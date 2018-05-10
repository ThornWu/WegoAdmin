package wego;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

public class LogOut extends HttpServlet {
    public void init() throws ServletException {
    }
    public void destroy() {
        super.destroy();
    }


    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        request.setCharacterEncoding("UTF-8");
        String msg = "error";
        try{
            request.getSession().invalidate();
            msg="ok";
            msg = new String(msg.getBytes("ISO-8859-1"), "utf-8");
            out.write(msg);
        }
        catch(Exception ex){
            ex.printStackTrace();
        }
        out.flush();
        out.close();
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    }
}
