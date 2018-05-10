package wego;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class DeletedLocationUI extends HttpServlet {
    public void init() throws ServletException {
    }

    public void destroy() {
        super.destroy();
    }

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String usercode = (String)request.getSession().getAttribute("admin");
        if(usercode!=null&&usercode!=""){
            request.getRequestDispatcher("/WEB-INF/DeletedLocation.jsp").forward(request, response);
        }
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    }
}
