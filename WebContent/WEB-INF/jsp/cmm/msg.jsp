 <%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
 <link rel="stylesheet" href="<c:url value='/css/cmm/sweetalert.css'/>" type="text/css" />
 <script type="text/javascript"	src="<c:url value='/js/cmm/sweetalert.min.js'/>"></script>
 <style>
 .sweet-alert h2 {
    font-size: 12px;
    margin : 0;
    vertical-align: center;
}

.sweet-alert fieldset {
    display: none;
}

.sweet-alert button {
    font-size: 10px;
    margin-top: 40px;
}

.sweet-alert {
    width: 320px;
    background-color:#EFE5D2;
    border-radius: 10px;
}

.sweet-alert .sa-icon {
    width: 40px;
    height: 40px;
    float: left;
    margin-right: -30px;
}

.sweet-alert .sa-icon.sa-warning .sa-body {
    height: 10px;
}

.sweet-alert button.cancel {
    float: right;
    margin-right: 60px;
    margin-left: -60px;
}

.sweet-alert p {
   font-size: 12px;
   font-weight: 700;
/*     top: 10%; */
/*     position: sticky; */
    vertical-align: center;
}

 </style>
<!-- JS  -->

<script type="text/javascript">
$(document).ready(function(){
	 var color =  "linear-gradient(to bottom, #F3F9FD,#208AD0)";
	 var color2 = "linear-gradient(to bottom, rgba(255, 191, 122, 0.31), rgba(255, 197, 108, 0.75))";
	 
	 $("#btn1_ok").jqxButton({ 
			width: 70, 
			height: 25, 
		}); 
		
		$('#btn1_ok').hover(function(){
		 $('#btn1_ok').css('background',color);
		 },
		 function(){
		    $('#btn1_ok').css('background',color2);
		 }
		);
		
		$('#btn1_ok').on('click',function(){
			$("#msg_btn1").jqxWindow('close'); 
			  // $("#p_f_pms_adddoc").jqxWindow('close'); 
		});
		
		/////////////////////////////////////////////
		$("#btn2_ok").jqxButton({ 
			width: 70, 
			height: 25, 
		}); 
		$("#btn2_cancel").jqxButton({ 
			width: 70, 
			height: 25, 
		}); 
		
		$('#btn2_ok').hover(function(){
		 $('#btn2_ok').css('background',color);
		 },
		 function(){
		    $('#btn2_ok').css('background',color2);
		 }
		);
		
		$('#btn2_cancel').hover(function(){
			 $('#btn2_cancel').css('background',color);
			 },
			 function(){
			    $('#btn2_cancel').css('background',color2);
			 }
			);
		
		$('#btn2_cancel').on('click',function(){
			$("#msg_btn2").jqxWindow('close'); 
			// $("#p_f_pms_adddoc").jqxWindow('close'); 
		});
		
		//////////////////////////////
		$("#btn3_ok").jqxButton({ 
			width: 70, 
			height: 25, 
		}); 
		$("#btn3_cancel").jqxButton({ 
			width: 70, 
			height: 25, 
		}); 
		
		$('#btn3_ok').hover(function(){
		 $('#btn3_ok').css('background',color);
		 },
		 function(){
		    $('#btn3_ok').css('background',color2);
		 }
		);
		
		$('#btn3_cancel').hover(function(){
			 $('#btn3_cancel').css('background',color);
			 },
			 function(){
			    $('#btn3_cancel').css('background',color2);
			 }
			);
		
		$('#btn3_cancel').on('click',function(){
			$("#msg_btn3").jqxWindow('close'); 
			// $("#p_f_pms_adddoc").jqxWindow('close'); 
		});
		
//////////////////////////////
		$("#btn4_ok").jqxButton({ 
			width: 70, 
			height: 25, 
		}); 
		$("#btn4_cancel").jqxButton({ 
			width: 70, 
			height: 25, 
		}); 
		
		$('#btn4_ok').hover(function(){
		 $('#btn4_ok').css('background',color);
		 },
		 function(){
		    $('#btn4_ok').css('background',color2);
		 }
		);
		
		$('#btn4_cancel').hover(function(){
			 $('#btn4_cancel').css('background',color);
			 },
			 function(){
			    $('#btn4_cancel').css('background',color2);
			 }
			);
		
		$('#btn4_cancel').on('click',function(){
			$("#msg_btn4").jqxWindow('close'); 
			// $("#p_f_pms_adddoc").jqxWindow('close'); 
		});
		
	 
})



function msg1(rtnmsg){
// 	$("#msg_btn1").jqxWindow("move", $(window).width() / 2 - $("#msg_btn1").jqxWindow("width") / 2, $(window).height() / 2 - $("#msg_btn1").jqxWindow("height") / 2);
//     $("#msg_btn1").jqxWindow({width: 300, height: 170, resizable: false,  isModal: true, autoOpen: false, cancelButton: $("#btn1_ok"), modalOpacity: 0.01 });
//     $("#msg_btn1").jqxWindow('show'); 
//     $("#rtn1").html(rtnmsg);
	//swal(rtnmsg);
	swal({
		  title: "",
		  text: rtnmsg,
		  animation:false,
		  closeOnConfirm: false
		});
}


	
function msg2(rtnmsg, width, height){
    $("#msg_btn2").jqxWindow("move", $(window).width() / 2 - $("#msg_btn2").jqxWindow("width") / 2, $(window).height() / 2 - $("#msg_btn2").jqxWindow("height") / 2);
	 $("#msg_btn2").jqxWindow({width: width, height: height, resizable: false,  isModal: true, autoOpen: false, cancelButton: $("#re_logoutbtn"), modalOpacity: 0.01 });
	 $("#msg_btn2").jqxWindow('show'); 
	 $("#rtn2").html(rtnmsg);
}

function msg3(rtnmsg, width, height){   //msg1 넓이 높이 주기
  $("#msg_btn1").jqxWindow("move", $(window).width() / 2 - $("#msg_btn1").jqxWindow("width") / 2, $(window).height() / 2 - $("#msg_btn1").jqxWindow("height") / 2);
  $("#msg_btn1").jqxWindow({width: width, height: height, resizable: false,  isModal: true, autoOpen: false, cancelButton: $("#re_logoutbtn"), modalOpacity: 0.01 });
  $("#msg_btn1").jqxWindow('show'); 
  $("#rtn1").html(rtnmsg);
}

function msg4(rtnmsg, width, height){   // ok 두개 필요 할때
    $("#msg_btn3").jqxWindow("move", $(window).width() / 2 - $("#msg_btn3").jqxWindow("width") / 2, $(window).height() / 2 - $("#msg_btn3").jqxWindow("height") / 2);
	 $("#msg_btn3").jqxWindow({width: width, height: height, resizable: false,  isModal: true, autoOpen: false, cancelButton: $("#re_logoutbtn"), modalOpacity: 0.01 });
	 $("#msg_btn3").jqxWindow('show'); 
	 $("#rtn3").html(rtnmsg);
}

function msg5(rtnmsg, width, height){   // ok 세개 필요 할때
    $("#msg_btn4").jqxWindow("move", $(window).width() / 2 - $("#msg_btn4").jqxWindow("width") / 2, $(window).height() / 2 - $("#msg_btn4").jqxWindow("height") / 2);
	 $("#msg_btn4").jqxWindow({width: width, height: height, resizable: false,  isModal: true, autoOpen: false, cancelButton: $("#re_logoutbtn"), modalOpacity: 0.01 });
	 $("#msg_btn4").jqxWindow('show'); 
	 $("#rtn4").html(rtnmsg);
}


function msgWindowClose(rtnmsg){
// 	$("#msg_btn1").jqxWindow("move", $(window).width() / 2 - $("#msg_btn1").jqxWindow("width") / 2, $(window).height() / 2 - $("#msg_btn1").jqxWindow("height") / 2);
//     $("#msg_btn1").jqxWindow({width: 300, height: 170, resizable: false,  isModal: true, autoOpen: false, cancelButton: $("#btn1_ok"), modalOpacity: 0.01 });
//     $("#msg_btn1").jqxWindow('show'); 
//     $("#rtn1").html(rtnmsg);
	//swal(rtnmsg);
	swal({
		  title: "",
		  text: rtnmsg,
		  type: "warning",

		  confirmButtonColor: "#DD6B55",
		  confirmButtonText: "OK!", animation: false,
		  closeOnConfirm: false
		},
		function(){
			window.close();
		});
}

function msgWindowRelaod(rtnmsg){
// 	$("#msg_btn1").jqxWindow("move", $(window).width() / 2 - $("#msg_btn1").jqxWindow("width") / 2, $(window).height() / 2 - $("#msg_btn1").jqxWindow("height") / 2);
//     $("#msg_btn1").jqxWindow({width: 300, height: 170, resizable: false,  isModal: true, autoOpen: false, cancelButton: $("#btn1_ok"), modalOpacity: 0.01 });
//     $("#msg_btn1").jqxWindow('show'); 
//     $("#rtn1").html(rtnmsg);
	//swal(rtnmsg);
	swal({
		  title: "",
		  text: rtnmsg,
		  type: "warning",

		  confirmButtonColor: "#DD6B55",
		  confirmButtonText: "OK!", animation: false,
		  closeOnConfirm: false
		},
		function(){
			location.reload();
		});
}


</script>

<div id="msg_btn1" style="display: none">
      <div style="background-color: #FDC06D;">
         알림
      </div>
      <div style="overflow: auto;">
         <table style="margin: auto;">
            <tr>
               <td  align="center" style="padding-top: 30px; font-size: 14px;" id="rtn1"></td> 
            </tr> 
            <tr>
               <td style="padding-top: 15px;" align="center">
               <input type="button" value="OK" id="btn1_ok" style="align:center; background:linear-gradient(to bottom, rgba(255, 191, 122, 0.31), rgba(255, 197, 108, 0.75));" /></td>
            </tr>
         </table>
         <div style="height: 20px; position: absolute; left: 0px; bottom: 0px; width: 100%; background-color: #FDC06D; text-align: left; font-size: 15px; color: white;"
            id="msg2">msg
         </div>
 	</div>
</div>

<div id="msg_btn2" style="display: none;">
      <div style="background-color: #FDC06D;">
         알림
      </div>
      <div style="overflow: auto;">
         <table style="margin: auto;">
            <tr>
               <td  align="center" style="padding-top: 30px; font-size: 14px;"  id="rtn2" ></td> 
            </tr> 
            <tr>
               <td style="padding-top: 30px;" align="center">
               <input
                  type="button" value="OK" id="btn2_ok" style=" background:linear-gradient(to bottom, rgba(255, 191, 122, 0.31), rgba(255, 197, 108, 0.75));" />
               <input
                  type="button" value="Cancel" id="btn2_cancel" style=" background:linear-gradient(to bottom, rgba(255, 191, 122, 0.31), rgba(255, 197, 108, 0.75));" /> 
                </td>
            </tr>
         </table>
         <div
            style="height: 20px; position: absolute; left: 0px; bottom: 0px; width: 100%; background-color: #FDC06D; text-align: left; font-size: 15px; color: white;"
            id="msg2">msg
         </div>
 </div>
</div>

<div id="msg_btn3" style="display: none;">
      <div style="background-color: #FDC06D;">
         알림
      </div>
      <div style="overflow: auto;">
         <table style="margin: auto;">
            <tr>
               <td  align="center" style="padding-top: 30px; font-size: 14px;"  id="rtn3" ></td> 
            </tr> 
            <tr>
               <td style="padding-top: 30px;" align="center">
               <input
                  type="button" value="OK" id="btn3_ok" style=" background:linear-gradient(to bottom, rgba(255, 191, 122, 0.31), rgba(255, 197, 108, 0.75));" />
               <input
                  type="button" value="Cancel" id="btn3_cancel" style=" background:linear-gradient(to bottom, rgba(255, 191, 122, 0.31), rgba(255, 197, 108, 0.75));" /> 
                </td>
            </tr>
         </table>
         <div
            style="height: 20px; position: absolute; left: 0px; bottom: 0px; width: 100%; background-color: #FDC06D; text-align: left; font-size: 15px; color: white;"
            id="msg3">msg
         </div>
 </div>
</div>

<div id="msg_btn4" style="display: none;">
      <div style="background-color: #FDC06D;">
         알림
      </div>
      <div style="overflow: auto;">
         <table style="margin: auto;">
            <tr>
               <td  align="center" style="padding-top: 30px; font-size: 14px;"  id="rtn4" ></td> 
            </tr> 
            <tr>
               <td style="padding-top: 30px;" align="center">
               <input
                  type="button" value="OK" id="btn4_ok" style=" background:linear-gradient(to bottom, rgba(255, 191, 122, 0.31), rgba(255, 197, 108, 0.75));" />
               <input
                  type="button" value="Cancel" id="btn4_cancel" style=" background:linear-gradient(to bottom, rgba(255, 191, 122, 0.31), rgba(255, 197, 108, 0.75));" /> 
                </td>
            </tr>
         </table>
	         <div
	            style="height: 20px; position: absolute; left: 0px; bottom: 0px; width: 100%; background-color: #FDC06D; text-align: left; font-size: 15px; color: white;"
	            id="msg4">msg
	         </div>
 		</div>
</div>