<%@ page pageEncoding="UTF-8"%>
<%@page import="java.sql.*,wego.SqlCoon"%>
<%
if(session.getAttribute("admin")==null){
	response.sendRedirect("/index.jsp");
}
%>
<!DOCTYPE html>
<html>
  <head>
    <title>WeGo Management System</title>
	<script src="/js/jquery-3.2.1.min.js"></script>
	<link rel="stylesheet" type="text/css" href="/css/list_show.css">
  </head>

  <body>
      <div class="whole_container">
          <div class="table_container">
              <div class="table_title">
                  <span class="chi_title">Location Info</span>
              </div>

              <div class="table_link">
                  <div class="table_link_left">
                      <a href="/servlet/AddLocationUI" class="table_button">Add Location</a>
                      <%
                          String page_num = (request.getParameter("page"))==null ? "1" : request.getParameter("page");
                          String venueid = request.getParameter("venueid");
                      %>
                      <label>Search：</label>
                      <input id="venueid" placeholder="venueid" value="<%=(venueid==null)?"":venueid%>" size="30"> &nbsp;
                      <button onclick="jump_url(0)" class="table_button">Search</button>
                      <button onclick="clear_search()" class="table_button">Clear</button>
                  </div>
              </div>

              <table class="main_table">
                  <tr class="main_table_title">
                      <th>Venueid</th>
                      <th>Venuename</th>
                      <th>Category</th>
                      <th>Latitude</th>
                      <th>Longitude</th>
                      <th>Localcity</th>
                      <th>Edit</th>
                      <th>Delete</th>
                  </tr>
                  <%
                      SqlCoon sqlcoon=new SqlCoon();
                      Connection conn = sqlcoon.GetCoon();

                      PreparedStatement psmt=null;
                      ResultSet rs=null;

                      try {
                          if(venueid!=null){
                              String sql="select * from venue where venueid='"+venueid+"' and isused='True'";
                              psmt=conn.prepareStatement(sql);
                          }else {
                              String sql="select * from venue where isused='True' limit "+(Integer.parseInt(page_num)-1)*100+",100";
                              psmt=conn.prepareStatement(sql);
                          }
                          rs=psmt.executeQuery();
                          int count = 0;
                          while(rs.next()){
                              %>
                              <tr class="main_table_content <%if(count%2==0){%>main_table_content_first<%}else{%>main_table_content_second<%}%>">
                                  <td><%=rs.getString("venueid")%></td>
                                  <td><%=rs.getString("venuename")%></td>
                                  <td><%=rs.getString("category")%></td>
                                  <td><%=rs.getDouble("latitude")%></td>
                                  <td><%=rs.getDouble("longitude")%></td>
                                  <td><%=rs.getString("localcity")%></td>
                                  <td><a href="/servlet/AddLocationUI?id=<%=rs.getString("venueid")%>&action=edit" class="table_edit_button">[ Edit ]</a></td>
                                  <td> <a href="javascript:" class="table_edit_button" onclick="del('<%=rs.getString("venueid")%>')">[ Delete ]</a></td>
                              </tr>
                              <%
                              count++;
                          }
                      } catch (SQLException e) {
                          e.printStackTrace();
                      }
                  %>
              </table>

              <%
                  try {
                          if(venueid!=null){
                              String sql="select count(venueid) as count from venue where isused='True' and venueid='"+venueid+"'";
                              psmt=conn.prepareStatement(sql);
                          }else{
                              String sql="select count(venueid) as count from venue where isused='True'";
                              psmt=conn.prepareStatement(sql);
                          }

                          rs=psmt.executeQuery();
                          while(rs.next()) {
                              int total = (int)Math.floor(rs.getInt("count")/100)+1;
                              int current = Integer.parseInt(page_num);
                              int prev = current==1 ? 1:(current-1);
                              int next = current==total ? total:(current+1);
                            %>
                                  <div class="bottom_button_area">
                                      <span class='bottom_info_left'>
                                          <label>Total</label>
                                          <label class='num'><%=rs.getInt("count")%> </label>
                                          <label>Records</label>
                                      </span>
                                      <span class='bottom_info_left'>
                                          <label>Current：</label>
                                          <label class='num'><%=current%></label>
                                          <label>/</label>
                                          <label class='num'><%=total%></label>
                                      </span>
                                      <a href='javascript:' class='bottom_button <%if(current!=1){%>bottom_button_active<%}%>' <%if(current!=1){%>onclick="jump_url(1)"<%}%>>First</a>
                                      <a href='javascript:' class='bottom_button <%if(current!=1){%>bottom_button_active<%}%>' <%if(current!=1){%>onclick="jump_url(<%=prev%>)"<%}%>>Prev</a>
                                      <a href='javascript:' class='bottom_button <%if(current!=total){%>bottom_button_active<%}%>' <%if(current!=total){%>onclick="jump_url(<%=next%>)"<%}%>>Next</a>
                                      <a href='javascript:' class='bottom_button <%if(current!=total){%>bottom_button_active<%}%>' <%if(current!=total){%>onclick="jump_url(<%=total%>)"<%}%>>Last</a>


                                      <span class="bottom_info_right">
                                          <label>Jump：</label>
                                          <input id="jump_page" value="<%=page_num%>" size="5"> &nbsp;
                                          <a onclick="jump_url()" class="bottom_button bottom_button_active">Jump</a>
                                      </span>


                                  </div>


                              <%
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
              %>
          </div>
      </div>

      <script>
          function del(id){
              var r = confirm("Confirm delete?");
              if (r==true)
              {
                  s="action=del&venueid="+id;
                  $.ajax({
                      url: '/servlet/AddLocation',
                      type:"POST",
                      dataType: 'text',
                      data:s,
                      success: function (msg) {
                          msg = msg.replace(/rn/g, '');
                          if (msg == "ok") {
                              alert("Delete successfully");
                              parent.IframeMain.location.href ="/servlet/LocationInfoUI";
                          }
                          else{
                              alert("Delete failed");
                          }
                      }
                  });
              }
          }
          function jump_url(click_page){
              var page = document.getElementById("jump_page").value;
              var venueid = document.getElementById("venueid").value;
              var reg = /^[1-9]\d*$/;
              if(click_page>0){
                  if(venueid!=""){
                      parent.IframeMain.location.href ="/servlet/LocationInfoUI?page="+click_page+"&venueid="+venueid;
                  }else{
                      parent.IframeMain.location.href ="/servlet/LocationInfoUI?page="+click_page;
                  }
              }else if(page!=""){
                  if(reg.test(page)){
                      if(venueid!=""){
                          parent.IframeMain.location.href ="/servlet/LocationInfoUI?page="+page+"&venueid="+venueid;
                      }else{
                          parent.IframeMain.location.href ="/servlet/LocationInfoUI?page="+page;
                      }
                  }else{
                      alert("Invaild input");
                      document.getElementById("jump_page").value="";
                  }
              }
          }
          function clear_search(){
              document.getElementById("venueid").value="";
              jump_url(0);
          }
      </script>
  </body>
</html>
