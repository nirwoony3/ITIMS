<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<style type="text/css">
 .jqx-tabs-title{width: auto;} 
</style>
<script type="text/javascript">
window.focus();
//var pageNum  = 1;

//var userno = "${loginInfo.userno}";
//var username = "${loginInfo.username}";
//var userposition = "${loginInfo.userposition}";
//var userdeptname = "${loginInfo.userdeptname}";

$(document).ready(function() {
	$("#btn_pgm_new").jqxButton({ 
		width: 75, 
		height: 25, 
		theme:theme
	});
	$("#btn_pgm_update").jqxButton({ 
		width: 75, 
		height: 25, 
		theme:theme
	});
	$("#btn_pgm_delete").jqxButton({ 
		width: 75, 
		height: 25, 
		theme:theme
	});
	$("#btn_pgm_close").jqxButton({ 
		width: 75, 
		height: 25, 
		theme:theme
	});
	
	
	// new
	$("#btn_pgm_new_new").jqxButton({ 
		width: 75, 
		height: 25, 
		theme:theme
	});
	$("#btn_pgm_new_close").jqxButton({ 
		width: 75, 
		height: 25, 
		theme:theme
	});
	$("#btn_pgm_3dplm").jqxButton({ 
		width: 75, 
		height: 25, 
		theme:theme
	});
	$("#pwm_new_extension").jqxInput({ height : 25, width : 186});        	
	$("#pwm_new_name").jqxInput({ height : 25, width : 186});        	
	$("#pwm_new_desc").jqxInput({ height : 25, width : 186});        	
	
    //update
        
    $("#pwm_update_extension").jqxInput({ height : 25, width : 76});
    $("#pwm_update_type").jqxInput({ height : 25, width : 76});
    $("#pwm_update_excution").jqxInput({ height : 25, width : 186});
    $("#pwm_update_name").jqxInput({ height : 25, width : 186});
    $("#pwm_update_desc").jqxInput({ height : 25, width : 186});
    
    $("#btn_pgm_update_save").jqxButton({ 
		width: 75, 
		height: 25, 
		theme:theme
	});
	$("#btn_pgm_update_close").jqxButton({ 
		width: 75, 
		height: 25, 
		theme:theme
	});
    
	
	$('#jqxPgmTree').on('expand', function (event) {
		var selectTree = $("#jqxPgmTree").jqxTree('getItem', event.args.element);
		console.log(selectTree);
	});		
    
	$("#btn_pgm_new").click(function(){
		$("#pgm_new_winm").jqxWindow("move", $(window).width() / 2 - $("#pgm_new_winm").jqxWindow("width") / 2, $(window).height() / 2 - $("#pgm_new_winm").jqxWindow("height") / 2);
        $("#pgm_new_winm").jqxWindow({width: 380, height: 214, title: "iTims - manage head information of user program...", resizable: true,theme:theme,  isModal: false, autoOpen: false /*modalOpacity: 0.01*/ });
        $("#pgm_new_winm").jqxWindow('show');

	});
    
	$("#btn_pgm_update").click(function(){
		var selectTree = $("#jqxPgmTree").jqxTree('getItem', event.args.element);
		//console.log(selectTree);
		
		$("#pgm_update_winm").jqxWindow("move", $(window).width() / 2 - $("#pgm_update_winm").jqxWindow("width") / 2, $(window).height() / 2 - $("#pgm_update_winm").jqxWindow("height") / 2);
        $("#pgm_update_winm").jqxWindow({width: 380, height: 248, title: "iTims - manage detail information of user program...", resizable: true,theme:theme,  isModal: false, autoOpen: false /*modalOpacity: 0.01*/ });
        $("#pgm_update_winm").jqxWindow('show');

	});


}); // End Ready Function


function getPgmList(){
	$.ajax({//D_DOCDB 데이터 갖고오기
		url : "getPgmList.do",
		type : "POST",
		dataType : "json",
		//data : {"dbname" : docdbname,"docno":docno},
		success : function(data, status,XHR){
			console.log(data);
			
		/*pgmname-pgmextention   (pgmaccesstype == EXTENTION)
			read
				pgmname or pgmdesc
			write
				pgmname or pgmdesc */
				
			var source = [ ];
			var pgmList = data.pgmList;
			var cnt;
			//var item = {};
			for(var i in pgmList){
			    if(pgmList[i].pgmaccesstype == 'EXTENTION'){
			    	source.push ({id: pgmList[i].pgmextention,
						  //icon: childFolder, 
						  label: pgmList[i].pgmname+"-"+pgmList[i].pgmextention, 
						  cnt: 0,
						  //items:{label:"read-"+pgmList[i].aa, label2:"write-"+pgmList[i].bb}
					});
				} 
			}
			var read = 'read';
			var write = 'write';
			var item = [];

			for(var i in source){
				for(var j in pgmList){
					if(source[i].id === pgmList[j].pgmextention){
						if(pgmList[j].pgmaccesstype == 'READ'){
							read = 'read - '+pgmList[j].pgmname;
						}else if(pgmList[j].pgmaccesstype == 'WRITE'){
							write = 'write - '+pgmList[j].pgmname;
						}
					}
				}
				source[i].items = {label:read, label2:write};
			}
			
			$("#jqxPgmTree").jqxTree({ source: source,  height: 350, width: '100%'/* , theme:'ui-lightness' */ });
		},
		error : function(data, status){
		},
		complete : function(){
		}
	});		
}
  	


</script>
<div id="pgm_winm" style="max-width:100%; z-index:1; height:auto; margin: -2px; display:none;">
	<div>
		<!-- Main Div -->
		<div id="pgm_main_cond" style="border:1px solid lightgray;">
			
			<div id="pgm_main_tab">
				<div id='jqxWidget'>
			        <div id='jqxPgmTree'>
			            <div>
			                Folders
			            </div>
			            <div style="overflow: hidden;">
			                <div style="border: none;" id='jqxTree'>
			                </div>
			            </div>
			        </div>
			    </div>
			    
			    <button id="btn_pgm_new" style="margin-top:10px; margin-left:150px;">new</button>
			    <button id="btn_pgm_update" style="margin-top:10px;">update</button>
			    <button id="btn_pgm_delete" style="margin-top:10px;">delete</button>
			    <button id="btn_pgm_close" style="margin-top:10px;">close</button>
			</div>
			
		</div>
	</div>
 </div><!-- End pgm_winm winm -->
 
 
 <div id="pgm_new_winm" style="max-width:100%; z-index:2; height:auto; margin: -2px; display:none;">
	<div>
		<!-- Main Div -->
		<div id="pgm_new_main_cond" style="border:1px solid lightgray;">
			
			<div id="pgm_new_main_tab">
				<div style="margin-left:20px; margin-top:10px;">User Program File extension List</div>
				<table cellspacing="3px" style="padding-right: 18px; margin-top: 10px; padding-left: 35px;">
					<tr>
						<td align="right">File Extension </td>
						<td align="left"><input type="text" id="pwm_new_extension" /></td>
					</tr>
					<tr>
						<td align="right">Program Name </td>
						<td align="left"><input type="text" id="pwm_new_name" /></td>
					</tr>
					<tr>
						<td align="right">Program Desc </td>
						<td align="left"><input type="text" id="pwm_new_desc" /></td>
					</tr>
					
				</table>

			    <button id="btn_pgm_new_new" style="margin-top:10px; margin-left:90px;">new</button>
			    <button id="btn_pgm_new_close" style="margin-top:10px;">close</button>
			    <button id="btn_pgm_3dplm" style="margin-top:10px;">3d plm</button>
			</div>
			
		</div>
	</div>
 </div><!-- End pgm_new_winm winm -->
 
 
  <div id="pgm_update_winm" style="max-width:100%; z-index:2; height:auto; margin: -2px; display:none;">
	<div>
		<!-- Main Div -->
		<div id="pgm_update_main_cond" style="border:1px solid lightgray;">
			
			<div id="pgm_update_main_tab">
				<div style="margin-left:20px; margin-top:10px;">User Program Detail Contents</div>
				<table cellspacing="3px" style="padding-right: 18px; margin-top: 10px; padding-left: 35px;">
					<tr>
						<td align="right">File type </td>
						<td align="left">
							<input type="text" id="pwm_update_extension" />
							<input type="text" id="pwm_update_type" />
						</td>
					</tr>
					<tr>
						<td align="right">Excution file</td>
						<td align="left"><input type="text" id="pwm_update_excution" /></td>
					</tr>
					<tr>
						<td align="right">Program Name </td>
						<td align="left"><input type="text" id="pwm_update_name" /></td>
					</tr>
					<tr>
						<td align="right">Program Desc </td>
						<td align="left"><input type="text" id="pwm_update_desc" /></td>
					</tr>
					
				</table>

			    <button id="btn_pgm_update_save" style="margin-top:10px; margin-left:90px;">new</button>
			    <button id="btn_pgm_update_close" style="margin-top:10px;">close</button>
			</div>
			
		</div>
	</div>
 </div><!-- End pgm_update_winm winm -->
 
 