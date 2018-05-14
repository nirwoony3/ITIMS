<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="cmm/jstl.jsp"%>
<%@ include file="cmm/loginSession.jsp"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>iTIMS:Main</title>
<%@ include file="cmm/jqwidgets.jsp"%>
<%@ include file="cmm/msg.jsp"%>
<%@ include file="cmm/normal.jsp"%>
<%@ include file="F_PGM.jsp"%>

<style type="text/css">

/* body { font-family:'Malgun Gothic'; font-size:10pt; } */

.jqx-tabs-title{height:15px; }
.jqx-grid-cell{border: 0px;} 

##progress { position:relative; width: 80%; height: 17px; border: 1px solid #ddd; border-radius: 3px; overflow: hidden; display:inline-block; margin:0px 10px 5px 5px; }       
#bar { background-color: #64c657; width:0%; height:20px; border-radius: 3px; }
#percent { position:absolute; display:inline-block; top:3px; left:48%; }

.jqx-tree-item-li {	margin-top : -3px; }

input[readonly] { background-color: #dddddd; }

/* .jqx-tabs-title-selected-top{background: white;} */
</style>

<script type="text/javascript">

window.onresize = funLoad;

var splitHeight;
var childFolder = "images/folder.png";
var childNoFolder = "images/folderOpen.png";
var tabsItem = 0;
var docdbname = "";
var subdbname = "";
var option = "";
var doubleSubmitFlag = false;
var pageNum = 1;
var selectedVaultNo = "";
var themaColor = "dark";

//
$(document).ready(function () {
	
	splitHeight = $(document).height() - 95; 

	//
    //var color2 = "linear-gradient(to bottom, rgba(255, 191, 122, 0.31), rgba(255, 197, 108, 0.75))";	
    var color2 = "linear-gradient(to bottom, rgba(255, 191, 122, 0.31), rgba(255, 197, 108, 0.75))";	
    //$('#btn_login').css('background',color2); 
	//$('#btn_close').css('background',color2);
	$(".button").css("background",color2); //use class
	$('.button').hover(
		function(){ $(this).css('background','linear-gradient(to bottom, #F3F9FD,#208AD0)'); },
		function(){ $(this).css('background',color2); }
	);

	//
	$("#sys_head").jqxPanel({ width: '100%', height: 55});
    $("#cb_main_newtype").jqxDropDownList({ source: ["iTIMS Korea","iTIMS English","iTIMS Japan"], selectedIndex: 0, width: '120', height: '15' ,autoDropDownHeight: true});
		
    //Head 우측 버튼 
    $("#btn_main_close").jqxButton({width: 60,	height: 20,	imgPosition: "center", imgSrc: "" ,});
    $("#btn_main_1").jqxButton({width: 20,	height: 20,	imgPosition: "center", imgSrc: "" ,});
    $("#btn_main_2").jqxButton({width: 20,	height: 20,	imgPosition: "center", imgSrc: "" ,});
    $("#btn_main_3").jqxButton({width: 20,	height: 20,	imgPosition: "center", imgSrc: "" ,});
    $("#btn_main_4").jqxButton({width: 20,	height: 20,	imgPosition: "center", imgSrc: "" ,});
    $("#btn_main_5").jqxButton({width: 20,	height: 20,	imgPosition: "center", imgSrc: "" ,});
    
    $('#mainSplitter').jqxSplitter({ width: '100%', height: splitHeight, theme:theme, panels: [{ size: '20%' }] });	
    $('#main_tab').jqxTabs({ width: '100%', height: splitHeight, position: 'top', theme : theme});  
    $("#menu_tv").jqxMenu({ width: '160px', height: '140px',  autoOpenPopup: false, mode: 'popup'});
    $("#menu_lv").jqxMenu({ width: '230px', height: '500px',  autoOpenPopup: false, mode: 'popup'});       	

	// edit div
	$("#e_edit_docno").jqxInput({ height : 25, width : 186, minLength : 1, });        	
	$("#e_edit_docname").jqxInput({ height : 25, width : 186, minLength : 1, });        	
	$("#e_edit_docdesc").jqxInput({ height : 25, width : 445, minLength : 1, });        	
	$("#e_edit_projectname").jqxInput({ height : 25, width : 445, minLength : 1, });        	
	$("#e_edit_histcontent").jqxTextArea({ placeHolder: '',	height: 90, width: 450, minLength: 1, });  

	$("#btn_edit_save").jqxButton({ width: 50, height: 23, });        	
	$("#btn_edit_cancel").jqxButton({ width: 50, height: 23, });	
        	
	$('#docsearch_main_tab').jqxTabs({ width: '100%', height: splitHeight, position: 'top', theme: theme});        	
	$('#docsearch_mainSplitter').jqxSplitter({ width: '100%', height: 228, theme:theme, panels: [{ size: '30%' }] });
		
	$("#docsearch_radiogroup").jqxButtonGroup({ mode: 'radio' });
    $("#rb_docsearch_all").jqxRadioButton();
    $("#rb_docsearch_selectvault_below").jqxRadioButton();
    $("#rb_docsearch_selectvault").jqxRadioButton(); 	
    $("#rb_docsearch_all").jqxRadioButton({checked: true});    
	 	
	$("#e_docsearch_docdesc").jqxInput({ height : 25, width : 200, minLength : 1, });	
    $("#e_docsearch_docname").jqxInput({ height : 25, width : 222, minLength : 1, });	
    $("#e_docsearch_filename").jqxInput({ height : 25, width : 200, minLength : 1, });	
	
	$("#e_docsearch_propdate1").jqxDateTimeInput({formatString: "yyyyMMdd", width: '100px', height: '25px'});
	$("#e_docsearch_propdate2").jqxDateTimeInput({formatString: "yyyyMMdd", width: '100px', height: '25px'});			
	$("#e_docsearch_propdate1").jqxDateTimeInput('setDate', getLastyear()); 			
	$("#e_docsearch_creator").jqxInput({ height : 25, width : 100, 	minLength : 1, });	
    $("#cb_docsearch_plantcode").jqxDropDownList({ source: ["iTIMS Korea","iTIMS English","iTIMS Japan"], selectedIndex: 0, width: 207 ,autoDropDownHeight: true});  		

	$("#btn_docsearch_gry").jqxButton({ width: 90, height: 25, });	
	$("#btn_docsearch_close").jqxButton({ width: 90, height: 25, });

	//test btn_main_5
	$("#btn_main_5").click(function(){
		//$('#vaultproperty').jqxWindow({ maxWidth: 1920, maxHeight: 1080 }); 
		//$('#vaultproperty').jqxWindow({ maxHeight: 1080 });

		var w = "99.8%"; //window.innerWidth-25; //document.body.clientwidth; /window.screen.availWidth; //$(window).width(); //screen.availWidth;  //window.innerWidth
	    var h = window.innerHeight-10; //$(document).height() - 95; //window.innerHeight-20; //document.body.clientheight; //window.screen.availHeight; //$(window).height(); //screen.avialHeight; //window.innerHeight

	    //var w1 = $(window).width();
        //var h1 = $(window).height();

		//$('#vaultproperty').jqxWindow({ maxWidth: w, maxHeight:h, width: w, height: h }); 
		//$('#vaultproperty').jqxWindow({ maxWidth: w, maxHeight:h, width: w, height: h, minWidth:65, minHeight:100 }); 
		//$('#vaultproperty').jqxWindow({ maxWidth: w, maxHeight:h, width: w, height: h, minWidth:65, minHeight:100 }); 
		$('#vaultproperty').jqxWindow({
		    height: h,
		    width: w,
		    minHeight: 100,
		    minWidth: 200,
		    maxHeight: screen.height,
		    maxWidth: screen.width,
		    isModal: true,
		    autoOpen: false,
		    resizable: true,
		    theme:theme,
		    modalOpacity: 0.01,
		    position:"center",
		    cancelButton: $("#CancelP")
		});

		//$("#vaultproperty").jqxWindow({ position:"center", resizable: false,  isModal: true, autoOpen: false, theme:theme, cancelButton: $("#CancelP"), modalOpacity: 0.01 });
		$("#vaultproperty").jqxWindow('show');
		//winmaximize();
	}); 
	$("#btn_main_4").click(function(){
		$("#pgm_winm").jqxWindow("move", $(window).width() / 2 - $("#pgm_winm").jqxWindow("width") / 2, $(window).height() / 2 - $("#pgm_winm").jqxWindow("height") / 2);
        $("#pgm_winm").jqxWindow({width: 610, height: 429, title: "iTims - manage user program list...", resizable: true,theme:theme,  isModal: false, autoOpen: false /*modalOpacity: 0.01*/ });
        $("#pgm_winm").jqxWindow('show');
        
        
        getPgmList();
		
	});

    //#event
    $("#btn_main_close").click(function(){
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

    $('#docsearch_tv_announce').on('expand', function (event) {	docsearch_treeExpandItem('#docsearch_tv_announce',event); });		
	$('#docsearch_tv_vault').on('expand', function (event) { docsearch_treeExpandItem('#docsearch_tv_vault',event); });		
	$('#docsearch_tv_summury').on('expand', function (event) { docsearch_treeExpandItem('#docsearch_tv_summury',event); });
	$('#docsearch_tv_query').on('expand', function (event) { docsearch_treeExpandItem('#docsearch_tv_query',event); });

    //
    $('#btn_docsearch_close').on('click',function(){ $("#docsearch_winm").jqxWindow('close'); });

	$('#btn_edit_save').on('click',function(){ 
		var projectname =$("#e_edit_projectname").val(), histcontent=$("#e_edit_histcontent").val();
		var docversion = $("#e_edit_docver").val(), docno = $("#e_edit_docno").val(),
		
		filename = $("#e_edit_filename").val(), filepath = $("#e_edit_filepath").val(),
		vaultlno = $("#e_edit_vaultlno").val(), dbname = $("#e_edit_dbname").val();
	
		var param = {"projectname":projectname, "histcontent":histcontent, "docno":docno, "docversion":docversion,
				     "docfilename" : filename, "filepath":filepath, "vaultlno":vaultlno, "dbname":dbname};

		var url = ""

		var checkOnly = $("#e_edit_checkOnly").val();
		console.log(checkOnly);

		if(checkOnly == "true") { 
			url = "insertHistoryOnly.do" }
		else {	
			url = "insertHistoryVersion.do"	}
		
		console.log(url);
		$.ajax({ url : url, type : "post", dataType : "json", data : param,
		    beforeSend : function(){ }, 
		    success : function(data, textStatus, jqXHR){	
			    if(!data.rtncode){
				    msg1(data.rtnmsg);
		        }else{
		    	    msg1("성공적으로 수정하였습니다.");
		    	    $("#edit_winm").jqxWindow('close');
		        }},
		    error : function(jqXHR, textStatus, errorThrown){ }
		});
	});			
	
	
	$('#btn_edit_cancel').on('click',function(){ 
		console.log("aa");
		var filename = $("#e_edit_filename").val(), filepath = $("#e_edit_filepath").val();	
		var param = {"filename" : filename, "filepath":filepath};

		$.ajax({ url : "cancelHistory.do", type : "post", dataType : "json", data : param,
			  beforeSend : function(){ }, 
			  success : function(data, textStatus, jqXHR){						
				console.log(data);
				if(!data.rtncode){
					msg1(data.rtnmsg);
			    }else{
			    	$("#edit_winm").jqxWindow('close');
			    }
			  },
			  error : function(jqXHR, textStatus, errorThrown){ }
		});
	});        	

	$('#btn_docsearch_gry').on('click',function(){ 
		var selectionRadio = $( "#docsearch_radiogroup" ).jqxButtonGroup('getSelection' );
		if(selectionRadio == undefined){ selectionRadio = 0;}
		
		var params = "";
		var docdesc =$("#e_docsearch_docdesc").val(), docname=$("#e_docsearch_docname").val(), docfilename=$("#e_docsearch_filename").val(),
		propdate1=$("#e_docsearch_propdate1").val(), propdate2=$("#e_docsearch_propdate2").val(), creator=$("#e_docsearch_creator").val();

		if(selectionRadio == 0){ // 0 : 전체 , 1: 하위폴더, 2: 선택폴더
			 params = {"docdesc":docdesc, "docname":docname, "docfilename":docfilename, "propdate1":propdate1,
						"propdate2":propdate2, "creator":creator, "pageNum":1, "docdbname":"D_DOCDB1" };
		}
		else if(selectionRadio == 1){
			var selectedTab =$("#docsearch_main_tab").jqxTabs('selectedItem');
			var tabTitle = $('#docsearch_main_tab').jqxTabs('getTitleAt', selectedTab).trim();
			var tabId = "docsearch_tv_"+tabTitle.toLowerCase();
			var selectedTree = $('#'+tabId).jqxTree('selectedItem');
			if(selectedTree == null){
				msg1("트리를 선택하세요"); return;
			}
			var vaultlno = selectedTree.value;
			var vaultnoSplit = vaultlno.split("-");
			var changeVaultlno = "";
			var vaultlevel = selectedTree.level+1;
			
			for (var i = 0; i < vaultlevel; i++) {
				changeVaultlno += vaultnoSplit[i];
				if(i != vaultlevel-1){ changeVaultlno+="-";	}
			}
			console.log("change Valutlno : " +changeVaultlno);
			
			params = {"docdesc":docdesc, "docname":docname, "docfilename":docfilename, "propdate1":propdate1,
						"propdate2":propdate2, "creator":creator, "pageNum":1, "docdbname":"D_DOCDB1",
						"vaultlNo":changeVaultlno};
		} else {
			var selectedTab =$("#docsearch_main_tab").jqxTabs('selectedItem');
			var tabTitle = $('#docsearch_main_tab').jqxTabs('getTitleAt', selectedTab).trim();
			var tabId = "docsearch_tv_"+tabTitle.toLowerCase();
			var selectedTree = $('#'+tabId).jqxTree('selectedItem');
			if(selectedTree == null){
				msg1("트리를 선택하세요"); return;
			}
			var vaultlno = selectedTree.value;
			console.log(vaultlno);
			params = {"docdesc":docdesc, "docname":docname, "docfilename":docfilename, "propdate1":propdate1,
					  "propdate2":propdate2, "creator":creator, "pageNum":1, "docdbname":"D_DOCDB1", "vaultlNo":vaultlno};
		}

	    console.log(selectionRadio);
	 	getDocdb1List(params);
	});	
	
    //first tab data in win open
	docsearch_treeData(0,'#docsearch_tv_announce'); //첫번째 Tree 데이터 갖고오기
	
	$('#docsearch_main_tab').on('tabclick', function (event) { 
		tabsItem = event.args.item; 
	    var tvArr = ['#docsearch_tv_announce','#docsearch_tv_summury','#docsearch_tv_vault','#docsearch_tv_query'];
	    
	    switch (tabsItem) {
		case 0:	//Announce
			treeData(0,tvArr[0]);
			break;
		case 1://Vault
			treeData(1,tvArr[1]);				
			break;
		case 2://Summury
			treeData(2,tvArr[2]);
			break;
		case 3://Query
			treeData(3,tvArr[3]);
			break;
		default:
			break;
		}
	});	

	// div end
   
    // initialize jqxGrid
    $("#mainlist").jqxGrid(
    {
        width: '100%', //1525
        height: splitHeight,
        pageable: false,
        sortable: true,
        altrows: true, //행 마다 색상구별
		editable: false,
        pageSize: 200,
        rowsheight: 22,
        enabletooltips: true,
        columnsresize: true,
		selectionmode:  'checkbox',
		enablebrowserselection : true,
		theme: theme,
        columns: [
            {text: '번호', datafield: 'RNUM', width:'5%'},
            {text: '기술자료명',datafield: 'DOCNAME',width:'15%'},
			{text: '기술자료제목',datafield: 'DOCDESC',width:'15%'},
			{text: '자료번호', datafield: 'DOCNO', width:'14%'},
			{text: '자료버전',  datafield: 'DOCVERSION',width:'10%'},
			{text: '자료타입',datafield: 'DOCTYPE',width:'10%', hidden: true},
			{text: '시스템파일이름', datafield: 'DOCZIPFILENAME',width:'10%', hidden: true},
			{text: '파일이름', datafield: 'DOCFILENAME',width:'20%'},
			{text: '파일타입',datafield: 'DOCFILETYPE',width:'10%'},
			{text: '파일사이즈',datafield: 'DOCFILESIZE',width:'10%'},
			{text: '최종버젼', datafield: 'DOCVERMAX',width:'10%'},
			{text: '오픈횟수',  datafield: 'DOCOPENCNT',width:'10%'},
			{text: '출력횟수', datafield: 'DOCPRINTCNT',width:'10%'},
			{text: '프로세스등록여부', datafield: 'DOCPROADD',width:'10%'},
			{text: '자료상태',  datafield: 'DOCSTATUS',width:'10%'},
			{text: '자료프로세스상태',  datafield: 'DOCAPPSTATUS',width:'10%'},
			{text: '집합번호',  datafield: 'DOCSETNO',width:'10%'},
			{text: '자료등급',  datafield: 'DOCGRADE',width:'10%', hidden: true},
			{align:'center',  text: '자료반송상태',  datafield: 'DOCRETURN',width:'10%', hidden: true},
			{text: '생성일',  datafield: 'DOCCREATED',width:'10%'},
			{align:'center',  text: '생성자ID',  datafield: 'DOCCREATOR',width:'10%'},
			{align:'center',  text: '생성자이름',  datafield: 'DOCCREATORNAME',width:'10%'},
			{text: '생성자부서코드',  datafield: 'DOCCREATORDEPTCODE',width:'10%', hidden: true},
			{text: '생성자부서이름',  datafield: 'DOCCREATORDEPTNAME',width:'10%'},
			{text: '수정일',  datafield: 'DOCUPDATED',width:'10%'},
			{align:'center',  text: '수정자ID',  datafield: 'DOCUPDATOR',width:'10%', hidden: true},
			{align:'center',  text: '수정자이름',  datafield: 'DOCUPDATORNAME',width:'10%'},
			{text: '수정자부서코드',  datafield: 'DOCUPDATORDEPTCODE',width:'10%', hidden: true},
			{text: '수정자부서이름',  datafield: 'DOCUPDATORDEPTNAME',width:'10%'},
			{text: '수정상태FLAG',  datafield: 'DOCUPDFLAG',width:'10%', hidden: true},
			{text: '결재지정자',  datafield: 'DOCAPPRID',width:'10%', hidden: true},
			{text: '분석대상여부',  datafield: 'DOCANALYZEKIND',width:'10%', hidden: true},
			{text: '분석일자',  datafield: 'DOCANALYZED',width:'10%', hidden: true},
			{text: '볼트NO',  datafield: 'VAULTLNO',width:'50%', hidden: true},
			{text: '볼트자료번호',  datafield: 'VLDOCNO',width:'65%', hidden: true}
        ],
    });
 
    cellclick($("#mainlist"));

    //# Set Timer to bottom_time div
	var timerid;			 
	function timerstart(){ timerid = setInterval(timer1,1000); } //var timerstart = function() {
	function timerstop(){ setTimeout(function() { clearInterval(timerid); }, 1000); }
	function timer1(){
	   var d = new Date();
	   var s = leadingZeros(d.getFullYear(), 4) + '-' + leadingZeros(d.getMonth() + 1, 2) + '-' + leadingZeros(d.getDate(), 2) + ' ' +
		       leadingZeros(d.getHours(), 2) + ':' + leadingZeros(d.getMinutes(), 2) + ':' + leadingZeros(d.getSeconds(), 2);
	   //var d = new Date(); var t = d.toLocaleTimeString(); //console.log(t);
	   $("#bottom_time").text("now : "+ s);
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
	
	treeData(0,'#tv_announce'); //첫번째 Tree 데이터 갖고오기
	
	//------------ 이벤트   -----------------------
	
	$('#main_tab').on('tabclick', function (event) { 
		tabsItem = event.args.item; 
		console.log("# tab cliented item => "+ tabsItem);
	    var tvArr = ['#tv_announce','#tv_summury','#tv_vault','#tv_query'];
	    
	    switch (tabsItem) {
		case 0:	//Announce
			treeData(0,tvArr[0]);
			break;
		case 1://Vault
			treeData(1,tvArr[1]);				
			break;
		case 2://Summury
			treeData(2,tvArr[2]);
			break;
		case 3://Query
			treeData(3,tvArr[3]);
			break;
		default:
			break;
		}
	});
	
	$('#tv_announce').on('expand', function (event) { treeExpandItem('#tv_announce',event); });		
	$('#tv_vault').on('expand', function (event) { treeExpandItem('#tv_vault',event); });		
	$('#tv_summury').on('expand', function (event) { treeExpandItem('#tv_summury',event); });
	$('#tv_query').on('expand', function (event) { treeExpandItem('#tv_query',event); });
	
	
	// ---------------- Tree 팝업  ---------------------
	$("#tv_announce").on('contextmenu', function (event) {
		var selectedItem = $('#tv_announce').jqxTree('selectedItem');
		if (selectedItem == null) {
			$("#menu_tv").jqxMenu('disable', 'Root Create', false);
			$("#menu_tv").jqxMenu('disable', 'Create', true);
			$("#menu_tv").jqxMenu('disable', 'Update', true);
			$("#menu_tv").jqxMenu('disable', 'Delete', true);
			$("#menu_tv").jqxMenu('disable', 'Property', true);
		} else {
			//$("#menu_tv").jqxMenu('disable', 'Root Create', true);
			$("#menu_tv").jqxMenu('disable', 'Create', false);
			$("#menu_tv").jqxMenu('disable', 'Update', false);
			$("#menu_tv").jqxMenu('disable', 'Delete', false);
			$("#menu_tv").jqxMenu('disable', 'Property', false);
		}
        var rightClick = isRightClick(event) || $.jqx.mobile.isTouchDevice();
        //console.log(rightClick);
        if (rightClick) {
            var scrollTop = $(window).scrollTop();
            var scrollLeft = $(window).scrollLeft();
            $("#menu_tv").jqxMenu('open', parseInt(event.clientX) + 5 + scrollLeft, parseInt(event.clientY) + 5 + scrollTop);
            return false;
        }
    });

	$("#tv_vault").on('contextmenu', function (event) {
		var selectedItem = $('#tv_vault').jqxTree('selectedItem');
		if (selectedItem == null) {
			$("#menu_tv").jqxMenu('disable', 'Root Create', false);
			$("#menu_tv").jqxMenu('disable', 'Create', true);
			$("#menu_tv").jqxMenu('disable', 'Update', true);
			$("#menu_tv").jqxMenu('disable', 'Delete', true);
			$("#menu_tv").jqxMenu('disable', 'Property', true);	
		} else {
			//$("#menu_tv").jqxMenu('disable', 'Root Create', true);
			$("#menu_tv").jqxMenu('disable', 'Create', false);
			$("#menu_tv").jqxMenu('disable', 'Update', false);
			$("#menu_tv").jqxMenu('disable', 'Delete', false);
			$("#menu_tv").jqxMenu('disable', 'Property', false);
		}
        var rightClick = isRightClick(event) || $.jqx.mobile.isTouchDevice();
        //console.log(rightClick);
        if (rightClick) {
            var scrollTop = $(window).scrollTop();
            var scrollLeft = $(window).scrollLeft();
            $("#menu_tv").jqxMenu('open', parseInt(event.clientX) + 5 + scrollLeft, parseInt(event.clientY) + 5 + scrollTop);
            return false;
        }
    });

	$("#tv_summury").on('contextmenu', function (event) {
		var selectedItem = $('#tv_summury').jqxTree('selectedItem');
		if (selectedItem == null) {
			$("#menu_tv").jqxMenu('disable', 'Root Create', false);
			$("#menu_tv").jqxMenu('disable', 'Create', true);
			$("#menu_tv").jqxMenu('disable', 'Update', true);
			$("#menu_tv").jqxMenu('disable', 'Delete', true);
			$("#menu_tv").jqxMenu('disable', 'Property', true);
		} else {
			//$("#menu_tv").jqxMenu('disable', 'Root Create', true);
			$("#menu_tv").jqxMenu('disable', 'Create', false);
			$("#menu_tv").jqxMenu('disable', 'Update', false);
			$("#menu_tv").jqxMenu('disable', 'Delete', false);
			$("#menu_tv").jqxMenu('disable', 'Property', false);
		}
        var rightClick = isRightClick(event) || $.jqx.mobile.isTouchDevice();
        //console.log(rightClick);
        if (rightClick) {
            var scrollTop = $(window).scrollTop();
            var scrollLeft = $(window).scrollLeft();
            $("#menu_tv").jqxMenu('open', parseInt(event.clientX) + 5 + scrollLeft, parseInt(event.clientY) + 5 + scrollTop);
            return false;
        }
    });
	
	$("#tv_query").on('contextmenu', function (event) {
		$("#menu_lv").jqxMenu('close');
		var selectedItem = $('#tv_query').jqxTree('selectedItem');
		if (selectedItem == null) {
			$("#menu_tv").jqxMenu('disable', 'Root Create', false);
			$("#menu_tv").jqxMenu('disable', 'Create', true);
			$("#menu_tv").jqxMenu('disable', 'Update', true);
			$("#menu_tv").jqxMenu('disable', 'Delete', true);
			$("#menu_tv").jqxMenu('disable', 'Property', true);
		} else {
			//$("#menu_tv").jqxMenu('disable', 'Root Create', true);
			$("#menu_tv").jqxMenu('disable', 'Create', false);
			$("#menu_tv").jqxMenu('disable', 'Update', false);
			$("#menu_tv").jqxMenu('disable', 'Delete', false);
			$("#menu_tv").jqxMenu('disable', 'Property', false);
		}
        var rightClick = isRightClick(event) || $.jqx.mobile.isTouchDevice();
        //console.log(rightClick);
        if (rightClick) {
            var scrollTop = $(window).scrollTop();
            var scrollLeft = $(window).scrollLeft();
            
            $("#menu_tv").jqxMenu('open', parseInt(event.clientX) + 5 + scrollLeft, parseInt(event.clientY) + 5 + scrollTop);
            return false;
        }
    });

    function isRightClick(event) { //search jquery event.which, 3:right click, 2:left click
        var rightclick;
        if (!event) var event = window.event;
        if (event.which) rightclick = (event.which == 3);  
        else if (event.button) rightclick = (event.button == 2);                 
        return rightclick;
    } 
	
    //폴더 클릭
	$("#tv_announce").on('itemClick', function (event) {
		var item = $('#tv_announce');
		//console.log(item.jqxTree('selectedItem')); //아이템 클릭한 JSON 데이터
		var id = item.jqxTree('selectedItem').id;
		selectedVaultNo = id;
		var selectedItem = item.jqxTree('selectedItem');		
		
		var ajaxData = $.ajax({
			  //root: "listView",  						
			  url : "getVaultlInfo.do",
			  type : "post",
			  dataType : "json",
			  data : {"vaultlNo" : id},
			  beforeSend : function(){
			  }, 
			  success : function(data, textStatus, jqXHR){
				  	  docdbname = data.vault.docdbName;
				 	  subdbname = data.vault.subdbName;
				 	  
				 	 var param = {"vaultlNo" : id,"pageNum":1, "docdbname":docdbname  };
				 	getDocdb1List(param);
			  },
			  error : function(jqXHR, textStatus, errorThrown){
					msg1("관리자에게 문의하세요");
			  }
		});
	}); 

	//폴더 클릭
	$("#tv_vault").on('itemClick', function (event) {
		var item = $('#tv_vault');
		//console.log(item.jqxTree('selectedItem')); //아이템 클릭한 JSON 데이터
		var id = item.jqxTree('selectedItem').id;
		selectedVaultNo = id;
		var selectedItem = item.jqxTree('selectedItem');
		
		console.log(id);
		
		var ajaxData = $.ajax({
			  //root: "listView",  						
			  url : "getVaultlInfo.do",
			  type : "post",
			  dataType : "json",
			  data : {"vaultlNo" : id},
			  beforeSend : function(){
			  }, 
			  success : function(data, textStatus, jqXHR){
				  	  docdbname = data.vault.docdbName;
				 	  subdbname = data.vault.subdbName;
				 	 var param = {"vaultlNo" : id,"pageNum":1, "docdbname":docdbname };
				 	 getDocdb1List(param);
			  },
			  error : function(jqXHR, textStatus, errorThrown){
					msg1("관리자에게 문의하세요");
			  }
		});
	});

	//폴더 클릭
	$("#tv_summery").on('itemClick', function (event) {
		var item = $('#tv_summery');
		//console.log(item.jqxTree('selectedItem')); //아이템 클릭한 JSON 데이터
		var id = item.jqxTree('selectedItem').id;
		selectedVaultNo = id;
			var selectedItem = item.jqxTree('selectedItem');
		
		var ajaxData = $.ajax({
			  //root: "listView",  						
			  url : "getVaultlInfo.do",
			  type : "post",
			  dataType : "json",
			  data : {"vaultlNo" : id},
			  beforeSend : function(){
			  }, 
			  success : function(data, textStatus, jqXHR){
				  	  docdbname = data.vault.docdbName;
				 	  subdbname = data.vault.subdbName;
				 	  
				 	 var param = {"vaultlNo" : id,"pageNum":1, "docdbname":docdbname };
				 	 getDocdb1List(param);	
			  },
			  error : function(jqXHR, textStatus, errorThrown){
					msg1("관리자에게 문의하세요");
			  }
		});				
	});

	//폴더 클릭
	$("#tv_query").on('itemClick', function (event) {
		var item = $('#tv_query');
		//console.log(item.jqxTree('selectedItem')); //아이템 클릭한 JSON 데이터
		var id = item.jqxTree('selectedItem').id;
		selectedVaultNo = id;
			var selectedItem = item.jqxTree('selectedItem');
		
		var ajaxData = $.ajax({
			  //root: "listView",  						
			  url : "getVaultlInfo.do",
			  type : "post",
			  dataType : "json",
			  data : {"vaultlNo" : id},
			  beforeSend : function(){
			  }, 
			  success : function(data, textStatus, jqXHR){
				  	  docdbname = data.vault.docdbName;
				 	  subdbname = data.vault.subdbName;
				 	  
				 	 var param = {"vaultlNo" : id,"pageNum":1, "docdbname":docdbname };
				 	getDocdb1List(param);
			  },
			  error : function(jqXHR, textStatus, errorThrown){
					msg1("관리자에게 문의하세요");
			  }
		});				
	});

    //--------- Tree 팝업 클리 이벤트   -------------
    $("#menu_tv").on('itemclick', function (event) {

		$('#msg_alert').empty(); // msg창 초기화
		var selectedItem;
		switch (tabsItem) {
		case 0:
			selectedItem = $('#tv_announce').jqxTree('selectedItem');
			break;
		case 1:
			selectedItem = $('#tv_summury').jqxTree('selectedItem');
			break;
		case 2:
			selectedItem = $('#tv_vault').jqxTree('selectedItem');
			break;
		case 3:
			selectedItem = $('#tv_query').jqxTree('selectedItem');
			break;
		default:
			break;
		}
		
		//console.log(selectedItem);
		
		var itemText = $(event.args).text();
		var element = event.args;
		switch (itemText) {
			//insert
			case "Root Create": //트리 루트 생성
			doubleSubmitFlag = false;
			var offset = $("#tv_announce").offset(); //offset: 객체의 속성 중 top 과 left 값을 반환, position: 부모 요소를 기준으로 한 상대적인 위치
        	$("#vaultrootcreate").jqxWindow({ position: { x: parseInt(offset.left) + 80, y: parseInt(offset.top) + 80} });
			$("#vaultrootcreate").jqxWindow({ width: 470, height:262, resizable: false,  isModal: true, autoOpen: false,  cancelButton: $("#CancelR"), modalOpacity: 0.01, theme:theme });
			$("#vaultrootcreate").jqxWindow('show');
			
			$("#vaultlName").jqxInput({placeHolder: "VaultlName", height: 25, width: 284,  });
			$("#vaultlDesc").jqxInput({placeHolder: "vaultlDesc", height: 25, width: 284,  });
			
			var source_cb1_Key = {"docdbName" : "DOC" };
			var source_cb1 = 
			{
				datatype: "json",
				data : source_cb1_Key,
				root: "listView",
				type: "post",
				datafields: [ { name: 'docname' } ],
				url: "columList.do",
				async: false,
			};

			//console.log(source_cb1);
			var dataAdapter_cb1 = new $.jqx.dataAdapter(source_cb1, {
				autoBind: true,
                beforeLoadComplete: function (records) {
					//console.log(records[0].docname.length);			                	
                    var data = new Array();
                    // update the loaded records. Dynamically add EmployeeName and EmployeeID fields. 
                    for (var i = 0; i < records[0].docname.length; i++) {
                        var docdbName = records[0].docname[i].docdbName;
                        data.push(docdbName);
                    }
                    return data;
                }							
			});
			//console.log(dataAdapter_cb1);
			var source_cb2_Key = { "subdbName" : "SUB" };
			var source_cb2 =
			{
				datatype: "json",
				data : source_cb2_Key,
				root: "listView",
				type: "post",
				datafields: [{ name: 'subname' }],
				url: "columList.do",
				async: false,
			};
			var dataAdapter_cb2 = new $.jqx.dataAdapter(source_cb2, {
                autoBind: true,
                beforeLoadComplete: function (records) {
					//console.log(records[0].subname.length);			                	
                    var data = new Array();
                    // update the loaded records. Dynamically add EmployeeName and EmployeeID fields. 
                    for (var i = 0; i < records[0].subname.length; i++) {
                        var subdbName = records[0].subname[i].subdbName;
                        data.push(subdbName);
                    }
                    return data;
                }								
			});					

			var source_cb3_Key = { "storageNo" : "STR" };
			var source_cb3 =
			{
				datatype: "json",
				type: "post",
				root: "listView",
				datafields: [ { name: 'storageno' } ],
				url: "columList.do",
				data: source_cb3_Key,
				async: false
			};
			var dataAdapter_cb3 = new $.jqx.dataAdapter(source_cb3, {
                autoBind: true,
                beforeLoadComplete: function (records) {
					//console.log(records[0].strNo.length);			                	
                    var data = new Array();
                    // update the loaded records. Dynamically add EmployeeName and EmployeeID fields. 
                    for (var i = 0; i < records[0].storageno.length; i++) {
                        var storageNo = records[0].storageno[i].storageNo;
                        data.push(storageNo);
                    }
                    return data;
                }								
			});	 
			
			// jqxcombobox
			$("#cb_docdbname").jqxDropDownList({ source: dataAdapter_cb1, selectedIndex: 0, width: '290px', height: '25px', autoDropDownHeight:true, theme: 'ui-lightness'});
			$('#cb_docdbname').bind('select', function (event) {
			});
			
			$("#cb_subdbname").jqxDropDownList({ source: dataAdapter_cb2, selectedIndex: 0, width: '290px', height: '25px', autoDropDownHeight:true, theme: 'ui-lightness'});
			$('#cb_subdbname').bind('select', function (event) {
			});


			//$("#cb_storageno").jqxComboBox({selectedIndex: 0, width: '270px', height: '25px', displayMember: 'storagedesc', valueMember: 'storageno' });
			$("#cb_storageno").jqxDropDownList({ source: dataAdapter_cb3, selectedIndex: 0, width: '290px', height: '25px', autoDropDownHeight:true, theme: 'ui-lightness'});

			$('#cb_storageno').bind('select', function (event) {
			});

			//$("#SaveR").jqxButton({ width: 120, height: 30, theme:themaColor, textImageRelation: "imageBeforeText", textPosition: "left", imgSrc: "/images/save.png" });
			//$('#CancelR').jqxButton({ width: 120, height: 30, theme:themaColor, textImageRelation: "imageBeforeText", textPosition: "left", imgSrc: "/images/cancel.png" });
			
			$("#SaveR").jqxButton({ width: 90, height: 26,  });
			$("#CancelR").jqxButton({ width: 90, height: 26, });
			
			break;
		case "Create": // 트리 생성
			doubleSubmitFlag = false;
			var label;
			var id;
			var offset;
			switch (tabsItem) {
			case 0:
				 label = $('#tv_announce').jqxTree('selectedItem').label;
				 id = $('#tv_announce').jqxTree('selectedItem').id;
				 offset = $("#tv_announce").offset();
				break;
			case 1:
				 label = $('#tv_summury').jqxTree('selectedItem').label;
				 id = $('#tv_summury').jqxTree('selectedItem').id;
				 offset = $("#tv_summury").offset();
				break;
			case 2:
				 label = $('#tv_vault').jqxTree('selectedItem').label;
				 id = $('#tv_vault').jqxTree('selectedItem').id;
				 offset = $("#tv_vault").offset();
				break;
			case 3:
				 label = $('#tv_query').jqxTree('selectedItem').label;
				 id = $('#tv_query').jqxTree('selectedItem').id;
				 offset = $("#tv_query").offset();
			break;
			default:
				break;
			}
			
			$("#vaultcreate").jqxWindow({ position: { x: parseInt(offset.left) + 80, y: parseInt(offset.top) + 80} });
			$("#vaultcreate").jqxWindow({ width: 470, height:294, resizable: false,  isModal: true, autoOpen: false, theme:theme, cancelButton: $("#CancelC"), modalOpacity: 0.01 });
			$("#vaultcreate").jqxWindow('show');
			
			$("#vaultlNamePC").jqxInput({placeHolder: "Parent VaultlName", height: 25, width: 265, theme:themaColor });
			$('#vaultlNamePC').val(label);
			
			$("#vaultlNameC").jqxInput({placeHolder: "VaultlName", height: 25, width: 265, theme:themaColor });
			$("#vaultlDescC").jqxInput({placeHolder: "vaultlDesc", height: 25, width: 265, theme:themaColor });
			
				var ajaxData = $.ajax({
					  //root: "listView",  						
				  url : "getVaultlInfo.do",
				  type : "post",
				  dataType : "json",
				  data : {"vaultlNo" : id},
					  beforeSend : function(){
				  }, 
				  success : function(data, textStatus, jqXHR){
						$("#cb_docdbnameC").jqxInput({ height: 25, width: 265, theme:themaColor });
						$('#cb_docdbnameC').val(data.vault.docdbName);
						
						$("#cb_subdbnameC").jqxInput({ height: 25, width: 265, theme:themaColor });
						$('#cb_subdbnameC').val(data.vault.subdbName);
						
						$("#cb_storagenoC").jqxInput({ height: 25, width: 265, theme:themaColor });
						$('#cb_storagenoC').val(data.vault.storageNo);	    						  
				  },
				  error : function(jqXHR, textStatus, errorThrown){
						alert("관리자에게 문의하세요");
				  }
				});
			 
			//$('#SaveC').jqxButton({ width: 120, height: 30, theme:'ui-sunny', textImageRelation: "imageBeforeText", textPosition: "left", imgSrc: "/images/save.png" });
			//$('#CancelC').jqxButton({ width: 120, height: 30, theme:'ui-sunny', textImageRelation: "imageBeforeText", textPosition: "left", imgSrc: "/images/cancel.png" });
			$("#SaveC").jqxButton({ width: 90, height: 26, theme:themaColor });
			$("#CancelC").jqxButton({ width: 90, height: 26, theme:themaColor });
			
			break;
		case "Update": // 트리 수정
			doubleSubmitFlag = false;
			var itemId;
			var itemLabel;
			var offset;
			switch (tabsItem) {
			case 0:
				 itemId = $('#tv_announce').jqxTree('selectedItem').id;
				 itemLabel = $('#tv_announce').jqxTree('selectedItem').label;
				 offset = $("#tv_announce").offset();
				break;
			case 1:
				 itemId = $('#tv_summury').jqxTree('selectedItem').id;
				 itemLabel = $('#tv_summury').jqxTree('selectedItem').label;
				 offset = $("#tv_summury").offset();
				break;
			case 2:
				 itemId = $('#tv_vault').jqxTree('selectedItem').id;
				 itemLabel = $('#tv_vault').jqxTree('selectedItem').label;
				 offset = $("#tv_vault").offset();
				break;
			case 3:
				 itemId = $('#tv_query').jqxTree('selectedItem').id;
				 itemLabel = $('#tv_query').jqxTree('selectedItem').label;
				 offset = $("#tv_query").offset();
			break;
			default:
				break;
			}
			//console.log(itemLabel);
			
			$("#vaultupdate").jqxWindow({ position: { x: parseInt(offset.left) + 80, y: parseInt(offset.top) + 80} });
			$("#vaultupdate").jqxWindow({ width: 470, height:263, resizable: false,  isModal: true, autoOpen: false, theme:theme, cancelButton: $("#CancelU"), modalOpacity: 0.01 });
			$("#vaultupdate").jqxWindow('show');
			
			$("#vaultlNameU").jqxInput({placeHolder: "VaultlName", height: 25, width: 270, theme:themaColor });
			$('#vaultlNameU').val(itemLabel);
			
				var ajaxData = $.ajax({
					  //root: "listView",  						
				  url : "getVaultlInfo.do",
				  type : "post",
				  dataType : "json",
				  data : { "vaultlNo" : itemId },
					  beforeSend : function(){ }, 
				  success : function(data, textStatus, jqXHR){
					  	//console.log(data.vault.vaultlDesc);
					  	//$("#vaultlDescU").val(data.vault.vaultlDesc);
					  	$("#vaultlDescU").jqxInput({placeHolder: "vaultlDesc", height: 25, width: 270, theme:themaColor });
					  	$('#vaultlDescU').val(data.vault.vaultlDesc);
					  	
					  	var docSelectedIndex = 0;
					  	var subSelectedIndex = 0;
					  	var strSelectedIndex = 0;
					  	var dataDocName = data.vault.docdbName;
					  	var dataSubName = data.vault.subdbName;
					  	var dataStrName = data.vault.storageNo;
					  	var dataCount = 0;
					  	
						var source_cb1_Key = {"docdbName" : "DOC", "vaultlNo" : itemId };
						//console.log(source_cb1_Key);
						var source_cb1 = 
						{
							datatype: "json",
							data : source_cb1_Key,
							root: "listView",
							type: "post",
							datafields: [ { name: 'docname' } ],
							url: "columList.do",
							async: false,
						};

						//console.log(source_cb1);
						var dataAdapter_cb1 = new $.jqx.dataAdapter(source_cb1, {
			                autoBind: true,
			                beforeLoadComplete: function (records) {
								//console.log(records);
								dataCount = records[0].docname[0].dataCount;
								//console.log(dataCount);
								 
			                    var dataArr = new Array();	
			                    for (var i = 0; i < records[0].docname.length; i++) {
			                        var docdbName = records[0].docname[i].docdbName;	    				                        
			                        dataArr.push(docdbName);	    				                        
			                        if(dataDocName == docdbName){ //원래 가지고 있던 data를 비교해서 update창에 출력.
			                        	docSelectedIndex = i;
			                        }
			                    }
			                    return dataArr;
			                }							
						});

						//console.log(dataAdapter_cb1);
						var source_cb2_Key = { "subdbName" : "SUB", "vaultlNo" : itemId };
						var source_cb2 =
						{
							datatype: "json",
							data : source_cb2_Key,
							root: "listView",
							type: "post",
							datafields: [{ name: 'subname' }],
							url: "columList.do",
							async: false,
						};

						var dataAdapter_cb2 = new $.jqx.dataAdapter(source_cb2, {
			                autoBind: true,
			                beforeLoadComplete: function (records) {	
			                	dataCount = records[0].subname[0].dataCount;
								//console.log(dataCount);	    				                    
								var dataArr = new Array();
			                    // update the loaded records. Dynamically add EmployeeName and EmployeeID fields. 
			                    for (var i = 0; i < records[0].subname.length; i++) {
			                        var subdbName = records[0].subname[i].subdbName;
			                        dataArr.push(subdbName);	    				                        
			                        if(dataSubName == subdbName){	    				                        	
			                        	subSelectedIndex = i;
			                        }
			                    }
			                    return dataArr;
			                }								
						});					

						var source_cb3_Key = { "storageNo" : "STR", "vaultlNo" : itemId };
						var source_cb3 =
						{
							datatype: "json",
							type: "post",
							root: "listView",
							datafields: [ { name: 'storageno' } ],
							url: "columList.do",
							data: source_cb3_Key,
							async: false
						};

						var dataAdapter_cb3 = new $.jqx.dataAdapter(source_cb3, {
			                autoBind: true,
			                beforeLoadComplete: function (records) {
								//console.log(records[0].strNo.length);			                	
			                    dataCount = records[0].storageno[0].dataCount;
			                    
								var dataArr = new Array();
			                    // update the loaded records. Dynamically add EmployeeName and EmployeeID fields. 
			                    for (var i = 0; i < records[0].storageno.length; i++) {
			                        var storageNo = records[0].storageno[i].storageNo;
			                        dataArr.push(storageNo);	    				                        
			                        if(dataStrName == storageNo){	    				                        	
			                        	strSelectedIndex = i;
			                        }
			                    }
			                    return dataArr;
			                }								
						});	 
						
					// Grid data가 없을 시 드랍다운 생성
					if (dataCount == 0 ) { 
						//console.log("grid 없음");
						
						$("#updateDOC").html("<div id='cb_docdbnameU'></div>");
						$("#updateSUB").html("<div id='cb_subdbnameU'></div>");
						$("#updateSTR").html("<div id='cb_storagenoU'></div>");
						
						$("#cb_docdbnameU").jqxDropDownList({ source: dataAdapter_cb1, selectedIndex: docSelectedIndex, width: '270px', height: '25px', autoDropDownHeight:true, theme:'ui-lightness'});
						$('#cb_docdbnameU').bind('select', function (event) {
						});
							
						$("#cb_subdbnameU").jqxDropDownList({ source: dataAdapter_cb2, selectedIndex: subSelectedIndex, width: '270px', height: '25px', autoDropDownHeight:true, theme:'ui-lightness'});
						$('#cb_subdbnameU').bind('select', function (event) {
						});	

						$("#cb_storagenoU").jqxDropDownList({ source: dataAdapter_cb3, selectedIndex: strSelectedIndex, width: '270px', height: '25px', autoDropDownHeight:true, theme:'ui-lightness'});
						$('#cb_storagenoU').bind('select', function (event) {
						}); 
						
					} else if (dataCount > 0 ){
						//console.log("grid 있음");
						
						$("#updateDOC").html("<input type='text' id='cb_docdbnameU' readonly/>"); 
						$("#updateSUB").html("<input type='text' id='cb_subdbnameU' readonly/>"); 
						$("#updateSTR").html("<input type='text' id='cb_storagenoU' readonly/>"); 
						
						$("#cb_docdbnameU").jqxInput({ height: 25, width: 270, theme: 'ui-lightness' });
						$("#cb_docdbnameU").val(dataDocName);
						
						$("#cb_subdbnameU").jqxInput({ height: 25, width: 270, theme: 'ui-lightness' });
						$("#cb_subdbnameU").val(dataSubName);
						
						$("#cb_storagenoU").jqxInput({ height: 25, width: 270, theme: 'ui-lightness' });
						$("#cb_storagenoU").val(dataStrName);
					}

					$("#UpdateU").jqxButton({ width: 90, height: 26, theme:themaColor });
					$("#CancelU").jqxButton({ width: 90, height: 26, theme:themaColor });	
				  	
				  	return data;
				  },
				  error : function(jqXHR, textStatus, errorThrown){
						msg1("관리자에게 문의하세요");
				  }
				});
				
			break;
		case "Delete": // 트리 삭제
		    var offset;
			switch (tabsItem) {
			case 0:
				 offset = $("#tv_announce").offset();
				break;
			case 1:
				 offset = $("#tv_summury").offset();
				 break;
			case 2:
				 offset = $("#tv_vault").offset();
				break;
			case 3:
				 offset = $("#tv_query").offset();
			break;
			default:
				break;
			}
			
			var tvId = "";
			switch (tabsItem) {
			case 0:
				tvId = "#tv_announce";
				break;
			case 1:
				tvId = "#tv_summury";
				break;
			case 2:
				tvId = "#tv_vault";
				break;
			case 3:
				tvId = "#tv_query";
			break;
			default:
				break;
			}
			
			
			swal({
				  title: "",
				  text: "삭제하시겠습니까?",
				  type: "warning",
				  showCancelButton: true,
				  confirmButtonColor: "#DD6B55",
				  confirmButtonText: "OK!", animation: false,
				  closeOnConfirm: false
				},
				function(){
					var label = $(tvId).jqxTree('selectedItem').label;
						var no = $(tvId).jqxTree('selectedItem').id;
						var level = $(tvId).jqxTree('selectedItem').level;
					var param = { "vaultlNo" : no, "vaultlLevel" : level, "docdbName":docdbname,
							"subdbName":subdbname};


	 				$.ajax({
						  url : "vaultDelete.do",
						  type : "post",
						  dataType : "json", 
						  data : param,
						  beforeSend : function(){
							  
						  },
						  success : function(data, textStatus, jqXHR){
								console.log(data);								
								if(data.rtncode) {
									//alert("삭제 되었습니다.");										
									
									var selectedItem = $(tvId).jqxTree('selectedItem');
				                    
									$(tvId).jqxTree('removeItem', selectedItem.element, false);
				                    $(tvId).jqxTree('render');
				                    $('#vaultdelete').jqxWindow('close');
				                    
									msg1("삭제하였습니다.");
				                } else {
									if(data.rtnerrno == "0"){
										msg1("선택된 폴더 또는 하위 폴더에 데이터가 있습니다.");										
									}else{
										msg1("삭제실패");
									}
								}
						  },
						  error : function(jqXHR, textStatus, errorThrown){
								msg1("관리자에게 문의하세요");
						  }
	 				});	 
				}
			); 
				
			 
// 						$("#vaultdelete").jqxWindow({ position: { x: parseInt(offset.left) + 180, y: parseInt(offset.top) + 120} });
// 						$("#vaultdelete").jqxWindow({ width: 300, height:160, resizable: false,  isModal: true, autoOpen: false, theme:'ui-lightness', cancelButton: $("#CancelD"), modalOpacity: 0.01 });
// 						$("#vaultdelete").jqxWindow('show');
			
// 						$("#OK_D").jqxButton({ width: 120, height: 30, theme:themaColor });
// 						$("#CancelD").jqxButton({ width: 120, height: 30, theme:themaColor });	
			
			break;
		case "Property": // 트리 정보
			doubleSubmitFlag = false;
			var itemId;
			var itemLabel;
			var offset;
			switch (tabsItem) {
			case 0:
				 itemId = $('#tv_announce').jqxTree('selectedItem').id;
				 itemLabel = $('#tv_announce').jqxTree('selectedItem').label;
				 offset = $("#tv_announce").offset();
				break;
			case 1:
				 itemId = $('#tv_summury').jqxTree('selectedItem').id;
				 itemLabel = $('#tv_summury').jqxTree('selectedItem').label;
				 offset = $("#tv_summury").offset();
				break;
			case 2:
				 itemId = $('#tv_vault').jqxTree('selectedItem').id;
				 itemLabel = $('#tv_vault').jqxTree('selectedItem').label;
				 offset = $("#tv_vault").offset();
				break;
			case 3:
				 itemId = $('#tv_query').jqxTree('selectedItem').id;
				 itemLabel = $('#tv_query').jqxTree('selectedItem').label;
				 offset = $("#tv_query").offset();
			break;
			default:
				break;
			}
			
			$("#vaultproperty").jqxWindow({ position: { x: parseInt(offset.left) + 80, y: parseInt(offset.top) + 80} });
			$("#vaultproperty").jqxWindow({ width: 500, height: 357,resizable: false, isModal: true, autoOpen: false, theme:theme, cancelButton: $("#CancelP"), modalOpacity: 0.01 });
	        $("#vaultproperty").jqxWindow('show');
			
			//$("#vaultlNoP").jqxInput({placeHolder: "VaultlName", height: 25, width: 390, theme:themaColor });
			//$('#vaultlNoP').val(itemId);
			
			$("#vaultlNameP").jqxInput({placeHolder: "VaultlName", height: 25, width: 300, theme:'ui-lightness' });
			$('#vaultlNameP').val(itemLabel);
			
				$.ajax({
					  //root: "listView",  						
				  url : "getVaultlInfo.do",
				  type : "post",
				  dataType : "json",
				  data : {"vaultlNo" : itemId},
					  beforeSend : function(){  
				  }, 
				  success : function(data, textStatus, jqXHR){
					  	console.log(data);
						$("#vaultlKindP").jqxInput({placeHolder: "", height: 25, width: 300, theme:'ui-lightness' });
						$('#vaultlKindP').val(data.vault.vaultlKind);
						
						$("#vaultlDescP").jqxInput({placeHolder: "", height: 25, width: 300, theme:'ui-lightness' });
						$('#vaultlDescP').val(data.vault.vaultlDesc);
						
						$("#docdbNameP").jqxInput({placeHolder: "", height: 25, width: 300, theme:'ui-lightness' });
						$('#docdbNameP').val(data.vault.docdbName);
						
						$("#subdbNameP").jqxInput({placeHolder: "", height: 25, width: 300, theme:'ui-lightness' });
						$('#subdbNameP').val(data.vault.subdbName);
						
						$("#storageNoP").jqxInput({placeHolder: "", height: 25, width: 300, theme:'ui-lightness' });
						$('#storageNoP').val(data.vault.storageNo);
						
						$("#creatorP").jqxInput({placeHolder: "", height: 25, width: 300, theme:'ui-lightness' });
						$('#creatorP').val(data.vault.creator);
						
						$("#createdP").jqxInput({placeHolder: "", height: 25, width: 300, theme:'ui-lightness' });
						$('#createdP').val(data.vault.created);
						
					  	return data;
				  },
				  error : function(jqXHR, textStatus, errorThrown){
						msg1("관리자에게 문의하세요");
				  }
				});

				$("#SaveP").jqxButton({ width: 90, height: 26, theme:themaColor, disabled: true, });
				$("#CancelP").jqxButton({ width: 90, height: 26, theme:themaColor });

				$("#tv_announce").jqxTree('selectItem', null);
				$("#tv_vault").jqxTree('selectItem', null);
				$("#tv_summury").jqxTree('selectItem', null);
				$("#tv_query").jqxTree('selectItem', null);
			break;
		}	
	});			 

      //트리 루트 생성 함수
		$('#SaveR').on('click', function () {
			$('#SaveR').find("span").remove();
/*확인창 				var offset = $("#tv_announce").offset();
            $("#msg_win").jqxWindow({ position: { x: parseInt(offset.left) + 60, y: parseInt(offset.top) + 60} });
			$("#msg_win").jqxWindow({ width: 250, height:140, resizable: false,  isModal: true, autoOpen: false, theme: 'ui-lightness', cancelButton: $("#OK_msg"), modalOpacity: 0.01 });
			$("#OK_msg").jqxButton({ width: 120, height: 30, theme:'ui-sunny' });
			$("#msg_win").show(); */
			
			var no = tabsItem; // 이게 탭 넘버인지 확인해바야함
			var id = '${loginInfo.userno }'; // user ID
			console.log(id);
			var name = $("#vaultlName").val();
			var desc = $("#vaultlDesc").val();
			var doc = $("#cb_docdbname").val();
			var sub = $("#cb_subdbname").val();
			var str = $("#cb_storageno").val();
			
			var param = { 
						 "vaultlNo":no,						
						 "vaultlName":name,
						 "vaultlDesc":desc,
						 "docdbName":doc,
						 "subdbName":sub,
						 "creator":id,
						 "storageNo":str};
			
			if(doubleSubmitCheck()) return;
				$.ajax({
				  url : "rootCreate.do",
				  type : "post",
				  dataType : "json", 
				  data : param,
				  beforeSend : function(){
					  
				  }, 
				  success : function(data, textStatus, jqXHR){
						//alert("생성 되었습니다.");
						//console.log(data);
						if(data.rtnStr == "S"){
							switch (tabsItem) {
							case 0:
								$('#tv_announce').jqxTree('addTo', 
										 {id: data.addVault.vaultlNo,
										  icon: "images/folderOpen.png", 
										  label: data.addVault.vaultlName, 
										  cnt: data.addVault.childCount,
										  });
								$('#tv_announce').jqxTree('render');
								
								$('#vaultrootcreate').jqxWindow('close');
								$("#tv_announce").jqxTree('selectItem', null);
								$('#vaultlName').val(null);
								$('#vaultlDesc').val(null);			
											break;
							case 1:
								$('#tv_summury').jqxTree('addTo', 
										 {id: data.addVault.vaultlNo,
										  icon: "images/folderOpen.png", 
										  label: data.addVault.vaultlName, 
										  cnt: data.addVault.childCount,
										  });
								$('#tv_summury').jqxTree('render');
								
								$('#vaultrootcreate').jqxWindow('close');
								$("#tv_summury").jqxTree('selectItem', null);
								$('#vaultlName').val(null);
								$('#vaultlDesc').val(null);	
									break;
							case 2:
								$('#tv_vault').jqxTree('addTo', 
										 {id: data.addVault.vaultlNo,
										  icon: "images/folderOpen.png", 
										  label: data.addVault.vaultlName, 
										  cnt: data.addVault.childCount,
										  });
								$('#tv_vault').jqxTree('render');
								
								$('#vaultrootcreate').jqxWindow('close');
								$("#tv_vault").jqxTree('selectItem', null);
								$('#vaultlName').val(null);
								$('#vaultlDesc').val(null);
								break;
							
							case 3:
								$('#tv_query').jqxTree('addTo', 
										 {id: data.addVault.vaultlNo,
										  icon: "images/folderOpen.png", 
										  label: data.addVault.vaultlName, 
										  cnt: data.addVault.childCount,
										  });
								$('#tv_query').jqxTree('render');
								
								$('#vaultrootcreate').jqxWindow('close');
								$("#tv_query").jqxTree('selectItem', null);
								$('#vaultlName').val(null);
								$('#vaultlDesc').val(null);		
										break;
							}
						}else{
							msg3(data.rtnStr,500,200);
						}
/*확인창 							$('#msg_alert').append(name + ' 가(이) 생성 되었습니다.'); */
				  },
				  error : function(jqXHR, textStatus, errorThrown){
						msg1("관리자에게 문의하세요.");
				  } 
			});
		});
		
		//트리 생성 함수
		$('#SaveC').on('click', function () {
			var no;
			var level;
			switch (tabsItem) {
			case 0:
				 no = $("#tv_announce").jqxTree('selectedItem').id;
				 level = $("#tv_announce").jqxTree('selectedItem').level;
				break;			
			case 1:
				 no = $("#tv_summury").jqxTree('selectedItem').id;
				 level = $("#tv_summury").jqxTree('selectedItem').level;
				break;
			case 2:
				 no = $("#tv_vault").jqxTree('selectedItem').id;
				 level = $("#tv_vault").jqxTree('selectedItem').level;
				break;
			case 3:
				 no = $("#tv_query").jqxTree('selectedItem').id;
				 level = $("#tv_query").jqxTree('selectedItem').level;
			break;
			default:
				break;
			}
			
			var id = '${loginInfo.userno }'; // user ID
			var kind = tabsItem; // 이게 탭 넘버인지 확인해바야함
			var name = $("#vaultlNameC").val();
			var desc = $("#vaultlDescC").val();
			var doc = $("#cb_docdbnameC").val();
			var sub = $("#cb_subdbnameC").val();
			var str = $("#cb_storagenoC").val();
			
			var param = { 
						 "vaultlNo":no,						
						 "vaultlName":name,
						 "vaultlLevel":level,
						 "vaultlKind":kind,
						 "vaultlDesc":desc,
						 "docdbName":doc,
						 "subdbName":sub,
						 "creator":id,
						 "storageNo":str};

			if(doubleSubmitCheck()) return;
				$.ajax({
				  url : "vaultCreate.do",
				  type : "post",
				  dataType : "json", 
				  data : param,
				  beforeSend : function(){
					  
				  }, 
				  success : function(data, textStatus, jqXHR){
						//alert("생성 되었습니다.");
						
						var childFolder = "images/folder.png";
						var childNoFolder = "images/folderOpen.png";
						var selectedItem; 
						switch (tabsItem) {
						case 0:
							selectedItem = $("#tv_announce").jqxTree('selectedItem');
							  $('#tv_announce').jqxTree('addTo', 
										{id: data.addVault.vaultlNo,
										 icon: childNoFolder, 
										 label: data.addVault.vaultlName, 
										 cnt: data.addVault.childCount,
										},  selectedItem.element, false);
									
								$('#tv_announce').jqxTree('updateItem', {icon: childFolder, label: $("#tv_announce").jqxTree('selectedItem').label}, selectedItem.element);
								$('#tv_announce').jqxTree('render');
								$("#tv_announce").jqxTree('selectItem', null);
							break;
						case 1:
							 selectedItem = $("#tv_summury").jqxTree('selectedItem');
							  $('#tv_summury').jqxTree('addTo', 
										{id: data.addVault.vaultlNo,
										 icon: childNoFolder, 
										 label: data.addVault.vaultlName, 
										 cnt: data.addVault.childCount,
										},  selectedItem.element, false);
									
								$('#tv_summury').jqxTree('updateItem', {icon: childFolder, label: $("#tv_summury").jqxTree('selectedItem').label}, selectedItem.element);
								$('#tv_summury').jqxTree('render');
								$("#tv_summury").jqxTree('selectItem', null);
							break;
						case 2:
							 selectedItem = $("#tv_vault").jqxTree('selectedItem');
							  $('#tv_vault').jqxTree('addTo', 
										{id: data.addVault.vaultlNo,
										 icon: childNoFolder, 
										 label: data.addVault.vaultlName, 
										 cnt: data.addVault.childCount,
										},  selectedItem.element, false);
									
								$('#tv_vault').jqxTree('updateItem', {icon: childFolder, label: $("#tv_vault").jqxTree('selectedItem').label}, selectedItem.element);
								$('#tv_vault').jqxTree('render');
								$("#tv_vault").jqxTree('selectItem', null);
							break;
						
						case 3:
							 selectedItem = $("#tv_query").jqxTree('selectedItem');
							  $('#tv_query').jqxTree('addTo', 
										{id: data.addVault.vaultlNo,
										 icon: childNoFolder, 
										 label: data.addVault.vaultlName, 
										 cnt: data.addVault.childCount,
										},  selectedItem.element, false);
									
								$('#tv_query').jqxTree('updateItem', {icon: childFolder, label: $("#tv_query").jqxTree('selectedItem').label}, selectedItem.element);
								$('#tv_query').jqxTree('render');
								$("#tv_query").jqxTree('selectItem', null);
						break;
						default:
							break;
						}
						$('#vaultcreate').jqxWindow('close');
						$('#vaultlNameC').val(null);
						$('#vaultlDescC').val(null);

/*확인창 							$('#msg_alert').append(name + ' 가(이) 생성 되었습니다.'); */
				  },
				  error : function(jqXHR, textStatus, errorThrown){
						alert("관리자에게 문의하세요");
				  } 
			});
		});        

		//트리 수정 함수
		$('#UpdateU').on('click', function (event) {
			//'${loginInfo.userno }';
			var tvId = "";
			switch (tabsItem) {
			case 0:
				tvId = "#tv_announce";
				break;
			case 1:
				tvId = "#tv_summury";
				break;
			case 2:
				tvId = "#tv_vault";
				break;
			case 3:
				tvId = "#tv_query";
			break;
			default:
				break;
			}
			
			var label = $(tvId).jqxTree('selectedItem').label;
			var no = $(tvId).jqxTree('selectedItem').id;
			var name = $("#vaultlNameU").val();
			var desc = $("#vaultlDescU").val();
			var doc = $("#cb_docdbnameU").val();
			var sub = $("#cb_subdbnameU").val();
			var str = $("#cb_storagenoU").val();
			
			var param = {"vaultlNo":no, "vaultlName":name, "vaultlDesc":desc, "docdbName":doc, "subdbName":sub, "storageNo":str};
			
			if(doubleSubmitCheck()) return;
				$.ajax({
				  url : "vaultUpdate.do",
				  type : "post",
				  dataType : "json", 
				  data : param,
				  beforeSend : function(){
					  
				  }, 
				  success : function(data, textStatus, jqXHR){
				  		//alert("수정 되었습니다.");
						
				        if(data.rtnStr == "S") {						        	
							var selectedItem = $(tvId).jqxTree('selectedItem');
							var icon = $(tvId).jqxTree('selectedItem').icon;

							$(tvId).jqxTree('updateItem', {icon: icon, label : name }, selectedItem.element);
		                    $(tvId).jqxTree('render');	

		                    //msg1("수정 되었습니다.");

							$('#vaultupdate').jqxWindow('close');
							$(tvId).jqxTree('selectItem', null);

/*확인창 								$('#msg_alert').append(label + ' 가(이) 수정 되었습니다.'); */
				        }							
				  },
				  error : function(jqXHR, textStatus, errorThrown){
						msg1("관리자에게 문의하세요");
						  
				  } 
			});
		}); //update
		
		//트리 삭제 함수
		$('#OK_D').on('click', function (event) {
				var tvId = "";
				switch (tabsItem) {
				case 0:
					tvId = "#tv_announce";
					break;
				case 1:
					tvId = "#tv_summury";
					break;
				case 2:
					tvId = "#tv_vault";
					break;
				case 3:
					tvId = "#tv_query";
				break;
				default:
					break;
				}
				var label = $(tvId).jqxTree('selectedItem').label;
					var no = $(tvId).jqxTree('selectedItem').id;
					var level = $(tvId).jqxTree('selectedItem').level;
				var param = { "vaultlNo" : no, "vaultlLevel" : level, "docdbName":docdbname,
						"subdbName":subdbname};

			
				
 				$.ajax({
					  url : "vaultDelete.do",
					  type : "post",
					  dataType : "json", 
					  data : param,
					  beforeSend : function(){
						  
					  },
					  success : function(data, textStatus, jqXHR){
							console.log(data);								
							if(data.rtncode) {
								//alert("삭제 되었습니다.");										
								
								var selectedItem = $(tvId).jqxTree('selectedItem');
			                    
								$(tvId).jqxTree('removeItem', selectedItem.element, false);
			                    $(tvId).jqxTree('render');
			                    $('#vaultdelete').jqxWindow('close');
			                    
								msg1("삭제하였습니다.");
			                } else {
								if(data.rtnerrno == "0"){
									msg1("선택된 폴더 또는 하위 폴더에 데이터가 있습니다.");										
								}else{
									msg1("삭제실패");
								}
							}
					  },
					  error : function(jqXHR, textStatus, errorThrown){
							msg1("관리자에게 문의하세요");
					  }
 				});	  
			});
		
		//그리드 팝업
		$("#mainlist").on('contextmenu', function (event) {
			$("#menu_tv").jqxMenu('close');
            
			if(docdbname != "" && subdbname != ""){
                var rightClick = isRightClick(event) || $.jqx.mobile.isTouchDevice();
                if (rightClick) {
                    var scrollTop = $(window).scrollTop();
                    var scrollLeft = $(window).scrollLeft();
                    $("#menu_lv").jqxMenu('open', parseInt(event.clientX) + 5 + scrollLeft, parseInt(event.clientY) + 5 + scrollTop);
                    return false;
                }
			}
        });

		// 그리드 ContextMenu
		$("#menu_lv").on('itemclick', function (event) {
			var menuitemText = $(event.args).text();
			var menuitemText = $(args).text();

			console.log("clicked menu_lv => "+ menuitemText);
			
			var element = event.args;
			var leftm = (screen.width/2)-(1500/2);
		    var topm = (screen.height/2)-(650/2);
		    var rowData = getselectsGrDatas("#mainlist");
		    
			switch (menuitemText) {
				case "Create Doc":
					option = "create";
					//var win1 = window.open('lvDetail.do',"F_lvDetail", "width="+ (screen.width - 200) +", height="+ (screen.height- 150) + ",resizable = yes, top=5, left=10,scrollbars=no");
					window.open('lvDetail.do',"F_lvDetail", "width=1280, height=622, resizable = no, top=" + topm + ", left=" + leftm + ",scrollbars=no");
					//openedWin.push(win1);
					//console.log("createdoc");
					$("#menu_lv").jqxMenu('close');
					break;
				case "Update Doc":
					if(rowData.length == 0){
						msg1("데이터를 선택하세요");
					}else if(rowData.length == 1){
						option = "update";
						window.open('lvDetail.do',"F_lvDetail", "width=1280, height=622,resizable = no, top=" + topm + ", left=" + leftm + ",scrollbars=no");
					}else if(rowData.length > 1){
						msg1("한개의 데이터를 선택해주세요.");
					}
					$("#menu_lv").jqxMenu('close');
					break;
				case "Delete Doc":

					if(rowData.length == 0){
						msg1("데이터를 선택하세요");
					}else if(rowData.length >= 1){
						//msg2(rowData.length + "개의 데이터를 삭제하시겠습니까?",300,180);
						swal({
							  title: "",
							  text: rowData.length + "개의 데이터를 삭제하시겠습니까?",
							  type: "warning",
							  showCancelButton: true,
							  confirmButtonColor: "#DD6B55",
							  confirmButtonText: "OK!", animation: false,
							  closeOnConfirm: false
							},
							function(){
								//var params = docdbname + "";
								var fd = new FormData();
								
								fd.append('vaultlno', rowData[0].VAULTLNO);
								fd.append('docdbname', docdbname);
								fd.append('subdbname', subdbname);

								for(var i = 0; i < rowData.length; i++){
									fd.append('docno', rowData[i].DOCNO);
								}

								 $.ajax({
										url : "deleteDetail.do",
										type : "POST",
										dataType : "json",
										contentType:false,
								  		processData: false,
										data : fd,
										traditional :true,
										success : function(data, status,XHR){
											msg1("총 " + data.count + "건 삭제하였습니다.");
											$("#mainlist").jqxGrid('updatebounddata');
											$("#mainlist").jqxGrid('clearselection');
										},
										error : function(data, status){
											msg1("관리자에게 문의하세요.");
										},
										complete : function(){
										}
									});
							}
						); 
					}
					$("#menu_lv").jqxMenu('close');
					break;
				case "Column Action":
					alert("Column Action");
					break;
				case "Delete Selected Row":
					var offset = $("#mainlist").offset();
					$("#griddelete").jqxWindow({ position: { x: parseInt(offset.left) + 60, y: parseInt(offset.top) + 60} });
					$("#griddelete").jqxWindow({ width: 300, height:160, resizable: false,  isModal: true, autoOpen: false, theme:theme, cancelButton: $("#CancelGD"), modalOpacity: 0.01 });
					$("#griddelete").jqxWindow('show');
					
					$("#OK_GD").jqxButton({ width: 120, height: 30, theme:'ui-sunny' });
					$("#CancelGD").jqxButton({ width: 120, height: 30, theme:'ui-sunny' });	
					break;
				case "Open server":
					location.href="docDowload.do?docno="+rowData[0].DOCNO+"&vaultlno="+rowData[0].VAULTLNO+"&filename="+rowData[0].DOCFILENAME;
					break;
				case "Open local":
					//location.href="docOpen.do?docno="+rowData.DOCNO+"&vaultlno="+rowData.VAULTLNO;
				//	var param = {"docno":rowData[0].DOCNO, "vaultlno":rowData[0].VAULTLNO, "docfilename":rowData[0].DOCFILENAME};
					docOpen(rowData[0].DOCNO, rowData[0].VAULTLNO, rowData[0].DOCFILENAME)
					break;
				case "Find":
				    console.log("Find");
					//$("#docsearch_winm").jqxWindow("move", $(window).width() / 2 - $("#docsearch_winm").jqxWindow("width") / 2, $(window).height() / 2 - $("#docsearch_winm").jqxWindow("height") / 2);

			        $("#docsearch_winm").jqxWindow({position:'center', width:800, height:324, resizable:false, theme:theme, isModal:false, autoOpen:false, modalOpacity: 0.01});
			        $("#docsearch_winm").jqxWindow('show'); //show:can query, but open: could not ? 
					break;
				case "Open Editing Version":					
					var param = {"docno":rowData[0].DOCNO, "vaultlno":rowData[0].VAULTLNO, "docfilename":rowData[0].DOCFILENAME};
					console.log(param);
					$.ajax({
						  url : "docOpenEditVersion.do",
						  type : "post",
						  dataType : "json", 
						  data : param,
						  beforeSend : function(){  
						  }, 
						  success : function(data, textStatus, jqXHR){						
							  if(!data.rtncode){
									msg1(data.rtnmsg);
								}
							  console.log(data.checkEditFile);
							  if(data.checkEditFile){  //수정했을시!
								  console.log(data);
								  $("#e_edit_docno").val(rowData[0].DOCNO);
								  $("#e_edit_docname").val(rowData[0].DOCNAME);
								  $("#e_edit_docdesc").val(rowData[0].DOCDESC);
								  $("#e_edit_docver").val(data.docversion);
								  $("#e_edit_filepath").val(data.filepath);
								  $("#e_edit_filename").val(rowData[0].DOCFILENAME);
								  $("#e_edit_vaultlno").val(rowData[0].VAULTLNO);
								  $("#e_edit_dbname").val(data.dbname);
								  $("#e_edit_checkOnly").val(false);
									
								  $("#edit_winm").jqxWindow("move", $(window).width() / 2 - $("#edit_winm").jqxWindow("width") / 2, $(window).height() / 2 - $("#edit_winm").jqxWindow("height") / 2);
						          $("#edit_winm").jqxWindow({width: 525, height: 275, resizable: false, theme:theme, isModal: false, autoOpen: false /*modalOpacity: 0.01*/ });
						          $("#edit_winm").jqxWindow('show');
								  
							  }else{console.log("수정안함!!");}
							  
						  },
						  error : function(jqXHR, textStatus, errorThrown){ 
						  }
					});
		
					break;
				case "Open Editing Only":
					var param = {"docno":rowData[0].DOCNO, "vaultlno":rowData[0].VAULTLNO, "docfilename":rowData[0].DOCFILENAME};
					console.log(param);
					$.ajax({
						  url : "docOpenEditOnly.do",
						  type : "post",
						  dataType : "json", 
						  data : param,
						  beforeSend : function(){  
						  }, 
						  success : function(data, textStatus, jqXHR){						
							  if(!data.rtncode){
									msg1(data.rtnmsg);
								}
							  console.log(data.checkEditFile);
							  if(data.checkEditFile){  //수정했을시!
								  $("#e_edit_docno").val(rowData[0].DOCNO);
								  $("#e_edit_docname").val(rowData[0].DOCNAME);
								  $("#e_edit_docdesc").val(rowData[0].DOCDESC);
								  $("#e_edit_docver").val(data.docversion);		 
								  $("#e_edit_filepath").val(data.filepath);
								  $("#e_edit_filename").val(rowData[0].DOCFILENAME);
								  $("#e_edit_vaultlno").val(rowData[0].VAULTLNO);
								  $("#e_edit_dbname").val(data.dbname);
								  $("#e_edit_checkOnly").val(true);
							  
								  $("#edit_winm").jqxWindow("move", $(window).width() / 2 - $("#edit_winm").jqxWindow("width") / 2, $(window).height() / 2 - $("#edit_winm").jqxWindow("height") / 2);
						          $("#edit_winm").jqxWindow({width: 525, height: 275, resizable: false, theme:theme, isModal: false, autoOpen: false /*modalOpacity: 0.01*/ });
						          $("#edit_winm").jqxWindow('show');
							  }else{console.log("수정안함!!");}
						  },
						  error : function(jqXHR, textStatus, errorThrown){ 
						  } 
					});
					break;
				case "Check In":
					break;
					
			}
		});
		
		
		 ///// 드래그앤드랍
		 var objDragAndDrop = $("#mainlist");
	     
		 $(document).on("dragenter","#mainlist",function(e){
	         e.stopPropagation();
	         e.preventDefault();
	         $(this).css('border', '2px solid #0B85A1');
	     });
	     $(document).on("dragover","#mainlist",function(e){
	         e.stopPropagation();
	         e.preventDefault();
	         
	     });
	     $(document).on("drop","#mainlist",function(e){
	    	 objDragAndDrop.css('border', '');
	         e.preventDefault();
	         var files = e.originalEvent.dataTransfer.files;
	         console.log(files);
	         var selectedItem = $('#tv_announce').jqxTree('selectedItem');
	         console.log(selectedItem);

	         if(files.length > 500){
	        	 alert("파일 드래그 등록시 최대 500개 입니다.<br>현재선택한 파일 개수 : "+ (files.length));
	         }else{
	        	 var fd = new FormData();
	        	 
	        	 fd.append('vaultlno', selectedVaultNo);
	        	 fd.append('dbname', docdbname);
	        	 
	        	 for (var i = 0; i < files.length; i++) {
	          		var datarow = {};
	          		var fileName = files[i].name;
					
					fd.append('file', files[i]);
					
					
				 }	
	        	 
	        	 $.ajax({
					 dataType:"json",
					 url : "insertDocdb.do",
			  		 type: "POST",
			  		 contentType:false,
			  		 processData: false,
			  		 cache: false,
			    	 data: fd,
				     //async : false,
			    	 xhr: function()
			    		{
			    			myXhr = $.ajaxSettings.xhr();
			    	        if (myXhr.upload)
			    	        {
			        	        myXhr.upload.addEventListener('progress', function(ev){
			        	        	if (ev.lengthComputable) {
			        	        		$('#progress').show();       	        				   	        		
			        		            var percentComplete = Math.round((ev.loaded / ev.total) * 100);	
			        		            
			        		            $('#percent').text(percentComplete + '%'); 
			        		            $('#bar').css('width', percentComplete+'%');
					        
			        		        }
			        	        }, false);
			        	        myXhr.upload.addEventListener('load', function(ev){
			    	            	//업로드 완료시
			    	       		}, false);
			    	        }
			    	        return myXhr;
			    		},						    	
			    	success : function(data, textStatus) {	
			    		if(data.rtncode){
			    			msg1(data.count +"건 저장되었습니다.");
			    		}
			    		$("#mainlist").jqxGrid('updatebounddata');
			    	},
					error : function(textStatus, errorThrown) {

					},	
					complete : function(){
						$('#percent').text(''); 
    		            $('#bar').css('width', 0+'%');
					}
				});

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
	     
	     
	     $('#mainlist').on('rowdoubleclick', function (event) 
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
				    
				    var data = $('#mainlist').jqxGrid('getrowdata', boundIndex);

					docOpen(data.DOCNO, data.VAULTLNO, data.DOCFILENAME);
			});
	     
	     
	     $('#mainlist').on('rowselect', function (event) {
	    	 var args = event.args;             //event arguments.			    
			 var rowBoundIndex = args.rowindex; //row's bound index.
			 
			 var data = $('#mainlist').jqxGrid('getrowdata', rowBoundIndex);
			 selectedDocno = data.DOCNO;
	     });
}); //document.ready END

function treeData(tabIndex,tvArr){
	var tree = $(tvArr);
	var source = [];
	$.ajax({ 
		dataType: "json",
		contentType: "application/x-www-form-urlencoded; charset=UTF-8",
		type: "post",
		url : "viewVaultNo.do",
		data : {"vaultlNo": tabIndex},
		datafields: [
		            { name: 'vaultlName', type: 'string' },
		            { name: 'vaultlLevel', type: 'int' },
		            { name: 'childCount', type: 'int' }
		            ],
		beforeSend: function() {},
		success : function(data, textStatus, jqXHR){
			
				console.log(data.vault);
				for(var i=0; i<data.vault.length; i++) {
					if(data.vault[i].childCount > 0){
						source.push ({id: data.vault[i].vaultlNo,
								  icon: childFolder, 
								  label: data.vault[i].vaultlName, 
								  cnt: data.vault[i].childCount
								  });
					} else {
						source.push ({id: data.vault[i].vaultlNo,
							  icon: childNoFolder, 
							  label: data.vault[i].vaultlName, 
							  cnt: data.vault[i].childCount
							  });
					}
	 			}
	 			for (var i = 0; i < source.length; ++i) {					
					if (source[i]['cnt'] > 0) { 						
						var item1 = []; 
						item1.push({icon: "images/loader.gif", label:"Loading..."});
						source[i]['items'] = item1;
					}
				}
	 			
				tree.jqxTree({ source: source,  height: '100%', width: '100%'/* , theme:'ui-lightness' */ });
		},
	 	error : function(jqXHR, textStatus, errorThrown){
		}
	 });
}
        
        
function docsearch_treeData(tabIndex,tvArr){
	var tree = $(tvArr);
	var source = [];
	$.ajax({ 
		dataType: "json",
		contentType: "application/x-www-form-urlencoded; charset=UTF-8",
		type: "post",
		url : "viewVaultNo.do",
		data : {"vaultlNo": tabIndex},
		datafields: [
		            { name: 'vaultlName', type: 'string' },
		            { name: 'vaultlLevel', type: 'int' },
		            { name: 'childCount', type: 'int' }
		            ],
		beforeSend: function() {},
		success : function(data, textStatus, jqXHR){
				for(var i=0; i<data.vault.length; i++) {
					if(data.vault[i].childCount > 0){
						source.push ({id: "docsearch_"+data.vault[i].vaultlNo,
								  icon: childFolder, 
								  label: data.vault[i].vaultlName, 
								  value: data.vault[i].vaultlNo,
								  cnt: data.vault[i].childCount
								  });
					} else {
						source.push ({id: data.vault[i].vaultlNo,
							  icon: childNoFolder, 
							  label: data.vault[i].vaultlName, 
							  value: data.vault[i].vaultlNo,
							  cnt: data.vault[i].childCount
							  });
					}
	 			}
	 			for (var i = 0; i < source.length; ++i) {					
					if (source[i]['cnt'] > 0) { 						
						var item1 = []; 
						item1.push({icon: "images/loader.gif", label:"Loading..."});
						source[i]['items'] = item1;
					}
				}
	 			
				tree.jqxTree({ source: source,  height: '100%', width: '100%'/* , theme:'ui-lightness' */ });
		},
	 	error : function(jqXHR, textStatus, errorThrown){
		}
	 });
}

function treeExpandItem(tvId,event){
	var itemo = $(tvId).jqxTree('getItem', event.args.element);
	//console.log(itemo); //expand 정보
    var label = $(tvId).jqxTree('getItem', event.args.element).label; //선택한 트리라벨
    var $element = $(event.args.element); //li #id==>vaultlNo
    var loader = false;
    var loaderItem = null;
    var children = $element.find('ul:first').children();
    $.each(children, function () {
        var item = $(tvId).jqxTree('getItem', this);
        //console.log(item); //로딩 아이템
        if (item && item.label == 'Loading...') {
            loaderItem = item;
            //console.log(loaderItem); //로딩 표시해주는아이템
            loader = true;
            return false //라벨과 Loading이 맞다면 바로 펑션 탈출
        };
    });

    if (loader) {
        $.ajax({
        	dataType: "json",
			contentType: "application/x-www-form-urlencoded; charset=UTF-8",
			type: "post",
			url : "getDirectory.do",
			data : {"vaultlNo": loaderItem.parentId,"vaultlLevel": loaderItem.level},
            success: function (data, status, xhr) {
                //var items = jQuery.parseJSON(data);
                //tree.jqxTree('addTo', items, $element[0]);
                //tree.jqxTree('removeItem', loaderItem.element);
                
               for(var i=0; i<data.vault.length;i++){
            	   if(data.vault[i].childCount > 0){
            		 $(tvId).jqxTree('addTo', {id: data.vault[i].vaultlNo,
						  icon: childFolder, 
						  label: data.vault[i].vaultlName, 
						  cnt: data.vault[i].childCount,
						  items: [{icon: "images/loader.gif", label:"Loading..."}]
						  }, $element[0]); 
            	   		//console.log(data.vault[i]);
	            	   		//console.log($element[0]);
						
            	   } else {
            		 $(tvId).jqxTree('addTo', {id: data.vault[i].vaultlNo,
							  icon: childNoFolder, 
							  label: data.vault[i].vaultlName, 
							  cnt: data.vault[i].childCount
							  }, $element[0]);
            	   }
               }

             $(tvId).jqxTree('removeItem', loaderItem.element); //
            }
        });
    }
}


function docsearch_treeExpandItem(tvId,event){
		
	var itemo = $(tvId).jqxTree('getItem', event.args.element);
	//console.log(itemo); //expand 정보
    var label = $(tvId).jqxTree('getItem', event.args.element).label; //선택한 트리라벨
    var $element = $(event.args.element); //li #id==>vaultlNo
    var loader = false;
    var loaderItem = null;
    var children = $element.find('ul:first').children();
    $.each(children, function () {
        var item = $(tvId).jqxTree('getItem', this);
        //console.log(item); //로딩 아이템
        if (item && item.label == 'Loading...') {
            loaderItem = item;
            //console.log(loaderItem); //로딩 표시해주는아이템
            loader = true;
            return false //라벨과 Loading이 맞다면 바로 펑션 탈출
        };
    });
	console.log(loaderItem);
    if (loader) {
        $.ajax({
        	dataType: "json",
			contentType: "application/x-www-form-urlencoded; charset=UTF-8",
			type: "post",
			url : "getDirectory.do",
			data : {"vaultlNo": loaderItem.parentId.replace("docsearch_", ""),"vaultlLevel": loaderItem.level},
            success: function (data, status, xhr) {
                //var items = jQuery.parseJSON(data);
                //tree.jqxTree('addTo', items, $element[0]);
                //tree.jqxTree('removeItem', loaderItem.element);
                console.log(data.vault);
               for(var i=0; i<data.vault.length;i++){
            	   if(data.vault[i].childCount > 0){
            		 $(tvId).jqxTree('addTo', {id: "docsearch_"+data.vault[i].vaultlNo,
						  icon: childFolder, 
						  label: data.vault[i].vaultlName, 
						  cnt: data.vault[i].childCount,
						  value: data.vault[i].vaultlNo,
						  items: [{icon: "images/loader.gif", label:"Loading..."}]
						  }, $element[0]); 
            	   		//console.log(data.vault[i]);
	            	   		//console.log($element[0]);
						
            	   } else {
            		 $(tvId).jqxTree('addTo', {id: "docsearch_"+data.vault[i].vaultlNo,
							  icon: childNoFolder, 
							  label: data.vault[i].vaultlName, 
							  value: data.vault[i].vaultlNo,
							  cnt: data.vault[i].childCount
							  }, $element[0]);
            	   }
               }

             $(tvId).jqxTree('removeItem', loaderItem.element); //
            }
        });
    }
}

function getDocdb1List(params){
	var source =
    {
		datatype: "json",
        type:"POST",
        data: params,
        datafields: [
            { name: 'DOCNO', type: 'string' },
            { name: 'DOCTYPE', type: 'string' },
            { name: 'DOCVERSION', type: 'int' },
            { name: 'DOCFILENAME', type: 'string' },
            { name: 'DOCFILETYPE', type: 'string' },
            { name: 'DOCFILESIZE', type: 'int' },
            { name: 'DOCDESC', type: 'string' },
            { name: 'DOCPROADD', type: 'string' },
            { name: 'DOCSTATUS', type: 'string' },
            { name: 'DOCAPPSTATUS', type: 'string' },
            { name: 'DOCSETNO', type: 'string' },
            { name: 'DOCZIPFILENAME', type: 'string' },
            { name: 'DOCGRADE', type: 'string' },
            { name: 'DOCRETURN', type: 'string' },
            { name: 'DOCCREATED', type: 'string' },
            { name: 'DOCCREATOR', type: 'string' },
            { name: 'DOCCREATORNAME', type: 'string' },
            { name: 'DOCCREATORDEPT', type: 'string' },
            { name: 'DOCUPDATED', type: 'string' },
            { name: 'DOCUPDATOR', type: 'string' },
            { name: 'DOCUPDFLAG', type: 'string' },
            { name: 'DOCAPPRID', type: 'string' },
            { name: 'DOCANALYZED', type: 'string' },
            { name: 'VAULTLNO', type: 'string' },
            { name: 'VLDOCNO', type: 'string' },
            { name: 'DOCFACADDED', type: 'string' },
            { name: 'DOCOPENCNT', type: 'int' },
            { name: 'DOCANALYZEDCNT', type: 'int' },
            { name: 'DOCVERMAX', type: 'string' },
            { name: 'DOCUPDATORNAME', type: 'string' },
            { name: 'DOCUPDATORDEPTCODE', type: 'string' },
            { name: 'DOCUPDATORDEPTNAME', type: 'string' },
            { name: 'DOCPRINTCNT', type: 'int' },
            { name: 'DOCCREATORDEPTNAME', type: 'string' },
            { name: 'DOCCREATORDEPTCODE', type: 'string' },
            { name: 'RNUM', type:'int'},
            { name: 'TOTCNT', type:'int'}
         ],	
        id: "pmsJobList",
        url: "getDocdb1List.do",
    };
	 
    var cellsrenderer = function (row, columnfield, value, defaulthtml, columnproperties, rowdata) {
        if (value < 20) {
            return '<span style="margin: 4px; float: ' + columnproperties.cellsalign + '; color: #ff0000; ">' + value + '</span>';
        }
        else {
            return '<span style="margin: 4px; float: ' + columnproperties.cellsalign + '; color: #008000; ">' + value + '</span>';
        }
    }

    var dataAdapter = new $.jqx.dataAdapter(source, {
        downloadComplete: function (data, status, xhr) { },
        loadComplete: function (data) {},
        loadError: function (xhr, status, error) {}
    });

     var self = this;
     var pagerrenderer = function () {
       var TOTCNT;
       if(dataAdapter.recordids.length == 0){
    	   TOTCNT = 0;// 토탈 컬럼수
       }else{
    	   TOTCNT = dataAdapter.recordids[0].TOTCNT;// 토탈 컬럼수
       }
     var tempInt = 200; //page당 컬럼 수
     var pagetot = Math.ceil(TOTCNT / tempInt); // 토탈컬럼수 출력할 페이지 수 ex) 10  
     var element = $("<div style='margin-left: 10px; margin-top: 5px; width: 100%; height: 100%;'></div>");
      /*var datainfo = $("#gr_dwgcon2t").jqxGrid('getdatainformation'); */
       //console.log(paginginfo);
        
     var lastPage;
     if(TOTCNT % 200 == 0){
    	 lastPage = TOTCNT / 200;
     }else if(TOTCNT % 200 >= 1){
    	 lastPage = Math.ceil(TOTCNT / 200);
     }
     var pageLabel = $("<div style='font-size: 12px; margin: 2px 3px;  float: left;'></div>");
     pageLabel.text('Go to Page :');
     pageLabel.appendTo(element);
     self.pageLabel = pageLabel;
      
     var inputGoto = $("<div style='padding: 0px; margin: 0px 5px; float: left;'><input type='text' style='margin-left: 9px; width: 16px; height: 16px;'/></div>");
     inputGoto.find('div').addClass('goTo');
     inputGoto.width(55);
     inputGoto.jqxInput({});
     inputGoto.appendTo(element);	
     inputGoto.val(pageNum); //누른 값
     //console.log(firstNum + " of " + finalNum);
     var label = $("<div style='font-size: 12px; margin: 2px 3px;  float: left;'></div>");
         //label.text(firstNum +" - " + finalNum + ' of ' + TOTCNT + ' rows.');  
     	 label.text("/" + lastPage + " of " + TOTCNT + ' rows.');
         label.appendTo(element);
         self.label = label;          
         
     var leftButton = $("<div style='padding: 0px; margin: 0px 3px; float: left;'><div style='margin-left: 9px; width: 16px; height: 16px;'></div></div>");
          leftButton.find('div').addClass('jqx-icon-arrow-left');
          leftButton.width(36);
          leftButton.jqxButton({ });
          leftButton.appendTo(element);
             
      var rightButton = $("<div id='btn_right' style='padding: 0px; margin: 0px 3px; float: left;'><div style='margin-left: 9px; width: 16px; height: 16px;'></div></div>");
         rightButton.find('div').addClass('jqx-icon-arrow-right');
         rightButton.width(36);
         rightButton.jqxButton({ });
         rightButton.appendTo(element);
       
        rightButton.click(function () {
        	 if(pageNum != pagetot){
        	pageNum++;
          ///console.log("plus : "+pageNum);
          params.pageNum = pageNum;
           /// var params = {"plantcode":plantcode,"docclass1":docclass1,"docclass2":docclass2,"pageNum":pageNum}; 
        //  console.log(params.plantcode);
          getDocdb1List(params);
        	 }
       });

       leftButton.click(function () {
    	   if(pageNum != 1){
    	   pageNum--;
          //console.log("minus : "+pageNum);
          params.pageNum = pageNum;
          // var params = {"plantcode":plantcode,"docclass1":docclass1,"docclass2":docclass2,"pageNum":pageNum}; 
          getDocdb1List(params);
    	   }
       }); 

           if (pageNum == 1) { 
	             leftButton.jqxButton({disabled: true });
           }
           if(pageNum == pagetot) { 
	             rightButton.jqxButton({disabled: true });
	          } 

      //Enter 키 펑션
      inputGoto.keypress( function(e) {
         if (e.which == 13) { //13 == enter key@ascii 
            //alert("you pressed enter key");
        	 var inputpage = inputGoto.val();
        	 if (inputpage < (lastPage+1) && inputpage > 0){
             	 pageNum = inputGoto.val();
            	 params.pageNum = inputpage;
            	 getDocdb1List(params);
        	 }
         }
      });

      inputGoto.val(params.pageNum);     
       return element;
      }

     $("#mainlist").jqxGrid(
        {	 pageable: true,
            source:dataAdapter,
        	pagerrenderer: pagerrenderer,
           
        });
}
function getselectsGrDatas(grId){
	
	var rowindexes = $(grId).jqxGrid('getselectedrowindexes');
	if(rowindexes.length == 0){
		return rowindexes;
	}else{
		var data = new Array();
		for(var i = 0; i < rowindexes.length; i++){
			data[i] = $(grId).jqxGrid('getrowdata', rowindexes[i]);
		}
		return data;
	}
	
}

//
function funLoad(){
    var Cheight = $(window).height() - 95;
    $('#mainSplitter').jqxSplitter({height: Cheight});
    $('#main_tab').jqxTabs({ height: Cheight});
    $('#mainlist').jqxGrid({ height: Cheight});  
    //
	//var w = window.innerWidth;
	//var h = window.innerHeight-10;            
    //$('#vaultproperty').jqxWindow('resize', w, h);	
}
/*
$('#vaultproperty').on('resizing',
   function (event) {  
   	    var w = "99.8%";
   	    var h = window.innerHeight-10;            
        $('#vaultproperty').jqxWindow('resize', w, h);	   
    }
);
*/

function getDocdb1List(params){
	var source =
    {
    		datatype: "json",
            type:"POST",
            data: params,
            datafields: [
                        { name: 'DOCNO', type: 'string' },
                        { name: 'DOCTYPE', type: 'string' },
                        { name: 'DOCVERSION', type: 'int' },
                        { name: 'DOCFILENAME', type: 'string' },
                        { name: 'DOCFILETYPE', type: 'string' },
                        { name: 'DOCFILESIZE', type: 'int' },
                        { name: 'DOCDESC', type: 'string' },
                        { name: 'DOCPROADD', type: 'string' },
                        { name: 'DOCSTATUS', type: 'string' },
                        { name: 'DOCAPPSTATUS', type: 'string' },
                        { name: 'DOCSETNO', type: 'string' },
                        { name: 'DOCZIPFILENAME', type: 'string' },
                        { name: 'DOCGRADE', type: 'string' },
                        { name: 'DOCRETURN', type: 'string' },
                        { name: 'DOCCREATED', type: 'string' },
                        { name: 'DOCCREATOR', type: 'string' },
                        { name: 'DOCCREATORNAME', type: 'string' },
                        { name: 'DOCCREATORDEPT', type: 'string' },
                        { name: 'DOCUPDATED', type: 'string' },
                        { name: 'DOCUPDATOR', type: 'string' },
                        { name: 'DOCUPDFLAG', type: 'string' },
                        { name: 'DOCAPPRID', type: 'string' },
                        { name: 'DOCANALYZED', type: 'string' },
                        { name: 'VAULTLNO', type: 'string' },
                        { name: 'VLDOCNO', type: 'string' },
                        { name: 'DOCFACADDED', type: 'string' },
                        { name: 'DOCOPENCNT', type: 'int' },
                        { name: 'DOCANALYZEDCNT', type: 'int' },
                        { name: 'DOCVERMAX', type: 'string' },
                        { name: 'DOCUPDATORNAME', type: 'string' },
                        { name: 'DOCUPDATORDEPTCODE', type: 'string' },
                        { name: 'DOCUPDATORDEPTNAME', type: 'string' },
                        { name: 'DOCPRINTCNT', type: 'int' },
                        { name: 'DOCCREATORDEPTNAME', type: 'string' },
                        { name: 'DOCCREATORDEPTCODE', type: 'string' },
                        { name: 'RNUM', type:'int'},
                        { name: 'TOTCNT', type:'int'}
                     ],	
            id: "Docdb1List",
            url: "getDocdb1List.do",
    	};
	 
	    var cellsrenderer = function (row, columnfield, value, defaulthtml, columnproperties, rowdata) {
	        if (value < 20) {
	            return '<span style="margin: 4px; float: ' + columnproperties.cellsalign + '; color: #ff0000; ">' + value + '</span>';
	        } else {
	            return '<span style="margin: 4px; float: ' + columnproperties.cellsalign + '; color: #t; ">' + value + '</span>';
	        }
	    }
	    var dataAdapter = new $.jqx.dataAdapter(source, {
	        downloadComplete: function (data, status, xhr) { },
	        loadComplete: function (data) {},
	        loadError: function (xhr, status, error) {}
	    });

	    var self = this;
	     var pagerrenderer = function () {
          var TOTCNT;
          if(dataAdapter.recordids.length == 0){
       	   TOTCNT = 0;// 토탈 컬럼수
          }else{
       	   TOTCNT = dataAdapter.recordids[0].TOTCNT;// 토탈 컬럼수
          }
        var tempInt = 200; //page당 컬럼 수
        var pagetot = Math.ceil(TOTCNT / tempInt); // 토탈컬럼수 출력할 페이지 수 ex) 10  
        var element = $("<div style='margin-left: 10px; margin-top: 5px; width: 100%; height: 100%;'></div>");
         /*var datainfo = $("#gr_dwgcon2t").jqxGrid('getdatainformation'); */
          //console.log(paginginfo);
           
        var lastPage;
        if(TOTCNT % 200 == 0){
       	 lastPage = TOTCNT / 200;
        }else if(TOTCNT % 200 >= 1){
       	 lastPage = Math.ceil(TOTCNT / 200);
        }
        var pageLabel = $("<div style='font-size: 12px; float: left;'></div>");
        pageLabel.text('Go to Page :');
        pageLabel.appendTo(element);
        self.pageLabel = pageLabel;
         
        var inputGoto = $("<div style='padding: 0px; margin-bottom:3px;  float: left;'><input type='text' style='margin-left: 9px; margin-bottom:3px; width: 16px; height: 16px;'/></div>");
	        inputGoto.find('div').addClass('goTo');
	        inputGoto.width(55);
	        inputGoto.jqxInput({});
	        inputGoto.appendTo(element);	
	        inputGoto.val(pageNum); //누른 값

        //console.log(firstNum + " of " + finalNum);
        var label = $("<div style='font-size: 12px; float: left;'></div>");
            //label.text(firstNum +" - " + finalNum + ' of ' + TOTCNT + ' rows.');  
        	label.text("/" + lastPage + " of " + TOTCNT + ' rows.');
            label.appendTo(element);
            self.label = label;          
            
        var leftButton = $("<div style='padding: 0px; margin: 0px 3px; float: left;'><div style='margin-left: 9px; width: 16px; height: 16px;'></div></div>");
            leftButton.find('div').addClass('jqx-icon-arrow-left');
            leftButton.width(36);
            leftButton.jqxButton({ });
            leftButton.appendTo(element);
                
         var rightButton = $("<div id='btn_right' style='padding: 0px; margin: 0px 3px; float: left;'><div style='margin-left: 9px; width: 16px; height: 16px;'></div></div>");
            rightButton.find('div').addClass('jqx-icon-arrow-right');
            rightButton.width(36);
            rightButton.jqxButton({ });
            rightButton.appendTo(element);
          
            rightButton.click(function () {
	           	if(pageNum != pagetot){
	           	    pageNum++;
	                ///console.log("plus : "+pageNum);
	                params.pageNum = pageNum;
	                /// var params = {"plantcode":plantcode,"docclass1":docclass1,"docclass2":docclass2,"pageNum":pageNum}; 
	                //console.log(params.plantcode);
	                getDocdb1List(params);
	           	}
            });

            leftButton.click(function () {
	       	    if(pageNum != 1){
	       	        pageNum--;
	                //console.log("minus : "+pageNum);
	                params.pageNum = pageNum;
	                // var params = {"plantcode":plantcode,"docclass1":docclass1,"docclass2":docclass2,"pageNum":pageNum}; 
	                getDocdb1List(params);
	       	    }
            }); 

            if (pageNum == 1) { 
	             leftButton.jqxButton({disabled: true });
            }
            if(pageNum == pagetot) { 	  
	             rightButton.jqxButton({disabled: true });
	        } 

	        //Enter 키 펑션
	        inputGoto.keypress( function(e) {
	            if (e.which == 13) { //13 == enter key@ascii 
	               //alert("you pressed enter key");
	           	var inputpage = inputGoto.val();
	           	if (inputpage < (lastPage+1) && inputpage > 0){
	             	 pageNum = inputGoto.val();
	            	 params.pageNum = inputpage;
	            	 getDocdb1List(params);
	           	}
	            }
	        });

            inputGoto.val(params.pageNum);
        
            return element;
        }

        $("#mainlist").jqxGrid({	
       	    pagerheight: 27,
            pageable: true,
            source:dataAdapter,
        	pagerrenderer: pagerrenderer,
        	theme: theme
        });
}

/*resize
$(window).resize(function(event){
	$('#vaultproperty').on('resizing',
	   function (event) {  
	   	    var w = "99.8%";
	   	    var h = window.innerHeight-10;            
            $('#vaultproperty').jqxWindow('resize', w, h);	   
	    }
	); 
	//$("#vaultproperty").jqxWindow({ position:"center" });	
});*/
   

</script>
</head>

<body>
	<div id="winm" style="max-width:100%; margin: -2px; ">
		<div id="sys_head">
			<div id="head_top" style="height: 27.5px; border-bottom: 1px solid lightgray; " >
				 <img alt="" src="images/uk.png" style="float: left; margin-top: 6px; margin-left: 2px;"> 
				 <font style="font-size: 12px; float: left; margin-top: 5px; margin-left: 2px; ">iTIMS - integrated Technical Information Solution v3.0.1</font>
				 <font style="font-size: 12px; text-align: center; margin-right:45px; float:right; margin-top: 5px;">Login: ${loginInfo.userno } ${loginInfo.username }</font> 
			</div><!-- head_top END -->
			
			<div id="head_bot" style="height: 27.5px;">
				<table width="100%" style="vertical-align: middle; margin-top: 1.5px;">
					<tr>
						<td width="15px"></td><td style="font-size: 12px;" width="15px">.viewtype</td>
						<td width="15px"><div id="cb_main_newtype" style="font-size: 11px;" ></div></td>
						<td>
							<input type="button" class="button" id="btn_main_close" style="float: right; margin-right: 3px;" value="close">
							<input type="button" class="button" id="btn_main_1" style="float: right; margin-right: 3px;" value="1">
							<input type="button" class="button" id="btn_main_2" style="float: right; margin-right: 3px;" value="2">
							<input type="button" class="button" id="btn_main_3" style="float: right; margin-right: 3px;" value="3">
							<input type="button" class="button" id="btn_main_4" style="float: right; margin-right: 3px;" value="4">
							<input type="button" class="button" id="btn_main_5" style="float: right; margin-right: 3px;" value="5">
						</td>
					</tr>
				</table>
			</div><!-- head_bot END -->
		</div><!-- sys_head END -->
		
		<div id="sys_main" >
			<div id="mainSplitter">
	            <div class="splitter-panel">
	                <div id="main_tab">
						<ul>
							<li style=""><img alt="" src="images/pinned-blue.png" style="float: left; margin-top: 2px;">1.기술자료</li>
							<li style=""><img alt="" src="images/pinned-blue.png" style="float: left; margin-top: 2px;">2.기술자료</li>
							<li style=""><img alt="" src="images/pinned-blue.png" style="float: left; margin-top: 2px;">3.프로세스</li>
							<li style=""><img alt="" src="images/pinned-blue.png" style="float: left; margin-top: 2px;">4.결재검색</li>
						</ul>
						<div id="tv_announce"></div>
						<div id="tv_summury"></div>
						<div id="tv_vault"></div>
						<div id="tv_query"></div>
					</div>
	            </div>
	            <div class="splitter-panel">
	                <div id="mainlist"></div>
	            </div>
        	</div>
		</div><!-- sys_main END -->
	</div> <!-- bottom div End Winm -->

	<div id="sys_bot" style="max-width:100%; height:auto;  border: 1px solid lightgray ; margin: -2px; margin-top: 5px;">　
			<div id="bottom_msg" style="width:auto; float: left; font-size: 12px;" >msg</div>
			<div id="progress" style="float: left;">
				<div id="bar"></div>
				<div id="percent"></div>
			</div>
			<div id="bottom_time" style="width:auto; float: right; font-size: 14px;">now</div>
	</div>
	
	<!-- 트리 ContextMenu div -->
	<div id='menu_tv' style="display: none">
		<ul>
			<li id="Root Create"><img style='float: left; margin-right: 5px;'
				src='images/mailIcon.png' /><span>Root Create</span></li>
			<li id="Create"><img style='float: left; margin-right: 5px;'
				src='images/calendarIcon.png' /><span>Create</span></li>
			<li id="Update"><img style='float: left; margin-right: 5px;'
				src='images/contactsIcon.png' /><span>Update</span></li>
			<li id="Delete"><img style='float: left; margin-right: 5px;'
				src='images/folder.png' /><span>Delete</span></li>
			<li id="Property"><img style='float: left; margin-right: 5px;'
				src='images/settings.png' /><span>Property</span></li>
		</ul>
	</div>
	
	<!-- 트리 루트 생성 div --> 
	<div id="vaultrootcreate" style="display: none">
		<div class = "header_bar">
			<img src="images/usa.png" alt="" style="margin-top: 3px; margin-right: 5px; height: 12px" />iTIMS -	vault information management
		</div>
		<div style="overflow: auto;">
			<table cellspacing="3px" style="padding-right: 18px; margin-top: 10px; padding-left: 35px;">
				<tr>
					<td align="right">VAULTL NAME:</td>
					<td align="left"><input type="text" id="vaultlName" /></td>
				</tr>
				<tr>
					<td align="right">CLASSIFY:</td>
					<td align="left"><input type="text" id="vaultlDesc" /></td>
				</tr>
				<tr>
					<td align="right">DOC DBNAME:</td>
					<td align="left"><div id='cb_docdbname'></div></td>
				</tr>
				<tr>
					<td align="right">SUB DBNAME:</td>
					<td align="left"><div id='cb_subdbname'></div></td>
				</tr>
				<tr>
					<td align="right">STORAGE NO:</td>
					<td align="left"><div id='cb_storageno'></div></td>
				</tr>
				<tr>
					<td colspan='2' style="padding-top: 7px; padding-left: 101px;" align="left">
					    <input type="button" class="button" value="Save" id='SaveR' style="display: inline-block;" /> 
						<input type="button" class="button" value="Close" id='CancelR' style="display: inline-block;" /></td>
				</tr>
			</table>
			<div class = "bottom_bar" id="msg" style="padding-left:20px;">add valut data...</div>
			</div>
	</div>

	<!-- 트리 삭제 div -->
	<div id="vaultdelete" style="display: none">
		<div class = "header_bar"><img src="images/usa.png" alt="" style="margin-top: 3px; margin-right: 5px; height: 12px" />iTIMS - vault information management</div>
		<div style="overflow: auto;">
			<table cellspacing="3px" style="padding-right: 20px; margin-top: 10px; padding-left: 20px;">
				<tr>
					<td colspan="2" align="center">정말 삭제하시겠습니까 ?</td>
				</tr>
				<tr>
					<td style="padding-top: 25px;" align="center"><input type="button" class="button" value="OK" id='OK_D' /></td>
					<td style="padding-top: 25px;" align="center"><input type="button" class="button" value="Close" id='CancelD' /></td>
				</tr>
			</table>
			<div class = "bottom_bar" id="msg">please add valut data...</div>
		</div>
	</div>
	
	
	<!-- 트리 생성 div -->
	<div id="vaultcreate" style="display: none">
		<div class = "header_bar"><img src="images/usa.png" alt="" style="margin-top: 3px; margin-right: 5px; height: 12px"/>iTIMS - vault information management</div>
		<div style="overflow: auto;">
			<table cellspacing="3px" style="padding-right: 18px; margin-top: 10px; padding-left: 35px;">
				<tr>
					<td align="right">PARENT VAULT:</td>
					<td align="left"><input type="text" id="vaultlNamePC" readonly />
					</td>
				</tr>
				<tr>
					<td align="right">VAULTL NAME:</td>
					<td align="left"><input type="text" id="vaultlNameC" /></td>
				</tr>
				<tr>
					<td align="right">CLASSIFY:</td>
					<td align="left"><input type="text" id="vaultlDescC" /></td>
				</tr>
				<tr>
					<td align="right">DOC DBNAME:</td>
					<td align="left"><input type="text" id="cb_docdbnameC" readonly /></td>
				</tr>
				<tr>
					<td align="right">SUB DBNAME:</td>
					<td align="left"><input type="text" id="cb_subdbnameC" readonly /></td>
				</tr>
				<tr>
					<td align="right">STORAGE NO:</td>
					<td align="left"><input type="text" id="cb_storagenoC" readonly /></td>
				</tr>
				<tr>
					<td colspan='2' style="padding-top: 7px; padding-left: 107px;" align="left">
						<input type="button" class="button" value="Save" id='SaveC' />
						<input type="button" class="button" value="Close" id='CancelC' />
					</td>
				</tr>
			</table>
			<div class = "bottom_bar" id="msg" style="padding-left:20px;">add valut data...</div>
		</div>
	</div>
	
	<!-- 트리 수정 div -->
	<div id="vaultupdate" style="display: none">
		<div class = "header_bar">
			<img src="images/usa.png" alt="" style="margin-top: 3px; margin-right: 5px; height: 12px" />iTIMS - vault information management
		</div>
		<div style="overflow: auto;">
			<table cellspacing="3px" style="padding-right: 18px; margin-top: 10px; padding-left: 35px;">
				<tr>
					<td align="right">VAULTL NAME:</td>
					<td align="left"><input type="text" id="vaultlNameU" /></td>
				</tr>
				<tr>
					<td align="right">CLASSIFY:</td>
					<td align="left"><input type="text" id="vaultlDescU" /></td>
				</tr>
	
				<tr>
					<td align="right">DOC DBNAME:</td>
					<td id="updateDOC" align="left"></td>
				</tr>
	
				<tr>
					<td align="right">SUB DBNAME:</td>
					<td id="updateSUB" align="left"></td>
				</tr>
	
				<tr>
					<td align="right">STORAGE NO:</td>
					<td id="updateSTR" align="left"></td>
				</tr>
	
				<tr>
					<td colspan='2' style="padding-top: 7px; padding-left: 101px;" align="left">
						<input type="button" class="button" value="Save" id='UpdateU' /> 
						<input type="button" class="button" value="Close" id='CancelU' />
					</td>
				</tr>
			</table>
			<div class = "bottom_bar" id="msg" style="padding-left:20px;">...</div>
		</div>
	</div>
	
	<!-- 트리 정보 div -->
	<div id="vaultproperty" style="display: none">
		<div class = "header_bar"><img src="images/usa.png" alt="" style="margin-top: 3px; margin-right: 8px; height: 12px"/>iTIMS - vault information management</div>
		<div style="overflow: auto;">
			<table cellspacing="3px" style="padding-right: 18px; margin-top: 10px; padding-left: 40px;">
				<!-- 			<tr>
					<td align="right">VAULTL NO:</td>
					<td align="left"><input type="text" id="vaultlNoP"  readonly/></td>
				</tr> -->
				<tr>
					<td align="right">VAULTL NAME:</td>
					<td align="left"><input type="text" id="vaultlNameP" readonly /></td>
				</tr>
				<tr>
					<td align="right">VAULTL KIND:</td>
					<td align="left"><input type="text" id="vaultlKindP" readonly /></td>
				</tr>
				<tr>
					<td align="right">CLASSIFY:</td>
					<td align="left"><input type="text" id="vaultlDescP" readonly /></td>
				</tr>
				<tr>
					<td align="right">DOC DBNAME:</td>
					<td align="left"><input type="text" id="docdbNameP" readonly /></td>
				</tr>
				<tr>
					<td align="right">SUB DBNAME:</td>
					<td align="left"><input type="text" id="subdbNameP" readonly /></td>
				</tr>
				<tr>
					<td align="right">STORAGE NO:</td>
					<td align="left"><input type="text" id="storageNoP" readonly /></td>
				</tr>
				<tr>
					<td align="right">CREATOR:</td>
					<td align="left"><input type="text" id="creatorP" readonly /></td></tr>
				<tr>
					<td align="right">CREATED:</td>
					<td align="left"><input type="text" id="createdP" readonly /></td></tr>
				<tr>
					<!-- <td colspan='2' style="padding-top: 25px; padding-left: 45px;" align="center"> -->
					<td colspan="2" style="padding-top: 7px; padding-left: 100px;" align="left">
						<input type="button" class="button" value="Save" id='SaveP' /> 
						<input type="button" class="button" value="Close" id="CancelP"/>
					</td>
				</tr>
			</table>
			<div class = "bottom_bar" id="msg" style="padding-left:20px;">valut data...</div>
		</div>
	</div>
	
	<div id="menu_lv">
		<ul>
			<!-- <i>Edit Selected Row</li>-->
			<li id="Column Action"><img style='float: left; margin-right: 5px;' src='images/mailIcon.png' /><span>Show/Hide Column</span>
				<ul>
					<li id="chkBox"><input type="checkbox" name="chk" value="docNo">자료번호<li>
					<li id="chkBox"><input type="checkbox" name="chk" value="docZipFileName">시스템파일명<li>			
				</ul>
			</li>
			<li id="Create Doc"><img style='float: left; margin-right: 5px;' src='images/mailIcon.png' /><span>Create Doc</span></li>
			<li id="Update Doc"><img style='float: left; margin-right: 5px;' src='images/calendarIcon.png' /><span>Update Doc</span></li>
			<li id="Delete Doc"><img style='float: left; margin-right: 5px;' src='images/folder.png' /><span>Delete Doc</span></li>
			<li id="Properties Doc"><img style='float: left; margin-right: 5px;' src='images/settings.png' /><span>Properties Doc</span></li>
			<li id="Download Doc"><img style='float: left; margin-right: 5px;' src='images/folder.png' /><span>Download Doc</span></li>
			<li id="Open Set" style="margin-top: 5px;"><img style='float: left; margin-right: 5px;' src='images/mailIcon.png' /><span>Open Set</span></li>
			<li id="Create Set"><img style='float: left; margin-right: 5px;' src='images/calendarIcon.png' /><span>Create Set</span></li>
			<li id="Update Set"><img style='float: left; margin-right: 5px;' src='images/contactsIcon.png' /><span>Update Set</span></li>
			<li id="Delete Set"><img style='float: left; margin-right: 5px;' src='images/settings.png' /><span>Delete Set</span></li>
			<li id="Find" style="margin-top: 7px;"><img style='float: left; margin-right: 5px;' src='images/mailIcon.png' /><span>Find</span></li>
			<li id="General Comment Viewing"><img style='float: left; margin-right: 5px;' src='images/calendarIcon.png' /><span>General Comment Viewing</span></li>
			<li id="Change History Viewing"><img style='float: left; margin-right: 5px;' src='images/contactsIcon.png' /><span>Change History Viewing</span></li>
			<li id="Open Viewing" style="margin-top: 7px;"><img style='float: left; margin-right: 5px;' src='images/folder.png' /><span>Open Viewing</span>
				<ul>
					<li id="Open server"><img style='float: left; margin-right: 5px;' src='images/settings.png' /><span>Open server</span><li>
					<li id="Open local"><img style='float: left; margin-right: 5px;' src='images/mailIcon.png' /><span>Open local</span><li>		
				</ul>	
			</li>
			<li id="Open Editing Only"><img style='float: left; margin-right: 5px;' src='images/settings.png' /><span>Open Editing Only</span></li>
			<li id="Open Editing Version"><img style='float: left; margin-right: 5px;' src='images/settings.png' /><span>Open Editing Version</span></li>
			<li id="Check Out"><img style='float: left; margin-right: 5px;' src='images/calendarIcon.png' /><span>Check Out</span></li>
			<li id="Check In"><img style='float: left; margin-right: 5px;' src='images/contactsIcon.png' /><span>Check In</span></li>
			<li id="Free" style="margin-top: 7px;"><img style='float: left; margin-right: 5px;' src='images/settings.png' /><span>Free</span></li>
		</ul>
	</div>
	
	
<!-- D_QUERY, FIND -->
<div id="docsearch_winm" style="display: none; border: 1px solid #C1B4F7; width: 1000px;"> 	
	<div class = "header_bar" id="docsearch_head_sys" style="width:100%; height: 15px; border-bottom: 1px solid lightgray; ">
	    <img src="images/uk.png" alt="" style="float: left; margin-top: 2px; margin-left: 2px; height: 14px"/> 
		<font style="margin-left: 4px; vertical-align: text-bottom;" size="1" face="verdana" color="maroon">find - search management</font>
	</div>	
	<div id="docsearch_main" style="margin-top: 1x; margin-right: 2px; margin-left: 2px; border-bottom: 1px solid lightgray; ">
		<div id="docsearch_mainSplitter">
	            <div class="splitter-panel" style = "overflow-y:auto;">
	                <div id="docsearch_main_tab">
						<ul>
							<li style=""><img alt="" src="images/pin.png" style="float: left; margin-top: 4px;">1.기술자료</li>
							<li style=""><img alt="" src="images/pin.png" style="float: left; margin-top: 4px;">2.기술자료</li>
							<li style=""><img alt="" src="images/pin.png" style="float: left; margin-top: 4px;">3.프로세스</li>
							<li style=""><img alt="" src="images/pin.png" style="float: left; margin-top: 4px;">4.결재검색</li>
						</ul>
						<div id="docsearch_tv_announce"></div>
						<div id="docsearch_tv_summury"></div>
						<div id="docsearch_tv_vault"></div>
						<div id="docsearch_tv_query"></div>
					</div>
	            </div>
	            <div class="splitter-panel">
	            	<table  style="margin-top:5px; margin-left:5px;" >
	            		<tr>
	            			<td style="font-size: 12px; width: 50px;" align='right'>조회조건</td>
	            			<td colspan="3">
		            			<div id="docsearch_radiogroup">
		            				<button style="background-color: white; margin-right: 1em;" id="rb_docsearch_all">전체</button>
	            					<button style="background-color: white; margin-right: 1em;" id="rb_docsearch_selectvault_below">선택하위폴더포함</button>
	            		 			<button style="background-color: white; margin-right: 1em;" id="rb_docsearch_selectvault">선택폴더</button>
		            			</div>
	            			</td>
	            		</tr>
						<tr style="height: 20px;">
					  		<td style="font-size: 12px;" align='right'>자료제목</td>
							<td><input type="text" id="e_docsearch_docdesc"></td>
							<td style="font-size: 12px;" align='right'>자료명</td>
							<td><input type="text" id="e_docsearch_docname"></td>						
						</tr>
						<tr style="height: 20px;">
							<td style="font-size: 12px;" align='right'>파일명</td>
							<td><input type="text" id="e_docsearch_filename"></td>
							<td style="font-size: 12px;" align='right'>등록일</td>
							<td>
			<!-- 				<input type="text" id="e_docsearch_propdate1">~ -->
			<!-- 				<input type="text" id="e_docsearch_propdate2"> -->
							<div id='e_docsearch_propdate1' style="margin-left:0px; display: inline-block;"></div>
							<span style="vertical-align: super;"> ~ </span>
							<div id='e_docsearch_propdate2' style="display: inline-block;"></div>
							</td>							
						</tr>
						<tr>
							<td style="font-size: 12px;" align='right'>공장명</td>
							<td><div id="cb_docsearch_plantcode"></div></td>
							<td style="font-size: 12px;" align='right'>등록자</td>
							<td><input type="text" id="e_docsearch_creator"></td>
						</tr>
					</table>
	            </div>
	    </div>
		
		<button id="btn_docsearch_gry" class="button" style="margin-top:10px; margin-left:320px;">Search</button>
		<button id="btn_docsearch_close" class="button" >Close</button>
        
        <div class = "bottom_bar" id="docsearch_msg" style="padding-left:20px;">...</div></div>
	</div>
</div>


<div id="edit_winm" style="display:none; border: 1px solid gold; width: 1000px;"> 
	<!-- Header DIV -->
	<div id="edit_head_sys" style="width:100%; height: 20px; border-bottom: 1px solid lightgray;"> 
		<font style="float: left; margin-left: 9px;  margin-top: 7px;  " size="2"> Edit - 자료수정</font>
	</div>
	<!-- Main Div -->
	<div id="edit_main" style="">
		<table  style="margin-top:5px;" >		
			<tr style="height: 20px;">
				<td style="font-size: 11px;" align='right'>자료번호</td>
				<td><input type="text" id="e_edit_docno" readonly></td>
				<td style="font-size: 11px;" align='right'>기술자료명</td>
				<td><input type="text" id="e_edit_docname" readonly></td>
			</tr>
			<tr>
				<td style="font-size: 11px;" align='right'>기술자료제목</td>
				<td colspan="3"><input type="text" id="e_edit_docdesc" readonly></td>
			</tr>
			<tr style="height: 20px;">
				<td style="display:none;"><input type="text" id="e_edit_docver"></td>
				<td style="display:none;"><input type="text" id="e_edit_filename"></td>
				<td style="display:none;"><input type="text" id="e_edit_filepath"></td>
				<td style="display:none;"><input type="text" id="e_edit_vaultlno"></td>
				<td style="display:none;"><input type="text" id="e_edit_dbname"></td>
				<td style="display:none;"><input type="text" id="e_edit_checkOnly"></td>
		  		<td style="font-size: 11px;" align='right'>수정제목</td>
				<td colspan="3"><input type="text" id="e_edit_projectname"></td>
			</tr>
			<tr style="height: 20px;">
				<td style="font-size: 11px;" align='right'>수정내용</td>
				<td colspan="3" ><textArea id="e_edit_histcontent"></textArea>
			</tr>
		</table>
		<button id="btn_edit_save" style="margin-top:10px; margin-left:200px;">저장</button>
		<button id="btn_edit_cancel">취소</button>
	</div>
</div>
	
</body>

</html>