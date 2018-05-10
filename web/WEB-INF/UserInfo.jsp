<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="java.sql.*,wego.SqlCoon"%>
<%
    if(session.getAttribute("employee")==null){
        response.sendRedirect("/index.jsp");
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <title>WeGo Management System</title>
        <script src="/js/jquery-3.2.1.min.js"></script>
        <link rel="stylesheet" type="text/css" href="/css/tablestyle.css">
    </head>

    <body>
        <%
            String page_num = (request.getParameter("page"))==null ? "1" : request.getParameter("page");
            String userid = request.getParameter("userid");
            SqlCoon sqlcoon=new SqlCoon();
            Connection conn = sqlcoon.GetCoon();

            PreparedStatement psmt=null;
            ResultSet rs=null;

            try {
                if(userid!=null){
                    String sql="select count(userid) as count from user where isused='True' and userid="+userid;
                    psmt=conn.prepareStatement(sql);
                }else{
                    String sql="select count(userid) as count from user where isused='True'";
                    psmt=conn.prepareStatement(sql);
                }

                rs=psmt.executeQuery();
                while(rs.next())
                {
        %>
            Total: <%=rs.getInt("count")%>  &nbsp;&nbsp; Per page:200&nbsp;&nbsp;Current page: <%=page_num%> &nbsp;&nbsp;Jump:<input id="jump_page" value="<%=page_num%>"> <button onclick="jump_url()">Jump</button>
            <br/>
            Search:<input id="userid" placeholder="userid" value="<%=(userid==null)?"":userid%>"> <button onclick="jump_url()">Search</button> <button onclick="clear_search()">Clear</button>
        <%
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        %>

        <table>
            <tr>
                <td>userid</td>
                <td>username</td>
                <td>email</td>
                <td>gender</td>
                <td>homecity</td>
                <td>delete</td>
            </tr>
            <%
                try {
                    if(userid!=null){
                        String sql="select * from user where userid='"+userid+"' and isused='True'";
                        psmt=conn.prepareStatement(sql);
                    }else {
                        String sql="select * from user where isused='True' limit "+(Integer.parseInt(page_num)-1)*200+",200";
                        psmt=conn.prepareStatement(sql);
                    }
                    rs=psmt.executeQuery();
                    while(rs.next())
                    {
                        %>
                        <tr>
                            <td><%=rs.getString("userid")%></td>
                            <td><%=rs.getString("username")%></td>
                            <td><%=rs.getString("email")%></td>
                            <td><%=(rs.getInt("gender")==1)?"male":"female"%></td>
                            <td><%=rs.getString("homecity")%></td>
                            <td><button onclick="del(<%=rs.getString("userid")%>)">delete</button></td>
                        </tr>
                        <%
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            %>
        </table>
        <script>
            function del(id){
                var r = confirm("Confirm delete?");
                if (r==true)
                {
                    s="action=del&userid="+id;
                    $.ajax({
                        url: '/servlet/AddUser',
                        type:"POST",
                        dataType: 'text',
                        data:s,
                        success: function (msg) {
                            msg = msg.replace(/rn/g, '');
                            if (msg == "ok") {
                                alert("Delete successfully");
                                parent.IframeMain.location.href ="/servlet/UserInfoUI";
                            }
                            else{
                                alert("Delete failed");
                            }
                        }
                    });
                }
            }
            function jump_url(){
                var page = document.getElementById("jump_page").value;
                var userid = document.getElementById("userid").value;
                var reg = /^[1-9]\d*$/;
                if(page!=""){
                    if(reg.test(page)){
                        if(userid!=""){
                            parent.IframeMain.location.href ="/servlet/UserInfoUI?page="+page+"&userid="+userid;
                        }else{
                            parent.IframeMain.location.href ="/servlet/UserInfoUI?page="+page;
                        }
                    }else{
                        alert("Invaild input");
                        document.getElementById("jump_page").value="";
                    }
                }
            }
            function clear_search(){
                document.getElementById("userid").value="";
                jump_url();
            }
        </script>
    </body>
</html>