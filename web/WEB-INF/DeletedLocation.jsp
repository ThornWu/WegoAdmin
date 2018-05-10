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
            String venueid = request.getParameter("venueid");
            SqlCoon sqlcoon=new SqlCoon();
            Connection conn = sqlcoon.GetCoon();

            PreparedStatement psmt=null;
            ResultSet rs=null;

            try {
                if(venueid!=null){
                    String sql="select count(venueid) as count from venue where isused='False' and venueid='"+venueid+"'";
                    psmt=conn.prepareStatement(sql);
                }else{
                    String sql="select count(venueid) as count from venue where isused='False'";
                    psmt=conn.prepareStatement(sql);
                }

                rs=psmt.executeQuery();
                while(rs.next())
                {
        %>
        Total: <%=rs.getInt("count")%>  &nbsp;&nbsp; Per page:200&nbsp;&nbsp;Current page: <%=page_num%> &nbsp;&nbsp;Jump:<input id="jump_page" value="<%=page_num%>"> <button onclick="jump_url()">Jump</button>
        <br/>
        Search:<input id="venueid" placeholder="venueid" value="<%=(venueid==null)?"":venueid%>"> <button onclick="jump_url()">Search</button> <button onclick="clear_search()">Clear</button>
        <%
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        %>

        <table>
            <tr>
                <td>venueid</td>
                <td>venuename</td>
                <td>category</td>
                <td>latitude</td>
                <td>longitude</td>
                <td>localcity</td>
                <td>recover</td>
            </tr>
            <%
                try {
                    if(venueid!=null){
                        String sql="select * from venue where venueid='"+venueid+"' and isused='False'";
                        psmt=conn.prepareStatement(sql);
                    }else {
                        String sql="select * from venue where isused='False' limit "+(Integer.parseInt(page_num)-1)*200+",200";
                        psmt=conn.prepareStatement(sql);
                    }
                    rs=psmt.executeQuery();
                    while(rs.next())
                    {
            %>
            <tr>
                <td><%=rs.getString("venueid")%></td>
                <td><%=rs.getString("venuename")%></td>
                <td><%=rs.getString("category")%></td>
                <td><%=rs.getDouble("latitude")%></td>
                <td><%=rs.getDouble("longitude")%></td>
                <td><%=rs.getString("localcity")%></td>
                <td><button onclick="recover('<%=rs.getString("venueid")%>')">recover</button></td>
            </tr>
            <%
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            %>
        </table>
        <script>
            function recover(id){
                var r = confirm("Confirm recover?");
                if (r==true)
                {
                    s="action=recover&venueid="+id;
                    $.ajax({
                        url: '/servlet/AddLocation',
                        type:"POST",
                        dataType: 'text',
                        data:s,
                        success: function (msg) {
                            msg = msg.replace(/rn/g, '');
                            if (msg == "ok") {
                                alert("Recover successfully");
                                parent.IframeMain.location.href ="/servlet/DeletedLocationUI";
                            }
                            else{
                                alert("Recover failed");
                            }
                        }
                    });
                }
            }
            function jump_url(){
                var page = document.getElementById("jump_page").value;
                var venueid = document.getElementById("venueid").value;
                var reg = /^[1-9]\d*$/;
                if(page!=""){
                    if(reg.test(page)){
                        if(venueid!=""){
                            parent.IframeMain.location.href ="/servlet/DeletedLocationUI?page="+page+"&venueid="+venueid;
                        }else{
                            parent.IframeMain.location.href ="/servlet/DeletedLocationUI?page="+page;
                        }
                    }else{
                        alert("Invaild input");
                        document.getElementById("jump_page").value="";
                    }
                }
            }
            function clear_search(){
                document.getElementById("venueid").value="";
                jump_url();
            }
        </script>
    </body>
</html>
