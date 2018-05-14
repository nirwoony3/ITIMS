<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.net.URLEncoder"%>
<%@ include file="cmm/jstl.jsp"%>
<%@ include file="cmm/jqwidgets.jsp"%>
<%@ include file="cmm/msg.jsp" %> 

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>TIMS Login</title>
</head>

<!--script type="text/javascript" src="json2.js" ></script-->
<script type="text/javascript">
$(document).ready(function(){	
	var color2 = "linear-gradient(to bottom, rgba(255, 191, 122, 0.31), rgba(255, 197, 108, 0.75))";	
	
	$("#login_win").jqxWindow({ position:"center", resizable: false , height:200, width: 400, theme:"bootstrap" });  //Title: 'iTIMS newest', summer
	$("#login_win").jqxWindow({ draggable: false, showCloseButton: false });
	 
	$("#btn_login").jqxButton({ width:80, height:25 });	 
	$("#btn_close").jqxButton({ width:80, height:25 });

	//$('#btn_login').css('background',color2); 
	//$('#btn_close').css('background',color2);
	$(".button").css("background",color2); //use class

	$('#btn_login').hover(
		function(){ $('#btn_login').css('background','linear-gradient(to bottom, #F3F9FD,#208AD0)'); },
		function(){ $('#btn_login').css('background',color2); }
	);
	$('#btn_close').hover(
		function(){ $('#btn_close').css('background','linear-gradient(to bottom, #F3F9FD,#208AD0)'); },
		function(){ $('#btn_close').css('background',color2); }
	);
		 
	$("#e_login_userid").jqxInput({ height:25, width:200, minLength:1 });
	$("#e_login_userpw").jqxInput({ height:25, width:200, minLength:1 });
	//
	$("#e_login_userid").val("U100");
	$("#e_login_userpw").val("111");
	 
	//#event proc
	$("#btn_login").click( function(){
		var params = {"userno": $("#e_login_userid").val(),"userpassword":$("#e_login_userpw").val(),"mode":""};
		loginAction(params,"loginAction.do");
	});
	 
	$("#btn_close").click(function(){
		var agent = navigator.userAgent.toLowerCase(); //alert("agent => "+ agent);
		if (agent.indexOf("msie") > 0) {
			window.open("about:blank","_self").close(); //opener.open('about:blank','_self').close(); - close parent window
      } else {
      	window.close(); // 일반적인 현재 창 닫기
      	window.open('about:blank','_self').self.close();  // IE에서 묻지 않고 창 닫기      	
      } 
      sessionStorage.clear(); //clear all session information 
      //sessionStorage.removeItem('SABUN');

      //window.open("about:blank","_self").close(); //ie work ok   
		//self.opener = self;
		//window.close();		
		//window.open('','_self').close();
		//self.opener = self; window.close(); //close msg displayed
		//window.open('', '_self', '');
      //window.close();
	});
});

//resize
$(window).resize(function(event){
	$("#login_win").jqxWindow({ position:"center" });	
});

function enterkey() {
    if (window.event.keyCode == 13) {   
        var params = {"userno": $("#e_login_userid").val(),"userpassword":$("#e_login_userpw").val(),"mode":""};     
	    loginAction(params,"loginAction.do");
    }
}

function loginAction(params,searchUrl){
	//넘어오는 params는 그냥 참고용 JK
	var uid = jQuery.trim($("#e_login_userid").val());
	var pwd = jQuery.trim($("#e_login_userpw").val());
    if (uid=="") { $("#e_login_userid").focus(); msg1("아이디를 입력하세요."); return; }
    if (pwd=="") { $("#e_login_userpw").focus(); msg1("패스워드를 입력하세요."); return; }
	var params2 = {"userno": uid, "userpassword": pwd, "mode":""};

	$.ajax({
		url : searchUrl,
		type: "POST",
		dataType : "json",
		data: params2,  //params
        async: false,
		beforeSend : function(){ },
		success : function(data, status,XHR){
			switch (Number(data.resMsg)) {
			case 1:
				///console.log("로그인 성공"); 
			  	location.href="main.do"; 
				break;
			case 2:
				msg1("아이디와 패스워드가 바르지않습니다.");
				break;
			case 3:
				msg1("아이디와 패스워드가 바르지않습니다.");
				break;
			case -1:
				msg1("[에러]관리자에게 문의하세요");
				break;
			case 5:
				$("#p_updpw").jqxWindow("move", $(window).width() / 2 - $("#p_updpw").jqxWindow("width") / 2, $(window).height() / 2 - $("#p_updpw").jqxWindow("height") / 2);
			    $("#p_updpw").jqxWindow({width: 400, height: 200, resizable: false,  isModal: true, autoOpen: false, cancelButton: $("#re_logoutbtn"), modalOpacity: 0.3 });
			    $("#p_updpw").jqxWindow('show'); 
				msg1("규정에 맞지않는 비밀번호입니다.");
				break;
			}			
		},
		error: function(data){
			msg1("관리자에게 문의하세요");
		},
		complete : function(){			
		}
	});
}
</script>

<body>
<!-- <body style="background-image: url('images_up2/bg_login.png');"> -->
<div id="login_win">
	<div class="header_bar"><img alt="CompanyLogo" src="<c:url value='images/uk.png'/>" style="height: 17px; float: left;"> 
		<font style="color: white; font-size: 14px; font-weight: bold; font-style: italic; margin-left: 10px;">iTIMS - for Technical Knowledge Producer.</font>
		<img alt="CloseLogo" src="<c:url value='images/close_white.png'/>" style="height: 20px; margin-top: -1px; margin-left: 58px; float: right;"> 
	</div>

	<div>
		<table align="center" style="">
		<tr>
			<td align="left" colspan='2' style="height:35px; font-size: 12px; margin-bottom:5px; color:maroon; ">integrated Technical Information Management Solution.</td>
		</tr>
		<tr>
			<td align="right" style="font-size:12px; color:maroon;">USER ID:</td>
			<td style="font-size: 14px;"><input type="text" id="e_login_userid" name="username" onkeyup="enterkey();"></td>
		</tr>
		<tr>
			<td align="right" style="font-size:12px; color:maroon;">PASSWORD:</td>
			<td style="font-size: 14px;"><input type="password" id="e_login_userpw" name="userpassword" onkeyup="enterkey();"></td>
		</tr>
		<tr><td></td></tr>
		<tr>
			<td ></td>
			<td>
				<input type="button" class="button" id="btn_login" value="LOGIN" style="margin-top: 5px; font-size: 12px; color:maroon;" >
				<input type="button" class="button" id="btn_close" value="CLOSE" style="margin-top: 5px; font-size: 12px; color:maroon;" >
			</td>
		</tr>
		</table>
		<div class="bottom_bar" id="msg" style="font-style: italic;"> 
			<!-- text top 마진은 위 style에 padding:3px 2px 0 30px; float:left; color:#727272; font-size:22px; font-weight:bold; 문제는 3px 높이가 커짐
                 현재 jqwudegts.jsp에서 이 class의 높이가 20px로 주어졌음으로 전체가 23px가 됨으로 높이가 커짐. 주의  
			-->
			<font style="font-size: 9px; text-align: left; margin-left:60px; ">&nbsp; ver 3.0.1 </font>
			<font style="font-size: 9px; text-align: left; margin-left:26px; ">Copyright(C) DeltaSolutions All rights reserved</font>
		</div>
	</div>
</div> 	

</body>
</html>