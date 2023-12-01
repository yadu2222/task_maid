import 'package:flutter/material.dart';
import 'constant.dart';

class items {
  static Map<String, dynamic> userInfo = {'name': 'おさかな', 'userid': '12345', 'userTask': taskList, 'message': message, 'myroom': myroom};

  static Map<String, dynamic> friend = {
    '12345': {'name': 'おさかな', 'userTask': taskList, 'message': message, 'myroom': '1234', 'bool': false},
    '23456': {'name': 'せろり', 'userTask': taskList, 'message': message, 'myroom': '1234', 'bool': false},
    '67890': {'name': 'ニャリオット', 'userTask': taskList, 'message': message, 'myroom': '2345', 'bool': false}
  };

  static Map myroom = {
    'myroomID': ['1111', '1234', '2345']
  };

  // ルーム
  static Map room = {
    '1111': {
      'roomName': 'てすとるーむ',
      'leader': '12345',
      'workers': ['12345'],
      'tasks': [
        {'user': 'おさかな', 'worker': 'おさかな', 'task': 'タスク追加機能', 'day': '10', 'month': '09', 'limitDay': '10-09', 'limitTime': '13:00', 'level': 3, 'bool': false, 'taskIndex': 0, 'roomid': '1111'},
      ],
    },
    '3456': {
      'roomName': '参加できない; ;',
      'leader': '12345',
      'workers': ['12345'],
      'tasks': [
        {'user': 'おさかな', 'worker': 'おさかな', 'task': 'タスク追加機能', 'day': '10', 'month': '09', 'limitDay': '10-09', 'limitTime': '13:00', 'level': 3, 'bool': false, 'taskIndex': 0, 'roomid': '3456'},
      ],
    },
    '1234': {
      'roomName': 'てくてくてっく',
      'leader': '12345',
      'workers': ['12345', '67890'],
      'tasks': [
        {'user': 'せろり', 'worker': 'おさかな', 'task': 'ニャリオットとあそぶ', 'day': '09', 'month': '23', 'limitDay': '09-23', 'limitTime': '10:25', 'level': 3, 'bool': false, 'taskIndex': 0, 'roomid': '1234'},
        {'user': 'せろり', 'worker': 'おさかな', 'day': '09', 'month': '23', 'task': 'フロント完成', 'limitDay': '09-23', 'limitTime': '10:25', 'level': 3, 'bool': false, 'taskIndex': 1, 'roomid': '1234'},
      ],
    },
    '2345': {
      'roomName': 'ニャリオットのお世話',
      'leader': '67890',
      'workers': ['67890'],
      'tasks': [
        {'user': 'おさかな', 'worker': 'おさかな', 'task': 'ニャリオットにごはんあげる', 'day': '09', 'month': '23', 'limitDay': '09-23', 'limitTime': '10:25', 'level': 3, 'bool': false, 'taskIndex': 0, 'roomid': '2345'},
      ],
    }
  };

  // 部屋を作るときに値を保存する変数
  static String roomName = '';
  static String roomNum = '0000';

  // タスクを追加するときに値を保存する変数
  static String worker = '';
  static String newtask = '0000';
  static DateTime limitTime = DateTime.now();

  // でーたべーすから自分でとってくるようにしないといけないんだろうなあとおもっているなう
  //タスクリスト
  static List taskList = [
    {
      'taskid': '123456654',
      'limit': DateTime.now(),
      'leader': 12345,
      'worker': 12345,
      'contents': 'でーたべーすどうにかしろ',
      'roomid': '1234',
      'status': 0,
    }
  ];

  static int karioki = 1234565;

  static Map sender = {
    'sender': [1234]
  };

  static Map message = {
    // ここ相手のgoogleアカウントとかにしないと名前変えたとき困るねとおもった
    // idに、すべきや、、、！！！
    '1234': [
      {'msgid': 1234556, 'time': DateTime.now(), 'message': 'おわりませんね', 'status': 1, 'index': 0, 'level': 2, 'sender': '23456', 'chatRoom': '1234'},
      {'msgid': 1234553, 'time': DateTime.now(), 'message': 'おわりませんね', 'status': 1, 'index': 0, 'level': 2, 'sender': '12345', 'chatRoom': '1234'},
    ],
  };

  // メッセージ
  static Map<String, dynamic> leaderWord = {
    'idWord': [
      {'sender': 'せろり', 'time': '2023-10-02', 'word': '遊んでないで仕事してください！！', 'level': 5, 'index': 0},
    ]
  };

  // 画像リスト
  static Map taskMaid = {
    'standing': [
      'assets/images/taskMaid_01.png', //とてもうれしい
      'assets/images/taskMaid_03.png', //びっくり
      'assets/images/taskMaid_04.png', //おろおろ
    ],
    'stamp': [
      'assets/images/stamp/taskMaid_stamp01.png',
      'assets/images/stamp/taskMaid_stamp02.png',
      'assets/images/stamp/taskMaid_stamp01.png',
      'assets/images/stamp/taskMaid_stamp01.png',
      'assets/images/stamp/taskMaid_stamp01.png',
      'assets/images/stamp/taskMaid_stamp01.png',
      'assets/images/stamp/taskMaid_stamp01.png',
      'assets/images/stamp/taskMaid_stamp01.png',
    ],
  };

  // messagesの画面内の状態を保存する変数
  static bool indexBool = false;
  static bool stamplist = false;
  static bool stampbool = false;
  static int stampIndex = 0;
  static int taskIndex = 0;

  Widget _test_taskList(var _screenSizeWidth) {
    return ListView.builder(
      // indexの作成 widgetが表示される数
      itemCount: items.taskList.length,
      itemBuilder: (context, index) {
        // 繰り返し描画されるwidget
        return Card(color: Constant.glay, elevation: 0, child: SizedBox());
      },
    );
  }
}
