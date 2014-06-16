<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page import="DAO.BoardDAO"%>
<%@ page import="java.util.List"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>List Page</title>
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
			<form action="boardList" method="get" name="SearchForm">
				<div class="topArea">
					<div class="titleArea">
						<h3>Category Board</h3>
						<h4>검색 결과&nbsp;<strong>${searchCount}</strong>건</h4>
					</div>
					<div class="searchArea" id="inputbox">
						<%-- <input type="hidden" name="pageNum" value="${pageNum}"/> --%>
						<SELECT name="pageSize" onchange="submit()">
						<c:forEach var="i" begin="5" end="50" step="5">
							<option value="${i}" <c:if test="${pageSize==i}">selected</c:if>>${i}개</option>
						</c:forEach>
						</SELECT>
						<select name="category">
							<option value="">카테고리</option>
						<fmt:requestEncoding value="UTF-8" />
						<c:forEach var="category" items="${categorylist}">
							<option value="${category.category}" <c:if test="${param.category==category.category}">selected</c:if>>${category.cname}</option>
						</c:forEach>
						</select>
						<select name="searchType">
							<option value="subject" <c:if test="${param.searchType=='subject'}">selected</c:if>>제목</option>
							<option value="writer" <c:if test="${param.searchType=='writer'}">selected</c:if>>글쓴이</option>
							<option value="content" <c:if test="${param.searchType=='content'}">selected</c:if>>글내용</option>
						</select>
						<input type="text" name="searchKey" value="${searchKey}">
						<input type="submit" value="검색">
					</div>
				</div>
				<table class="memberlist">
					<tr>
						<th class="category">구분</th>
						<th class="subject">제목</th>
						<th class="writer">글쓴이</th>
						<th class="recommend">추천</th>
						<th class="readNum">조회</th>
						<th class="writeDate">날짜</th>
					</tr>
					<%-- <c:when test="${empty boardlist}">
					<tr>
						<td colspan="6">
							게시글이 없습니다.
						</td>
					</tr>
					</c:when>
					<c:otherwise>
					<fmt:requestEncoding value="UTF-8"/> --%>
					<c:forEach var="board" items="${boardlist}">
					
					<tr <c:if test="${board.notice=='Y'}">class="notice"</c:if>>
						<td>
							<c:choose>
								<c:when test="${board.notice=='Y'}"><img alt="공지" src="../images/hidden.gif" width="27" height="16" class="notice_icon"></c:when>
								<c:otherwise>${board.cname}</c:otherwise>
							</c:choose>
						</td>
						<td class="subject">	
						<!-- 원본글 ... 답변글인 경우 -->
						<c:set var="depth" value="${board.depth}" />
						<span style="padding-left:<c:forEach var="i" begin="1" end="${depth}" step="1">${i*10}</c:forEach>px;"></span>		
						<c:if test="${depth>0}"><img alt="re" src="../images/re.gif"></c:if>
						<a href="boardContent?idx=${board.idx}&pageNum=${pageNum}&pageSize=${pageSize}&category=${category}&searchType=${searchType}&searchKey=${searchKey}">${board.subject}</a>
						</td>
						<td>${board.writer}</td>
						<td>${board.recommend}</td>
						<td>${board.readNum}</td>
						<td>
						<%-- <fmt:formatDate value="${board.writeDate}" pattern="yy.MM.dd hh:mm:ss" /> --%>
						${board.writeDate_String}
						</td>
					</tr>
					</c:forEach>
					<%-- </c:otherwise> --%>
				</table>
			</form>
			<div class="pageArea">
				<!-- 이전 링크 -->
				<c:if test="${beginpage>10}">
					<a href="boardList?pageNum=${pageNum-1}&pageSize=${pageSize}&category=${category}&searchType=${searchType}&searchKey=${searchKey}">이전</a>
				</c:if>
				<!-- 페이지 리스트   -->
				<c:forEach var="i" begin="${beginpage}" end="${endpage}" step="1">
					<c:if test="${i==pageNum}">
						<span class="current Page">${i}</span>
					</c:if>
					<c:if test="${i!=pageNum}">
						<span class="Page"><a href="boardList?pageNum=${i}&pageSize=${pageSize}&category=${category}&searchType=${searchType}&searchKey=${searchKey}">${i}</a></span>
					</c:if>
				</c:forEach>
				<!-- 다음링크 -->	
				<c:if test="${endpage<pagecount}">
					<a href="boardList?pageNum=${pageNum+1}&pageSize=${pageSize}&category=${category}&searchType=${searchType}&searchKey=${searchKey}">다음</a>
				</c:if> 
			</div>
			<input type="button" value="글쓰기" onclick="location.href='boardWrite';"/>
		</div>
		<!-- Footer -->
		<jsp:include page="../include/footer.jsp" />
	</div>
</body>
</html>