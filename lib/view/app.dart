import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_maid/data/controller/room_manager.dart';
import 'package:task_maid/data/controller/task_manager.dart';
import 'pages/page_home.dart';
import '../const/items.dart';
import '../data/database_helper.dart';
import '../data/controller/door.dart'; // 各情報のクラス
import '../data/component_communication.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, //デバッグの表示を消す

      // 状態管理
      home: MultiProvider(providers: [ChangeNotifierProvider(create: (context) => TaskManager()), ChangeNotifierProvider(create: (context) => RoomManager())], child: MyStatefulWidget()), //ホーム画面を呼び出す
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
  // wsインスタンスの宣言
  late SocketIO sio;
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
    // wsインスタンス生成
    sio = SocketIO();
    dbroomFirstAdd();
    _door.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageHome(sio: sio),
    );
  }
}
