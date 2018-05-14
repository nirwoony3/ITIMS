<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="cmm/jstl.jsp"%>
<%@ include file="cmm/loginSession.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<title>DETAIL</title>
<%@ include file="cmm/jqwidgets.jsp"%>
<%@ include file="cmm/msg.jsp"%>
<%@ include file="cmm/normal.jsp"%>
<%@ include file="F_FIND.jsp"%>
<%@ include file="F_FILEATTACH.jsp"%>
<%@ include file="F_APPROVAL.jsp"%>

<style type="text/css">
.jqx-tabs-title{width: auto;} 
#detail_progress { position:relative; width: 77%; height: 17px; border: 1px solid #ddd; border-radius: 3px; overflow: hidden; display:inline-block; margin:0px 10px 5px 5px; }
#detail_bar { background-color: #64c657; width:0%; height:20px; border-radius: 3px; }
#detail_percent { position:absolute; display:inline-block; top:3px; left:48%; }
/* .jqx-tabs-content-element{background-color: white;}  */
</style>

<script type="text/javascript">
window.focus();
window.onresize = funLoad; //local function to resize window

var tabsItem = opener.tabsItem;
var detailtabsItem = 0;
var docdbname = opener.docdbname;
var subdbname = opener.subdbname;
var selectedVaultNo = opener.selectedVaultNo;
var selectedDocno = opener.selectedDocno;
var selectedDocname = "";
var doubleSubmitFlag = false;
var option = opener.option;
var docappstatus = "";
var tabslength = [];
var filebtnIdNo = 0;
var fileObjectList = new Array();
var radioValue = "open";
var clickedItemList = new Array();
var createdDocno = "";
 
$(document).ready(function() {
	clickedItemList.push("formId0");

	window.onload = function(){
			 //tabsItem = opener.tabsItem;
			 //docdbname = opener.docdbname;
			 //subdbname = opener.subdbname;
			 //selectedVaultNo = opener.selectedVaultNo;

			 //option = opener.option;   //create update 구분
			 filebtnIdNo = 0;
			 
			 console.log("tabsItem : " + tabsItem)
			 if(tabsItem == 1){
				 $("#txtname").text("발의제목");
				 $("#txtno").text("발의번호");
			 }else if(tabsItem != 1){
				 $("#txtname").text("기술자료제목");
				 $("#txtno").text("자료번호");
			 }
			 
			 $("#num").jqxInput({
					height : 25,
					width : '97%', 
					minLength : 1,
					disabled: true,
					theme:theme
			});
			 
			 $("#e_filename").jqxInput({
					height : 25,
					width : '74%', 
					minLength : 1,
					disabled: true,
					theme:theme
			});
			 
			
			 if(option == "create"){
			    //			
			 }else if(option == "update"){
				 
				var rowindex = opener.$('#mainlist').jqxGrid('getselectedrowindex'); //get parent object
				var datas = opener.$('#mainlist').jqxGrid('getrowdata', rowindex);
				var docno = datas.DOCNO;

				$.ajax({//D_DOCDB 데이터 갖고오기
					url : "getDocdb.do",
					type : "POST",
					dataType : "json",
					async: false,
					data : {"dbname" : docdbname,"docno":docno},
					success : function(data, status,XHR){
						
						console.log(data.docdb[0].docappstatus);
						docappstatus = data.docdb[0].docappstatus;
						$("#e_approval_apprstatus").val(docappstatus);  // F_APPROVAL apprstatus insert value
						$("#combo_doing").jqxDropDownList("val", docappstatus);
						$("#title").val(data.docdb[0].docdesc);
						$("#bal_num").val(data.docdb[0].docname);
						$("#size").val(data.docdb[0].docfilesize);
						$("#num").val(data.docdb[0].docno);
						$("#e_filename").val(data.docdb[0].docfilename);
						createdDocno = data.docdb[0].docno;
						
					},
					error : function(data, status){
					},
					complete : function(){
					}
				});				
		  		 
				$.ajax({
					dataType:"json",
					url : "getFileAttach.do",
			  		type: "POST",
			  		data :{"docno":docno},
					beforeSend : function(){
					},
					success : function(data, status,XHR){

						var btnid = ""
		        		 for(var i = 0; i < data.fileAttachVoList.length; i++){	
							filebtnIdNo++;
							
							var btnid = "btn_attachfile"+filebtnIdNo;
			        		 
			        		 var exts = getExtensionOfFilename(data.fileAttachVoList[i].filename); 
			        		 var src = getImgsrcOfExtension(exts);

			        		 var html = "<button id='"+btnid+"' title='"+data.fileAttachVoList[i].filename+"'>";
			        		 html += "<img class='btn-img'"
			        		 html += " src="+src+" alt='xx'></button>";

							$("#div_btnfile").append(html);	  
							
							
							$("#"+btnid).jqxButton({ 
								width: 20, 
								height: 20, 
								theme:theme
							});
							$("#"+btnid).css("margin-left", "5px");
							var filestatus = ["", data.fileAttachVoList[i].filename, "server", ""];
							fileObjectList.push(filestatus);
							
							$(document).on("click","#"+btnid+"",function(){ 

								
								var fileName = $(this).attr('title');
								var filePath = "D://pwmStr//AttachFile";
								
								
								if(radioValue == "delete"){        // delete
									$("#"+$(this).attr('id')+"").css( "display", "none" );
									console.log(fileName);
									for (var j = 0; j < fileObjectList.length; j++) {
										if(fileObjectList[j][1] == fileName){
											console.log("같은 파일명있다");
											fileObjectList[j][3] = "Y";
											//fileObjectList.splice(i, 1);
										}else{
											console.log("같은 파일명 없다");
										}
									}
								}else{                            // open
									//location.href="fileOpen.do?f="+fileName+"&of="+fileName+"&filePath="+filePath;
									fileOpen(fileName, filePath)
								}
							});
						 }	
						//filebtnIdNo = data.fileAttachVoList.length;
					},
					error : function(data, status){
						console.log("Ajax 실패");
					},
					complete : function(){
						 $('#jqxLoader').jqxLoader('close'); 
					}
				});	
			  }
    		// getD_SUBDB100.do , getD_SUBDBE100E.do, getD_SUBDBE200.do
    			console.log("clickedItemList");
    			console.log(clickedItemList);
			 for(var i =0; i < clickedItemList.length; i++){
					var formid = clickedItemList[i];
					var tablename = $("#"+formid).attr('value');
					
					var vaultlNo = selectedVaultNo;

					 $.ajax({
						url : "getD_SUBDB.do",
						type : "POST",
						dataType : "json",
						data : {"docno":docno, "vaultlno":vaultlNo, "tablename":tablename},
						success : function(data, status,XHR){	
							
							//console.log($("#"+formid).serializeArray());
							var formArray = $("#"+formid).serializeArray();
							
							if(data.D_SUBDB.length != 0){
								var id_by_name = "", idSplit = "", colname = "", colvalue = "", colvalueSplit="";
								var name_value = "";

								Object.keys(data.D_SUBDB[0]).forEach(function(v, i){

									for(var i =0; i<formArray.length; i++){
										name_value = formArray[i].name;
										id_by_name = $('[name="'+name_value+'"]').attr('id');
										if(name_value.includes("CK_")){
											idSplit = id_by_name.split("_");
											colname = idSplit[1].toUpperCase();
											colvalue = data.D_SUBDB[0][colname.toString()];
											
											if(colvalue != undefined){
												colvalueSplit= colvalue.split("|");
												for(var j =0; j<colvalueSplit.length; j++){
													id_by_name = $('[name="'+"CK_"+colvalueSplit[j]+'"]').attr('id');
		
													$("#"+id_by_name).jqxCheckBox({checked: true});
												}
											}
										}else if(id_by_name.includes("rb_")){
											$('input:radio[name="'+name_value+'"]').filter('[value="'+data.D_SUBDB[0][name_value.toUpperCase()]+'"]').attr('checked', true);
										}else if(id_by_name.includes("cb_")){
											$("#"+id_by_name).jqxDropDownList('val', data.D_SUBDB[0][name_value.toUpperCase()]);	
										}else if(id_by_name.includes("dt_")){
											$("#"+id_by_name).jqxDateTimeInput('setDate', data.D_SUBDB[0][v.toString()]); 
										}
										else if(name_value.toUpperCase() == v.toString()){
											$("#"+id_by_name).val(data.D_SUBDB[0][v.toString()]);
										}
									}
								});

							}else{
								var dom2 = document.forms[formid].elements["docno"]; 
								var dom3 = document.forms[formid].elements["vaultlno"]; 
								var docnoId = $(dom2).attr('id');
								var vaultlnoId = $(dom3).attr('id');

								$("#"+docnoId).val(docno);
								$("#"+vaultlnoId).val(vaultlNo);
							}
						},
						error : function(data, status){
						},
						complete : function(){
						}
					});
				}	
		};
	
	//$("#rbtn_open").jqxRadioButton({checked: true});
	$("#sys_head").jqxMenu({ width: '100%', height: 30, theme:theme });
	$("#main_cond").jqxPanel({ width: '100%',rtl:true, height:120, theme:theme});
	$("#panel_btn2").jqxPanel({ width: '100%',rtl:true, height:24, theme:theme});
	$("#panel_btnfile").jqxPanel({ width: '100%', height:20, theme:theme});	
	
	$("#title").jqxInput({ height : 25, width : '99%', minLength : 1, theme:theme });
	$("#bal_num").jqxInput({ height : 25, width : 215, minLength : 1, theme:theme });	
	$("#working").jqxInput({ height : 25, width : 55, minLength : 1, theme:theme });
	$("#name").jqxInput({ height : 25, width : 100, minLength : 1, disabled: true, theme:theme });
	$("#team").jqxInput({ height : 25, width : 100, minLength : 1, disabled: true, theme:theme });
	$("#ver").jqxInput({ height : 25, width : 100, minLength : 1, disabled: true, theme:theme });
	$("#size").jqxInput({ height : 25, width : 100, minLength : 1, disabled: true, theme:theme });
	
	// Create a jqxComboBox
	document.getElementById("combo_doing").readOnly = true;

	// Create a jqxComboBox
	$("#combo_attch").jqxDropDownList({
		source : {
			"*" : "*",
			"1" : "1",
			"2" : "2"
		},
		selectedIndex : 0,
		width : '170',
		height : '25px',
		autoDropDownHeight: true,
		theme:theme
	});

	//Create Checkbox
	$("#chkbox_pass").jqxCheckBox({
		width : 70,
		height : 20,
		theme:theme
	});
	$("#chkbox_back").jqxCheckBox({
		width : 70,
		height : 20,
		theme:theme
	});
	$("#chkbox_drop").jqxCheckBox({
		width : 70,
		height : 20,
		theme:theme
	});
	
	//Create Button jqwidgets

	
	$("#btn_fileadd").jqxButton({ 
		width: 45, 
		height: 23, 
		theme:theme
	});

	$("#btn1").jqxButton({ 
		width: 50, 
		height: 25, 
		
		textImageRelation: "imageBeforeText", 
		textPosition: "left", 
		theme:theme
		});
	
	$("#btn2").jqxButton({ 
		width: 50, 
		height: 25, 
		textImageRelation: "imageBeforeText", 
		textPosition: "left", 
		theme:theme
		});
	$("#btn3").jqxButton({ 
		width: 50, 
		height: 25, 
		textImageRelation: "imageBeforeText", 
		textPosition: "left", 
		theme:theme
		});
	
	$("#btn4").jqxButton({ 
		width: 50, 
		height: 25, 
		textImageRelation: "imageBeforeText", 
		textPosition: "left", 
		theme:theme
		});
	
	$("#btn_detail_memo").jqxButton({ 
		width: 45, 
		height: 23, 
		theme:theme
		});
	
	$("#btn_detail_save").jqxButton({ 
		width: 50, 
		height: 23, 
		theme:theme
		});
	$("#btn_detail_close").jqxButton({ 
		width: 50, 
		height: 23, 
		theme:theme
		});
	$("#btn_detail_flowter").jqxButton({ 
		width: 50, 
		height: 23, 
		theme:theme
		});
	$("#btn_detail_wo").jqxButton({ 
		width: 50, 
		height: 23, 
		theme:theme
		});
	$("#btn_detail_app").jqxButton({ 
		width: 50, 
		height: 23, 
		theme:theme
		});
	$("#btn_basicopen").jqxButton({ 
		width: 20, 
		height: 20, 
		theme:theme
		});
	$("#btn_processprint").jqxButton({ 
		width: 20, 
		height: 20, 
		theme:theme
		});
	$("#btn_explorer").jqxButton({ 
		width: 20, 
		height: 20, 
		theme:theme
		});
	$("#btn_serverfind").jqxButton({ 
		width: 20, 
		height: 20, 
		theme:theme
		});
	$("#btn_localattach").jqxButton({ 
		width: 20, 
		height: 20, 
		theme:theme
		});
	$("#btn_attachlist").jqxButton({ 
		width: 20, 
		height: 20, 
		theme:theme
		});

	$("#rbtn_gr2").jqxButtonGroup({ mode: 'radio', theme:theme});
	
	
	$("#rbtn_open").jqxRadioButton({width:60, height:18 , theme:theme }); 
	$("#rbtn_delete").jqxRadioButton({width:70, height:18, theme:theme  }); 
	
	$("#rbtn_open").jqxRadioButton({checked: true});
	/* ------- 현재 페이지로 넘어올시의 Ajax (데이터 갖고오기) ------- */
	
	
	$.ajax({
		url : "getDocapprstatus.do",
		type : "POST",
		dataType : "json",
		success : function(data, status,XHR){
			var source = [];
			for (var i = 0; i < data.docapprstatus.length; i++) {
				source.push(data.docapprstatus[i].wfstate);
			}
			$("#combo_doing").jqxDropDownList({
				source : source,
				selectedIndex : 0,
				width : '150',
				height : '25px',
				enableSelection:true,
				animationType: 'none',
				autoDropDownHeight: true,
				theme : theme
			});
			if(option == "update"){
				
				
			}
		},
		error : function(data, status){
		},
		complete : function(){
		}
	});
	
	var doccreatorname = '${loginInfo.username}';//요청자 이름
	var doccreator = "<c:out value='${loginInfo.userno}'/>";
	var doccreatordeptname = '${loginInfo.userdeptname}';//요청자 부서명 
	
	$("#name").val(doccreatorname+"("+doccreator+")");
	$("#team").val(doccreatordeptname);
	$("#ver").val(0);
	var wfdesc = new Array();
	//Create Loader
	$("#jqxLoader").jqxLoader({ width: 100, height: 60, imagePosition: 'top' });
	

	 $.ajax({
		url : "getdocno.do",
		type : "POST",
		dataType : "json",
		data : {"dbname" : docdbname},
		async: false,
		success : function(data, status,XHR){
			$("#num").val(data.docno);
			createdDocno = data.docno;
		},
		error : function(data, status){
		},
		complete : function(){
		}
	});

	
	//db에서 값 가져와 오브젝트 만들어주기
	$.ajax({
			url : "detailAction.do",
			type : "POST",
			dataType : "json",
			data : {"vaultlNo" : opener.selectedVaultNo, "subdbname" : opener.subdbname},
			async : false,
			beforeSend : function(){
				$('#jqxLoader').jqxLoader('open');
			},
			success : function(data, status,XHR){
				console.log(data);
				console.log(tabsItem);

				
				var source = [];
				// ---------- <ul></ul> 태그 영역 html (텝 메뉴) ---------------
				var htmlStr = "<ul>"
				
				if(tabsItem != 1){
					if(option == "create"){
						for(var i = 0; i < 1; i++){https://www.youtube.com/watch?v=eYhDDOeeanE
							// ----- Jqwidgets 의  Source 함수를 이용하기 위한 코드
							/* source.push({label: data.WorkFlowVo[i].wfstate, id: data.WorkFlowVo[i].wfdesc, value: data.WorkFlowVo[i].wfstate }); */
							htmlStr += "<li  id='wfstate" + i +  "' value="+data.WorkFlowVo[i].wfdesc+">"+data.WorkFlowVo[i].wfstate+"</li>";
							wfdesc.push(data.WorkFlowVo[i].wfdesc);
							
							//tabs 갯수만큼 false	
							if(i == 0){
								tabslength.push(true);
							}else{
								tabslength.push(false);
							}
						};
					}else{
						for(var i = 0; i < data.WorkFlowVo.length; i++){https://www.youtube.com/watch?v=eYhDDOeeanE
							console.log("wfdesc : " + data.WorkFlowVo[i].wfdesc+ " / wfstate : " + data.WorkFlowVo[i].wfstate);
							console.log(data);
							// ----- Jqwidgets 의  Source 함수를 이용하기 위한 코드
							/* source.push({label: data.WorkFlowVo[i].wfstate, id: data.WorkFlowVo[i].wfdesc, value: data.WorkFlowVo[i].wfstate }); */
							htmlStr += "<li  id='wfstate" + i +  "' value="+data.WorkFlowVo[i].wfdesc+">"+data.WorkFlowVo[i].wfstate+"</li>";
							wfdesc.push(data.WorkFlowVo[i].wfdesc);
							
							//tabs 갯수만큼 false	
							if(i == 0){
								tabslength.push(true);
							}else{
								tabslength.push(false);
							}
						};
					}
					
					htmlStr += "</ul>";
					
					// ---------- 텝에 해당하는 각 <div></div>의 html 영역 -----------
					for(var i = 0; i < data.WorkFlowVo.length; i++){
						htmlStr += "<div id='wfdesc"+ i +"'>";
						htmlStr += "<div id='wfdesc" + i + "Scroll'></div>";
						htmlStr += "</div>";
					}
				}else if(tabsItem == 1){
					for(var i = 0; i < data.WorkFlowVo.length; i++){
						/* console.log("wfdesc : " + data.WorkFlowVo[i].wfstate + " / wfstate : " + data.WorkFlowVo[i].wfdesc); */
						// ----- Jqwidgets 의  Source 함수를 이용하기 위한 코드
						/* source.push({label: data.WorkFlowVo[i].wfstate, id: data.WorkFlowVo[i].wfdesc, value: data.WorkFlowVo[i].wfstate }); */
						htmlStr += "<li  id='wfstate" + i +  "'>" + data.WorkFlowVo[i].wfstate + "</li>";
						wfdesc.push(data.WorkFlowVo[i].wfdesc);
						
						if(i == 0){
							tabslength.push(true);
						}else{
							tabslength.push(false);
						}
					};
					htmlStr += "</ul>";
					
					// ---------- 텝에 해당하는 각 <div></div>의 html 영역 -----------
					for(var i = 0; i < data.WorkFlowVo.length; i++){
						htmlStr += "<div id='wfdesc"+ i +"'>";
						htmlStr += "<div id='wfdesc" + i + "Scroll'></div>";
						htmlStr += "</div>";
					}
				}
				
				/* for(var i = 0; i < data.WorkFlowVo.length; i++){
					htmlStr += "<li  id='wfstate" + i +  "'>" + data.WorkFlowVo[i].wfstate + "</li>";
					wfdesc.push(data.WorkFlowVo[i].wfdesc);
				};
				htmlStr += "</ul>";
				
				// ---------- 텝에 해당하는 각 <div></div>의 html 영역 -----------
				for(var i = 0; i < data.WorkFlowVo.length; i++){
					htmlStr += "<div id='wfdesc"+ i +"'>";
					htmlStr += "<div id='wfdesc" + i + "Scroll'></div>";
					htmlStr += "</div>";
				} */
				
				// ---------- jqxTabs에 htmlStr에 저장된 정보 적용
				document.getElementById('jqxTabs').innerHTML = htmlStr; 
				//Create Tabs Widgets
				$('#jqxTabs').jqxTabs({ width: '100%',  position: 'top', height:375, theme:theme });
				//$('#jqxTabs').jqxTabs({ width: '100%',  position: 'top',  autoHeight: true });
				
				//Create Scroll Widgets in the division
				/* for(var i = 0; i < data.WorkFlowVo.length; i++){
					$("#wfdesc" + i + "Scroll").jqxScrollBar({ width: '100%', height: 475, max: 475,vertical: true });
				}  */ 

				/* 
				 	첫 tab에 해당되는 데이터를 html에 뿌려주는 공통 함수 호출 
				 	data.D_TableVo : 텝에 해당되는 데이터를 갖고있는 변수 
				 	data.D_ColItemVo : 각 컴포넌트 값을 갖고있는 변수
				 	0 : 첫번째 텝의 item값이 '0' 이므로  '0' 을 보내줌
				 	wfdesc[0] : 각종 컴포넌트의 id의 중복을 막기위한 각 텝의 DB값 
				*/
				htmlWrite(data.D_TableVo,data.D_ColItemVo,0,wfdesc[0]);
				
			},
			error : function(data, status){
				console.log("Ajax 실패");
			},
			complete : function(){
				 $('#jqxLoader').jqxLoader('close'); 
			}
		});
	
	// -------- 텝 메뉴 Click 시 Script
	$("#jqxTabs").on('tabclick', function (event) {
		var clickedItem = event.args.item; 
		
		var rtn = contains(clickedItemList, "formId" + clickedItem + "");
		if(rtn == -1){clickedItemList.push("formId" + clickedItem + "");} //리스트에 저장안되있다면 클릭한 탭 저장

		var param = wfdesc[clickedItem];
		
		var rowindex = opener.$('#mainlist').jqxGrid('getselectedrowindex');
		var datas = opener.$('#mainlist').jqxGrid('getrowdata', rowindex);
		var docno = datas.DOCNO;
		
		if(!tabslength[clickedItem]){
			$.ajax({
				url : "tabAction.do",
				type : "POST",
				dataType : "json",
				data : {"param" : param },
				beforeSend : function(){
					$('#jqxLoader').jqxLoader('open');
				},
				async: false,
				success : function(data, status,XHR){
					/* 
				 	첫 tab에 해당되는 데이터를 html에 뿌려주는 공통 함수 호출 
				 	data.D_TableVo : 텝에 해당되는 데이터를 갖고있는 변수 
				 	data.D_ColItemVo : 각 컴포넌트 값을 갖고있는 변수
				 	clickedItem : 텝의 아이템(번호) 변수
				 	wfdesc[0] : 각종 컴포넌트의 id의 중복을 막기위한 각 텝의 DB값 
					*/
					htmlWrite(data.D_TableVo,data.D_ColItemVo,clickedItem,param);

					var formid = "formId" + clickedItem;
					var tablename = $("#"+formid).attr('value');
					
					var vaultlNo = selectedVaultNo;

					 $.ajax({
						url : "getD_SUBDB.do",
						type : "POST",
						dataType : "json",
						data : {"docno":docno, "vaultlno":vaultlNo, "tablename":tablename},
						success : function(data, status,XHR){	

							
							var formArray = $("#"+formid).serializeArray();
							
							if(data.D_SUBDB.length != 0){
								var id_by_name = "", idSplit = "", colname = "", colvalue = "", colvalueSplit="";
								var name = "";

								Object.keys(data.D_SUBDB[0]).forEach(function(v, i){

									for(var i =0; i<formArray.length; i++){
										name = formArray[i].name;
										id_by_name = $('[name="'+name+'"]').attr('id');
										if(name.includes("CK_")){
											idSplit = id_by_name.split("_");
											colname = idSplit[1].toUpperCase();
											colvalue = data.D_SUBDB[0][colname.toString()];
											
											if(colvalue != undefined){
												colvalueSplit= colvalue.split("|");
												for(var j =0; j<colvalueSplit.length; j++){
													id_by_name = $('[name="'+"CK_"+colvalueSplit[j]+'"]').attr('id');
													$("#"+id_by_name).jqxCheckBox({checked: true});
												}
											}
										}else if(id_by_name.includes("rb_")){
											$('input:radio[name="'+name+'"]').filter('[value="'+data.D_SUBDB[0][name.toUpperCase()]+'"]').attr('checked', true);
										}else if(id_by_name.includes("cb_")){
											$("#"+id_by_name).jqxDropDownList('val', data.D_SUBDB[0][name.toUpperCase()]);	
										}else if(id_by_name.includes("dt_")){
											$("#"+id_by_name).jqxDateTimeInput('setDate', data.D_SUBDB[0][v.toString()]); 
										}
										else if(name.toUpperCase() == v.toString()){
											var dom = document.forms[formid].elements[name]; 
											id_by_name = $(dom).attr('id')
											//var id_by_name = $('[name="'+Split[i]+'"]').attr('id');
											console.log("idbyname : " + id_by_name)
											$("#"+id_by_name).val(data.D_SUBDB[0][v.toString()]);
										}
									}
								});

							}else{
								var dom2 = document.forms[formid].elements["docno"]; 
								var dom3 = document.forms[formid].elements["vaultlno"]; 
								var docnoId = $(dom2).attr('id');
								var vaultlnoId = $(dom3).attr('id');

								$("#"+docnoId).val(docno);
								$("#"+vaultlnoId).val(vaultlNo);
							}
							
// 								console.log(data);
// 								if(data.D_SUBDB.length != 0){
// 									var formArray = $("#"+formid).serializeArray();
// 									var value = "";
// 									var name = "";
// 									Object.keys(data.D_SUBDB[0]).forEach(function(v, i){
// 										for(var i =0; i< formArray.length; i++){
// 											name = formArray[i].name;
// 											if(name.toUpperCase() == v.toString()){
// 												var dom = document.forms[formid].elements[name]; 
// 												var id_by_name = $(dom).attr('id')
// 												//var id_by_name = $('[name="'+Split[i]+'"]').attr('id');
// 												console.log("idbyname : " + id_by_name)
// 												$("#"+id_by_name).val(data.D_SUBDB[0][v.toString()]);
// 											}
// 										}
// 									})
								
// 								}else{
// 									var dom2 = document.forms[formid].elements["docno"]; 
// 									var dom3 = document.forms[formid].elements["vaultlno"]; 
// 									var docnoId = $(dom2).attr('id');
// 									var vaultlnoId = $(dom3).attr('id');

// 									$("#"+docnoId).val(docno);
// 									$("#"+vaultlnoId).val(vaultlNo);
// 								}
						},
						error : function(data, status){
						},
						complete : function(){
						}
					});
					
				},
				error : function(data, status){
					msg1("관리자에게 문의하세요.");
				},
				complete : function(){
					 $('#jqxLoader').jqxLoader('close');
					// ---------- jqxTabs에 htmlStr에 저장된 정보 적용
					tabslength[clickedItem] = true;
				}
			});
		 }
     }); 
	

	//# Set Timer to bottom_time div
	 var timerid;			 
	function timerstart(){ timerid = setInterval(timer1,1000); } //var timerstart = function() {
	function timerstop(){ setTimeout(function() { clearInterval(timerid); }, 1000); }
	function timer1(){
	   var d = new Date();
	   var s = leadingZeros(d.getFullYear(), 4) + '-' + leadingZeros(d.getMonth() + 1, 2) + '-' + leadingZeros(d.getDate(), 2) + ' ' +
		       leadingZeros(d.getHours(), 2) + ':' + leadingZeros(d.getMinutes(), 2) + ':' + leadingZeros(d.getSeconds(), 2);
	   //var d = new Date(); var t = d.toLocaleTimeString(); console.log(t);
	   $("#bottom_time").text("Now : "+ s);
	}			
	function leadingZeros(n, digits){ //var leadingZeros = function (n, digits) { 
	  var zero = '';
	  n = n.toString();
	  if (n.length < digits) { 
		 for (i = 0; i < digits - n.length; i++) { zero += '0'; }
	  }
	  return zero + n;
	}
	timerstart();
	
	/*  */
	
	$("#btn_basicopen").on('click',function(){  //파일명 미아
		
		var index = opener.$("#mainlist").jqxGrid('getselectedrowindex');
	    var rowData = opener.$("#mainlist").jqxGrid('getrowdata', index);
	    selectedDocno = $("#num").val();

	    console.log(selectedDocno + "/"+ selectedVaultNo+"/"+rowData.DOCFILENAME)
		docOpen(selectedDocno, selectedVaultNo, rowData.DOCFILENAME);
	});
	
	$('#btn_serverfind').on('click',function(){ 
// 			var leftm = (screen.width/2)-(1500/2);
// 		    var topm = (screen.height/2)-(650/2);
// 			window.open('f_find.do',"F_Find", "width=1280, height=622,resizable = no, top=" + topm + ", left=" + leftm + ",scrollbars=no");
		$("#find_winm").jqxWindow("move", $(window).width() / 2 - $("#find_winm").jqxWindow("width") / 2, $(window).height() / 2 - $("#find_winm").jqxWindow("height") / 2);
        $("#find_winm").jqxWindow({width: 920, height: 507, title: "ServerFind - 서버파일첨부",theme:theme, maxWidth: 1300, resizable: true,  isModal: true, autoOpen: false /*modalOpacity: 0.01*/ });
        $("#find_winm").jqxWindow('show');
	});
	
	$('#btn_attachlist').on('click',function(){ 
		selectedDocno = $("#num").val();
		selectedDocname = $("#bal_num").val();
		
		var params = {"docno" : selectedDocno};
		getFileAttach(params);
		
// 			var leftm = (screen.width/2)-(1500/2);
// 		    var topm = (screen.height/2)-(650/2);
// 			window.open('f_fileattach.do',"F_Filaattach", "width=1280, height=582,resizable = no, top=" + topm + ", left=" + leftm + ",scrollbars=no");

		$("#fileattach_winm").jqxWindow("move", $(window).width() / 2 - $("#fileattach_winm").jqxWindow("width") / 2, $(window).height() / 2 - $("#fileattach_winm").jqxWindow("height") / 2);
        $("#fileattach_winm").jqxWindow({width: 920, height: 485, title: "AttachList - 첨부파일리스트",theme:theme, maxWidth: 1300, resizable: true,  isModal: true, autoOpen: false /*modalOpacity: 0.01*/ });
        $("#fileattach_winm").jqxWindow('show');
		});
	
	$('#btn_detail_close').on('click',function(){ 
		window.close();
	});

	$('#btn_detail_save').on('click',function(){ 
		
	    var docdesc = $("#title").val();//자료제목
		var docname = $("#bal_num").val();
		var docno = $("#num").val(); //자료번호
		var docfilename = $("#btn_filename").val(); //파일
			 $("#working").val(); //working
// 			var doccreatorname = '${loginInfo.username}';//요청자 이름
// 			var doccreator = "<c:out value='${loginInfo.userno}'/>";
// 			var doccreatordeptname = '${loginInfo.userdeptname}';//요청자 부서명
// 			var docno = $("#num").val();//자료번호
		var docversion = $("#ver").val();
		var docfilesize = $("#size").val();
		var docgrade  =$("#combo_attch").val();//자료참고
		var docappstatus = $("#combo_doing").val();//윜플로우진행
		var text = "";
		var rtntext ="";
		$('.notnull').each(function(){ 
		  text = $(this).val(); 
		 
		  if(text == ""){rtntext = $(this).attr('title');	return false;}
		});
		if(text == ""){msg1( rtntext+ " 값은 필수값입니다");	return;}
		

		if(option == "create"){    // 생성
			
			// insert subdb  sql 작성!
			
		//	var formid = clickedItemList[i];
			var formid = "formId0";
			var sql = getInsertSqlByFormId(formid);
			// insert subdb   sql 생성완료
			
			// 상세정보 insert
			var rtncode1 = false;
			var rtncode2 = false;
			var rtncode3 = false;
			var rtnmsg1 = "";
			var rtnmsg2 = "";
			var rtnmsg3 = "";


			var fd = new FormData();
        	fd.append('vaultlno', selectedVaultNo);
        	fd.append('docdesc', docdesc);
        	fd.append('dbname', docdbname);
        	fd.append('docno', docno);
        	fd.append('docgrade', docgrade);
        	fd.append('docappstatus', docappstatus);
        	fd.append('sql', sql);

        	var files = document.getElementById("btn_filename").files;
        	for (var i = 0; i < files.length; i++) {
          		var datarow = {};
          		var fileName = files[i].name;
				
				fd.append('file', files[i]);	
			}	
        	

     		for(var i =0; i<fileObjectList.length; i++){
     			if((fileObjectList[i][2]=="local" && fileObjectList[i][3]!="Y")){ // local 파일에 delflag != Y 인것 인설트
     				fd.append('attach_localFile', fileObjectList[i][0]);
     			}
     			if(fileObjectList[i][2]=="find" && fileObjectList[i][3]!="Y"){
     				fd.append('attach_findfile', fileObjectList[i][1]+"|"+fileObjectList[i][4]);
     			}
     			//create 는 서버파일 없음
     		}

        	
        	 $.ajax({               //docdb insert
				 dataType:"json",
				 url : "insertDetail.do",
		  		 type: "POST",
		  		 contentType:false,
		  		 processData: false,
		  		 cache: false,
		    	 data: fd,
		    	 xhr: function()
		    		{
		    			myXhr = $.ajaxSettings.xhr();
		    	        if (myXhr.upload)
		    	        {
		        	        myXhr.upload.addEventListener('progress', function(ev){
		        	        	if (ev.lengthComputable) {
		        	        		$('#detail_progress').show();       	        				   	        		
		        		            var percentComplete = Math.round((ev.loaded / ev.total) * 100);	
		        		            
		        		            $('#detail_percent').text(percentComplete + '%'); 
		        		            $('#detail_bar').css('width', percentComplete+'%');
				        
		        		        }
		        	        }, false);
		        	        myXhr.upload.addEventListener('load', function(ev){
		    	            	//업로드 완료시
		    	       		}, false);
		    	        }
		    	        return myXhr;
		    		},						    	
		    	success : function(data, textStatus) {	
		    		rtncode1 = data.rtncode;
		    		rtnmsg1 = data.rtnmsg;
		    		if(data.rtncode){
		    			msgWindowRelaod("입력되었습니다.");
		    			
		    			//window.close();
		    		}else{
		    			msg1(data.rtnmsg);
		    		}
		    		opener.$("#mainlist").jqxGrid('updatebounddata');
		    	},
				error : function(textStatus, errorThrown) {

				},
				complete : function(){
					$('#detail_percent').text(''); 
		            $('#detail_bar').css('width', 0+'%');
				}
			});
        	 
        	 
		}else if(option == "update"){
			
			//url = "detailupdate.do";
			var formid = "";
			var sql = "";
			console.log(clickedItemList);
			console.log($("#"+clickedItemList));
			console.log($("#"+clickedItemList)[0].length);
			
			var fd = new FormData();
			
			for(var i = 0; i < clickedItemList.length; i++){
				formid = clickedItemList[i];
				var tablename = $("#"+formid).attr('value');
				
				var param = {'tablename': tablename, 'docno': docno, 'vaultlno':selectedVaultNo};
				console.log(param);
				
				$.ajax({
 					url : "getCountSubdb.do",
 					type : "POST",
 					dataType : "json",
 					data : param,
 					async: false,
 					success : function(data, status,XHR){
 						
 						if(data.count[0].COUNT > 0){
 							sql = getUpdateSqlByFormId(formid);
 						}else{
 							sql = getInsertSqlByFormId(formid);
 						}
 						console.log(data.count[0].COUNT);
 						fd.append('sql', sql);
 					},
 					error : function(data, status){
 					},
 					complete : function(){
 					}
 				});
			}
			
        	fd.append('vaultlno', selectedVaultNo);
        	fd.append('docdesc', docdesc);
        	fd.append('dbname', docdbname);
        	fd.append('docno', docno);
        	fd.append('docgrade', docgrade);
        	fd.append('docappstatus', docappstatus);
        	

        	var files = document.getElementById("btn_filename").files;
        	for (var i = 0; i < files.length; i++) {
          		var datarow = {};
          		var fileName = files[i].name;
				
				fd.append('file', files[i]);	
			}	
        	

     		for(var i =0; i<fileObjectList.length; i++){
     			if((fileObjectList[i][2]=="local" && fileObjectList[i][3]!="Y")){ // local 파일에 delflag != Y 인것 인설트
     				fd.append('attach_localFile', fileObjectList[i][0]);
     			}
     			if(fileObjectList[i][2]=="find" && fileObjectList[i][3]!="Y"){
     				fd.append('attach_findfile', fileObjectList[i][1]+"|"+fileObjectList[i][4]);
     			}
     			if(fileObjectList[i][2]=="server" && fileObjectList[i][3]=="Y"){ //server 파일에 delflag == Y 인것 파일삭제, db삭제
     				fd.append('delete_serverfile', fileObjectList[i][1]);
     			}
     		}
     		

        	
        	 $.ajax({               //docdb insert
				 dataType:"json",
				 url : "updateDetail.do",
		  		 type: "POST",
		  		 contentType:false,
		  		 processData: false,
		  		 cache: false,
		    	 data: fd,
		    	 xhr: function()
		    		{
		    			myXhr = $.ajaxSettings.xhr();
		    	        if (myXhr.upload)
		    	        {
		        	        myXhr.upload.addEventListener('progress', function(ev){
		        	        	if (ev.lengthComputable) {
		        	        		$('#detail_progress').show();       	        				   	        		
		        		            var percentComplete = Math.round((ev.loaded / ev.total) * 100);	
		        		            
		        		            $('#detail_percent').text(percentComplete + '%'); 
		        		            $('#detail_bar').css('width', percentComplete+'%');
				        
		        		        }
		        	        }, false);
		        	        myXhr.upload.addEventListener('load', function(ev){
		    	            	//업로드 완료시
		    	       		}, false);
		    	        }
		    	        return myXhr;
		    		},						    	
		    	success : function(data, textStatus) {	
		    		rtncode1 = data.rtncode;
		    		rtnmsg1 = data.rtnmsg;
		    		if(data.rtncode){
		    			msgWindowRelaod("수정되었습니다.");
		    		}else{
		    			msg1(data.rtnmsg);
		    		}
		    		opener.$("#mainlist").jqxGrid('updatebounddata');
		    	},
				error : function(textStatus, errorThrown) {

				},
				complete : function(){
					$('#detail_percent').text(''); 
 		            $('#detail_bar').css('width', 0+'%');
				}
			});
        	 
			
			
			//insertFileAttach(docno, fileObjectList); // 파일어태치 삽입, docno, 파일리스트
		}
			
// 					$.ajax({
// 						url : url,
// 						type : "POST",
// 						dataType : "json",
// 						traditional: true,
// 						data : params,
// 						success : function(data, status,XHR){
// 							//msg1(data.msg);
// 						},
// 						error : function(data, status){
// 						},
// 						complete : function(){
// 							//doubleSubmitFlag = false;
// 						}
// 					});
			
	});
	
	
	
///// 드래그앤드랍
	 var objDragAndDrop = $("#panel_btnfile");
     
	 $(document).on("dragenter","#panel_btnfile",function(e){
         e.stopPropagation();
         e.preventDefault();
         $(this).css('border', '2px solid #0B85A1');
     });
     $(document).on("dragover","#panel_btnfile",function(e){
         e.stopPropagation();
         e.preventDefault();
         
     });
     $(document).on("drop","#panel_btnfile",function(e){
    	 objDragAndDrop.css('border', '');
         e.preventDefault();
         var files = e.originalEvent.dataTransfer.files;
		 var checkFileName = true;  // 파일명 중복체크 중복시 버튼생성x

         if(files.length > 500){
        	 msg1("파일 드래그 등록시 최대 500개 입니다.<br>현재선택한 파일 개수 : "+ (files.length));
         }else{
        	 for (var i = 0; i < files.length; i++) {
        		 for(var j = 0; j < fileObjectList.length; j++){  // 파일명 중복체크
        			if(files[i].name == fileObjectList[j][1]){
        				checkFileName = false;
        			}
        		 }
        		 if(!checkFileName){
        			msg1(files[i].name + "은 이미 있습니다.");
        			 continue;
        		 }
        		 filebtnIdNo++;
        		 var btnid = "btn_attachfile"+filebtnIdNo;
        		// var html = "<button id='"+btnid+"' value='"+files[i].name+"'><img class='btn-img' src='images/administrator.png' alt='xx'></button>";
        		 
        		 var exts = getExtensionOfFilename(files[i].name); 
        		 var src = getImgsrcOfExtension(exts);

        		 var html = "<button id='"+btnid+"' title='"+files[i].name+"'>";
        		 html += "<img class='btn-img'"
        		 html += " src="+src+" alt='xx'></button>";
				$("#div_btnfile").append(html);	  
				
				
				$("#"+btnid).jqxButton({ 
					width: 20, 
					height: 20, 
				});
				$("#"+btnid).css("margin-left", "5px");
				var filestatus = [files[i], files[i].name, "local", ""];
				fileObjectList.push(filestatus);
				
				$(document).on("click","#"+btnid+"",function(){ 

					
					var fileName = $(this).attr('title');
					var filePath = "D://pwmStr//AttachFile";
					
					//console.log(fileName);
					console.log(radioValue);
					
					if(radioValue == "delete"){        // delete
						$("#"+$(this).attr('id')+"").css( "display", "none" );
						for (var i = 0; i < fileObjectList.length; i++) {
							if(fileObjectList[i][1] == fileName){
								fileObjectList[i][3] = "Y";
								//fileObjectList.splice(i, 1);
							}
						}
					}else{                            // open
						//location.href="fileOpen.do?f="+fileName+"&of="+fileName+"&filePath="+filePath;
						fileOpen2(files[i]);
					}
					 console.log(fileObjectList);
				});

			 }	
			 console.log(fileObjectList);

         } 
     });
       
     $(document).on('dragenter', function (e){
         e.stopPropagation();
         e.preventDefault();

     });
     $(document).on('dragover', function (e){
       e.stopPropagation();
       e.preventDefault();
       objDragAndDrop.css('border', '');

     });
     $(document).on('drop', function (e){
         e.stopPropagation();
         e.preventDefault();
     });
     
     $('#rbtn_open').on('checked', function (event) { // Some code here. 
   		  radioValue = "open";
     	  console.log(radioValue);
   	  }); 
   	  $('#rbtn_delete').on('checked', function (event) { // Some code here. 
   		  radioValue = "delete";
   		  console.log(radioValue);
   	  });
   	  
   	$('#btn_fileadd').on('click',function(){ 
		 $("#btn_filename").click();
	});
   	
	$('#btn_detail_app').on('click',function(){ 
		$("#approval_winm").jqxWindow("move", $(window).width() / 2 - $("#approval_winm").jqxWindow("width") / 2, $(window).height() / 2 - $("#approval_winm").jqxWindow("height") / 2);
        $("#approval_winm").jqxWindow({width: 610, height: 534, title: "approval", resizable: true,theme:theme,  isModal: false, autoOpen: false /*modalOpacity: 0.01*/ });
        $("#approval_winm").jqxWindow('show');
        
        
        approvalOnload(); // F_APPROVAL.JSP
	});

}); // End Ready Function



function htmlWrite(D_TableVo,D_ColItemVo,clickedItem,tab){
	console.log("tab ------ ");

	 var htmlStr = "";
	 htmlStr += "<div><form id='formId" + clickedItem + "' value='"+D_TableVo[0].tabname +"' enctype='multipart/form-data'><table style='width:100%;'>";  //<div id='wfdesc" + clickedItem + "Scroll'></div>
		// ---------- Create HTML ----------
		for(var i = 0; i < D_TableVo.length; i++){ 
			if(D_TableVo[i].colname.includes("DATE")){
				htmlStr += "<tr id= 'tr"+i+"_"+tab+"' style='height: 30px;'><td align='right' style='font-size: 11px; width: 8%;'>" + D_TableVo[i].dispname + "</td><td><div id='dt_"+ D_TableVo[i].colname +  "_" + tab + "' name='"+D_TableVo[i].colname.toLowerCase()+"' title='"+D_TableVo[i].dispname +"' value='"+selectedVaultNo +"' ></div></td></tr>";
			}
			else if(D_TableVo[i].colstyle == "NORMAL" || D_TableVo[i].colstyle == "" || D_TableVo[i].colstyle == null){

				if(D_TableVo[i].collen < 100)         //docno 와 vaultlnl 는 따로 줬음 update 일땐 가져온 데이터를 넣어주기때문에 뺌
					if(D_TableVo[i].colname.toLowerCase() == "vaultlno" && option != "update"){
						htmlStr += "<tr id= 'tr"+i+"_"+tab+"' style='height: 30px;'><td align='right' style='font-size: 11px; width: 8%;'>" + D_TableVo[i].dispname + "</td><td><input type='text' id='e_"+ D_TableVo[i].colname +  "_" + tab + "' name='"+D_TableVo[i].colname.toLowerCase()+"' title='"+D_TableVo[i].dispname +"' value='"+selectedVaultNo +"' ></td></tr>";
					}else if(D_TableVo[i].colname.toLowerCase() == "docno" && option != "update"){
						htmlStr += "<tr id= 'tr"+i+"_"+tab+"' style='height: 30px;'><td align='right' style='font-size: 11px; width: 8%;'>" + D_TableVo[i].dispname + "</td><td><input type='text' id='e_"+ D_TableVo[i].colname +  "_" + tab + "' name='"+D_TableVo[i].colname.toLowerCase()+"' title='"+D_TableVo[i].dispname +"' value='"+createdDocno +"'  ></td></tr>";
					}else{
						htmlStr += "<tr id= 'tr"+i+"_"+tab+"' style='height: 30px;'><td align='right' style='font-size: 11px; width: 8%;'>" + D_TableVo[i].dispname + "</td><td><input type='text' id='e_"+ D_TableVo[i].colname +  "_" + tab + "' name='"+D_TableVo[i].colname.toLowerCase()+"' title='"+D_TableVo[i].dispname +"'></td></tr>";
					}
				else
				htmlStr += "<tr id= 'tr"+i+"_"+tab+"' style='height: 50px;'><td align='right' style='font-size: 11px;'>" + D_TableVo[i].dispname + "</td><td><textarea  id='tx_"+ D_TableVo[i].colname +"_" + tab + "' name='"+D_TableVo[i].colname.toLowerCase()+"' title='"+D_TableVo[i].dispname +"' ></textarea></td></tr>";
				
// 					if(D_TableVo[i].colname.toLowerCase() == "docno"){
// 						$("#e_"+ D_TableVo[i].colname +  "_" + tab).val($("#num").val());
// 					}
// 					if(D_TableVo[i].colname.toLowerCase() == "vaultlno"){
// 						$("#e_"+ D_TableVo[i].colname +  "_" + tab).val(selectedVaultNo);
// 					}
			}
			else if(D_TableVo[i].colstyle == "COMBOBOX"){
				htmlStr += "<tr id= 'tr"+i+"_"+tab+"' style='height: 30px;'><td align='right' style='font-size: 11px;'>" + D_TableVo[i].dispname + "</td><td><div id='cb_"+ D_TableVo[i].colname + "_" + tab  + "' class='cb_cls' name='"+D_TableVo[i].colname.toLowerCase()+"' ></div></td></tr>";
			}else if(D_TableVo[i].colstyle == "RADIOBOX"){
				htmlStr += "<tr id= 'tr"+i+"_"+tab+"' style='height: 50px;'><td align='right' style='font-size: 11px;'>" + D_TableVo[i].dispname + "</td><td><div  id='rb_"+ D_TableVo[i].colname + "_" + tab + "'>";
				var radioCheckTrue = false;
				for(var j = 0; j < D_ColItemVo.length; j++){
					if(D_ColItemVo[j].colStyle == "RADIOBOX"){ 
						// htmlStr += "<div id='rb_" +(j+1) + "_" + tab + "' name='" + D_TableVo[i].colname +"' style='margin-right: 10px;'>" + D_ColItemVo[j].colItem + "</div>";  
						if(!radioCheckTrue){
							htmlStr += "<input type='radio' id='rb_" +(j+1) + "_" + tab + "' name='" + D_TableVo[i].colname + "' value='" + D_ColItemVo[j].colItem +"'checked ='checked' style='margin-right: 10px;'>";  
							radioCheckTrue = true;
						}else{
							htmlStr += "<input type='radio' id='rb_" +(j+1) + "_" + tab + "' name='" + D_TableVo[i].colname + "' value='" + D_ColItemVo[j].colItem +"' style='margin-right: 10px;'>";  
							
						}
						htmlStr += "<label for='rb_" +(j+1) + "_" + tab + "' style='margin-left: -5px; margin-right: 15px; color:black;'>"+D_ColItemVo[j].colItem+"</label>";
					} 

				} 
				htmlStr += "</div></td></tr>";
			}else if(D_TableVo[i].colstyle == "CHECKBOX"){
				htmlStr += "<tr id= 'tr"+i+"_"+tab+"' style='height: 50px;'><td align='right' style='font-size: 11px;'>" + D_TableVo[i].dispname + "</td><td><div  id='ck_"+ D_TableVo[i].colname + "_" + tab +"' name='"+D_TableVo[i].colname.toLowerCase()+"'>";
				for(var j = 0; j < D_ColItemVo.length; j++){
					if(D_ColItemVo[j].colStyle == "CHECKBOX"){ 
						htmlStr += "<div id='ck_" + D_ColItemVo[j].colName.toLowerCase() + "_" + D_ColItemVo[j].seqNo + "' name='CK_" + D_ColItemVo[j].colItem + "' style='float: left;' >"+D_ColItemVo[j].colItem+"</div>";
					} 
				}
				htmlStr += "</div></td></tr>";
			}

		}
		htmlStr += "</table></div>"
		//console.log(htmlStr);					
		// ---------- jqxTabs에 htmlStr에 저장된 정보 적용 ----------
		document.getElementById('wfdesc'+clickedItem+'Scroll').innerHTML = htmlStr; 
		
		// ---------- Create Jqwidgets ----------
		for(var i = 0; i < D_TableVo.length; i++){
			
			if(D_TableVo[i].colname.includes("DATE")){
				console.log(D_TableVo[i].colname);
				$("#dt_"+ D_TableVo[i].colname + "_" + tab).jqxDateTimeInput({formatString: "yyyyMMdd", width: '100px', height: '25px'});
				$("#dt_"+ D_TableVo[i].colname + "_" + tab).jqxDateTimeInput('setDate', getLastyear());  // getLastyear -> normal.jsp
			}
			else if(D_TableVo[i].colstyle == "NORMAL" || D_TableVo[i].colstyle == "" || D_TableVo[i].colstyle == null){					
				if(D_TableVo[i].collen < 100){ //100 밑으로는 input
					
					$("#e_"+ D_TableVo[i].colname + "_" + tab).jqxInput({
						placeHolder : "",
						height : 25,
						width : '97.5%',
						minLength : 1,
					});
				
					if(D_TableVo[i].colnotnull=="NOT NULL"){
						$("#e_"+ D_TableVo[i].colname + "_" + tab).attr("class","notnull");
					}
				}else{
					$("#tx_"+ D_TableVo[i].colname + "_" + tab).jqxTextArea({ placeHolder: '', height: 90, width: '98%', minLength: 1});
					if(D_TableVo[i].colnotnull=="NOT NULL"){
						$("#tx_"+ D_TableVo[i].colname + "_" + tab).attr("class","notnull");
					}
				}
				
				
			}else if(D_TableVo[i].colstyle == "COMBOBOX"){
				var source = [];
				for(var j = 0; j < D_ColItemVo.length; j++){
					
					if(D_TableVo[i].colname == D_ColItemVo[j].colName){
						//console.log(D_ColItemVo[j].colItem);
						source.push(D_ColItemVo[j].colItem);
					}
				}
				$("#cb_" + D_TableVo[i].colname+ "_" + tab).jqxDropDownList({
					source : source,
					selectedIndex : 0,
					width : '98%',
					height : '25px',
					autoDropDownHeight: true
				});
				
			}else if(D_TableVo[i].colstyle == "RADIOBOX"){
// 					var CheckRadioTrue = false;
// 					$("#rb_" + D_TableVo[i].colname + "_" + tab).jqxButtonGroup({ mode: 'default',  });
// 					for(var j = 0; j < D_ColItemVo.length; j++){
// 						 if(D_ColItemVo[j].colStyle == "RADIOBOX"){ 
// 							 if(!CheckRadioTrue){
// 								 $("#rb_"+(j+1) + "_" + tab).jqxRadioButton({width:75, checked: true }); 
// 								 CheckRadioTrue = true;
// 							 }else{
// 								 $("#rb_"+(j+1) + "_" + tab).jqxRadioButton({width:75}); 
// 							 }
// 						 } 
// 					}
			}else if(D_TableVo[i].colstyle == "CHECKBOX"){
				//$("#" + D_TableVo[i].colname + "_" + tab).jqxCheckBox({ mode: 'default',  });
				for(var j = 0; j < D_ColItemVo.length; j++){
					if(D_ColItemVo[j].colStyle == "CHECKBOX"){ 
						$("#ck_"+D_ColItemVo[j].colName.toLowerCase() + "_" + D_ColItemVo[j].seqNo).jqxCheckBox({width:150  }); 
						
						//"<div id='ck" + (j+1) + "_" + tab + "'>"
					 } 
				}
			}/* htmlStr += data.D_TableVo[i].dispname + " : " + data.D_TableVo[i].colstyle + " : " + data.D_TableVo[i].collen + " "; */
			
			if(D_TableVo[i].colnotnull=="NOT NULL"){
				$("#tr"+i+"_"+tab).attr("class","trnotnull");
			}
		}
}

function setFileSizeName(){
	var file = document.getElementById("btn_filename").files[0];
	var size = file.size;
	var name = file.name;
	$("#size").val(size);
	$("#e_filename").val(name);
}

function getInsertSqlByFormId(formid){
	var tablename = $("#"+formid).attr('value');
	
	var formData = new FormData($("#"+formid)[0]);
	
	var sql = "INSERT INTO "+
			tablename +"( ";

	var formArray = $("#"+formid).serializeArray();
	
	var ck_list = new Array(); //체크박스 id, value, name, colname 담는 리스트
	var ck_colnamelist = new Array(); //체크박스 콜네임리스트
	
	var colname = "";
	
	var name = "";
	var value = "";
	for(var i =0; i<formArray.length; i++){
		name = formArray[i].name.toUpperCase();
		if(name.includes("CK_")){
			var id_by_name = $('[name="'+name+'"]').attr('id');
			
			var idSplit = id_by_name.split("_");
			colname = idSplit[1].toUpperCase();
			
			ck_list.push({"colname":colname, "name": name,"id":id_by_name, "value":$("#"+id_by_name).val()});
			
			if(contains(ck_colnamelist, colname) ==  -1){ ck_colnamelist.push(colname); }
			
		}else{
			sql += name + ", ";
		}	
	}
	
	for (var i = 0; i < ck_colnamelist.length; i++) {
		sql += ck_colnamelist[i] + ", ";
	}

	sql = sql.substring(0, sql.length-2);
	sql += ") VALUES( ";
	
	for(var i =0; i<formArray.length; i++){
		name = formArray[i].name.toUpperCase();
		value = formArray[i].value;
		if(name.includes("CK_")){
			
		}else if(value.trim() == ''){
			sql += ""+null + ", ";
		}else{ sql += "'"+value + "', "; }	
	}
	

	for (var i = 0; i < ck_colnamelist.length; i++) {
		var colname = "";
		for (var j = 0; j < ck_list.length; j++) {
			if(ck_list[j].colname == ck_colnamelist[i] && ck_list[j].value){
				colname+= ck_list[j].name.replace("CK_", "") + "|";
			}
		}
		colname = colname.substring(0, colname.length-1);
		if(colname.trim() == ''){
			sql += ""+null + ", ";
		}else{ sql += "'"+colname + "', "; }	
	}
	
	sql = sql.substring(0, sql.length-2);
	sql += ")";
	
	console.log(sql);
	
	return sql;
// 		var serialize = $("#"+formid).serialize().toUpperCase();
// 		serialize = decodeURIComponent(serialize);
// 		console.log(serialize);
// 		//var serialize = decodeURLComponent((serialize+").replace
// 		var formSplit = serialize.split("&");
// 		var colname = "";
	
// 		var Split ="";
// 		var ck_list = new Array(); //체크박스 id, value, name, colname 담는 리스트
// 		var ck_colnamelist = new Array(); //체크박스 콜네임리스트
// 		for(var i =0; i<formSplit.length; i++){
// 			Split =  formSplit[i].split("=");
// 			if(Split[0].includes("CK_")){
// 				var id_by_name = $('[name="'+Split[0]+'"]').attr('id');
			
// 				var idSplit = id_by_name.split("_");
// 				colname = idSplit[1].toUpperCase();
			
// 				ck_list.push({"colname":colname, "name": Split[0],"id":id_by_name, "value":$("#"+id_by_name).val()});
			
// 				if(contains(ck_colnamelist, colname) ==  -1){ ck_colnamelist.push(colname); }
			
// 			}else{
// 				sql += Split[0] + ", ";
// 			}	
// 		}
// 		for (var i = 0; i < ck_colnamelist.length; i++) {
// 			sql += ck_colnamelist[i] + ", ";
// 		}
// 		console.log(ck_list)
// 		console.log(ck_colnamelist);
// 		sql = sql.substring(0, sql.length-2);
// 		sql += ") VALUES( ";
	

// 		for(var i =0; i<formSplit.length; i++){
// 			Split =  formSplit[i].split("=");
// 			if(Split[0].includes("CK_")){
			
// 			}else if(Split[1].trim() == ''){
// 				sql += ""+null + ", ";
// 			}else{ sql += "'"+Split[1] + "', "; }	
// 		}
	
// 		for (var i = 0; i < ck_colnamelist.length; i++) {
// 			var colname = "";
// 			for (var j = 0; j < ck_list.length; j++) {
// 				if(ck_list[j].colname == ck_colnamelist[i] && ck_list[j].value){
// 					colname+= ck_list[j].name.replace("CK_", "") + "|";
// 				}
// 			}
// 			colname = colname.substring(0, colname.length-1);
// 			if(colname.trim() == ''){
// 				sql += ""+null + ", ";
// 			}else{ sql += "'"+colname + "', "; }	
// 		}
	
// 		sql = sql.substring(0, sql.length-2);
// 		sql += ")";
	
// 		console.log(sql);
// 		return sql;
}

//1. serialize() -> &= split 해서씀 비효율적
//2. serializeArray() -> name 값과 value 값 object list 저장 효율적
function getUpdateSqlByFormId(formid){
	var tablename = $("#"+formid).attr('value');
	
	var formData = new FormData($("#"+formid)[0]);
	
	var sql = "UPDATE "+
			tablename +" SET ";
	
	var formArray = $("#"+formid).serializeArray();
	console.log(formArray);
	var name = "";
	var value = "";
	var Split = "";
	var where = new Array();
	var checkbox = new Array();
	var substring = "CK_"
	
	for(var i =0; i<formArray.length; i++){
		name = formArray[i].name.toUpperCase();
		value = formArray[i].value;

		if(name == "DOCNO" || name == "VAULTLNO"){
			where.push(name + "='" + value+"'");
		}else if(name.includes("CK_")){
			checkbox.push(name + "='" + value +"'");	
		}else{
			if(value.trim() == ''){
				sql += name + "=" + null + ", ";
			}else{ sql += name + "='" + value + "', "; }
		}
	}
	
	var checkboxstr = "";           // checkbox 값 생성
	var colname = "";
	for(var i =0; i<checkbox.length; i++){
		var checkboxSplit = checkbox[i].split("=");
		
		var id_by_name = $('[name="'+checkboxSplit[0]+'"]').attr('id');
		
		console.log($("#"+id_by_name).val());
		var idSplit = id_by_name.split("_");
		colname = idSplit[1].toUpperCase();
		
		if(checkboxSplit[1] ==  "'true'"){
			checkboxstr+= checkboxSplit[0].replace("CK_", "") + "|";
		}
	}
	
	console.log(checkbox);
	console.log(checkboxstr);
	if(checkbox.length > 0){
		if(checkboxstr.trim() == ''){
			checkboxstr += colname + "=" + null + ", ";
		}else{ checkboxstr= colname + " = '" +checkboxstr.substring(0, checkboxstr.length-1)+"', "; }
		
		 //checkbox 값 생성 끝
		sql+= checkboxstr
		console.log(checkboxstr);
	}

	sql = sql.substring(0, sql.length-2); //마지막 쉼표뺌
	sql += " WHERE "
	for(var i =0; i<where.length; i++){
		sql += where[i];
		if(i != where.length-1){ sql += " AND "; }
	}
	console.log(sql);
	
	return sql;

}



function fileSelect(){
	var files = document.getElementById("e_fileselect").files;
	console.log(files);
	
	var checkFileName = true;  // 파일명 중복체크 중복시 버튼생성x

    if(files.length > 500){
   	 msg1("파일 드래그 등록시 최대 500개 입니다.<br>현재선택한 파일 개수 : "+ (files.length));
    }else{
   	 for (var i = 0; i < files.length; i++) {
   		 for(var j = 0; j < fileObjectList.length; j++){  // 파일명 중복체크
   			if(files[i].name == fileObjectList[j][1]){
   				checkFileName = false;
   			}
   		 }
   		 if(!checkFileName){
   			msg1(files[i].name + "은 이미 있습니다.");
   			 continue;
   		 }
   		 filebtnIdNo++;
   		 var btnid = "btn_attachfile"+filebtnIdNo;
   		// var html = "<button id='"+btnid+"' value='"+files[i].name+"'><img class='btn-img' src='images/administrator.png' alt='xx'></button>";
   		 
   		 var exts = getExtensionOfFilename(files[i].name); 
   		 var src = getImgsrcOfExtension(exts);

   		 var html = "<button id='"+btnid+"' title='"+files[i].name+"'>";
   		 html += "<img class='btn-img'"
   		 html += " src="+src+" alt='xx'></button>";
			$("#div_btnfile").append(html);	  
			
			
			$("#"+btnid).jqxButton({ 
				width: 20, 
				height: 20, 
			});
			$("#"+btnid).css("margin-left", "5px");
			var filestatus = [files[i], files[i].name, "local", ""];
			fileObjectList.push(filestatus);
			
			$(document).on("click","#"+btnid+"",function(){ 

				
				var fileName = $(this).attr('title');
				var filePath = "D://pwmStr//AttachFile";
				
				if(radioValue == "delete"){        // delete
					$("#"+$(this).attr('id')+"").css( "display", "none" );
					for (var i = 0; i < fileObjectList.length; i++) {
						if(fileObjectList[i][1] == fileName){
							fileObjectList[i][3] = "Y";
							//fileObjectList.splice(i, 1);
						}
					}
				}else{                            // open
					//location.href="fileOpen.do?f="+fileName+"&of="+fileName+"&filePath="+filePath;
					fileOpen2(files[i]);
				}
			});

		 }	
    } 
}

function chooseFile() {
   $("#e_fileselect").click();
}


function funLoad(){
   var Cheight = $(window).height()-250;
   $('#jqxTabs').jqxTabs({height:Cheight });
}

</script>

</head>
<body>
 <div id="winm" style="max-width:100%; margin: -2px; ">
		<div id="sys_head">
			<div id="head_top" style="height: 27.5px; border-bottom: 1px solid lightgray; " >
				 <img alt="" src="images/usa.png" style="float: left; margin-top: 4px;"> 
				 <font style="font-size: 12px; float: left; margin-top: 5px; ">ITIMS - Design Technical Information Solution v1.0</font>
				 <font style="font-size: 12px; text-align: center; margin-right:50px; float:right; margin-top: 5px;">Now login: ${loginInfo.userno } ${loginInfo.username }</font> 
			</div><!-- head_top END -->
			
		</div> <!-- End sys_head  -->
		<!-- Main Div -->
		<div id="main_cond" style="border:1px solid lightgray;">
		   <form></form>	
			<table  style="width: 98%;" >
				<tr style="height: 20px;">
					  		<td style="font-size: 11px; width: 6%;" align='right' id="txtname" ></td>
							<td colspan="5" style="width: 20%"><input type="text" id="title"></td>
							<td style="font-size: 11px; width: 5%;" align='right' id="txtno"></td>
							<td style="width: 20%"><input type="text" id="bal_num"></td>
				</tr>
				<tr style="height: 20px; ">
					<td style="font-size: 11px; width: 6%;" align='right'>파일명</td>
					<td style="width: 20%">
					<input type="file" id="btn_filename" enctype="multipart/form-data" onchange="setFileSizeName();" style="display:none;" />
					<input type="button" id="btn_fileadd" value="선택" style="margin-top: 3px; margin-left:3px;  display: inline-block; float: left; ">
					<input type="text" id="e_filename" style="margin-left:5px;">
					<!-- <div id="jqxFileUpload" readonly="readonly"></div> -->
					<!-- <input type="file" id="filename" style="position: relative;"> -->
					<!-- <img alt="" src="images/btn/gray/folder.png" style="height: 21px; position: relative; margin-left: 5px;"> --></td>

					<td style="font-size: 11px; width: 7%;" align='right'>윅플로우진행</td>
					<td  style="width: 19%;">  
						<div id="combo_doing" class='cb_cls' style="width: 15%; float: left; "></div>
						<input type="button" id="btn1" value="버튼" style="margin-left: 5px; margin-top: 1px; width: 10%; float: left;">
					</td>
					<td>	
						<input type="text" style="margin-left:1px; width: 15%; float: left;" readonly="readonly" id="working"> 
					</td>
					<td>	
						<input type="button" id="btn2" value="버튼" style=" margin-top: 4px; width: 10%; display: inline-block; ">
						<input type="button" id="btn3" value="버튼" style="margin-left:5px; margin-top: 4px; width: 10%; display: inline-block;">
						<input type="button" id="btn4" value="버튼" style="margin-left:5px; margin-top: 4px; width: 10%; display: inline-block;">
					</td>
					
					<td style="font-size: 11px; width: 7%;" align='right'>요청자</td>
					<td><input type="text" id="name"><input type="text"
						id="team" style="margin-left: 5px; width: 10%;"></td>
				</tr>
				<tr style="height: 20px;">
					<td style="font-size: 11px; width: 6%;" align='right'>자료번호</td>
					<td style="width: 20%;"><input type="text" id="num"></td>
					<td style="font-size: 11px; width: 5%;" align='right'>윅플로우결재</td>
					<td><div id="chkbox_pass" style="display:inline-block; font-size: 11px;">PASS</div>
						<div id="chkbox_back" style="display:inline-block; font-size: 11px;">BACK</div>
						<div id="chkbox_drop" style="display:inline-block; font-size: 11px;">DROP</div></td>
					<td style="font-size: 11px; width: 5%;" align='right'>자료참고</td>
					<td><div id="combo_attch" class='cb_cls' style=""></div></td>
					<td style="font-size: 11px; width: 5%;" align='right'>Ver*Size</td>
					<td><input type="text" id="ver"> <input type="text"
						id="size"></td>
				</tr>
			</table>
		</div><!-- End main_cond  -->
		
		<div id='jqxTabs'></div>
		
		
		
		<div id="panel_btn2" style="margin-top: 5px; border: 0px; width: 100%; ">
			<div style="display: inline-block; border: 1px solid lightgray;  vertical-align: top;">
				<button id="btn_basicopen" title="open"><img class="btn-img" src="images/button_image/open.bmp"></button>
				<button id="btn_processprint"  title="processprint"><img class="btn-img" src="images/button_image/open.bmp"></button>
				<button id="btn_explorer" title="explorer"><img class="btn-img" src="images/button_image/13_html.bmp"></button>
				<button id="btn_serverfind" title="serverfind"><img class="btn-img" src="images/button_image/open.bmp"></button>
				<input type="file" multiple="multiple" id="e_fileselect" name="fileInput" onchange="fileSelect();" style="display:none;" />			
				<button id="btn_localattach" onclick="chooseFile();" title="localattach"><img class="btn-img" src="images/button_image/open.bmp"></button>
				<button id="btn_attachlist" title="attachlist"><img class="btn-img" src="images/button_image/open.bmp"></button>
			</div>
			<div style="height:20px;  display: inline-block; border: 1px solid lightgray; vertical-align: top;">
				<div id="rbtn_gr2">
				<input type="radio" id="rbtn_open" value="open">open
				<input type="radio" id="rbtn_delete" value="close">delete
				</div>
			</div>

			<input type="button" value="결재" id="btn_detail_app" style="float: right; margin-right:2px;">
			<input type="button" value="WO" id="btn_detail_wo" style="float: right; margin-right:2px;">
			<input type="button" value="플로터" id="btn_detail_flowter" style="float: right; margin-right:2px;">
			<input type="button" value="닫기" id="btn_detail_close" style="float: right; margin-right:2px;">
			<input type="button" value="저장" id="btn_detail_save" style="float: right; margin-right:2px;">
			<input type="button" value="메모" id="btn_detail_memo" style="float: right; margin-right:2px;">
		</div>
		<div id="panel_btnfile" style="overflow-y : auto;">
			<div id="div_btnfile"></div>
		</div> 
		
		
		<!--div style="width:100%; height:25px; display: inline-block; border: 1px solid lightgray; margin: -2px; margin-top: 5px;"-->
				
		
		<div id="bottom" style="max-width:100%; height:auto;  border: 1px solid lightgray; margin: -2px; margin-top: 5px;">　
				<div id="bottom_msg" style="width:auto; float: left;" >msg</div>
				<div id="detail_progress" style="float: left;">
					<div id="detail_bar"></div>
					<div id="detail_percent"></div>
				</div>
				<div id="bottom_time" style="width:auto; float: right; font-size: 14px">now</div>
		</div>
</div>

</body>
<div id="jqxLoader"></div>
</html>