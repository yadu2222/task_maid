import 'dart:io';

import 'package:flutter/material.dart';
import 'package:task_maid/view/pages/page_home.dart';
import '../../const/items.dart';
import '../design_system/constant.dart';

import '../parts/Molecules.dart';

// 各情報のクラス
import '../../data/controller/door.dart';
import '../../data/models/task_class.dart';
import '../../data/models/msg_class.dart';
import '../../data/models/room_class.dart';

import '../../data/controller/room_manager.dart';
import '../../data/controller/task_manager.dart';

import '../../data/component_communication.dart';
import 'package:http/http.dart' as http; // http
import 'dart:convert'; // json
import '../app.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class PageSetting extends StatefulWidget {
  final SocketIO sio;
  const PageSetting({
    required this.sio,
    Key? key,
  }) : super(key: key);

  @override
  _PageSetting createState() => _PageSetting(sio: sio);
}

class _PageSetting extends State<PageSetting> {
  // インスタンス宣言
  SocketIO sio;
  _PageSetting({required this.sio});
  // テキストフィールド
  final controllerTextField = TextEditingController();

  @override
  void initState() {
    super.initState();
    //ws = WebSocket(); // ウィジェットが初期化されたときに WebSocket インスタンスを生成
  }

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
            molecules.PageTitle(
                context,
                '設定',
                1,
                PageHome(
                  sio: sio,
                )),
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
                // テキストフィールドコントローラからテキストを取り出し、
                String msg = controllerTextField.text;
                // wsのテスト用送信メソッドに与え、
                widget.sio.sendTestMsg(msg);
                sio.sendTestMsg(msg);
                // テキストフィールドをクリアする
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
              child: CustomText(text: sio.testText, fontSize: screenSizeWidth * 0.05, color: Constant.blackGlay), // ws.testText
            ),

            CustomText(text: "Connected Response.", fontSize: screenSizeWidth * 0.05, color: Constant.black),
            Container(
              margin: EdgeInsets.all(screenSizeWidth * 0.02),
              height: screenSizeHeight * 0.075,
              alignment: Alignment(0, 0),
              decoration: BoxDecoration(color: Constant.white, borderRadius: BorderRadius.circular(16)),
              child: CustomText(text: sio.serverResMsg, fontSize: screenSizeWidth * 0.05, color: Constant.blackGlay), // ws.testText
            )
          ],
        ),
      ),
    )));
  }
}
