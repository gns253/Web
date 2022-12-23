<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="../js/jquery-3.6.1.js"></script>
<script type="text/javascript">
	$(function() {
		$.ajax({
			type: "GET",
			url: "MemberInfo.me",
			dataType: "text",
		})
		.done(function(data) { // 요청 성공 시
			
		})
		.fail(function() { // 요청 실패 시
			$("#resultArea").html("요청 실패!");
		});
	});
</script>
</head>
<body>
	<h1>회원 정보</h1>
	<div id="resultArea">
	
	</div>
</body>
</html>










