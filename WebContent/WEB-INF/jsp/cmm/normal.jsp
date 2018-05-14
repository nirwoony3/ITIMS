<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<style type="text/css">
</style>
<script type="text/javascript">
var theme = 'energyblue'; 
//var theme = 'artic'; 

function cellclick(gridname){   //셀클릭 셀렉언셀렉
	gridname.on('cellclick', function (event) {
        var rowindex = gridname.jqxGrid('getselectedrowindex');
        if(rowindex == event.args.rowindex){
        	//gridname.jqxGrid('unselectrow', event.args.rowindex);
        }else{
        	gridname.jqxGrid('clearselection');
        	gridname.jqxGrid('selectrow', event.args.rowindex);
        }
     });
}

function getExtensionOfFilename(filename) { 
	var _fileLen = filename.length; 
	var _lastDot = filename.lastIndexOf('.'); // 확장자 명만 추출한 후 소문자로 변경 
	var _fileExt = filename.substring(_lastDot+1, _fileLen).toLowerCase(); 
	return _fileExt; 
}

function getImgsrcOfExtension(exts){
	 var src = "";
	 if(exts == "dwg"){ src = 'images/button_image/01_dwg.bmp' }   			 
	 else if(exts == "dgn"){ src = 'images/button_image/02_dgn.bmp' }		        			 
	 else if(exts == "tif"){ src = 'images/button_image/03_tif.bmp' }
	 else if(exts == "bmp"){ src = 'images/button_image/04_bmp.bmp' }
	 else if(exts == "jpg"){ src = 'images/button_image/05_jpg.bmp' }
	 else if(exts == "gif"){ src = 'images/button_image/06_gif.bmp' }
	 else if(exts == "doc" || exts == "docx"){ src = 'images/button_image/07_doc.bmp' }
	 else if(exts == "xls" || exts == "xlsx"){ src = 'images/button_image/08_xls.bmp' }
	 else if(exts == "ppt" || exts == "pptx"){ src = 'images/button_image/09_ppt.bmp' }
	 else if(exts == "pdf"){ src = 'images/button_image/10_pdf.bmp' }
	 else if(exts == "hwp"){ src = 'images/button_image/11_hwp.bmp' }
	 else if(exts == "txt"){ src = 'images/button_image/12_txt.bmp' }
	 else if(exts == "html"){ src = 'images/button_image/13_html.bmp' }
	 else if(exts == "gul"){ src = 'images/button_image/14_gul.bmp' }
	 else if(exts == "zip"){ src = 'images/button_image/15_zip.bmp' }
	 else{src = 'images/button_image/18_other.bmp'}
	 
	 return src;
}

//파일 오픈  -> 파일명, 파일패스 받아서 오픈
function fileOpen(fileName, filePath){
	console.log("fileName / filePath : "+fileName +" / " +filePath)
	$.ajax({
		url : "fileOpen.do",
		type : "POST",
		dataType : "json",
		data : {"f" : fileName, "of" : fileName,"filePath" : filePath},
		success : function(data, status,XHR){
			if(!data.rtncode){
				msg1(data.rtnmsg);
			}
		},
		error : function(data, status){
		},
		complete : function(){
		}
	});
}

//파일 오픈2   -> 파일 오브젝트 직접 넘겨서 오픈
function fileOpen2(file){
	console.log("파일오픈2");
	var fd = new FormData();
	fd.append('file', file);	
	$.ajax({
		url : "fileOpen2.do",
		type : "POST",
		contentType:false,
 		processData: false,
 		cache: false,
		dataType : "json",
		data : fd,
		success : function(data, status,XHR){
		},
		error : function(data, status){
		},
		complete : function(){
		}
	});
}


function fileDelete(fileName, filePath){
	console.log("fileName / filePath : "+fileName +" / " +filePath)
	$.ajax({
		url : "fileDelete.do",
		type : "POST",
		dataType : "json",
		data : {"fileName" : fileName, "filePath" : filePath,},
		success : function(data, status,XHR){
		},
		error : function(data, status){
		},
		complete : function(){
		}
	});
}

function contains(list, string){   //contain 함수
	var rtn = -1;
	for(var i = 0; i < list.length; i++){
		if(list[i] == string){
			rtn = i;
		}
	}
	return rtn;
}


function exelDown(gridId){
	var column = gridId.jqxGrid("columns");
	  var gridArray =new Array();
	  var header = "";
	  
	  var column0 = column.records[0].datafield;
	  
	  for (var i = 0; i < column.records.length; i++) { 
		  if(column.records[i].hidden == false && column.records[i].datafield != '_checkboxcolumn'){
		  	header += "^"+column.records[i].text;
		  }
	  }
	  header = header.substr(1);
	  gridArray.push(header);
	  
	  var griddata = gridId.jqxGrid('getdatainformation');
	  var row = null;
	  
	  for (var i = 0; i < griddata.rowscount; i++) {
		  row = gridId.jqxGrid('getrenderedrowdata', i);
	
		  var content = "";
		  for (var j = 0; j < column.records.length; j++) { 
			  if(column.records[j].hidden == false && column.records[j].datafield != '_checkboxcolumn'){
			  	content+= "^"+row[column.records[j].datafield];
			  }
		  }
		  content = content.substr(1);
		  gridArray.push(content);
	  }

	  $.ajax({
    	type : 'post',
        url : 'exeldown.do',
        data : {'gridArray' : gridArray},
        dataType : "json",
        traditional : true,
        beforeSend : function(){
			$('#jqxLoader').jqxLoader('open');
		},
        success : function(data) {
        	$('#jqxLoader').jqxLoader('close');
        	swal({
				  title: "",
				  text: "엑셀을 다운로드 하시겠습니까?",
				  type: "warning",
				  showCancelButton: true,
				  confirmButtonColor: "#DD6B55",
				  confirmButtonText: "OK!", animation: false,
				  closeOnConfirm: true
				},
				function(){
					location.href="fileDownload.do?f="+data.fileName+"&of="+data.fileName+"&filePath="+data.filePath;
				}); 
        },
        error : function(error) {
        }
    }); 
	 
}

function docOpen(docno, vaultlno, docfilename){
	var param = {"docno":docno, "vaultlno":vaultlno, "docfilename":docfilename};
	$.ajax({
			url : "docOpen.do",
			type : "POST",
			dataType : "json",
			data : param,
			success : function(data, status,XHR){
				//msg1(data.msg);
				if(!data.rtncode){
					msg1(data.rtnmsg);
				}
			},
			error : function(data, status){
			},
			complete : function(){
				//doubleSubmitFlag = false;
			}
		});
}


//1년전 구하기
function getLastyear(){
	 var year = String(new Date().getFullYear() - 1);
     var month = String(new Date().getMonth() + 1);
     var date = String(new Date().getDate());
     var dayStr;
     if(month.length == 1){
    	 dayStr =  year + "0" + month + date;
     }else{
    	 dayStr =  year + month + date;
     }
     return dayStr;
}

function replaceAll(str, searchStr, replaceStr) {
    return str.split(searchStr).join(replaceStr);
}

function doubleSubmitCheck(){
    if(doubleSubmitFlag){
        return doubleSubmitFlag;
    }else{
        doubleSubmitFlag = true;
        return false;
    }
}

//180206
function winmaximize(){
	top.window.moveTo(0,0);
	if (document.all) {
	    top.window.resizeTo(screen.availWidth,screen.availHeight);
	} else if (document.layers||document.getElementById) {
	    if (top.window.outerHeight<screen.availHeight||top.window.outerWidth<screen.availWidth){
	        top.window.outerHeight = screen.availHeight;
	        top.window.outerWidth = screen.availWidth;
	    }
	}    	
    return true;
}

//moveTo(0,0)
//resizeTo(800,600)


</script>