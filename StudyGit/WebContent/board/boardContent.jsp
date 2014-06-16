<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page import="DAO.BoardDAO"%>
<%@ page import="java.util.List"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>${dto.subject}</title>
<link type="text/css" rel="stylesheet" href="../include/common.css">
<script src="http://code.jquery.com/jquery-1.10.2.js"></script>
<script type="text/javascript">
	$(document).ready(function(){		
		
	});
</script>
</head>
<body>
	<div id="page">
		<!-- Header -->
		<jsp:include page="../include/headero.jsp" />
		<div id="main">
			<!-- 뷰 -->
			<div class="view_head">
				<div class="subject">${dto.subject}</div>
				<!-- <div class="idx">${dto.idx}</div> -->
				<div class="readcount_text">조회수</div>
				<div class="readcount">${dto.readNum}</div>
				<span class="txt_bar"> | </span>
				<div class="writer">${dto.writer}</div>
				<span class="txt_bar"> | </span>
				<div class="reg_date">
					<fmt:formatDate value="${dto.writeDate}"
						pattern="yy.MM.dd hh:mm:ss" />
				</div>
			</div>
			<div class="view_body">
				<div class="content">${dto.content}</div>
			</div>
			<!-- 버튼 -->
			<table>
				<tr>
					<td colspan="4">
					<c:if test="${sessionScope.memId!=null}">
					<c:if test="${sessionScope.memId eq dto.writer}">
						<input type="button" value="글수정"
						onclick="document.location.href='update.otl?idx=${dto.idx}&pageNum=${pageNum}'">
						&nbsp;&nbsp;&nbsp;&nbsp; 
						<input type="button" value="글삭제" onclick="openPopup();">
						&nbsp;&nbsp;&nbsp;&nbsp; 
					</c:if>
					<input type="button" value="답글쓰기"
						onclick="document.location.href='boardWrite?refer=${dto.refer}&depth=${dto.depth}&step=${dto.step}&category=${category}&pageSize=${pageSize}&pageNum=${pageNum}&searchKey=${searchKey}&searchType=${searchType}'">
						&nbsp;&nbsp;&nbsp;&nbsp; 
					</c:if> <input type="button" value="글목록"
						onclick="document.location.href='boardList?category=${category}&pageSize=${pageSize}&pageNum=${pageNum}&searchKey=${searchKey}&searchType=${searchType}'">
					</td>
				</tr>
			</table>
		</div>
		<!-- Footer -->
		<jsp:include page="../include/footer.jsp" />
	</div>
</body>
</html>