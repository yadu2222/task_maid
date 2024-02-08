import 'package:flutter/material.dart';

import '../../data/controller/user_manager.dart';
import '../../data/database_helper.dart';
import '../../view/pages/page_home.dart';
import '../../view/design_system/constant.dart';
import 'package:http/http.dart' as http; // http
import '../../data/models/component_communication.dart';
import 'dart:convert'; // json

class PageRegistration extends StatefulWidget {
  const PageRegistration({Key? key}) : super(key: key);

  @override
  _PageRegistration createState() => _PageRegistration();
}

class _PageRegistration extends State<PageRegistration> {
  final TextEditingController controllerTextFieldHttpInsertUsersMail = TextEditingController();
  final TextEditingController controllerTextFieldHttpInsertUsersName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // 画面サイズ
    var screenSizeWidth = MediaQuery.of(context).size.width;
    var screenSizeHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
          child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(color: Constant.main),
        child: Column(
          children: [
            SizedBox(
              height: screenSizeHeight * 0.2,
            ),
            CustomText(text: "アカウント作成", fontSize: 24, color: Constant.white),
            Container(
              width: screenSizeWidth * 0.75,
              margin: EdgeInsets.all(10),
              child: TextField(
                controller: controllerTextFieldHttpInsertUsersMail, // 入力内容を入れる
                decoration: const InputDecoration(
                  border: OutlineInputBorder(), // 枠
                  labelText: "mail",
                ),
              ),
            ),
            Container(
              width: screenSizeWidth * 0.75,
              margin: EdgeInsets.all(10),
              child: TextField(
                controller: controllerTextFieldHttpInsertUsersName, // 入力内容を入れる
                decoration: const InputDecoration(
                  border: OutlineInputBorder(), // 枠
                  labelText: "name",
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

                // mapに変換 サーバーから帰ってきたuserDataをdbに保存
                Map<String, dynamic> addUserData = {
                  "user_id": jsonDecode(httpResponse.body)["srv_res_data"],
                  "mail": controllerTextFieldHttpInsertUsersMail.text,
                  "name": controllerTextFieldHttpInsertUsersName.text,
                  "sid": "",
                  "tasks": [],
                  "rooms": []
                };

                await DatabaseHelper.insert('users', addUserData);

                // 登録しました！のダイアログを出したいなあという気持ちがある

                Navigator.push(context, MaterialPageRoute(builder: (context) => PageHome()));
              },
              child: Container(
                margin: EdgeInsets.all(screenSizeWidth * 0.03),
                width: screenSizeWidth * 0.3,
                height: screenSizeHeight * 0.05,
                alignment: const Alignment(0.0, 0.0), //中身の配置真ん中

                decoration: BoxDecoration(
                  color: Constant.glay,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: CustomText(text: '登録', fontSize: screenSizeWidth * 0.04, color: Constant.blackGlay),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
