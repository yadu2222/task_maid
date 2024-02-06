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
  const PageSetting({
    Key? key,
  }) : super(key: key);

  @override
  _PageSetting createState() => _PageSetting();
}

class _PageSetting extends State<PageSetting> {
  // インスタンス宣言
  SocketIO sio = SocketIO();
  // テキストフィールド
  final TextEditingController controllerTextFieldWSTest = TextEditingController();
  final TextEditingController controllerTextFieldHttpInsertUsersMail = TextEditingController();
  final TextEditingController controllerTextFieldHttpInsertUsersName = TextEditingController();
  final TextEditingController controllerTextFieldWSMsg = TextEditingController();
  String resCode = "";
  String resBody = "";

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
    // キーボードで持ち上がる分の高さを取得
    final bottomSpace = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
        // 自分で高さをせっていするのでfalse
        resizeToAvoidBottomInset: false,
        // スクロールを可能にする
        // こんなのあるんだあ、、、、
        body: SingleChildScrollView(
            // スクロールの向きを逆(true)に設定
            reverse: true,
            // 最初に取得した高さ分のpaddingを設定
            child: Padding(
                padding: EdgeInsets.only(bottom: bottomSpace),
                child: Center(
                    child: Container(
                  width: screenSizeWidth,
                  height: screenSizeHeight,
                  decoration: BoxDecoration(color: Constant.main),
                  child: SafeArea(
                    bottom: false,
                    child: Column(
                      children: [
                        // 上部バー部分
                        molecules.PageTitle(context, '設定', 1, PageHome()),

                        // ループして繰り返すリストウィジェットのサンプル
                        SizedBox(
                          height: screenSizeHeight * 0.85,
                          width: screenSizeWidth,
                          child: ListView(
                            // indexの作成 widgetが表示される数
                            children: [
                              // WS
                              CustomText(text: "WS", fontSize: screenSizeWidth * 0.05, color: Constant.black),
                              SizedBox(
                                width: screenSizeWidth * 0.8,
                                child: TextField(
                                  controller: controllerTextFieldWSTest, // 入力内容を入れる
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(), // 枠
                                    labelText: "ここにいれた文字を鯖にwsで送る。",
                                    hintText: "ひんとてきすと",
                                    errorText: "えらー(笑)", // 実際には出したり出さなかったり
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  // ここに処理を書いてね
                                  // ws
                                  // テキストフィールドコントローラからテキストを取り出し、
                                  String msg = controllerTextFieldWSTest.text;
                                  // wsのテスト用送信メソッドに与え、
                                  sio.sendTestMsg(msg);
                                  // テキストフィールドをクリアする
                                  controllerTextFieldWSTest.clear();
                                },
                                child: Container(
                                  margin: EdgeInsets.all(screenSizeWidth * 0.03),
                                  width: screenSizeWidth * 0.8,
                                  height: screenSizeHeight * 0.05,
                                  decoration: BoxDecoration(color: Constant.glay),
                                  child: CustomText(text: 'てすとBUTTON: ;~~~; ws', fontSize: screenSizeWidth * 0.03, color: Constant.blackGlay),
                                ),
                              ),
                              // レスポンス
                              CustomText(text: "WS connected Response.", fontSize: screenSizeWidth * 0.03, color: Constant.black),
                              Container(
                                margin: EdgeInsets.all(screenSizeWidth * 0.02),
                                height: screenSizeHeight * 0.075,
                                alignment: Alignment(0, 0),
                                decoration: BoxDecoration(color: Constant.white, borderRadius: BorderRadius.circular(16)),
                                child: CustomText(text: sio.serverResMsg, fontSize: screenSizeWidth * 0.03, color: Constant.blackGlay), // ws.testText
                              ),
                              CustomText(text: "WS test response", fontSize: screenSizeWidth * 0.03, color: Constant.black),
                              Container(
                                margin: EdgeInsets.all(screenSizeWidth * 0.02),
                                height: screenSizeHeight * 0.075,
                                alignment: Alignment(0, 0),
                                decoration: BoxDecoration(color: Constant.white, borderRadius: BorderRadius.circular(16)),
                                child: CustomText(text: sio.testText, fontSize: screenSizeWidth * 0.03, color: Constant.blackGlay), // ws.testText
                              ),

                              // http insert into rooms
                              CustomText(text: "HTTP /post_ins_new_record rooms", fontSize: screenSizeWidth * 0.05, color: Constant.black),
                              InkWell(
                                onTap: () async {
                                  // http
                                  // 部屋の追加
                                  http.Response httpResponse = await HttpToServer.httpReq("POST", "/post_ins_new_record", {
                                    "tableName": "rooms",
                                    "pKey": "room_id",
                                    "pKeyValue": "uuid-1",
                                    "recordData": {
                                      "room_id": "uuid-1",
                                      "room_name": "てすとるーむ",
                                      "applicant": ["uuid"],
                                      "workers": ["ca12c172-297d-459b-b371-9748754e9c34"],
                                      "leaders": ["c76c4655-0113-4c3c-a466-7e62dcae8875"],
                                      "tasks": ["479d765d-9677-465a-8901-c1116cc9b5e3"],
                                      "room_number": "8282",
                                      "is_sub_room": 0,
                                      "main_room_id": "uuid",
                                      "sub_rooms": ["7163c555-4f0b-4a69-b757-36d68c4ee1bb", "bfa33bc9-d76c-4818-bdc8-e7cf2464eb50"],
                                    }
                                  });
                                  resCode = httpResponse.statusCode.toString();
                                  debugPrint(resCode);
                                  resBody = httpResponse.body.toString();
                                  debugPrint(resBody);
                                },
                                child: Container(
                                  margin: EdgeInsets.all(screenSizeWidth * 0.03),
                                  width: screenSizeWidth * 0.8,
                                  height: screenSizeHeight * 0.05,
                                  decoration: BoxDecoration(color: Constant.glay),
                                  child: CustomText(text: 'てすとBUTTON: ;~~~; http insert into rooms', fontSize: screenSizeWidth * 0.03, color: Constant.blackGlay),
                                ),
                              ),

                              // http insert into users
                              CustomText(text: "HTTP /post_ins_new_record users", fontSize: screenSizeWidth * 0.05, color: Constant.black),
                              SizedBox(
                                width: screenSizeWidth * 0.8,
                                child: TextField(
                                  controller: controllerTextFieldHttpInsertUsersMail, // 入力内容を入れる
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(), // 枠
                                    labelText: "ここにいれたmailで追加",
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: screenSizeWidth * 0.8,
                                child: TextField(
                                  controller: controllerTextFieldHttpInsertUsersName, // 入力内容を入れる
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(), // 枠
                                    labelText: "ここにいれたnameで追加",
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  // http
                                  // ユーザーの追加
                                  http.Response httpResponse = await HttpToServer.httpReq("POST", "/post_ins_new_record", {
                                    "tableName": "users",
                                    "pKey": "user_id",
                                    "pKeyValue": "uuid-1",
                                    "recordData": {
                                      "mail": controllerTextFieldHttpInsertUsersMail.text,
                                      "name": controllerTextFieldHttpInsertUsersName.text,
                                      "tasks": ["46956da2-7b0a-49e6-b980-f5ef4e7e3f12"],
                                      "rooms": ["005f9164-5eeb-4cfb-a039-8a9dceb07162"],
                                    }
                                  });
                                  print(httpResponse.statusCode);
                                  print(httpResponse.body);
                                },
                                child: Container(
                                  margin: EdgeInsets.all(screenSizeWidth * 0.03),
                                  width: screenSizeWidth * 0.8,
                                  height: screenSizeHeight * 0.05,
                                  decoration: BoxDecoration(color: Constant.glay),
                                  child: CustomText(text: 'てすとBUTTON: ;~~~; http insert into users', fontSize: screenSizeWidth * 0.03, color: Constant.blackGlay),
                                ),
                              ),

                              // http insert into users
                              CustomText(text: "HTTP /post_ins_new_record users set", fontSize: screenSizeWidth * 0.05, color: Constant.black),
                              InkWell(
                                onTap: () async {
                                  // http
                                  // ユーザーの追加
                                  await HttpToServer.httpReq("POST", "/post_ins_new_record", {
                                    "tableName": "users",
                                    "pKey": "user_id",
                                    "pKeyValue": "uuid-1",
                                    "recordData": {
                                      "mail": "deka@gmail.com",
                                      "name": "でかでかでっかまん",
                                      "tasks": ["46956da2-7b0a-49e6-b980-f5ef4e7e3f12"],
                                      "rooms": ["005f9164-5eeb-4cfb-a039-8a9dceb07162"],
                                    }
                                  });
                                  await HttpToServer.httpReq("POST", "/post_ins_new_record", {
                                    "tableName": "users",
                                    "pKey": "user_id",
                                    "pKeyValue": "uuid-1",
                                    "recordData": {
                                      "mail": "gonta@gmail.com",
                                      "name": "ごんた",
                                      "tasks": ["46956da2-7b0a-49e6-b980-f5ef4e7e3f12"],
                                      "rooms": ["005f9164-5eeb-4cfb-a039-8a9dceb07162"],
                                    }
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.all(screenSizeWidth * 0.03),
                                  width: screenSizeWidth * 0.8,
                                  height: screenSizeHeight * 0.05,
                                  decoration: BoxDecoration(color: Constant.glay),
                                  child: CustomText(text: 'てすとBUTTON: ;~~~; http insert into users set', fontSize: screenSizeWidth * 0.03, color: Constant.blackGlay),
                                ),
                              ),

                              // レスポンス
                              CustomText(text: "Http response", fontSize: screenSizeWidth * 0.03, color: Constant.black),
                              Container(
                                margin: EdgeInsets.all(screenSizeWidth * 0.02),
                                height: screenSizeHeight * 0.075,
                                alignment: Alignment(0, 0),
                                decoration: BoxDecoration(color: Constant.white, borderRadius: BorderRadius.circular(16)),
                                child: CustomText(text: "Res code: " + resCode + ",Res body: " + resBody, fontSize: screenSizeWidth * 0.05, color: Constant.blackGlay), // ws.testText
                              ),

                              // WSで相手にmsgを送る
                              CustomText(text: "WS_msg", fontSize: screenSizeWidth * 0.05, color: Constant.black),
                              SizedBox(
                                width: screenSizeWidth * 0.8,
                                child: TextField(
                                  controller: controllerTextFieldWSMsg, // 入力内容を入れる
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(), // 枠
                                    labelText: "ここにいれた文字を相手にwsで送る。",
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  // ws
                                  // テキストフィールドコントローラからテキストを取り出し、
                                  String msg = controllerTextFieldWSMsg.text;
                                  // wsのテスト用送信メソッドに与え、
                                  sio.sendMsg("send_msg_chat", {
                                    "tableName": "msg_chats",
                                    // pKey, pKeyValue はauto_incrementなので不要
                                    "recordData": {
                                      "msg_datetime": DateTime.now().toString(),
                                      "receiver": "ca12c172-297d-459b-b371-9748754e9c34",
                                      "room_id": "89480fc8-68dc-47fe-960c-54caf4d29fe0",
                                      "level": 0,
                                      "status": 0,
                                      "stamp_id": 0,
                                      "quote_id": "",
                                      "msg": msg
                                    },
                                    "token_mail": "deka@gmail.com", // 本来はトークンで認証し、通ればuuidを利用もしくはmailからuuidを取得し利用する。
                                  });
                                  // テキストフィールドをクリアする
                                  controllerTextFieldWSMsg.clear();
                                },
                                child: Container(
                                  margin: EdgeInsets.all(screenSizeWidth * 0.03),
                                  width: screenSizeWidth * 0.8,
                                  height: screenSizeHeight * 0.05,
                                  decoration: BoxDecoration(color: Constant.glay),
                                  child: CustomText(text: 'てすとBUTTON: ;~~~; WS_msg', fontSize: screenSizeWidth * 0.03, color: Constant.blackGlay),
                                ),
                              ),
                              // レスポンス
                              CustomText(text: "WS test response", fontSize: screenSizeWidth * 0.03, color: Constant.black),
                              Container(
                                margin: EdgeInsets.all(screenSizeWidth * 0.02),
                                height: screenSizeHeight * 0.075,
                                alignment: Alignment(0, 0),
                                decoration: BoxDecoration(color: Constant.white, borderRadius: BorderRadius.circular(16)),
                                child: CustomText(text: sio.testText, fontSize: screenSizeWidth * 0.03, color: Constant.blackGlay), // ws.testText
                              ),

                              // http get records
                              CustomText(text: "HTTP /get_records", fontSize: screenSizeWidth * 0.05, color: Constant.black),
                              InkWell(
                                onTap: () async {
                                  // http
                                  http.Response httpResponse = await HttpToServer.httpReq("POST", "/get_records", {
                                    "tableName": "rooms",
                                    "keyList": [
                                      {
                                        "pKey": "room_name",
                                        "pKeyValue": "てすとるーむ",
                                        "isList": "False",
                                      },
                                      {
                                        "pKey": "leaders",
                                        "pKeyValue": "c76c4655-0113-4c3c-a466-7e62dcae8875",
                                        "isList": "True",
                                      }
                                    ]
                                  });
                                  resCode = httpResponse.statusCode.toString();
                                  debugPrint(resCode);
                                  resBody = httpResponse.body.toString();
                                  debugPrint(resBody);
                                },
                                child: Container(
                                  margin: EdgeInsets.all(screenSizeWidth * 0.03),
                                  width: screenSizeWidth * 0.8,
                                  height: screenSizeHeight * 0.05,
                                  decoration: BoxDecoration(color: Constant.glay),
                                  child: CustomText(text: 'てすとBUTTON: ;~~~; http insert into users set', fontSize: screenSizeWidth * 0.03, color: Constant.blackGlay),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )))));
  }
}
