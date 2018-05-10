package wego;

import javax.servlet.ServletConfig;
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
        ServletConfig config = getServletConfig();

        // 获取初始化的参数
        String username = config.getInitParameter("username");
        String password = config.getInitParameter("password");

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        request.setCharacterEncoding("UTF-8");
        String msg = "error";

        String inputname=request.getParameter("username");
        String inputpassword=request.getParameter("password");
        HttpSession session=request.getSession(true);

        try{
            if(inputname.equals(username) && inputpassword.equals(password)){
                session.setAttribute("admin", inputname);
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
