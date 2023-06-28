<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
  <title>Card :: modify</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/jquery/dist/jquery.min.js"></script>
  <c:import url="${path}/resources/js/scripts.jsp"/>
  <link href="${path}/resources/css/commons.css" type="text/css" rel="stylesheet">
  <link href="${path}/resources/css/gallery.css" type="text/css" rel="stylesheet">
</head>
<body>
<c:import url="${path}/resources/js/GNB.jsp">
  <c:param name="pageName" value="gallery"/>
  <c:param name="btnNum" value="${categoryType}"/>
</c:import>
<div class="container-xl">
  <form action="/gallery/${card.seq}/modify" method="post" id="card-form" enctype="multipart/form-data">
    <input type="hidden" name="seq" value="${card.seq}">
    <input type="hidden" name="category_type" value="${categoryType}">
    <input type="hidden" name="writer" value="${sessionScope.code}">
    <input type="hidden" name="yn" value="${card.yn}">
    <div class="row input-box">
      <div class="col-6 d-flex justify-content-start align-items-center">
        <p class="m-0">AI 생성 컨텐츠인가요?</p>
      </div>
      <div class="col-6 d-flex justify-content-end align-items-center">
        <div class="btn-group" role="group" aria-label="ai radio button group">
          <input type="radio" class="btn-check" name="ai" id="input_ai_y" autocomplete="off" value="Y"
          <c:if test="${card.ai == 'Y'}">
               checked
          </c:if>
          >
          <label class="btn common-button-group" for="input_ai_y">네</label>
          <input type="radio" class="btn-check" name="ai" id="input_ai_n" autocomplete="off" value="N"
          <c:if test="${card.ai == 'N'}">
                 checked
          </c:if>
          >
          <label class="btn common-button-group" for="input_ai_n">아니오</label>
        </div>
      </div>
    </div>
    <div class="row input-box">
      <div class="col-6 d-flex justify-content-start align-items-center">
        <label for="input_title">제목</label>
      </div>
      <div class="col-6 d-flex justify-content-end align-items-center">
        <input class="input-text" type="text" name="title" id="input_title" value="${card.title}" placeholder="제목 : 최대 30자">
      </div>
    </div>
    <c:if test="${categoryType<=1002}">
      <div class="row input-box">
        <div class="col-md-12">
          <div class="genre">
            <p class="m-0">장르 / 최대 2개</p>
            <table class="w-100">
              <thead></thead>
              <tbody>
              <c:forEach items="${genreTypes}" var="genreType" varStatus="status">
                <c:if test="${status.count % 4 == 1}">
                  <tr>
                </c:if>
                <td>
                  <input type="checkbox" name="genreType" id="genre-${genreType.code}" value="${genreType.code}"
                  <c:if test="${card.genre_type1 != null and card.genre_type1 == genreType.code}">
                    checked
                  </c:if>
                  <c:if test="${card.genre_type2 != null and card.genre_type2 == genreType.code}">
                    checked
                  </c:if>
                  >
                  <label for="genre-${genreType.code}">${genreType.name}</label>
                </td>
                <c:if test="${status.count % 4 == 0 or status.last}">
                  </tr>
                </c:if>
              </c:forEach>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </c:if>
    <div class="row input-box">
      <div class="col-6 d-flex justify-content-start align-items-center">
        <label for="input_catchphrase">한 줄 요약</label>
      </div>
      <div class="col-6 d-flex justify-content-end align-items-center">
        <input class="input-text" type="text" name="catchphrase" id="input_catchphrase" placeholder="한 줄 요약 : 최대 20글자" value="${card.catchphrase}">
      </div>
    </div>
    <div class="row input-box">
      <div class="col-6 d-flex justify-content-start align-items-center">
        <label for="input_synopsis">줄거리</label>
      </div>
      <div class="col-6 d-flex justify-content-end align-items-center">
        <input class="input-text" type="text" name="synopsis" id="input_synopsis" placeholder="줄거리 : 최대 100글자" value="${card.synopsis}">
      </div>
    </div>
    <div class="row input-box">
      <div class="col-6 d-flex justify-content-start align-items-center">
        <label for="input_thumbnail_url">썸네일</label>
      </div>
      <div class="col-6 d-flex justify-content-end align-items-center">
        <input class="form-control form-control-sm" type="file" name="thumbnail_image" id="input_thumbnail_url" onchange="readURL(this)"
               formenctype="multipart/form-data">
        <input type="hidden" name="thumbnail_url" value="${card.thumbnail_url}">
      </div>
      <div class="col-12">
        <img class="preview-img" src="${card.thumbnail_url}" alt="${card.thumbnail_url}" id="img">
      </div>
    </div>
    <div class="row input-box">
      <div class="col-6 d-flex justify-content-start align-items-center">
        <button type="submit" class="common-button">수정</button>
      </div>
      <div class="col-6 d-flex justify-content-end align-items-center">
        <a href="/gallery/${card.seq}">
          <button type="button" class="common-button">돌아가기</button>
        </a>
      </div>
    </div>
  </form>
</div>
<script>
    $("input[name='genreType']").on("click", function () {
        const count = $("input:checked[name='genreType']").length;
        if (count > 2) {
            $(this).prop('checked', false);
            alert('장르는 최대 2개까지만 선택 가능합니다.');
        }
    });
    const allowVal = $('#input_allow_show');
    $(allowVal).on('change', function () {
        const hiddenAllow = $('#hidden_allow');
        if (allowVal.prop('checked')) {
            hiddenAllow.val('Y');
        } else {
            hiddenAllow.val('N');
        }
    });
    $('#card-form').on('submit', (e) => {
        if ($('#input_title').val().trim() === '') {
            e.preventDefault();
            alert("제목을 입력해주세요.");
            return false;
        }
        if ((${categoryType <= 1002}) && ($("input:checked[name='genreType']").length === 0)) {
            e.preventDefault();
            alert("장르를 체크해주세요.");
            return false;
        }
        if ($('#input_catchphrase').val().trim() === '') {
            e.preventDefault();
            alert("한 줄 요약을 입력해주세요.");
            return false;
        }
        if ($('#input_synopsis').val().trim() === '') {
            e.preventDefault();
            alert("줄거리를 입력해주세요.");
            return false;
        }
    });

    function readURL(input) {
        if (input.files && input.files[0]) {
            const reader = new FileReader();
            const blob = new Blob([input.files[0]]);
            reader.onload = function () {
                $('#img').attr('src', URL.createObjectURL(blob));
                $('input[name="thumbnail_url"]').val(input.files[0].name);
            };
            reader.readAsDataURL(blob);
        } else {
            $('#img').attr('src', "");
            $('input[name="thumbnail_url"]').val("");
        }
    }
</script>
</body>
</html>
