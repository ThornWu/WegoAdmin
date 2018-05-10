<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
if(session.getAttribute("employee")==null){
	response.sendRedirect("/index.jsp");
}
%>

<!DOCTYPE html>
<html>
  <head>
    <title>WeGo Management System</title>
	<link rel="stylesheet" type="text/css" href="/css/frame.css" />
	<link rel="stylesheet" type="text/css" href="/css/main.css" />
	<link href="/css/font-awesome.min.css" rel="stylesheet">
	<script src="/js/jquery-3.2.1.min.js"></script>
  </head>
  
  <body>
        <div class="container">
            <div id="header">
                <div class="logo">
                    <h1>WeGo Management System</h1>
                    <div id="UserInfo">
                    	<label id="UserLabel"><%=session.getAttribute("employee")%></label>
                    	<a href="javascript:" id="ChangePassword" target="IframeMain">账户管理</a>
                    	<button id="UButton" onclick="LogOut()">LogOut</button>
                    </div>
                </div>
            </div>
        </div>
        <div class="container" id="contentcontainer">
            <div class="aside">

				<ul id="accordion" class="accordion">
					<%if(session.getAttribute("LocationManagement")!=null){
						%>
							<li>
								<div class="link">Location Management<i class="fa fa-chevron-down"></i></div>
								<ul class="submenu">
									<li><a href="/servlet/LocationInfoUI" target="IframeMain">Location List</a></li>
									<li><a href="/servlet/DeletedLocationUI" target="IframeMain">Deleted Location</a></li>
								</ul>
							</li>
						<%
					}
 					%>
					<%if(session.getAttribute("UserManagement")!=null){
						%>
						<li>
							<div class="link">User Management<i class="fa fa-chevron-down"></i></div>
							<ul class="submenu">
								<li><a href="/servlet/UserInfoUI" target="IframeMain">User List</a></li>
								<li><a href="/servlet/DeletedUserUI" target="IframeMain">Deleted User</a></li>
							</ul>
						</li>
						<%
					}
 					%>
				</ul>

            </div>
            <div class="content">
                <iframe id="frame" name="IframeMain"></iframe>
            </div>
        </div>
        
        <script>
			   $(function() {
				var Accordion = function(el, multiple) {
					this.el = el || {};
					this.multiple = multiple || false;
			
					// Variables privadas
					var links = this.el.find('.link');
					// Evento
					links.on('click', {el: this.el, multiple: this.multiple}, this.dropdown)
				}
			
				Accordion.prototype.dropdown = function(e) {
					var $el = e.data.el;
						$this = $(this),
						$next = $this.next();
			
					$next.slideToggle();
					$this.parent().toggleClass('open');
			
					if (!e.data.multiple) {
						$el.find('.submenu').not($next).slideUp().parent().removeClass('open');
					};
				}	
			
				var accordion = new Accordion($('#accordion'), false);
			});
			function LogOut(){
				 $.ajax({
	                  url: '/servlet/LogOut',
	                  type:"GET",
	                  dataType: 'text',
	                  data: null,
	                  success: function (msg) {
	                      msg = msg.replace(/rn/g, '');
	                      if (msg == "ok") { 
	                      	alert("Log Out Successfully");
	                      	window.location.href="/index.jsp";
	                      }
	                  }
	              });
			}
        </script>
  </body>
</html>
