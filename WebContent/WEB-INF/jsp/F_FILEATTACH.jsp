<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<style type="text/css">
 .jqx-tabs-title{height: 11px; width: 50px;} 
 #fileattach_progress { position:relative; width: 70%;
                height: 17px;
                border: 1px solid #ddd;
                border-radius: 3px; 
                overflow: hidden;
                display:inline-block;
                margin:0px 10px 5px 5px;
                }
       
#fileattach_bar { background-color: #64c657; width:0%; height:20px; border-radius: 3px; }
#fileattach_percent { position:absolute; display:inline-block; top:3px; left:48%; }
</style>
<script type="text/javascript">
window.focus();
var pageNum  = 1;

$(document).ready(function() {
	console.log(selectedDocno);
	//$("#rbtn_open").jqxRadioButton({checked: true});
	//$("#fileattach_sys_head").jqxMenu({ width: '100%', height: 30 });
	$("#fileattach_main_cond").jqxPanel({ width: '100%',rtl:true, height:80});

	$("#e_fileattach_docno").jqxInput({
		height : 25,
		width : '80%',
		minLength : 1,
		theme:theme
	});
	
	$("#e_fileattach_docname").jqxInput({
		height : 25,
		width : '80%',
		minLength : 1,
		theme:theme
	});

	
	$("#btn_fileattach_checkin").jqxButton({ 
		width: 80, 
		height: 25,
		textImageRelation: "imageBeforeText", 
		textPosition: "left", 
		imgPosition:"left",
		imgSrc: "images/administrator.png" ,
		theme:theme
	 });

	$("#btn_fileattach_fileadd").jqxButton({ 
		width: 80, 
		height: 25,
		textImageRelation: "imageBeforeText", 
		textPosition: "left", 
		imgPosition:"left",
		imgSrc: "images/administrator.png" , 
		theme:theme
	});
	$("#btn_fileattach_xlsdown").jqxButton({ 
		width: 80, 
		height: 25,
		textImageRelation: "imageBeforeText", 
		textPosition: "left", 
		imgPosition:"left",
		imgSrc: "images/administrator.png" ,
		theme:theme
	});
	$("#btn_fileattach_filedelete").jqxButton({ 
		width: 80, 
		height: 25,
		textImageRelation: "imageBeforeText", 
		textPosition: "left", 
		imgPosition:"left",
		imgSrc: "images/administrator.png" ,
		theme:theme
	});
	$("#btn_fileattach_filestory").jqxButton({ 
		width: 80, 
		height: 25,
		textImageRelation: "imageBeforeText", 
		textPosition: "left", 
		imgPosition:"left",
		imgSrc: "images/administrator.png" ,
		theme:theme
	});
	$("#btn_fileattach_fileopen").jqxButton({ 
		width: 80, 
		height: 25,
		textImageRelation: "imageBeforeText", 
		textPosition: "left", 
		imgPosition:"left",
		imgSrc: "images/administrator.png" ,
		theme:theme
	});
	$("#btn_fileattach_close").jqxButton({ 
		width: 50, 
		height: 23, 
		theme:theme
	});
	
	$("#e_fileattach_docno").val(selectedDocno);
	$("#e_fileattach_docname").val(selectedDocname);

	$("#gr_fileattach").jqxGrid(
           {
               width: '100%', //1525
               height: 345,
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
				{ text: '자료번호',datafield:'docno',width:'15%' },
				{ text: '파일명',datafield:'filename',width:'15%' },
				{ text: '자료상태',datafield:'status',width:'10%' },
				{ text: '자료타입',datafield:'filetype',width:'10%' },
				{ text: 'userfilename',datafield:'userfilename',width:'10%' },
				{ text: 'rdlfilename', datafield:'rdlfilename',width:'10%' },
				{ text: '등록시간',datafield:'created',width:'15%' },
				{ text: '등록자',datafield:'creator',width:'10%' },
				{ text: '등록자명',datafield:'creatorname',width:'10%' },
				{ text: '등록자부서',datafield:'creatordept',width:'10%' },
				{ text: '파일자료번호',datafield:'filedocno',width:'10%'},
				{ text: '메모',datafield:'filedocmemo',width:'10%' },
				{ text: '파일사이즈',datafield:'filesize',width:'10%' },
				{ text: 'attcheckincnt',datafield:'attcheckincnt',width:'10%' },
				{ text: 'addedvaultname',datafield:'addedvaultname',width:'10%' },
				{ text: 'addedvaultlname',datafield:'addedvaultlname',width:'10%' },
               ]
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
	

	//# Set Timer to fileattach_bottom_time div
	 var timerid;			 
	function timerstart(){ timerid = setInterval(timer1,1000); } //var timerstart = function() {
	function timerstop(){ setTimeout(function() { clearInterval(timerid); }, 1000); }
	function timer1(){
	   var d = new Date();
	   var s = leadingZeros(d.getFullYear(), 4) + '-' + leadingZeros(d.getMonth() + 1, 2) + '-' + leadingZeros(d.getDate(), 2) + ' ' +
		       leadingZeros(d.getHours(), 2) + ':' + leadingZeros(d.getMinutes(), 2) + ':' + leadingZeros(d.getSeconds(), 2);
	   //var d = new Date(); var t = d.toLocaleTimeString(); console.log(t);
	   $("#fileattach_bottom_time").text("Now : "+ s);
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

	
	
	
	$('#btn_fileattach_checkin').on('click',function(){ 
		
	});
	
	$('#btn_fileattach_fileadd').on('click',function(){ 
		 $("#e_fileattach_fileselect").click();
	});
	
	
	$('#btn_fileattach_xlsdown').on('click',function(){ 
		exelDown($("#gr_fileattach"));
	});
	
	$('#btn_fileattach_fileopen').on('click',function(){ 
		var index = $("#gr_fileattach").jqxGrid('getselectedrowindex');
		var data = $("#gr_fileattach").jqxGrid('getrowdata', index);
		
		if(index==-1){msg1("오픈할 파일을 선택하세요"); return;}
		
		var filename = data.filename;
		var filePath = "D://pwmStr//attachFile";
		$.ajax({
			url : "fileOpen.do",
			type : "POST",
			dataType : "json",
			data : {"f":filename, "of":filename, "filePath":filePath},
			success : function(data, status,XHR){

			},
			error : function(data, status){
			},
			complete : function(){
			}
		});
		
	});
	
	$('#btn_fileattach_filedelete').on('click',function(){ 
		var indexes = $("#gr_fileattach").jqxGrid('getselectedrowindexes');
		var docno = "";
		var datas = "";
		var filenameList = new Array();
		for (var i = 0; i < indexes.length; i++) {
			datas = $("#gr_fileattach").jqxGrid('getrowdata', indexes[i]);
			docno = datas.docno;
			filenameList.push(datas.filename);
		}
		if(indexes.length == 0){msg1("삭제할 파일을 선택하세요"); return;}
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
			$.ajax({
				url : "deleteFileAttach.do",
				type : "POST",
				dataType : "json",
				traditional : true,
				data : {"docno":docno, "filenameList":filenameList},
				success : function(data, status,XHR){
					if(data.rtncode){
						msg1("총 "+ data.count + " 건을 삭제하였습니다.");
						$("#gr_fileattach").jqxGrid('updatebounddata');
					}
				},
				error : function(data, status){
				},
				complete : function(){
				}
			});
		});
	});
	
	$('#btn_fileattach_close').on('click',function(){ 
		location.reload();
		//$("#fileattach_winm").jqxWindow('close');
		//loclocation.reload();
	});
	
	
	 $('#gr_fileattach').on('rowdoubleclick', function (event) 
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
	    
	    var data = $('#gr_fileattach').jqxGrid('getrowdata', boundIndex);
		var filepath = "D://pwmStr//AttachFile";
	    fileOpen(data.filename, filepath);

	});
	
	
	cellclick($("#gr_fileattach"));
	
	

	
}); // End Ready Function



function doubleSubmitCheck(){//버튼 횟수 체크 함수
	    if(doubleSubmitFlag){
	        return doubleSubmitFlag;
	    }else{
	        doubleSubmitFlag = true;
	        return false;
	    }
} 

function getfilesize(){
	var size = document.getElementById("filename").files[0].size;
	$("#size").val(size);
}



function getFileAttach(params){
	var source =
    {
    		datatype: "json",
            type:"POST",
            data: params,
            datafields: [
						{ name:'docno', type: 'string' },
						{ name:'filename', type: 'string' },
						{ name:'status', type: 'string' },
						{ name:'filetype', type: 'string' },
						{ name:'userfilename', type: 'string' },
						{ name:'rdlfilename', type: 'string' },
						{ name:'created', type: 'string' },
						{ name:'creator', type: 'string' },
						{ name:'creatorname', type: 'string' },
						{ name:'creatordept', type: 'string' },
						{ name:'filedocno', type: 'string' },
						{ name:'filedocmemo', type: 'string' },
						{ name:'filesize', type: 'string' },
						{ name:'attcheckincnt', type: 'string' },
						{ name:'addedvaultname', type: 'string' }
                     ],	
            id: "fileAttachVoList",
            url: "getFileAttach.do",
    	};
	 
	    var cellsrenderer = function (row, columnfield, value, defaulthtml, columnproperties, rowdata) {
	        if (value < 20) {
	            return '<span style="margin: 4px; float: ' + columnproperties.cellsalign + '; color: #ff0000; ">' + value + '</span>';
	        }
	        else {
	            return '<span style="margin: 4px; float: ' + columnproperties.cellsalign + '; color: #008000; ">' + value + '</span>';
	        }
	    }
	    var TOTCNT = 0;
	    var dataAdapter = new $.jqx.dataAdapter(source, {
	        downloadComplete: function (data, status, xhr) { TOTCNT = data.totcount},
	        loadComplete: function (data) {},
	        loadError: function (xhr, status, error) {}
	    });
	    console.log(TOTCNT);
	    var self = this;
	     var pagerrenderer = function () {
          
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
             getFileAttach(params);
           	 }
          });
          leftButton.click(function () {
       	   if(pageNum != 1){
       	   pageNum--;
             //console.log("minus : "+pageNum);
             params.pageNum = pageNum;
             // var params = {"plantcode":plantcode,"docclass1":docclass1,"docclass2":docclass2,"pageNum":pageNum}; 
             getFileAttach(params);
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
     $("#gr_fileattach").jqxGrid(
       {	
       	pagerheight: 27,
           pageable: true,
           source:dataAdapter,
       	pagerrenderer: pagerrenderer,
       	theme:theme
          
       });
}

 
function fileattach_fileSelect(){

	var fd = new FormData();
	fd.append('docno', selectedDocno);
	
	var files = document.getElementById("e_fileattach_fileselect").files;
	for (var i = 0; i < files.length; i++) {
		fd.append('localfile', files[i]);
	}
	
	$.ajax({
	 dataType:"json",
	 url : "insertFileAttach.do",
	 type: "POST",
	 contentType:false,
	 processData: false,
	 cache: false,
	 async : false,
	 data: fd,
	 xhr: function()
	{
		myXhr = $.ajaxSettings.xhr();
        if (myXhr.upload)
        {
   	        myXhr.upload.addEventListener('fileattach_progress', function(ev){
   	        	if (ev.lengthComputable) {
   	        		$('#fileattach_progress').show();       	        				   	        		
   		            var fileattach_percentComplete = Math.round((ev.loaded / ev.total) * 100);	
   		            
   		            $('#fileattach_percent').text(fileattach_percentComplete + '%'); 
   		            $('#fileattach_bar').css('width', fileattach_percentComplete+'%');
        
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
			msg1("총 "+ data.count + " 건을 입력하였습니다.");
			$("#gr_fileattach").jqxGrid('updatebounddata');
		}else{
			msg1(data.rtnmsg);
		}
	},
		error : function(textStatus, errorThrown) {
		}
	});

}

</script>


<div id="fileattach_winm" style="max-width:100%; margin: -2px; display:none;">
 	<div>
		<!-- Main Div -->
		<div id="fileattach_main_cond" style="border:1px solid lightgray;">	
			<table  style="width: 98%; margin-top:5px;" >
				<tr style="height: 10px; ">
					<td style="font-size: 11px; width: 2%;" align='right'>docno</td>
					<td style="width: 20%"><input type="text" id="e_fileattach_docno"></td>
	
					<td style="font-size: 11px; width: 2%;" align='right'>docname</td>
					<td style="width: 20%"><input type="text" id="e_fileattach_docname">
						<input type="button" id="btn_fileattach_close" value="close" style="margin-top: 3px; margin-left:5px;  display: inline-block; float: right; ">
					</td>
					
				</tr>
				<tr>
					<td style="width: 20%" colspan="4">
<!-- 						<input type="button" id="btn_fileattach_checkin" title="체크인" style="margin-left:5px; margin-top:5px; floadt:left;">체크인 -->
<!-- 						<input type="file" multiple="multiple" id="e_fileattach_fileselect" name="fileInput" onchange="fileattach_fileSelect();" style="display:none;" /> -->
<!-- 						<input type="button" id="btn_fileattach_fileadd" title="첨부" onclick="chooseAttachFile();"  style="floadt:left;">첨부 -->
<!-- 						<button id="btn_fileattach_xlsdown" title="엑셀다운" style="floadt:left;">엑셀다운</button> -->
<!-- 						<button id="btn_fileattach_filedelete" title="삭제" style="floadt:left;">삭제</button> -->
<!-- 						<button id="btn_fileattach_filestory" title="파일이력" style="floadt:left;">파일이력</button> -->
<!-- 						<button id="btn_fileattach_fileopen" title="열기" style="floadt:left;">열기</button> -->
<!-- 						<button id="btn_fileattach_close" style="floadt:left;">close</button> -->
						
						<input type="button" id="btn_fileattach_checkin" value="체크인" style="margin: 3px;  display: inline-block; float: left; ">
						<input type="file" multiple="multiple" id="e_fileattach_fileselect" name="fileInput" onchange="fileattach_fileSelect();" style="display:none;" />
						<input type="button" id="btn_fileattach_fileadd" value="첨부" style="margin-top: 3px; margin-left:3px;  display: inline-block; float: left; ">
						<input type="button" id="btn_fileattach_xlsdown" value="엑셀다운" style="margin-top: 3px;margin-left:3px;  display: inline-block; float: left; ">
						<input type="button" id="btn_fileattach_filedelete" value="삭제" style="margin-top: 3px; margin-left:3px; display: inline-block; float: left; ">
						<input type="button" id="btn_fileattach_filestory" value="파일이력" style="margin-top: 3px; margin-left:3px;  display: inline-block; float: left; ">
						<input type="button" id="btn_fileattach_fileopen" value="열기" style="margin-top: 3px; margin-left:3px; display: inline-block; float: left; ">
						
						
					</td>
				</tr>
			</table>
		</div><!-- End fileattach_main_cond  -->
		
		<div id="gr_fileattach">
		</div>
	
		<div id="fileattach_bottom" style="max-width:100%; height:auto;  border: 1px solid lightgray; margin: -2px; margin-top: 5px;">　
				<div id="fileattach_bottom_msg" style="width:auto; float: left;" >msg</div>
				<div id="fileattach_progress" style="float: left;">
					<div id="fileattach_bar"></div>
					<div id="fileattach_percent"></div>
				</div>
				<div id="fileattach_bottom_time" style="width:auto; float: right; font-size: 14px">now</div>
		</div>
	</div>
 </div><!-- End fileattach_winm -->

