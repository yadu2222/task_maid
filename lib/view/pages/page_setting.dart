import 'package:flutter/material.dart';
import '../constant.dart';
import '../items.dart';
import '../Molecules.dart';
//import '../component_communication.dart';
import '../test.dart';
import 'package:http/http.dart' as http; // http
import 'dart:convert'; // json

class PageSetting extends StatefulWidget {
  const PageSetting({Key? key}) : super(key: key);

  @override
  _PageSetting createState() => _PageSetting();
}

class _PageSetting extends State<PageSetting> {
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
            // 上部バー部分
            Molecules.PageTitle(context, '設定'),

            // 設定
            Container(
              margin: EdgeInsets.all(_screenSizeWidth * 0.05),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: _screenSizeWidth * 0.03),
                    padding: EdgeInsets.all(_screenSizeWidth * 0.03),
                    alignment: Alignment.bottomLeft,
                    child: CustomText(text: 'ID：${items.userInfo['userid']}', fontSize: _screenSizeWidth * 0.045, color: Constant.glay),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: _screenSizeWidth * 0.03),
                    padding: EdgeInsets.all(_screenSizeWidth * 0.03),
                    alignment: Alignment.bottomLeft,
                    child: CustomText(text: 'ユーザーネーム', fontSize: _screenSizeWidth * 0.045, color: Constant.glay),
                  ),
                  Container(
                    width: _screenSizeWidth * 0.8,
                    height: _screenSizeHeight * 0.065,
                    padding: EdgeInsets.only(left: _screenSizeWidth * 0.05, right: _screenSizeWidth * 0.05, top: _screenSizeWidth * 0.025, bottom: _screenSizeWidth * 0.025),
                    decoration: BoxDecoration(color: Constant.glay, borderRadius: BorderRadius.circular(16)),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: items.userInfo['name'], // いまのなまえ
                      ),
                      onChanged: (text) {
                        items.userInfo['name'] = text;
                      },
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      // ここに処理を書いてね
                      print("aaaaaaaa");

                      http.Response response = await HttpToServer.httpReq("POST", "/post_upd", {
                        "tableName": "rooms",
                        "pKey": "room_id",
                        "pKeyValue": "uuid-1",
                        "recordData": {
                          "room_id": "uuid-1",
                          "room_name": "Sp:でかでかでっかまんのへや",
                          "applicant": ["uuid"],
                          "workers": ["46956da2-7b0a-49e6-b980-f5ef4e7e3f12"],
                          "leaders": ["005f9164-5eeb-4cfb-a039-8a9dceb07162"],
                          "tasks": ["479d765d-9677-465a-8901-c1116cc9b5e3"],
                          "room_number": "8282",
                          "is_sub_room": 0,
                          "main_room_id": "uuid",
                          "sub_rooms": ["7163c555-4f0b-4a69-b757-36d68c4ee1bb", "bfa33bc9-d76c-4818-bdc8-e7cf2464eb50"],
                        }
                      });
                      print(response.statusCode);
                    },
                    child: Container(
                        width: _screenSizeWidth * 0.8,
                        height: _screenSizeHeight * 0.065,
                        padding: EdgeInsets.only(left: _screenSizeWidth * 0.05, right: _screenSizeWidth * 0.05, top: _screenSizeWidth * 0.025, bottom: _screenSizeWidth * 0.025),
                        decoration: BoxDecoration(color: Constant.glay, borderRadius: BorderRadius.circular(16)),
                        child: CustomText(text: ';~~~;', fontSize: _screenSizeWidth * 0.03, color: Constant.blackGlay)),
                  ),
                  WSState.testContainer('うける', context)
                ],
              ),
            ),
          ],
        ),
      ),
    )));
  }
}
