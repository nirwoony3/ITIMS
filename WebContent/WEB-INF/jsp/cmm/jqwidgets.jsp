<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
 <meta content="IE=10" http-equiv="X-UA-Compatible"> 
<!-- CSS  -->
<link rel="stylesheet" 	href="<c:url value='/css/jqwidgets/jqx.base.css'/>" type="text/css" />
<link rel="stylesheet"  href="<c:url value='/css/jqwidgets/jqx.ui-lightness.css'/>" type="text/css" />
<link rel="stylesheet" 	href="<c:url value='/css/jqwidgets/jqx.orange.css'/>" 	type="text/css" />
<link rel="stylesheet" 	href="<c:url value='/css/jqwidgets/jqx.fresh.css'/>" 	type="text/css" />
<link rel="stylesheet" 	href="<c:url value='/css/jqwidgets/jqx.light.css'/>" 	type="text/css" />
<link rel="stylesheet"  href="<c:url value='/css/jqwidgets/jqx.bootstrap.css'/>" type="text/css" />
<link rel="stylesheet" 	href="<c:url value='/css/jqwidgets/jqx.ui-sunny.css'/>" 	type="text/css" />
<link rel="stylesheet" 	href="<c:url value='/css/jqwidgets/jqx.energyblue.css'/>" 	type="text/css" />

<!-- JS  -->
<script type="text/javascript"
	src="<c:url value='/js/com/jquery-1.11.1.min.js'/>"></script>
<!-- <script type="text/javascript" -->
<%-- 	src="<c:url value='/js/jqw/jqxdragdrop.js'/>"></script> --%>
<script type="text/javascript"
	src="<c:url value='/js/jqw/jqxcore.js'/>"></script>
<script type="text/javascript"
	src="<c:url value='/js/jqw/jqxinput.js'/>"></script>
<script type="text/javascript"
	src="<c:url value='/js/jqw/jqxcheckbox.js'/>"></script>
<script type="text/javascript"
	src="<c:url value='/js/jqw/jqxbuttons.js'/>"></script>
<script type="text/javascript"
	src="<c:url value='/js/jqw/jqxcombobox.js'/>"></script>
<script type="text/javascript"
	src="<c:url value='/js/jqw/jqxdropdownlist.js'/>"></script>
<script type="text/javascript"
	src="<c:url value='/js/jqw/jqxlistbox.js'/>"></script>
<script type="text/javascript"
	src="<c:url value='/js/jqw/jqxscrollbar.js'/>"></script>
<script type="text/javascript"
	src="<c:url value='/js/jqw/jqxtabs.js'/>"></script>
<script type="text/javascript"
	src="<c:url value='/js/jqw/jqxloader.js'/>"></script>
<script type="text/javascript"
	src="<c:url value='/js/jqw/jqxradiobutton.js'/>"></script>
<script type="text/javascript"
	src="<c:url value='/js/jqw/jqxbuttongroup.js'/>"></script>
<script type="text/javascript"
	src="<c:url value='/js/jqw/jqxtextarea.js'/>"></script>
<script type="text/javascript"
	src="<c:url value='/js/jqw/jqxmenu.js'/>"></script>
<script type="text/javascript"
	src="<c:url value='/js/jqw/jqxfileupload.js'/>"></script>
<script type="text/javascript"
	src="<c:url value='/js/jqw/jqxgrid.js'/>"></script>
<script type="text/javascript"
	src="<c:url value='/js/jqw/jqxgrid.sort.js'/>"></script>
<script type="text/javascript"
	src="<c:url value='/js/jqw/jqxgrid.pager.js'/>"></script>
<script type="text/javascript"
	src="<c:url value='/js/jqw/jqxgrid.filter.js'/>"></script>
<script type="text/javascript"
	src="<c:url value='/js/jqw/jqxgrid.selection.js'/>"></script>
<script type="text/javascript"
	src="<c:url value='/js/jqw/jqxgrid.edit.js'/>"></script>
<script type="text/javascript"
	src="<c:url value='/js/jqw/jqxdata.js'/>"></script>
<script type="text/javascript"
	src="<c:url value='/js/jqw/jqxsplitter.js'/>"></script>
<script type="text/javascript"
	src="<c:url value='/js/jqw/jqxdatetimeinput.js'/>"></script>
<script type="text/javascript"
	src="<c:url value='/js/jqw/jqxcalendar.js'/>"></script>
<script type="text/javascript"
	src="<c:url value='/js/jqw/jqxtooltip.js'/>"></script>
<script type="text/javascript"
	src="<c:url value='/js/jqw/jqxgrid.columnsresize.js'/>"></script>
<script type="text/javascript"
	src="<c:url value='/js/jqw/globalize.js'/>"></script>
<script type="text/javascript"
	src="<c:url value='/js/jqw/jqxdata.export.js'/>"></script>
<script type="text/javascript"
	src="<c:url value='/js/jqw/jqxgrid.export.js'/>"></script>
<script type="text/javascript"
	src="<c:url value='/js/jqw/jqxwindow.js'/>"></script>
<script type="text/javascript"
	src="<c:url value='/js/jqw/jqxtree.js'/>"></script>
<%-- <script type="text/javascript"
	src="<c:url value='/js/etc/jquery.MultiFile.js'/>"></script>
<script type="text/javascript"
	src="<c:url value='/js/etc/jquery.form.js'/>"></script> --%>
<script type="text/javascript"
	src="<c:url value='/js/jqw/jqxpanel.js'/>"></script>

<script type="text/javascript"
	src="<c:url value='/js/jqw/jqxgrid.grouping.js'/>"></script>
<script type="text/javascript"
	src="<c:url value='/js/jqw/jqxgrid.aggregates.js'/>"></script>
<%-- <script type="text/javascript"
	src="<c:url value='/js/jqw/cmm/gridshow.js'/>"></script> --%>

<style>
/* .btn_modal {
	background: linear-gradient(to bottom, rgba(255, 191, 122, 0.31),
		rgba(255, 197, 108, 0.75));
	margin-top: 5px;
	display: inline-block;
} */

/*.jqx-button { background-color: rgba(255, 191, 122, 0.31); color: Red; font-size: 11px; } /*larger; } */

.jqx-window-header {
	/* background: linear-gradient(to bottom, rgba(255, 191, 122, 0.31),
		rgba(255, 197, 108, 0.75)); */
}

/* .jqx-window-close-button {
	background-image: url("images_up2/btn/close/bu5_close.gif");
	max-width: 30px;  //넓이를 지정 
	background-size: 16px;
	margin-top: 2px;
	margin-bottom: 2px;
	vertical-align: center;
} */

#bottom_msg { margin-left: 15px; }
#bottom_time { margin-right: 15px; }

.cb_cls{ background-color: white; }
/*
.header_bar{ background: linear-gradient(to bottom, #E0F8E6, #81BEF7); height: 15px; }
.bottom_bar{ position: absolute; left: 0px; bottom: 0px; width:100%; height: 20px; background: linear-gradient(to bottom, #E0F8E6, #81BEF7); text-align:left; }
*/
.header_bar{ background: linear-gradient(to bottom, #E39F0B, #FDE9BE); height: 15px; }
.bottom_bar{ position: absolute; left: 0px; bottom: 0px; width:100%; height: 20px; background: linear-gradient(to bottom, #FDE9BE, #E39F0B); text-align:left; }

.trnotnull{ color:red; }

</style>
