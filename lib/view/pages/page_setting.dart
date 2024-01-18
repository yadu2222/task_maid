import 'dart:io';

import 'package:flutter/material.dart';
import '../constant.dart';
import '../items.dart';
import '../molecules.dart';
import '../component_communication.dart';
import 'package:http/http.dart' as http; // http
import 'dart:convert'; // json
import '../app.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class PageSetting extends StatefulWidget {
  const PageSetting({Key? key}) : super(key: key);

  @override
  _PageSetting createState() => _PageSetting();
}

class _PageSetting extends State<PageSetting> {
  // インスタンス生成
  late WebSocket ws;
  // テキストフィールド
  final controllerTextField = TextEditingController();
  // wssssssssssssssssssss
  String testText = '';
  //late io.Socket socket;
  // wssssssssssssssssssss
  @override
  void initState() {
    super.initState();
    debugPrint("befor initState"); // ok
    //Tryws ws = Tryws();
    ws = WebSocket();
    //_connectWS();
    //ws = WebSocket(); // ウィジェットが初期化されたときに WebSocket インスタンスを生成
    debugPrint("after initState"); // ok
  }

  // wssssssssssssssssssss
  // // Websocketの接続をコンストラクタから非同期で実行
  // Future<void> _connectWS() async {
  //   // httpでの疎通確認
  //   //var req = http.Request("POST", Uri.parse("http://10.0.2.2:5000/post_"));  // HTTPリクエストメソッドの種類とuriから
  //   var req = http.Request("POST", Uri.parse("http://" + Url.serverIP + ":5000/post_")); // HTTPリクエストメソッドの種類とuriから
  //   try {
  //     req.body = json.encode({"key": "testhoge"}); // bodyをjson形式に変換
  //     var res = req.send().then((value) => debugPrint(value.statusCode.toString())); //.timeout(const Duration(seconds: 5));
  //   } catch (e) {
  //     print("UGOKAN");
  //   }

  //   // ws
  //   // socket = io.io('http://10.0.2.2:5000', <String, dynamic>{
  //   socket = io.io('http://' + Url.serverIP + ':5108', <String, dynamic>{
  //     'transports': ['websocket'],
  //   });

  //   // on
  //   socket.on(
  //     'socket_connection_response',
  //     (data) {
  //       debugPrint(data);
  //       testText = "socket_connection_response: " + data;
  //     },
  //   );

  //   socket.on('socket_test_response', (data) {
  //     // response
  //     setState(() {
  //       debugPrint(data);
  //       testText = "socket_test_response: " + data;
  //     });
  //   });

  //   socket.on(
  //     '',
  //     (data) {},
  //   );

  //   socket.connect().emit('connect_socket', "Connection time: " + DateTime.now().toString());

  //   //channel = IOWebSocketChannel.connect(Uri.parse("ws://localhost:5000"));

  //   // try {
  //   //   channel = IOWebSocketChannel.connect(Uri.parse("ws://127.0.0.1:5000"));
  //   // } catch (e) {
  //   //   // 通信だめめ
  //   //   debugPrint("つなんがんない。鯖君しんでっかも。");
  //   // }
  // }

  // void _sendMessage(message) {
  //   // msg
  //   if (message.isNotEmpty) {
  //     socket.emit('socket_test', message);
  //   }
  // }
  // wssssssssssssssssssss

  @override
  Widget build(BuildContext context) {
    //画面サイズ
    var screenSizeWidth = MediaQuery.of(context).size.width;
    var screenSizeHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        body: Center(
            child: Container(
      width: screenSizeWidth,
      height: screenSizeHeight,
      decoration: BoxDecoration(color: Constant.main),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // 上部バー部分
            molecules.PageTitle(context, '設定'),

            // ========================
            // // 設定
            // Container(
            //   margin: EdgeInsets.all(screenSizeWidth * 0.05),
            //   child: Column(
            //     children: [
            //       Container(
            //         margin: EdgeInsets.only(left: screenSizeWidth * 0.03),
            //         padding: EdgeInsets.all(screenSizeWidth * 0.03),
            //         alignment: Alignment.bottomLeft,
            //         child: CustomText(text: 'ID：${items.userInfo['userid']}', fontSize: screenSizeWidth * 0.045, color: Constant.glay),
            //       ),
            //       Container(
            //         margin: EdgeInsets.only(left: screenSizeWidth * 0.03),
            //         padding: EdgeInsets.all(screenSizeWidth * 0.03),
            //         alignment: Alignment.bottomLeft,
            //         child: CustomText(text: 'ユーザーネーム', fontSize: screenSizeWidth * 0.045, color: Constant.glay),
            //       ),
            //       Container(
            //         width: screenSizeWidth * 0.8,
            //         height: screenSizeHeight * 0.065,
            //         padding: EdgeInsets.only(left: screenSizeWidth * 0.05, right: screenSizeWidth * 0.05, top: screenSizeWidth * 0.025, bottom: screenSizeWidth * 0.025),
            //         decoration: BoxDecoration(color: Constant.glay, borderRadius: BorderRadius.circular(16)),
            //         child: TextField(
            //           decoration: InputDecoration(
            //             hintText: items.userInfo['name'], // いまのなまえ
            //           ),
            //           onChanged: (text) {
            //             items.userInfo['name'] = text;
            //           },
            //         ),
            //       ),
            //       InkWell(
            //         onTap: () async {
            //           // ここに処理を書いてね
            //           // ws
            //           String msg = controllerTextField.text;
            //           //ws.sendTestMsg(msg);
            //           controllerTextField.clear();
            //           // http
            //           // http.Response response = await HttpToServer.httpReq("POST", "/post_ins_new_record", {
            //           //   "tableName": "rooms",
            //           //   "pKey": "room_id",
            //           //   "pKeyValue": "uuid-1",
            //           //   "recordData": {
            //           //     "room_id": "uuid-1",
            //           //     "room_name": "Sp:でかでかでっかまんのへや",
            //           //     "applicant": ["uuid"],
            //           //     "workers": ["46956da2-7b0a-49e6-b980-f5ef4e7e3f12"],
            //           //     "leaders": ["005f9164-5eeb-4cfb-a039-8a9dceb07162"],
            //           //     "tasks": ["479d765d-9677-465a-8901-c1116cc9b5e3"],
            //           //     "room_number": "8282",
            //           //     "is_sub_room": 0,
            //           //     "main_room_id": "uuid",
            //           //     "sub_rooms": ["7163c555-4f0b-4a69-b757-36d68c4ee1bb", "bfa33bc9-d76c-4818-bdc8-e7cf2464eb50"],
            //           //   }
            //           // });
            //           // print(response.statusCode);
            //           // print(response.body);
            //         },
            //         child: Container(
            //             width: screenSizeWidth * 0.8,
            //             height: screenSizeHeight * 0.065,
            //             padding: EdgeInsets.only(left: screenSizeWidth * 0.05, right: screenSizeWidth * 0.05, top: screenSizeWidth * 0.025, bottom: screenSizeWidth * 0.025),
            //             decoration: BoxDecoration(color: Constant.glay, borderRadius: BorderRadius.circular(16)),
            //             child: CustomText(text: 'BUTTON: ;~~~;', fontSize: screenSizeWidth * 0.03, color: Constant.blackGlay)), // ';~~~;'
            //       ),
            //       //WSState.testContainer(WSState.receivedData, context)
            //     ],
            //   ),
            // ),
            // ========================
            Container(
                width: screenSizeWidth,
                alignment: const Alignment(0.0, 0.0), //真ん中に配置
                margin: EdgeInsets.all(screenSizeWidth * 0.02),

// バー部分
                child: Row(children: [
                  SizedBox(width: screenSizeWidth * 0.05),
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Constant.glay,
                      size: 35,
                    ),
                    onPressed: () {
                      Navigator.pop(context); // 前のページに戻る
                    },
                  ),
                  CustomText(text: "設定", fontSize: screenSizeWidth * 0.06, color: Constant.glay),
                ])),
            SizedBox(
              width: screenSizeWidth * 0.8,
              child: TextField(
                controller: controllerTextField, // 入力内容を入れる
                decoration: const InputDecoration(
                  border: OutlineInputBorder(), // 枠
                  labelText: "ここにいれた文字を鯖にwsで送る。",
                  hintText: "ひんとてきすと",
                  errorText: "えらー(笑)", // 実際には出したり出さなかったり
                ),
              ),
            ),
            InkWell(
              onTap: () {
                // ここに処理を書いてね
                // ws
                String msg = controllerTextField.text;
                ws.sendTestMsg(msg); //sendTestMsg(msg);
                controllerTextField.clear();

                // http
                // http.Response response = await HttpToServer.httpReq("POST", "/post_ins_new_record", {
                //   "tableName": "rooms",
                //   "pKey": "room_id",
                //   "pKeyValue": "uuid-1",
                //   "recordData": {
                //     "room_id": "uuid-1",
                //     "room_name": "Sp:でかでかでっかまんのへや",
                //     "applicant": ["uuid"],
                //     "workers": ["46956da2-7b0a-49e6-b980-f5ef4e7e3f12"],
                //     "leaders": ["005f9164-5eeb-4cfb-a039-8a9dceb07162"],
                //     "tasks": ["479d765d-9677-465a-8901-c1116cc9b5e3"],
                //     "room_number": "8282",
                //     "is_sub_room": 0,
                //     "main_room_id": "uuid",
                //     "sub_rooms": ["7163c555-4f0b-4a69-b757-36d68c4ee1bb", "bfa33bc9-d76c-4818-bdc8-e7cf2464eb50"],
                //   }
                // });
                // print(response.statusCode);
                // print(response.body);
              },
              child: Container(
                margin: EdgeInsets.all(screenSizeWidth * 0.03),
                width: screenSizeWidth * 0.8,
                height: screenSizeHeight * 0.05,
                decoration: BoxDecoration(color: Constant.glay),
                child: CustomText(text: 'てすとBUTTON: ;~~~;', fontSize: screenSizeWidth * 0.03, color: Constant.blackGlay),
              ),
            ),

            CustomText(text: "TEST response", fontSize: screenSizeWidth * 0.05, color: Constant.black),
            Container(
              margin: EdgeInsets.all(screenSizeWidth * 0.02),
              height: screenSizeHeight * 0.075,
              alignment: Alignment(0, 0),
              decoration: BoxDecoration(color: Constant.white, borderRadius: BorderRadius.circular(16)),
              child: CustomText(text: testText, fontSize: screenSizeWidth * 0.05, color: Constant.blackGlay), // ws.testText
            ),

            CustomText(text: "Connected Response.", fontSize: screenSizeWidth * 0.05, color: Constant.black),
            Container(
              margin: EdgeInsets.all(screenSizeWidth * 0.02),
              height: screenSizeHeight * 0.075,
              alignment: Alignment(0, 0),
              decoration: BoxDecoration(color: Constant.white, borderRadius: BorderRadius.circular(16)),
              child: CustomText(text: ws.serverResMsg, fontSize: screenSizeWidth * 0.05, color: Constant.blackGlay), // ws.testText
            )
          ],
        ),
      ),
    )));
  }
}
