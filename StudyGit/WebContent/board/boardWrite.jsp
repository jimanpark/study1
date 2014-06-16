<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page import="DAO.BoardDAO"%>
<%@ page import="DTO.CategoryDTO"%>
<%@ page import="java.util.List"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Write Page</title>
<link type="text/css" rel="stylesheet" href="../include/common.css">
<script src="../ckeditor/ckeditor.js" type="text/javascript"></script>
<script src="http://code.jquery.com/jquery-1.10.2.js"></script>
<script type="text/javascript">

	$(document).ready(function(){		
		var ckeditor;
		
		//CKEDITOR를 textarea의 name값: 'content'랑 교체
		CKEDITOR.replace( 'content', {
			skin : 'bootstrapck',
			enterMode: '2',
			shiftEnterMode:'3'
		});
		ckeditor = CKEDITOR.instances['content'];
		
		$('#writeform').submit(function(){
			if($('select[name=category]').val() == ""){
				alert("카테고리를 선택하세요");
				$('select[name=category]').focus();
				return false;
			}
			if($('input[name=subject]').val() == ""){
				alert("제목을 입력하세요");
				$('input[name=subject]').focus();
				return false;
			}	
			if($('input[name=writer]').val() == ""){
				alert("글쓴이를 입력하세요");
				$('input[name=writer]').focus();
				return false;
			}		
			if($('input[name=pwd]').val() == ""){
				alert("암호를 입력하세요");
				$('input[name=pwd]').focus();
				return false;
			}			
			if($('input[name=pwd]').val() == ""){
				alert("암호를 입력하세요");
				$('input[name=pwd]').focus();
				return false;
			}				
/* 			if($('textarea[name=content]').val() == ""){
				alert("내용을 입력하세요");
				$('textarea[name=content]').focus();
				return false;
			}	 */
			
			if (ckeditor.getData()=="") {
				alert("글 내용을 입력하세요");
				ckeditor.focus();
				return false;
			}
		});
	});
</script>
</head>
<body>
	<div id="page">
		<!-- Header -->
		<jsp:include page="../include/headero.jsp" />
		<div id="main">
			<form action="boardWriteOK" method="post" id="writeform">
				<div class="writeform">
					<select name="category">
						<option value="">카테고리</option>
					<fmt:requestEncoding value="UTF-8" />
					<c:forEach var="category" items="${categorylist}">
						<c:if test="${empty param.category}">
							<option value="${category.category}">${category.cname}</option>
						</c:if>
						<c:if test="${param.category==category.category}">
							<option value="${category.category}" selected>${category.cname}</option>
						</c:if>
					</c:forEach>
					</select>
					<input type="text" name="subject" placeholder="Subject"> 
					<input type="text" name="writer" placeholder="Writer"> 
					<input type="password" name="pwd" placeholder="Password"> 
					<input type="text" name="email" placeholder="E-mail">
					<textarea rows="10" cols="5" name="content"></textarea>
					
					<input type="hidden" name="refer" value="${refer}"> 
					<input type="hidden" name="step" value="${step}"> 
					<input type="hidden" name="depth" value="${depth}">
				</div>
				<input type="submit" value="등록">
			</form>
		</div>
		<!-- Footer -->
		<jsp:include page="../include/footer.jsp" />
	</div>
</body>
</html>