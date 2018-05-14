<%@ include file="jstl.jsp"%>
<c:set var="loginInfo" value="${loginInfo }" />
<c:if test="${loginInfo == null }">
	<c:redirect url="login.do"></c:redirect>
</c:if>