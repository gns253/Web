<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="../js/jquery-3.6.1.js"></script>
<script type="text/javascript">
	// 영화 목록 페이지 번호를 저장할 전역변수 선언
	let curPage = 1;

	$(function() {
		// 영화 목록 조회를 수행할 load_movie_list() 메서드 호출
		load_movie_list();
		
		// 무한스크롤 기능 구현
		// window 객체에서 scroll 이 동작할 때 기능을 수행하기 위해 scroll() 함수 호출
		$(window).scroll(function() {
// 			$("#resultArea").after("스크롤 동작!<br>");
			
			// 1. window 객체와 document 객체를 활용하여 특정 값 가져오기
			let scrollTop = $(window).scrollTop(); // 스크롤바의 현재 위치
			let windowHeight = $(window).height(); // 문서가 표시되는 창의 높이
			let documentHeight = $(document).height(); // 문서 전체 높이
// 			$("#valueArea").html("scrollTop : " + scrollTop + ", windowHeight : " + windowHeight + ", documentHeight : " + documentHeight + "<br>");
			
			// 2. 스크롤바 현재 위치값 + 창의 높이 + x 가 문서 전체 높이 이상이면
			//    다음 페이지를 로딩하여 목록에 추가
			// => 이 때 x 는 문서 마지막으로부터 여유 공간으로 둘 스크롤바 아래쪽 남은 공간
			//    (단, 스크롤바 움직일 때 값이 1 씩 변하지 않고 큰 값으로 변화가 일어나므로 함수 호출이 여러번 일어남)
			//    (따라서, x 값을 1로 주면 바닥에 닿을 때 다음 페이지 로딩됨)
			if(scrollTop + windowHeight + 1 >= documentHeight) {
				// 다음 페이지 로딩을 위해 load_movie_list() 함수 호출
				// => 이 때, 함수 호출 전 페이지번호를 1 증가시킨 후 호출 필요
				curPage++;
				load_movie_list();
			}
		});
	});
	
	function load_movie_list() {
		// --------------------------------------------------------------------------------------
		// 무한스크롤 없이 [이전], [다음] 버튼 클릭 시 함수에 특정 값 전달하여 페이지 이동할 경우
// 	function load_movie_list(direction) {
// 		$("#resultArea > table").html("<tr>" + 
// 				"<th width='250'>영화명</th>" +
// 				"<th width='300'>영화명(영문)</th>" +
// 				"<th width='100'>제작연도</th>" +
// 				"<th width='100'>제작국가</th>" +
// 				"<th width='100'>장르</th>" +
// 				"<th width='150'>감독</th>" +
// 			"</tr>");
		
// 		if(direction == 'prev') {
// 			curPage--;
// 		} else {
// 			curPage++;
// 		}
		// --------------------------------------------------------------------------------------
		
		// =============================================================================
		// 영화 목록 샘플 API 요청 주소(최신 업데이트 순 목록)
		// https://kobis.or.kr/kobisopenapi/webservice/rest/movie/searchMovieList.json?key=f5eef3421c602c6cb7ea224104795888&curPage=페이지번호
		// => 단, 페이지번호 생략 시 기본 값은 1
		$.ajax({
			type: "GET",
			url: "https://kobis.or.kr/kobisopenapi/webservice/rest/movie/searchMovieList.json?key=f5eef3421c602c6cb7ea224104795888&curPage=" + curPage,
			dataType: "json", // 응답 데이터가 JSON 형식으로 전달되도록 "json" 타입 지정 
		})
		.done(function(data) { // 요청 성공 시
			// 영화 목록이 저장된 JSON 객체(data) 로부터 영화 목록 정보 추출하기
			// 1. 영화 목록(10개)이 저장된 "movieListResult" 객체 추출
			let movieListResult = data.movieListResult;
			
			// 2. 전체 영화 수(totCnt)와 출처(source) 추출
			// => movieListResult 객체를 통해 접근
			let totCnt = movieListResult.totCnt;
			let source = movieListResult.source;
			
			// 3. 영화 목록(movieList) 추출
			// => 복수개의 영화 정보 객체{}가 movieList 라는 이름의 배열[]로 관리됨
			let movieList = movieListResult.movieList;
			
			// 4. 추출된 영화 목록(배열)을 반복문을 통해 반복하면서
			//    영화명(movieNm), 영화명영문(movieNmEn), 제작연도(prdtYear), 
			//    제작국가(repNationNm), 장르(repGenreNm), 감독(directors 배열 - peopleNm) 추출 및 출력
			for(let movie of movieList) {
				let result = "<tr height='50'>" + 
				"<td>" + movie.movieNm + "</td>" + 
				"<td>" + movie.movieNmEn + "</td>" + 
				"<td>" + movie.prdtYear + "</td>" + 
				"<td>" + movie.repNationNm + "</td>" + 
				"<td>" + movie.repGenreNm + "</td>";
				
				// 감독이 있을 경우에만 감독명을 표시하고 아니면 빈칸으로 표시
				if(movie.directors.length > 0) {
					result += "<td>" + movie.directors[0].peopleNm + "</td>";
				} else {
					result += "<td></td>"
				}
				
				result += "</tr>";
				
				$("#resultArea > table").append(result);
			}
		})
		.fail(function() { // 요청 실패 시
			$("#resultArea").html("요청 실패!");
		});
			
	}
</script>
</head>
<body>
	<h1>test7_json.jsp - 영화 목록</h1>
<!-- 	<input type="button" value="영화 목록 조회" id="btnOk"> -->
	<hr>
	<div id="resultArea">
		<table border="1">
			<tr>
				<th width="250">영화명</th>
				<th width="300">영화명(영문)</th>
				<th width="100">제작연도</th>
				<th width="100">제작국가</th>
				<th width="100">장르</th>
				<th width="150">감독</th>
			</tr>
		</table>
			<!-- 무한스크롤 없이 [이전], [다음] 버튼 클릭 시 함수에 특정 값 전달하여 페이지 이동할 경우 -->
<!-- 		<input type="button" value="이전목록" onclick="load_movie_list('prev')"> -->
<!-- 		<input type="button" value="다음목록" onclick="load_movie_list('next')"> -->
	</div>
	<div id="valueArea"></div>
	<br><br><br><br><br><br><br>
</body>
</html>












