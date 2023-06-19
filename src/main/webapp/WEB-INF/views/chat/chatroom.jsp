<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.6.1/sockjs.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
<script src="https://code.jquery.com/jquery-3.6.4.js"></script>
	<style>
        *{box-sizing: border-box;}
        div{border: 1px solid black;}
        #div_contents{height: 700px; overflow: auto;background-color:yellow;}
        .linebox{overflow: auto;}
        .mytext{float:right;max-width:35%;word-break:break-all;padding-right:3px;background-color:red;}
        .othertext{float:left;max-width:35%;word-break:break-all;padding-right:3px;background-color:orange;}
        #div_text{height: 100px; overflow: auto;}
        .btn{width: 100%; height: 100%; background-color: gray;color: black;}
        .btn:hover{background-color: black;color:gray;}
    </style>
</head>
<body>
	<script>
		$(function(){
			const socket = new WebSocket("ws://192.168.50.203/chat");
			const stompClient = Stomp.over(socket);
			
			stompClient.connect({},function(){
				const subscription = stompClient.subscribe("/topic/${chatseq}", function(message){
					body = JSON.parse(message.body);
					console.log(message);
					console.log(body);
					const linediv = $("<div>");
					linediv.addClass("linebox");
					const textdiv = $("<div>");
					if(body.writer == ${code}){
						textdiv.addClass("mytext");
						textdiv.append(body.txt);
					}else{
						const writerbox = $("<div>");
						writerbox.addClass("writerbox");
						writerbox.append(body.writer);
						linediv.append(writerbox);
						textdiv.addClass("othertext");
						textdiv.append(body.txt);
					}
					linediv.append(textdiv);
					$("#div_contents").append(linediv);
					let chatbox = document.querySelector('#div_contents');
					chatbox.scrollTop = chatbox.scrollHeight;
				});
				let chatbox = document.querySelector('#div_contents');
				chatbox.scrollTop = chatbox.scrollHeight;
			},function(){
				alert("접속 실패");
			});
			
			$("#div_text").on("keydown",function(e){
				if(e.key == "Enter" && e.shiftKey){
						
				}else if(e.key == "Enter"){
					e.preventDefault();
					if($("#div_text").text().trim() == ""){
						return false;
					}else{
						const destination = "/app/message";
						const header = {};
						const body = JSON.stringify({chat_rooms : "${chatseq}" , writer : "${code}" , txt : $("#div_text").html()});
						stompClient.send(destination,header,body);
						$("#div_text").html("");
						$("#div_text").focus();
					}
				}
			})
			
			$("#button_send").on("click",function(){
				const destination = "/app/message";
				const header = {};
				const body = JSON.stringify({chat_rooms : "${chatseq}" , writer : "${code}" , txt : $("#div_text").html()});
				stompClient.send(destination,header,body);
				$("#div_text").html("");
				$("#div_text").focus();
			})
		})
	</script>
    <div class="container-fluid">
        <div class="row gnb">gnb</div>
	    <div class="row lnb">lnb</div>
    </div>
    <div class="container-xl">
        <div class="row">
            <div class="col-md-12" id="div_contents">
            	<c:forEach var="log" items="${chatlog}">
            		<c:choose>
            			<c:when test="${log.writer==code}">
            				<div class="linebox">
            					<div class="mytext">${log.txt}</div>
            				</div>
            			</c:when>
            			<c:otherwise>
            				<div class="linebox">
            					<div class="writerbox">${log.writer}</div>
            					<div class="othertext">${log.txt}</div>
            				</div>
            			</c:otherwise>
            		</c:choose>
            		
            	</c:forEach>
            </div>
        </div>
        <div class="row">
                <div class="col-md-10" contenteditable="true" id="div_text"></div>
            <div class="col-md-2 p-0">
                <button class="btn" id="button_send">작성</button>
            </div>
        </div>
        <div class="row">
        	메모 : 1. 무한 스크롤링을 할껀데 20개씩 데이터를 잘라서 가져오도록 할려고함.
        		  2. 무한 스크롤링을 할 때 마다 date 값을 불러와서 만약 전에 나왔던 (20개씩 불러오니깐) 숫자랑 같으면
        		  전에 띄웠던 date div 를 삭제하고 date 값을 다시 띄운다 ex) 카카오톡 스크롤링
        		  3. 처음 20개를 띄웠을 때 date 값을 어떻게 띄워야 할지 고민 해봐야겠다.
        		  4. 고민 해봤는데 다 가져와서 if 문으로 해야할 것 같긴 한데 띄울때 즉 c:forEach 돌릴 때 안쪽에 if 문
        		  쓰는건 거의 확실한데 전에 띄웠던 값을 seq-1 로 해서 할까? for 문으로 하는게 좋을듯?
        		  5. 컬럼을 한개 더 만들어서 date 가 전에 들어간 date 와 다르면 y 같으면 n 으로 하는거 어떰?
        </div>
    </div>
</body>
</html>