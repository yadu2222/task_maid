import 'package:flutter/material.dart';
import '../constant.dart';
import '../items.dart';
// import 'package:web_socket_channel/io.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:http/http.dart' as http;  // http
import 'dart:convert';  // json


class PageSetting extends StatefulWidget {
  const PageSetting({Key? key}) : super(key: key);

  @override
  _PageSetting createState() => _PageSetting();
}

class _PageSetting extends State<PageSetting> {

  String testText = '';

  // late WebSocketChannel channel;
  //final WebSocketChannel channel = IOWebSocketChannel.connect(Uri.parse("ws://localhost:5000"));

  // テキストフィールド
  final controllerTextfield = TextEditingController();


  final List<String> _messages = [];
  late io.Socket socket;

  @override
  void initState(){
    super.initState();
    // Websocketの接続をコンストラクタから非同期で起動
    _connectWS();
  }
  // Websocketの接続をコンストラクタから非同期で実行
  Future<void> _connectWS()async{
    // httpでの疎通確認
    var req = http.Request("POST", Uri.parse("http://10.0.2.2:5000/post_"));  // HTTPリクエストメソッドの種類とuriから
    try {
    req.body = json.encode({"key": "testhoge"});  // bodyをjson形式に変換
      var res = req.send().then((value) => debugPrint(value.statusCode.toString()));//.timeout(const Duration(seconds: 5));
    } catch (e) {
      print("UGOKAN");
    }

    // ws
    socket = io.io('http://10.0.2.2:5000', <String, dynamic>{
      'transports': ['websocket'],
    });
    socket.on('response', (data) {
      setState(() {
        debugPrint(data);
        testText = data;
        _messages.add(data);
      });
    });

    socket.on('', (data) {
      
    },);

    socket.connect();


    //channel = IOWebSocketChannel.connect(Uri.parse("ws://localhost:5000"));

    // try {
    //   channel = IOWebSocketChannel.connect(Uri.parse("ws://127.0.0.1:5000"));
    // } catch (e) {
    //   // 通信だめめ
    //   debugPrint("つなんがんない。鯖君しんでっかも。");
    // }
  }

  void _sendMessage() {
    String message = controllerTextfield.text;
    if (message.isNotEmpty) {
      socket.emit('message', message);
      controllerTextfield.clear();
    }
  }
  @override
  Widget build(BuildContext context) {
    //画面サイズ
    var _screenSizeWidth = MediaQuery.of(context).size.width;
    var _screenSizeHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        body: Center(
            child: Container(
      width: _screenSizeWidth,
      height: _screenSizeHeight,
      decoration: BoxDecoration(color: Constant.main),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Container(
                width: _screenSizeWidth,
                alignment: const Alignment(0.0, 0.0), //真ん中に配置
                margin: EdgeInsets.all(_screenSizeWidth * 0.02),

// バー部分
                child: Row(children: [
                  SizedBox(width: _screenSizeWidth * 0.05),
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
                  CustomText(
                      text: "設定",
                      fontSize: _screenSizeWidth * 0.06,
                      color: Constant.glay),
                ])),
            SizedBox(
              width: _screenSizeWidth * 0.8,
              child: TextField(
                controller: controllerTextfield,  // 入力内容を入れる
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
                // ここに処理設置
                //HttpToServer.httpReq("/result", "POST", {"id": 1234});
                // フィールドもらってきて送信
                // channel.sink.add(controllerTextfield.text);
                _sendMessage();
/*                 setState(() {
                  testText = 
                });
 */              },
              
              child: Container(
                width: _screenSizeWidth * 0.8,
                height: _screenSizeHeight * 0.05,
                decoration: BoxDecoration(color: Constant.glay),
                child: CustomText(
                    text: 'てすと',
                    fontSize: _screenSizeWidth * 0.03,
                    color: Constant.blackGlay),
              ),

              
            ),

            Container(
              margin:EdgeInsets.all(_screenSizeWidth*0.02),
              height: _screenSizeHeight*0.075,
              alignment: Alignment(0, 0),
              decoration: BoxDecoration(color: Constant.white,borderRadius: BorderRadius.circular(16)),
              child: CustomText(text: testText, fontSize: _screenSizeWidth*0.05, color: Constant.blackGlay),
            )
          ],
        ),
      ),
    )));
  }
}
