import 'dart:convert';

import 'package:flutter/material.dart';
import 'pages/page_home.dart';
import '../const/items.dart';
import '../data/database_helper.dart';

// 各情報のクラス
import '../data/models/door.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false, //デバッグの表示を消す
      home: MyStatefulWidget(), //ホーム画面を呼び出す
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  // アプリケーションの動的なUIの作成と更新？
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  final Door _door = Door();

  // 既にdbが存在しているかを判定し、なければ追加
  dbroomFirstAdd() async {
    if (!await DatabaseHelper.firstdb()) {
      // デフォルトの部屋の追加
      var firstAdd = {
        'room_id': '100',
        'room_name': 'てすとるーむ',
        'leaders': jsonEncode([items.userInfo['userid']]),
        'workers': jsonEncode([items.userInfo['userid']]),
        'tasks': jsonEncode([]),
        'room_number': '0',
        'sub_rooms': jsonEncode(['0']),
        'bool_sub_room': 0,
        'main_room_id': '0'
      };
      // _roomManager.deleat(_roomManager.findByindex(0));
      DatabaseHelper.insert('rooms', firstAdd);
    }
  }

  @override
  void initState() {
    super.initState();
    dbroomFirstAdd();
    _door.load();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: PageHome(),
    );
  }
}
