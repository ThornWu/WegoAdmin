package wego;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;

public class VarifyUser extends HttpServlet {
    public void init() throws ServletException {
    }
    public void destroy() {
        super.destroy();
    }
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    }


    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        request.setCharacterEncoding("UTF-8");
        String msg = "error";

        String inputname=request.getParameter("username");
        String inputpassword=request.getParameter("password");
        HttpSession session=request.getSession(true);

        try{
            if(inputname.equals("123") && inputpassword.equals("123")){
                session.setAttribute("employee", inputname);
                session.setAttribute("employee_id", "123");
                session.setAttribute("LocationManagement", "Open");
                session.setAttribute("UserManagement", "Open");
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
