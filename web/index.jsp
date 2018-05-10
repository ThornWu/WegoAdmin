<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
  	<head>
    	<title>WeGo Management System</title>
		<link rel="stylesheet" type="text/css" href="css/index_manage.css">
		<link rel="stylesheet" type="text/css" href="css/iconfont.css">
		<script src="js/jquery-3.2.1.min.js"></script>
		<style>
		body{
			background-image:url(images/background.jpg);
		}
		</style>
  	</head>
  
  	<body>
		<div id="content">
        	<div class="content-layout">
            	<div class="login-box-wrap">
                	<div class="login-box">
                    	<form name="EmployeeLogin" method="post" action="/servlet/VarifyUser">
                        	<div class="login-title">
								WeGo Management System
                            </div>

                            <div class="field">
				 				<span class="label">
                                  	<i class="iconfont icon-yonghu"></i>
                                </span>
                               	<input type="text" name="username" id="UserName" class="login-text" placeholder="Username">
                             </div>

                             <div class="field">
                              	<span class="label">
                                  	<i class="iconfont icon-mima"></i>
                                </span>
                                <input type="password" name="password" id="Password" class="login-text" placeholder="Password">
                             </div>
                              
                             <div class="submit">
                             	<input type="hidden" name="role" value="employee">
                               	<input type="submit" id="submitbutton" value="Submit">
                              </div>
                          </form>
              		</div>
            	</div>
        	</div>
    	</div>
    	<script>
    	 $("form").submit(function () {
	          	if ($("#UserName").val() == '' || $("#Password").val() == '') { 
	         		alert("Username or password is empty");
	         		$("#UserName").focus();
	          		return false; 
	          	}
	         	else {
	              $.ajax({
	                  url: '/servlet/VarifyUser',
	                  type:"POST",
	                  dataType: 'text',
	                  data: $("form").serialize(),
	                  success: function (msg) {
	                      msg = msg.replace(/rn/g, '');
	                      if (msg == "ok") { window.location.href = "/servlet/ManageCenterUI"; }
	                      else {
	                          alert("Username or password is incorrect");
	                          $("#UserName").val("");
	                          $("#Password").val("");
	                          $("#UserName").focus();
	                          return;
	                      }
	                  }
	              });
	          	}
          	return false;
     	 });
    	</script>
  	</body>
</html>
