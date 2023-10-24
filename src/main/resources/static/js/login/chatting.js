    let wsmsg = new WebSocket('ws:/172.30.1.39/user');  //채팅용 소켓
    let wslist = new WebSocket('ws:/172.30.1.39/list'); //참여인원 소켓

    wsmsg.onopen = function(event) {
        console.log("채팅이 열렸습니다.");
        var json = {
            "type" : "message",
            "userName" : name,
            "msg": ""
        }
        wsmsg.send(JSON.stringify(json));
    };
    wsmsg.onmessage = async function(event) {
        var eventData = event.data;
            if (event !== null && event !== undefined) {
                var msg = JSON.parse(eventData);
                msg.msg = msg.msg.replace(/</g,"&lt;").replace(/>/g,"&gt;");    //tag 적용시키지 않도록 <> 변환
                if(msg.time != null && msg.time.split(":")[1] < 10){msg.time= msg.time.split(":")[0]+":"+0+msg.time.split(":")[1] }
                if(msg.msg===""){
                    $("#messageBox").append(
                        "<div class='messageName' style='text-align: left;'><img src='/resources/pandora_logo.png' style='width:30px; height:30px; margin-right:3px;'>"+msg.userName+"님이 들어오셨습니다.</div>"
                    );
                }
                else if(msg.msg===" "){
                    $("#messageBox").append(
                        "<div class='messageName' style='text-align: left;'><img src='/resources/pandora_logo.png' style='width:30px; height:30px; margin-right:3px;'>"+msg.userName+"님이 나가셨습니다.</div>"
                    );
                }
                else if(msg.userName===name){
                    $("#messageBox").append(
                        "<div class='messageName'><img src='/resources/pandora_logo.png' style='width:30px; height:30px; margin-right:3px;'>나</div>"+
                        "<div class='time'>"+msg.time+"</div><div class='messageBody'>"+msg.msg+"</div><br><br>"
                    );
                }else if(msg.userName !==name){
                    $("#messageBox").append(
                        "<div class='messageName' style='text-align: left;'><img src='/resources/pandora_logo.png' style='width:30px; height:30px; margin-right:3px;'>"+msg.userName+"</div>"+
                        "<div class='messageBody' style='float:left;'>"+msg.msg+"</div><div class='time' style='float: left; padding-top:10px;'>"+msg.time+"</div><br><br>"
                    );
                }
                $("#messageBox").scrollTop($("#messageBox")[0].scrollHeight);
            }
    };
    wsmsg.onclose = function(event) { console.log('채팅이 닫혔습니다.'); };

// =============================================================================================

    wslist.onopen = function(event) {
        console.log("유저가 들어왔습니다.");
        wslist.send(name);
    };
    wslist.onmessage = async function(event) {
        try {
            if (event !== null && event !== undefined) {
                $("#messageList").empty();  // 새로고침하거나 페이지 이동하면 갱신되게끔 하기위해서 append한 div 제거하고 새로 출력
                let list = event.data.split(" ");
                for (let i=0; i < list.length-1; i++){
                    if(list[i] !== ""){ //공백도 출력됐었는데 if문으로 출력하지 않게 조건 걸어놓으니 해결
                        $("#messageList").append(
                            "<div class='messageName' style='text-align: left;'><img src='/resources/pandora_logo.png' style='width:30px; height:30px; margin-right:3px;'>"+list[i]+"</div>"
                        );
                    }
                }
            }
        } catch (err) { console.log(err); }
    };
    wslist.onclose = function(event) {
        console.log('유저가 나갔습니다.');
    };



