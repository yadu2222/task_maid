import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_maid/data/controller/room_manager.dart';
import 'package:task_maid/data/controller/task_manager.dart';
import 'pages/page_home.dart';
import '../const/items.dart';
import '../data/database_helper.dart';
import '../data/controller/door.dart'; // 各情報のクラス
import '../data/models/component_communication.dart';
import '../view/pages/page_registration.dart';

class MyApp extends StatelessWidget {
  // wsインスタンスの宣言
  final SocketIO sio = SocketIO();
  final Door _door = Door();

  void initaState() {
    // _door.load();
  }

  Widget loadMaid() {
    return SizedBox(child: Image.asset(items.taskMaid['move'][0]));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, //デバッグの表示を消す

      // 非同期処理
      home: FutureBuilder<bool>(
        // ここに入れた処理を待ってreturnの中身を実行する
        // dbの有無を確認
        future: DatabaseHelper.firstdb(),
        // snapshotに非同期処理の進捗や結果が含まれる
        builder: (context, snapshot) {
          // connectionStateを参照
          // connectionStateに関する補足
          // connectionState.none まだ非同期処理が開始されていない
          // waiting 非同期処理を実行中で結果がまだ出ていない
          // active 非同期処理を実行中で、結果が出た
          // done 非同期処理が完了し、結果を受け取った
          if (snapshot.connectionState == ConnectionState.waiting) {
            return loadMaid();
            //  CircularProgressIndicator(); // データベース確認中のローディング表示
            // エラー
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');

            // waitingでもerrorでもない = 結果を受け取っている
          } else {
            final bool isMemberRegistered = snapshot.data ?? false;

            return isMemberRegistered
                ? PageHome() // メンバーが登録済みの場合のホームページ
                : PageRegistration(); // メンバーが未登録の場合の登録ページ
          }
        },
      ),
    );
  }
}
