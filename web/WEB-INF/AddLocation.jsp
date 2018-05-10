<%@ page pageEncoding="UTF-8"%>
<%@page import="java.sql.*,wego.SqlCoon"%>
<%
    if(session.getAttribute("admin")==null){
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
        <link rel="stylesheet" type="text/css" href="/css/list_show.css" />
    </head>

    <body>
        <div class="whole_container">
            <div class="table_container" style="border:none;">
                <div class="table_title">
                    <span class="chi_title">Add Location Info</span>
                </div>
                <div class="b_form_container">
                    <form class="b_form" method="post" action="/servlet/AddLocation">
                        <table class="b_form_table">
                            <tr class="b_form_tr">
                                <td class="label">Venue Name:</td>
                                <td class="info">
                                    <input type="text" name="venuename" id="venuename" required="required" value="<%=this.venuename%>" size="80">
                                </td>
                            </tr>

                            <tr class="b_form_tr">
                                <td class="label">Category:</td>
                                <td class="info">
                                    <input type="text" name="category" id="category" required="required" value="<%=this.category%>" size="80">
                                </td>
                            </tr>

                            <tr class="b_form_tr">
                                <td class="label">Latitude：</td>
                                <td class="info">
                                    <input type="text" name="latitude" id="latitude" required="required" value="<%=this.latitude%>"><br/>
                                </td>
                            </tr>

                            <tr class="b_form_tr">
                                <td class="label">Longitude：</td>
                                <td class="info">
                                    <input type="text" name="longitude" id="longitude" required="required" value="<%=this.longitude%>"><br/>                                </td>
                            </tr>

                            <tr class="b_form_tr">
                                <td class="label">Address：</td>
                                <td class="info">
                                    <input type="text" name="address" id="address" required="required" value="<%=this.address%>" size="80"><br/>
                                </td>
                            </tr>

                            <tr class="b_form_tr">
                                <td class="label">LocalCity：</td>
                                <td class="info">
                                    <input type="text" name="localcity" id="localcity" required="required" value="<%=this.localcity%>"><br/>
                                </td>
                            </tr>

                            <tr class="b_form_tr">
                                <td class="label">City Label：</td>
                                <td class="info">
                                    <%if(citylabel.equals("LA")){%>
                                        <input type="radio" checked="checked" name="citylabel" value="LA"/>LA<input type="radio" name="citylabel" value="NY"/>NY<br/>
                                    <%}else{%>
                                        <input type="radio" name="citylabel" value="LA"/>LA<input type="radio" name="citylabel" value="NY" checked="checked" />NY<br/>
                                    <%}%>
                                </td>
                            </tr>

                            <tr class="b_form_tr">
                                <td class="submit_area" colspan="2">
                                    <input type="hidden" name="venueid" id="venueid" value="<%=this.venueid%>"><br/>
                                    <input type="hidden" name="action" value="<%=action%>">
                                    <input class="submit_button" type="submit" id="submitbutton" value="Submit">
                                    <a href="/servlet/LocationInfoUI" class="submit_button" style="text-decoration:none;">返回</a>
                                </td>
                            </tr>
                        </table>
                    </form>
                </div>
            </div>
        </div>
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
