<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<style type="text/css">
 .jqx-tabs-title{width: auto;} 
</style>
<script type="text/javascript">
window.focus();
var pageNum  = 1;

var userno = "${loginInfo.userno}";
var username = "${loginInfo.username}";
var userposition = "${loginInfo.userposition}";
var userdeptname = "${loginInfo.userdeptname}";

$(document).ready(function() {

	//$("#find_head_sys").jqxMenu({ width: '100%', height: 30 });
	$("#approval_main_cond").jqxPanel({ width: '99.5%',rtl:true, height:495, theme:theme});
	$('#approval_main_tab').jqxTabs({ width: '99.5%', height: 495, position: 'top', theme: theme});

	$("#e_approval_title").jqxInput({
		height : 25,
		width :490,
		minLength : 1,
	});
	
	$("#e_approval_user").jqxInput({
		height : 25,
		width :"50%",
		minLength : 1,
	});
	

	$('#tx_approval_memo').jqxTextArea({height: 90, width: "99%", minLength: 1,  });
	
	
	$("#cb_approval_atttach").jqxCheckBox({ width: 120, height: 25, checked:true});
	$("#cb_approval_autonotify").jqxCheckBox({ width: 220, height: 25, checked:true});
	
	$("#radiogroup_approval").jqxButtonGroup({ mode: 'radio', theme: theme });
    
    $("#rb_approval_approval").jqxRadioButton({ height:18 , theme:theme, checked: true }); 
	$("#rb_approval_agreement").jqxRadioButton({ height:18, theme:theme  }); 
	$("#rb_approval_notice").jqxRadioButton({ height:18, theme:theme  }); 


    $("#btn_approval_erase").jqxButton({ 
		width: 20, 
		height: 22, 
		theme:theme
	});
	$("#btn_approval_up").jqxButton({ 
		width: 20, 
		height: 22, 
		theme:theme
	});
	$("#btn_approval_down").jqxButton({ 
		width: 20, 
		height: 22, 
		theme:theme
	});	
	$("#btn_approval_userSearch").jqxButton({ 
		width: 20, 
		height: 20, 
		theme:theme
	});
	$("#btn_approval_appr").jqxButton({ 
		width: 70, 
		height: 25, 
		theme:theme
	});
	
	$('#btn_approval_close').on('click',function(){ 
		$("#approval_winm").jqxWindow('close');
	});
	
	
	$('#btn_approval_userSearch').on('click',function(){ 
		var username = $("#e_approval_user").val();
		var param = {"username" : username};
		
		$('#userlist_winm').jqxWindow('focus');
		gr_userlist(param);
		
		$("#userlist_winm").jqxWindow("move", $(window).width() / 2 - $("#userlist_winm").jqxWindow("width") / 2, $(window).height() / 2 - $("#userlist_winm").jqxWindow("height") / 2);
        $("#userlist_winm").jqxWindow({width: 500, height: 310, title:"userlist", resizable: true,theme:theme,  isModal: false, autoOpen: false /*modalOpacity: 0.01*/ });
        $("#userlist_winm").jqxWindow('show');
	});

	// userList //


	$("#userlist_main_cond").jqxPanel({ width: '100%', height:270, theme:theme});
	$("#btn_userlist_add").jqxButton({ 
		width: 50, 
		height: 25, 
		theme:theme
	});
	
	$('#btn_userlist_add').on('click',function(){ 
		var indexes = $("#gr_userlist").jqxGrid('getselectedrowindexes');
		var data = "";
		var apprkind = "";
		
		if($("#rb_approval_approval").val()){apprkind="결재"}
		else if($("#rb_approval_agreement").val()){apprkind="합의"}
		else if($("#rb_approval_notice").val()){apprkind="통보"}
		else(apprkind="결재");
		for (var i = 0; i < indexes.length; i++) {
			var datarow = {};
			data = $("#gr_userlist").jqxGrid('getrowdata', indexes[i]);
			
			var datainformations = $('#gr_approval_apprpath').jqxGrid('getdatainformation');
			var rowscounts = datainformations.rowscount;
			console.log(datainformations);
			datarow["seqno"] = rowscounts;
			datarow["apprstatus"] = $("#e_approval_apprstatus").val();
			datarow["apprkind"] = apprkind;
			datarow["userno"] = data.userno;
      	    datarow["username"] = data.username;
      	    datarow["userposition"] = data.userposition;
      	  	datarow["userdeptname"] = data.userdeptname;
      	    
      	  	var commit = $("#gr_approval_apprpath").jqxGrid('addrow', null, datarow);
      	  	
      	  $("#gr_approval_apprpath").jqxGrid('selectallrows');
		}
	});
	
	$("#btn_approval_erase").on('click',function(){ 
		var idArray = new Array();
	 	var rowindex = $("#gr_approval_apprpath").jqxGrid('getselectedrowindexes');
	 	var data = "";
	 	var id = "";
		for(var i=0; i<rowindex.length; i++){
			id = $("#gr_approval_apprpath").jqxGrid('getrowid', rowindex[i]);
			data = $("#gr_approval_apprpath").jqxGrid('getrowdata', rowindex[i]);
		    idArray.push(id);
		    if(data.apprkind == '기안'){msg1("기안은 삭제할수 없습니다"); return;}
		} 
	    var commit = $("#gr_approval_apprpath").jqxGrid('deleterow', idArray);
	});
	

	// userList End//

	
	
	$('#approval_main_tab').on('tabclick', function (event) 
 	{ 
		var tabsItem = event.args.item; 
		console.log(tabsItem);
	    switch (tabsItem) {
		case 0:	//결재신청처리
			break;
		case 1://결재작업처리
			getJobProcessing();
			break;
		case 2://결재진행내역
			getProgressHistory();
			break;
		case 3://윅플로우변경이력
			getModificationHistory();
			break;
		default:
			break;
		}
	});
	
	
	$('#rb_approval_approval').on('click', function (event) {
		var indexes = $("#gr_approval_apprpath").jqxGrid('getselectedrowindexes');
		for(var i =0; i < indexes.length; i++){
			if(indexes[i] == 0){msg1("기안은 변경할 수 없습니다."); return;}
			console.log(indexes[i]);
			$("#gr_approval_apprpath").jqxGrid('setcellvalue', indexes[i], "apprkind", "결재");
		}	
	});
	
	$('#rb_approval_agreement').on('click', function (event) {
		var indexes = $("#gr_approval_apprpath").jqxGrid('getselectedrowindexes');
		for(var i =0; i < indexes.length; i++){
			if(indexes[i] == 0){msg1("기안은 변경할 수 없습니다."); return;}
			console.log(indexes[i]);
			$("#gr_approval_apprpath").jqxGrid('setcellvalue', indexes[i], "apprkind", "합의");
		}
	 });
	
	$('#rb_approval_notice').on('click', function (event) {
		var indexes = $("#gr_approval_apprpath").jqxGrid('getselectedrowindexes');
		for(var i =0; i < indexes.length; i++){
			if(indexes[i] == 0){msg1("기안은 변경할 수 없습니다."); return;}
			console.log(indexes[i]);
			$("#gr_approval_apprpath").jqxGrid('setcellvalue', indexes[i], "apprkind", "통보");
		}
	 });
	
	
	$('#gr_approval_file').on('rowdoubleclick', function (event) 
	{ 
	    var args = event.args;
	    // row's bound index.
	    var boundIndex = args.rowindex;
	    // row's visible index.
	    var visibleIndex = args.visibleindex;
	    // right click.
	    var rightclick = args.rightclick; 
	    // original event.
	    var ev = args.originalEvent;
	    
	    var data = $('#gr_approval_file').jqxGrid('getrowdata', boundIndex);

	    fileOpen(data.filename, "D:\\pwmSTR\\AttachFile");

	});
	
	
	// 결재신청

	$("#btn_approval_appr").on('click', function () {
 		var apprstatus = $("#e_approval_apprstatus").val();
 		var apprmemo = $("#tx_approval_memo").val();
		var gridId = $('#gr_approval_apprpath');
 		var griddata = gridId.jqxGrid('getdatainformation');

 		var data = "";
 		var param = "";
		for (var i = 0; i < griddata.rowscount; i++) {
			data = gridId.jqxGrid('getrenderedrowdata', i);

 			param = {"docno"	 		: selectedDocno
 				    ,"apprstatus"		: data.apprstatus   
 				    ,"seqno"			: data.seqno
 				    ,"appruserid" 		: data.userno
 					,"apprkind"  		: data.apprkind
 					,"appruserposition" : data.userposition
 					,"apprusername"		: data.username
 					,"appruserdeptname" : data.userdeptname
 					,"apprjuminno" 		: "*"
 					,"apprmemo"			: apprmemo
 					};
 			
 			insertApprproc(param);
		}
	});

}); // End Ready Function

function getJobProcessing(){
	$("#e_approval_title2").jqxInput({
		height : 25,
		width :490,
		minLength : 1,
	});
	
	$('#tx_approval_memo2').jqxTextArea({height: 90, width: "99%", minLength: 1,  });
	
	$('#e_approval_title2').val($("#title").val());
	var gridId = "gr_approval_apprpath2";
	getApprPath(gridId, 280);
	
  	$("#radiogroup_approval2").jqxButtonGroup({ mode: 'radio', theme: theme });
  	$("#rb_approval_decide").jqxRadioButton({ height:18 , theme:theme, checked: true }); 
 	$("#rb_approval_approbation").jqxRadioButton({ height:18, theme:theme  }); 
 	$("#rb_approval_impossible").jqxRadioButton({ height:18, theme:theme  }); 

 	$("#btn_approval_approval").jqxButton({ 
		width: 70, 
		height: 25, 
		theme:theme
	});
}

function getProgressHistory(){
	$("#e_approval_title3").jqxInput({
		height : 25,
		width :490,
		minLength : 1,
	});
	
	$('#tx_approval_memo3').jqxTextArea({height: 120, width: "99%", minLength: 1,  });
	
	$('#e_approval_title3').val($("#title").val());
	var gridId = "gr_approval_apprpath3";
	getApprPath(gridId, 280);
	
	$("#"+gridId).jqxGrid('showcolumn', 'apprstatus');
}

function getModificationHistory(){
	var param = {"docno" : selectedDocno};
	getWorkflowHisList(param);
}

function getWorkflowHisList(param){

	var source =
    {
        datatype: "json",
        type:"POST",
        data:param,
        datafields: [
            { name: 'created', type: 'string' },
            { name: 'wfstateold', type: 'string' },
            { name: 'wfstate', type: 'string' },
            { name: 'creatorname', type:'string'},
            { name: 'wfscomment', type:'string'}
        ],
        url: "getWorkflowHisList.do",
        id: "userVoList",
        addrow: function (rowid, rowdata, position, commit) {
            // synchronize with the server - send insert command
            // call commit with parameter true if the synchronization with the server is successful 
            //and with parameter false if the synchronization failed.
            // you can pass additional argument to the commit callback which represents the new ID if it is generated from a DB.
            commit(true);
        }
    };
    var cellsrenderer = function (row, columnfield, value, defaulthtml, columnproperties, rowdata) {
        if (value < 20) {
            return '<span style="margin: 4px; float: ' + columnproperties.cellsalign + '; color: #ff0000;">' + value + '</span>';
        }
        else {
            return '<span style="margin: 4px; float: ' + columnproperties.cellsalign + '; color: #008000;">' + value + '</span>';
        }
    }
    var dataAdapter = new $.jqx.dataAdapter(source, {
        downloadComplete: function (data, status, xhr) { },
        loadComplete: function (data) { },
        loadError: function (xhr, status, error) { }
    });

    // initialize jqxGrid
    $("#gr_workflow").jqxGrid(
    {
        width: "99.5%",
        height:435,
        source: dataAdapter,
        pageable: true,
        autoheight: false,
        sortable: true,
        columnsresize: true,
        altrows: true, //칸마다 색깔
        enabletooltips: true,
        columnsheight: 20,
        theme: theme,
        columns: [
          { text: '변경일', datafield: 'created',width:150}, 
          { text: '진행전', datafield: 'wfstateold',width:110}, 
          { text: '진행후', datafield: 'wfstate',width:110}, 
          { text: '수정자', datafield: 'creatorname',width:110}, 
          { text: '코멘트', datafield: 'wfscomment',width:110},
        ]
    });
}

function approvalOnload(){
	var gridId = "gr_approval_apprpath";
	getApprPath(gridId, 120);
	
  	$('#e_approval_title').val($("#title").val());
    grid_approval_file();
    
    $("#gr_approval_apprpath").jqxGrid('selectallrows');
   
}
function gr_userlist(param){

	var source =
    {
        datatype: "json",
        type:"POST",
        data:param,
        datafields: [
            { name: 'userno', type: 'string' },
            { name: 'username', type: 'string' },
            { name: 'userposition', type: 'string' },
            { name: 'userdeptname', type:'string'}
        ],
        url: "getUserList.do",
        id: "userVoList",
        addrow: function (rowid, rowdata, position, commit) {
            // synchronize with the server - send insert command
            // call commit with parameter true if the synchronization with the server is successful 
            //and with parameter false if the synchronization failed.
            // you can pass additional argument to the commit callback which represents the new ID if it is generated from a DB.
            commit(true);
        }
    };
    var cellsrenderer = function (row, columnfield, value, defaulthtml, columnproperties, rowdata) {
        if (value < 20) {
            return '<span style="margin: 4px; float: ' + columnproperties.cellsalign + '; color: #ff0000;">' + value + '</span>';
        }
        else {
            return '<span style="margin: 4px; float: ' + columnproperties.cellsalign + '; color: #008000;">' + value + '</span>';
        }
    }
    var dataAdapter = new $.jqx.dataAdapter(source, {
        downloadComplete: function (data, status, xhr) { },
        loadComplete: function (data) { },
        loadError: function (xhr, status, error) { }
    });

    // initialize jqxGrid
    $("#gr_userlist").jqxGrid(
    {
        width: "99.5%",
        height:235,
        source: dataAdapter,
        pageable: true,
        autoheight: false,
        sortable: true,
        columnsresize: true,
        altrows: true, //칸마다 색깔
        selectionmode : 'checkbox',
        enabletooltips: true,
        columnsheight: 20,
        theme: theme,
        columns: [
          { text: 'userno', datafield: 'userno',width:100}, 
          { text: 'username', datafield: 'username',width:110}, 
          { text: 'userposition', datafield: 'userposition',width:110}, 
          { name: 'userdeptname', datafield:'userdeptname' ,width:120},
        ]
    });
    
    cellclick($("#gr_userlist"));
}

function grid_approval_file(){

	var source =
    {
        datatype: "json",
        type:"POST",
        data:{docno : selectedDocno},
        datafields: [
            { name: 'filename', type: 'string' },
            { name: 'filesize', type: 'int' },
            { name: 'status', type: 'string' },
            { name: 'creator', type: 'string' },
            { name: 'creatorname', type:'string'},
            { name: 'creatordept', type:'string'}
        ],
        url: "getFileAttach.do",
        id: "fileAttachVoList",
        addrow: function (rowid, rowdata, position, commit) {
            // synchronize with the server - send insert command
            // call commit with parameter true if the synchronization with the server is successful 
            //and with parameter false if the synchronization failed.
            // you can pass additional argument to the commit callback which represents the new ID if it is generated from a DB.
            commit(true);
        }
    };
    var cellsrenderer = function (row, columnfield, value, defaulthtml, columnproperties, rowdata) {
        if (value < 20) {
            return '<span style="margin: 4px; float: ' + columnproperties.cellsalign + '; color: #ff0000;">' + value + '</span>';
        }
        else {
            return '<span style="margin: 4px; float: ' + columnproperties.cellsalign + '; color: #008000;">' + value + '</span>';
        }
    }
    var dataAdapter = new $.jqx.dataAdapter(source, {
        downloadComplete: function (data, status, xhr) { },
        loadComplete: function (data) { $("#gr_approval_file").jqxGrid('selectallrows'); },
        loadError: function (xhr, status, error) { }
    });
    
    // initialize jqxGrid
    $("#gr_approval_file").jqxGrid(
    {
        width: "99%",
        height:130,
        source: dataAdapter,
        pageable: true,
        autoheight: false,
        sortable: true,
        columnsresize: true,
        altrows: true, //칸마다 색깔
        selectionmode : 'checkbox',
        enabletooltips: true,
        columnsheight: 20,
        pagerheight: 27,
        theme: theme,
        columns: [
          { text: 'filename', datafield: 'filename',width:290}, 
          { text: 'filesize', datafield: 'filesize',width:100}, 
          { text: 'status', datafield: 'status',width:110}, 
          { text: 'userid', datafield: 'creator',width:110}, 
          { name: 'username', datafield:'creatorname' ,width:110},
          { name: 'dept', datafield:'creatordept' ,width:110}
        ]
    });
    
    cellclick($("#gr_approval_file"));
}

function insertApprproc(param){
	$.ajax({
		url : "insertApprproc.do",
		type : "POST",
		dataType : "json",
		data : param,
		success : function(data, status,XHR){
			
		},
		error : function(data, status){
		},
		complete : function(data){

		}
	});
}

function getApprPath(gridId, gridHeight){
	
	$('#'+gridId).jqxGrid('clear');
	
	$("#"+gridId).jqxGrid(
    {
    	width: '70%', //1525
  	 	height: gridHeight,
   	 	pageable: false,
        sortable: true,
        altrows: true, //행 마다 색상구별
		editable: false,
        pageSize: 200,
        enabletooltips: true,
        columnsresize: true,
        selectionmode:  'checkbox',
		enablebrowserselection : true,
		columnsheight: 20,
		theme: theme,
        columns: [
			{ text: 'sno', datafield: 'seqno',width:50}, 
			{ text: 'status', datafield: 'apprstatus',width:110, hidden:true}, 
			{ text: 'apprkind', datafield: 'apprkind',width:110}, 
			{ text: 'userno', datafield: 'userno',width:100}, 
			{ text: 'username', datafield: 'username',width:110}, 
			{ text: 'userposition', datafield: 'userposition',width:110}, 
			{ text: 'userdeptname', datafield:'userdeptname' ,width:130},
         ],
     });
	
	cellclick($("#"+gridId));

	var datarow = {};
	datarow["seqno"] = 0;
	datarow["apprkind"] = "기안";
	datarow["userno"] = userno;
    datarow["username"] = username;
    datarow["userposition"] = userposition;
  	datarow["userdeptname"] = userdeptname;
  	datarow["apprstatus"] = $("#e_approval_apprstatus").val();
    
  	var commit = $("#"+gridId).jqxGrid('addrow', null, datarow);
  	
}

</script>
<div id="approval_winm" style="max-width:100%; height:auto; margin: -2px; display:none;">
	<div>
		<!-- Main Div -->
		<div id="approval_main_cond" style="border:1px solid lightgray;">	
			<div id="approval_main_tab">
				<ul>
					<li style="">결재신청처리</li>
					<li style="">결재작업처리</li>
					<li style="">결재진행내역</li>
					<li style="">윅플로우변경이력</li>
				</ul>
				<div id="approval_application_processing" >
					<table style="margin-left: 10px; margin-top:8px;" >
						<tr>
							<td align="right">제목</td>
							<td>
								<input type="text" id="e_approval_title" name="">
							</td>
						</tr>
						<tr>
							<td align="right">결재자</td>
							<td>
								<input type="text" id="e_approval_user" name="">
								<button type="button" id="btn_approval_userSearch"><img class="btn-img-small" src="images/button_image/search.png" style="max-width: 100%; height: auto;"></button>
							</td>
						</tr>
						<tr>
							<td align="right">결재경로</td>
							<td style="display: flex;">
								<div id="gr_approval_apprpath" style="flex:3;"></div>
								<div style="margin-left:2px; text-align:right; flex:1;">
									<input type="button" id="btn_approval_appr" value="결재신청">
									<button type="button" id="btn_approval_erase" ><img class="btn-img-small" src="images/button_image/delete1.png" style="max-width: 100%; height: auto;"></button>
									<button type="button" id="btn_approval_up" ><img class="btn-img-small" src="images/button_image/arrow_up.png" style="max-width: 100%; height: auto;"></button>
									<button type="button" id="btn_approval_down" ><img class="btn-img-small" src="images/button_image/arrow_down.png" style="max-width: 100%; height: auto;"></button>
									
									<div id="radiogroup_approval">
			            				<button style="background-color: white; margin-right: 1em;" id="rb_approval_approval">결재</button>
			           					<button style="background-color: white; margin-right: 1em;" id="rb_approval_agreement" ">합의</button>
			           		 			<button style="background-color: white; margin-right: 1em;" id="rb_approval_notice">통보</button>
			            			</div>
		            			</div>
							</td>
						</tr>
						<tr>
							<td align="left"><div id='cb_approval_atttach' style="float: right; margin-right:-70px;">
			               				첨부</div>
			               	</td>
			               	<td>
			               		<div id="gr_approval_file"></div>
			               	</td>
						</tr>
						<tr>
							<td colspan="2" align="left"><div id='cb_approval_autonotify' style='margin-top:4px; float: left;'>
			               				다음 프로세스 담당자 자동통보</div>
			               	</td>
						</tr>
						<tr>
							<td align="right">메모</td>
							<td><textarea id="tx_approval_memo" name="" style=" display:inline-block;"></textarea></td>
						</tr>
					</table>
				</div>
				<div id="approval_job_processing">
					<table style="margin-left: 10px; margin-top:8px;" >
						<tr>
							<td align="right">제목</td>
							<td>
								<input type="text" id="e_approval_title2" name="">
							</td>
						</tr>
						<tr>
							<td align="right">결재경로</td>
							<td style="display: flex;">
								<div id="gr_approval_apprpath2" style="flex:3;"></div>
							</td>
						</tr>
						<tr>
							<td align="right">메모</td>
							<td><textarea id="tx_approval_memo2" name="" style=" display:inline-block;"></textarea></td>
						</tr>
						<tr>
							<td colspan="2">
								<input type="button" id="btn_approval_approval" value="결재신청" style="flaot:right; font-color:red; font:red;">
								<div id="radiogroup_approval2" style="float:right;">
		            				<button style="float:right; background-color: white; margin-right: 1em;" id="rb_approval_decide">전결</button>
		           					<button style="float:right; background-color: white; margin-right: 1em;" id="rb_approval_approbation">승인</button>
		           		 			<button style="float:right; background-color: white; margin-right: 1em;" id="rb_approval_impossible">불가</button>
		            			</div>
			            	</td>
						</tr>
					</table>
				</div>
				<div id="approval_progress_history">
					<table style="margin-left: 10px; margin-top:8px;" >
						<tr>
							<td align="right">제목</td>
							<td>
								<input type="text" id="e_approval_title3" name="">
							</td>
						</tr>
						<tr>
							<td align="right">결재경로</td>
							<td style="display: flex;">
								<div id="gr_approval_apprpath3" style="flex:3;"></div>
							</td>
						</tr>
						<tr>
							<td align="right">메모</td>
							<td><textarea id="tx_approval_memo3" name="" style=" display:inline-block;"></textarea></td>
						</tr>
					</table>
				</div>
				<div id="approval_modification_history">
					<span style="margin-left:15px; margin-top:15px;">- 윅플로우를 포함한 전체 변경이력 -</span>
					<div id = "gr_workflow">
					
					</div>
				</div>
				
				<input type="hidden" id="e_approval_apprstatus"/>
			</div>

		</div>
	</div>
 </div><!-- End f_approval winm -->
 
 
 <!-- user List div -->
<div id="userlist_winm" style="max-width:100%; height:auto; margin: -2px; display:none;">
	<div>
		<!-- Main Div -->
		<div id="userlist_main_cond" style="border:1px solid lightgray;">	
			<div id = "gr_userlist">
			</div>
			<input type="button" id="btn_userlist_add" value="추가" style="margin-top:5px; margin-right:5px; float:right;">
		</div>
	</div>
</div>
 
 