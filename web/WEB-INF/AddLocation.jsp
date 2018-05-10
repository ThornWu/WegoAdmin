<%@ page pageEncoding="UTF-8"%>
<%@page import="java.sql.*,wego.SqlCoon"%>
<%
    if(session.getAttribute("employee")==null){
        response.sendRedirect("/index.jsp");
    }
%>
<%!String venueid,venuename,category,latitude,longitude,address,localcity,citylabel;%>
<%
    String action=(request.getParameter("action")==null)?"add":request.getParameter("action");
    String id=request.getParameter("id");
    if(action!=null&&action.equals("edit")){
        SqlCoon sqlcoon=new SqlCoon();
        Connection conn=(Connection) sqlcoon.GetCoon();
        PreparedStatement psmt=null;
        ResultSet rs=null;
        try {
            String sql="select * from venue where venueid='"+id+"'";
            psmt=conn.prepareStatement(sql);
            rs=psmt.executeQuery();
            if(rs.next())
            {
                this.venueid=rs.getString("venueid");
                this.venuename=rs.getString("venuename");
                this.category=rs.getString("category");
                this.latitude=rs.getString("latitude");
                this.longitude=rs.getString("longitude");
                this.address=rs.getString("address");
                this.localcity=rs.getString("localcity");
                this.citylabel=(rs.getInt("la_label")!=-2)?"LA":"NY";
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }finally {
            if (conn != null) {
                try{
                    conn.close();
                }catch (Exception e){
                    e.printStackTrace();
                }
            }
        }
    }else{
        this.venueid="";
        this.venuename="";
        this.category="";
        this.latitude="";
        this.longitude="";
        this.address="";
        this.localcity="";
        this.citylabel="LA";
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <title>WeGo Management System</title>
        <script src="/js/jquery-3.2.1.min.js"></script>
    </head>

    <body>
        <form method="post" action="/servlet/AddLocation">

            <input type="hidden" name="venueid" id="venueid" value="<%=this.venueid%>"><br/>
            Venue Name:<input type="text" name="venuename" id="venuename" required="required" value="<%=this.venuename%>"><br/>
            Category:<input type="text" name="category" id="category" required="required" value="<%=this.category%>"><br/>
            Latitude：<input type="text" name="latitude" id="latitude" required="required" value="<%=this.latitude%>"><br/>
            Longitude：<input type="text" name="longitude" id="longitude" required="required" value="<%=this.longitude%>"><br/>
            Address：<input type="text" name="address" id="address" required="required" value="<%=this.address%>"><br/>
            LocalCity：<input type="text" name="localcity" id="localcity" required="required" value="<%=this.localcity%>"><br/>
            City Label：
            <%if(citylabel.equals("LA")){%>
                <input type="radio" checked="checked" name="citylabel" value="LA"/>LA<input type="radio" name="citylabel" value="NY"/>NY<br/>
            <%}else{%>
                <input type="radio" name="citylabel" value="LA"/>LA<input type="radio" name="citylabel" value="NY" checked="checked" />NY<br/>
            <%}%>
            <input type="hidden" name="action" value="<%=action%>">
            <input type="hidden" id="ok">
            <input type="submit" id="submitbutton" value="Submit">
        </form>
        <a href="EmployeeInfo.jsp">返回</a>
        <script>
            $("form").submit(function () {
                $.ajax({
                    url: '/servlet/AddLocation',
                    type:"POST",
                    dataType: 'text',
                    data: $("form").serialize(),
                    success: function (msg) {
                        msg = msg.replace(/rn/g, '');
                        if (msg == "ok") {
                            alert("Submit successfully");
                            parent.IframeMain.location.href ="/servlet/LocationInfoUI"; }
                        else {
                            alert("Submit failed");
                            return;
                        }
                    }
                });
                return false;
            });
        </script>
    </body>
</html>
