<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<style type="text/css">
 .jqx-tabs-title{height: 11px; width: 50px;} 
</style>
<script type="text/javascript">
window.focus();
var pageNum  = 1;

$(document).ready(function() {

	//$("#find_head_sys").jqxMenu({ width: '100%', height: 30 });
	$("#find_main_cond").jqxPanel({ width: '100%',rtl:true, height:85, theme:theme});

	
	$("#cb_find_plantcode").jqxDropDownList({ source: ["Delta Korea","Delta English","Delta Japan"], selectedIndex: 0, width: '33%' ,autoDropDownHeight: true, theme:theme});
  		
	
	$("#e_find_docdesc").jqxInput({
		height : 25,
		width : '80%',
		minLength : 1,
		theme:theme
	});
	
	$("#e_find_docname").jqxInput({
		height : 25,
		width : '80%',
		minLength : 1,
		theme:theme
	});
	
	$("#e_find_filename").jqxInput({
		height : 25,
		width : '80%',
		minLength : 1,
		theme:theme
	});
	
// 	$("#dt_find_propdate1").jqxInput({
// 		height : 25,
// 		width : '37%',
// 		minLength : 1,
// 	});
	
// 	$("#dt_find_propdate2").jqxInput({
// 		height : 25,
// 		width : '37%',
// 		minLength : 1,
// 	});
	
	$("#dt_find_propdate1").jqxDateTimeInput({formatString: "yyyyMMdd", width: '100px', height: '25px', theme:theme});
	$("#dt_find_propdate2").jqxDateTimeInput({formatString: "yyyyMMdd", width: '100px', height: '25px', theme:theme});
	
	$("#dt_find_propdate1").jqxDateTimeInput('setDate', getLastyear());
	
	$("#e_creator").jqxInput({
		height : 25,
		width : '32%',
		minLength : 1,
		theme:theme
	});
	
	$("#btn_find_gry").jqxButton({ 
		width: 45, 
		height: 23, 
		theme:theme
		});
	
	$("#btn_find_add").jqxButton({ 
		width: 50, 
		height: 23, 
		theme:theme
		});
	$("#btn_find_close").jqxButton({ 
		width: 50, 
		height: 23, 
		theme:theme
	});
	
	$("#gr_find_docdb").jqxGrid(
           {
               width: '100%', //1525
               height: 360,
               pageable: false,
               sortable: true,
               altrows: true, //행 마다 색상구별
			   editable: false,
               pageSize: 200,
               enabletooltips: true,
               columnsresize: true,
			   selectionmode:  'checkbox',
			   enablebrowserselection : true,
			   theme:theme,
               columns: [
                { text: '번호', datafield: 'RNUM', width:'5%'},
                 { text: '기술자료명',datafield: 'DOCNAME',width:'10%'},
				{ text: '기술자료제목',datafield: 'DOCDESC',width:'10%'},
				{ text: '자료번호', datafield: 'DOCNO', width:'15%'},
				{ text: '자료버전',  datafield: 'DOCVERSION',width:'10%'},
				{ text: '자료타입',datafield: 'DOCTYPE',width:'10%'},
				{ text: '시스템파일이름', datafield: 'DOCZIPFILENAME',width:'10%'},
				{ text: '파일이름', datafield: 'DOCFILENAME',width:'10%'},
				{ text: '파일타입',datafield: 'DOCFILETYPE',width:'10%'},
				{ text: '파일사이즈',datafield: 'DOCFILESIZE',width:'10%'},
				{ text: '최종버젼', datafield: 'DOCVERMAX',width:'10%'},
				{ text: '오픈횟수',  datafield: 'DOCOPENCNT',width:'10%'},
				{ text: '출력횟수', datafield: 'DOCPRINTCNT',width:'10%'},
				{ text: '프로세스등록여부', datafield: 'DOCPROADD',width:'10%'},
				{ text: '자료상태',  datafield: 'DOCSTATUS',width:'10%'},
				{ text: '자료프로세스상태',  datafield: 'DOCAPPSTATUS',width:'10%'},
				{ text: '집합번호',  datafield: 'DOCSETNO',width:'10%'},
				{ text: '자료등급',  datafield: 'DOCGRADE',width:'10%'},
				{ text: '자료반송상태', datafield: 'DOCRETURN', align:'center',width:'10%'},
				{  text: '생성일',  datafield: 'DOCCREATED',width:'10%'},
				{ align:'center',  text: '생성자ID',  datafield: 'DOCCREATOR',width:'10%'},
				{ align:'center',  text: '생성자이름',  datafield: 'DOCCREATORNAME',width:'10%'},
				{  text: '생성자부서코드',  datafield: 'DOCCREATORDEPTCODE',width:'10%'},
				{  text: '생성자부서이름',  datafield: 'DOCCREATORDEPTNAME',width:'10%'},
				{  text: '수정일',  datafield: 'DOCUPDATED',width:'10%'},
				{ align:'center',  text: '수정자ID',  datafield: 'DOCUPDATOR',width:'10%'},
				{ align:'center',  text: '수정자이름',  datafield: 'DOCUPDATORNAME',width:'10%'},
				{  text: '수정자부서코드',  datafield: 'DOCUPDATORDEPTCODE',width:'10%'},
				{  text: '수정자부서이름',  datafield: 'DOCUPDATORDEPTNAME',width:'10%'},
				{  text: '수정상태FLAG',  datafield: 'DOCUPDFLAG',width:'10%'},
				{  text: '결재지정자',  datafield: 'DOCAPPRID',width:'10%'},
				{  text: '분석대상여부',  datafield: 'DOCANALYZEKIND',width:'10%'},
				{  text: '분석일자',  datafield: 'DOCANALYZED',width:'10%'},
				{  text: '볼트NO',  datafield: 'VAULTLNO',width:'50%'},
				{  text: '볼트자료번호',  datafield: 'VLDOCNO',width:'65%'}
               ],
       });
	


	/*  */
	$('#btn_find_gry').on('click',function(){ 
		var docdesc =$("#e_find_docdesc").val(), docname=$("#e_find_docname").val(), docfilename=$("#e_find_filename").val(),
		propdate1=$("#dt_find_propdate1").val(), propdate2=$("#dt_find_propdate2").val(), creator=$("#e_creator").val();
		
		console.log(docdesc);
		var params = {"docdesc":docdesc, "docname":docname, "docfilename":docfilename, "propdate1":propdate1,
				"propdate2":propdate2, "creator":creator, "pageNum":1, "docdbname":"D_DOCDB1" };
	
	 	 getDocdb1List(params);
	});
	
	$('#btn_find_add').on('click',function(){ 
		console.log(clickedItemList);
		var checkFileName = true;  // 파일명 중복체크 중복시 버튼생성x
		var indexes = $("#gr_find_docdb").jqxGrid('getselectedrowindexes');
		var data;
		for(var i =0; i<indexes.length; i++){
			filebtnIdNo++;
			data = $("#gr_find_docdb").jqxGrid('getrowdata', indexes[i]);
			
			var vaultno = data.VAULTLNO;
			var docno = data.DOCNO;
			var docfilename = data.DOCFILENAME;
			
			var existfile = getExistFile(vaultno, docfilename);
			
			console.log(existfile);
			
			if(!existfile.checkExistFile){
				msg1("파일이 존재하지 않습니다.");
				return;
			}
			
			 for(var j = 0; j < fileObjectList.length; j++){  // 파일명 중복체크
     			if(docfilename == fileObjectList[j][1]){
     				checkFileName = false;
     			}
     		 }
     		 if(!checkFileName){
     			msg1(docfilename + "은 이미 있습니다.");
     			 continue;
     		 }

			var exts = getExtensionOfFilename(docfilename); //확장자 가져오기
   		 	var src = getImgsrcOfExtension(exts);    //버튼 이미지생성
   		 	
   			var btnid = "btn_attachfile"+filebtnIdNo;
   		 	
	   		var html = "<button id='"+btnid+"' title='"+docfilename+"'>";
			html += "<img class='btn-img'"
			html += " src="+src+" alt='xx'></button>";
			
			$("#div_btnfile").append(html);
			
			$("#"+btnid+"").jqxButton({ 
				width: 20, 
				height: 20, 
			});
			$("#"+btnid+"").css("margin-left", "5px");
			
			var filestatus = ["", docfilename, "find", "", existfile.storagepath];
			fileObjectList.push(filestatus);
			
			$("#"+btnid+"").on('click',function(){ 
				var fileName = $(this).attr('title');
				//var filePath = "D://AttachFile";
				console.log(radioValue);
				if(radioValue == "delete"){        // delete
					$("#"+$(this).attr('id')+"").css( "display", "none" );
					for (var i = 0; i < fileObjectList.length; i++) {
						if(fileObjectList[i][1] == fileName){
							fileObjectList[i][3] = "Y";
						}
					}
				}else{      // open
					fileOpen(fileName, existfile.storagepath);
				}
			});
		} // for end
	})
	
	$('#btn_find_close').on('click',function(){ 
		$("#find_winm").jqxWindow('close');
	});
	
	cellclick($("#gr_find_docdb"))
	
	
	 $('#gr_find_docdb').on('rowdoubleclick', function (event) 
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
	    
	    var data = $('#gr_find_docdb').jqxGrid('getrowdata', boundIndex);

		docOpen(data.DOCNO, data.VAULTLNO, data.DOCFILENAME);
	});

}); // End Ready Function

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
	        	   console.log("1page임");
		             leftButton.jqxButton({disabled: true });
	           }
	           if(pageNum == pagetot) { 
	        	     console.log("없음");
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
     $("#gr_find_docdb").jqxGrid(
        {	
        	pagerheight: 27,
            pageable: true,
            source:dataAdapter,
        	pagerrenderer: pagerrenderer,
        	theme:theme
           
        });
}

function getExistFile(vaultlno, docfilename){
	var rtndata = "";
	$.ajax({
		url : "getExistFile.do",
		type : "POST",
		dataType : "json",
		data : {"vaultlno" :vaultlno, "docfilename" :docfilename},
        async : false,
		success : function(data, status,XHR){
			rtndata = data;
		},
		error : function(data, status){
		},
		complete : function(data){
			return data;
		}
	});
	
	return rtndata;
}
</script>
<div id="find_winm" style="max-width:100%; margin: -2px; display:none;">
	<div>
		<!-- Main Div -->
		<div id="find_main_cond" style="border:1px solid lightgray;">	
			<table  style="width: 98%; margin-top:5px;" >
				<tr style="height: 20px;">
			  		<td style="font-size: 11px; width: 3%;" align='right'>자료제목</td>
					<td style="width: 20%"><input type="text" id="e_find_docdesc"></td>
					<td style="font-size: 11px; width: 2%;" align='right'>자료명</td>
					<td style="width: 20%"><input type="text" id="e_find_docname"></td>
					<td style="font-size: 11px; width: 2%;" align='right'>공장명</td>
					<td style="width: 20%"><div id="cb_find_plantcode"></div></td>
				</tr>
				<tr style="height: 20px; ">
					<td style="font-size: 11px; width: 2%;" align='right'>파일명</td>
					<td style="width: 20%"><input type="text" id="e_find_filename"></td>
					<td style="font-size: 11px; width: 2%;" align='right'>등록일</td>
					<td style="width: 20%">
					<div id='dt_find_propdate1' style="margin-left:0px; display: inline-block;"></div><span style="vertical-align: super;"> ~ </span>
					<div id='dt_find_propdate2' style="display: inline-block;"></div>
					</td>
			
					<td style="font-size: 11px; width: 2%;" align='right'>등록자</td>
					<td style="width: 20%">
						<input type="text" id="e_creator">
						<button id="btn_find_gry" style="margin-left:5px;">조회</button>
						<button id="btn_find_add">첨부</button>
						<button id="btn_find_close">close</button>
					</td>
	
				</tr>
			</table>
		</div><!-- End find_main_cond  -->
		
		<div id="gr_find_docdb">
		</div>
	
		<div id="find_bottom" style="max-width:100%; height:auto;  border: 1px solid lightgray; margin: -2px; margin-top: 5px;">　
				<div id="find_bottom_msg" style="width:auto; float: left;" >msg</div>
				<div id="find_progress" style="float: left;">
					<div id="find_bar"></div>
					<div id="find_percent"></div>
				</div>
				<div id="find_bottom_time" style="width:auto; float: right; font-size: 14px">now</div>
		</div>
	</div>
 </div><!-- End find_winm -->
 