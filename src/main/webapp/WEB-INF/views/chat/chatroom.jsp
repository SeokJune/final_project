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
			})
			
			let lastScroll = 0;
			let dragFlag = false;
			let lengthsize = false;
			
			$("#div_contents").scroll(function(e){
				if (dragFlag || lengthsize){
					return;
				}
				let currentScroll = $(this).scrollTop();
				let contents_height = $("#div_contents").height();
				
				let now_height = $(this).scrollTop()+$("#div_contents").height();
				console.log("라스트 스크롤"+lastScroll)
				console.log("커런트 스크롤"+currentScroll);
				console.log("최대높이"+contents_height);
				console.log("커런트+최대높이"+now_height);
				if(currentScroll < lastScroll){
					if(currentScroll < 200){
						
						dragFlag = true;
						
						$.ajax({
							url: "/chatlog",
							method:"post",
							data:{
								seq:"${chatseq}"
							}
						}).done(function(resp){
							console.log(resp);
							if(resp.length == 0){
								lengthsize = true;
							}
							for(var i = resp.length-1;i >= 0;i--){
								const datalinediv = $("<div>");
								datalinediv.addClass("linebox");
								const datatextdiv = $("<div>");
								if(resp[i].writer == ${code}){
									datatextdiv.addClass("mytext");
									datatextdiv.append(resp[i].txt);
								}else{
									const datawriterbox = $("<div>");
									datawriterbox.addClass("writerbox");
									datawriterbox.append(resp[i].writer);
									datalinediv.append(datawriterbox);
									datatextdiv.addClass("othertext");
									datatextdiv.append(resp[i].txt);
								}
								datalinediv.append(datatextdiv);
								$("#div_contents").prepend(datalinediv);	
							}
							dragFlag = false;
							let chatbox = document.querySelector('#div_contents');
						})
					}
				}
				lastScroll = currentScroll;
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
        	메모 : 1. 시간을 나타내야 함 일단 시/분은 채팅 옆쪽에 출력하고 년 월 일은 모아서 위쪽에 추가 ( 카톡처럼 )
        		  2. regex 1300자 제한 해줘야 함 안그럼 DB 에 안들어가서 오류남 ( DB는 4000자 까지 되는데 한글은 3배라 1300자만 )
        </div>
    </div>
</body>
</html>