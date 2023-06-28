<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>민원 등록</title>
<!-- 공통 script & css -->
<c:import url="${path}/resources/js/scripts.jsp" />
<link href="${path}/resources/css/commons.css" type="text/css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.js"></script>
<style>
#inputTitle {
	width: 100%;
}

.note-editable {
	text-align: left;
	background-color: ghostwhite;
}
</style>
</head>

<body>
	<!-- GNB & LNB -->
	<c:import url="${path}/resources/js/GNB.jsp">
		<c:param name="pageName" value="community" />
		<c:param name="btnNum" value="${boardCode}" />
	</c:import>
	<!-- CONTENTS -->
	<div>
		<div class="container-xl position-relative p-0">
			<div class="row">
				<div class="col">
					<form action="/community/insertComplaint" method="post" id="boardForm">
						<input type="hidden" name="writer" value="${sessionScope.code}">
						<input type="hidden" name="board_type" value="${boardCode}">
						<div style="display: flex;">
							<div style="flex: 1;">
								<select style="width: 100%; height: 100%;">
									<c:forEach var="i" items="${selectTag}">
										<c:choose>
											<c:when test="${i.code == boardCode}">
												<option checked>${i.name}</option>
											</c:when>
											<c:otherwise>
												<option disabled>${i.name}</option>
											</c:otherwise>
										</c:choose>
									</c:forEach>
								</select>
							</div>
							<div style="flex: 1; text-align: center;">
								<label>
									<input type="radio" name="complaint_type" value="1001" checked>
									문의
								</label>
								<label>
									<input type="radio" name="complaint_type" value="1002">
									건의
								</label>
								<label>
									<input type="radio" name="complaint_type" value="1003">
									신고
								</label>
							</div>
							<div style="flex: 4;">
								<input type="text" name="title" placeholder="제목을 입력해주세요" id="inputTitle">
							</div>
						</div>
						<div>
							<textarea name="txt" id="textarea_contents" cols="30" rows="10"></textarea>
						</div>
						<div style="text-align: right;">
							<input type="button" id="formSubmit" value="등록하기">
							<input type="button" value="돌아가기" onclick="location.href = '/community/toBoard?code=${boardCode}&currentPage=1'">
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
	<!-- FOOTER -->
	<c:import url="${path}/resources/js/FOOTER.jsp" />
	<!-- script - Contents -->
	<script>
	$("#textarea_contents").summernote({
	    height : 500, // 에디터 높이
		minHeight : null, // 최소 높이
		maxHeight : null, // 최대 높이
		focus : true, // 에디터 로딩후 포커스를 맞출지 여부
		lang : "ko-KR", // 한글 설정
		codeviewIframeFilter: true,
		placeholder : '허위 신고는 제재 대상입니다', //placeholder 설정
		disableDragAndDrop : true,
		toolbar : [ [ 'style', [ 'style' ] ],
				[ 'font', [ 'bold', 'underline', 'clear' ] ],
				[ 'fontname', [ 'fontname' ] ],
				[ 'color', [ 'color' ] ],
				[ 'para', [ 'ul', 'ol', 'paragraph' ] ],
				[ 'table', [ 'table' ] ],
				[ 'insert', [ 'picture' ] ] ],
		callbacks : { //여기 부분이 이미지를 첨부하는 부분
			onImageUpload : function(files) {
				for (let i = 0; i < files.length; i++) {
					let blobUrl = URL.createObjectURL(files[i]);
					$(this).summernote("insertImage", blobUrl, files[i].name);
				}
			}
		}
	});
	$("#formSubmit").on("click", async function(e) {
	    e.preventDefault();
		let imgList = $(".note-editable img");
		let fileArr = [];
		for(let i = 0; i < imgList.length; i++) {
			let imgSrc = imgList[i].src;
			let imgName = imgList.eq(i).attr("data-filename");
			if(imgSrc.startsWith("blob:")) {
				let blob = await fetch(imgSrc).then(r => r.blob());
				let file = new File([blob], imgName);
				fileArr.push(file);
			}
		}
		if(fileArr.length == 0) {
			$("#boardForm").submit();   
		}
		console.log(fileArr);
		uploadImg(fileArr);
		let contents = $("#textarea_contents").val();
		$("#boardForm").submit();
	});
	
	function uploadImg(fileArr) {
	    console.log("uploadImg");
	    console.log(fileArr);
		let formData = new FormData();
		fileArr.map(function(e, i){
		    console.log(e);
			formData.append("files", e);
		});
		console.log(formData);
		$.ajax({
			data : formData,
			type : "POST",
			url : "/community/uploadFile",
			async : false,
			contentType : false,
			processData : false,
			encType : "multipart/form-data"
		}).done(function(response) {
		    response = JSON.parse(response);
		    response.map(function(e){
				let targetImg = $(".note-editable img[data-filename ='"+e.oriName+"']");
				targetImg.attr("src", e.imgSrc);
			});
			let div = $(".note-editable").html();
			$("#textarea_contents").val(div);
		});
	}
    </script>
</body>

</html>