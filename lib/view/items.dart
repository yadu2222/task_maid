import 'package:flutter/material.dart';
import 'constant.dart';

class items {
  static Map<String, dynamic> userInfo = {
    'name': 'おさかな',
    'userid': '12345',
    'userTask': taskList,
    'message': message,
    'myroom': myroom
  };

  static Map<String, dynamic> friend = {
    '12345': {'name': 'おさかな２', 'userTask': taskList, 'message': message, 'myroom': '1234'},
    '67890': {'name': 'ニャリオット', 'userTask': taskList, 'message': message, 'myroom': '2345'}
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
        {
          'user': 'おさかな',
          'woeker': 'おさかな',
          'task': 'タスク追加機能',
          'day': '10',
          'month': '09',
          'limitDay': '10-09',
          'limitTime': '13:00',
          'level': 3,
          'bool': false,
          'taskIndex': 0
        },
      ],
    },
    '3456': {
      'roomName': '参加できない; ;',
      'leader': '12345',
      'workers': ['12345'],
      'tasks': [
        {
          'user': 'おさかな',
          'woeker': 'おさかな',
          'task': 'タスク追加機能',
          'day': '10',
          'month': '09',
          'limitDay': '10-09',
          'limitTime': '13:00',
          'level': 3,
          'bool': false,
          'taskIndex': 0
        },
      ],
    },
    '1234': {
      'roomName': 'てくてくてっく',
      'leader': '12345',
      'workers': ['67890'],
      'task': [
        {
          'user': 'せろり',
          'woeker': 'おさかな',
          'task': 'ニャリオットとあそぶ',
          'day': '09',
          'month': '23',
          'limitDay': '09-23',
          'limitTime': '10:25',
          'level': 3,
          'bool': false,
          'taskIndex': 0
        },
        {
          'user': 'せろり',
          'worker': 'おさかな',
          'day': '09',
          'month': '23',
          'task': 'フロント完成',
          'limitDay': '09-23',
          'limitTime': '10:25',
          'level': 3,
          'bool': false,
          'taskIndex': 1
        },
      ],
    },
    '2345': {
      'roomName': 'ニャリオットのお世話',
      'leader': '67890',
      'workers': ['67890'],
      'task': [
        {
          'user': 'おさかな',
          'worker': 'おさかな',
          'task': 'ニャリオットにごはんあげる',
          'day': '09',
          'month': '23',
          'limitDay': '09-23',
          'limitTime': '10:25',
          'level': 3,
          'bool': false,
          'taskIndex': 0
        },
      ],
    }
  };

  // 部屋を作るときに値を保存する変数
  static String roomName = '';
  static String roomNum = '0000';

  //タスクリスト
  static Map taskList = {
    'id': [
      {
        'user': 'せろり',
        'worker': 'おさかな',
        'task': 'webソケット',
        'day': '09',
        'month': '23',
        'limitDay': '09-23',
        'limitTime': '10:25',
        'level': 3,
        'bool': false,
        'taskIndex': 0
      },
      {
        'user': 'おさかな',
        'worker': 'おさかな',
        'task': 'でーたべーす',
        'day': '09',
        'month': '23',
        'limitDay': '09-23',
        'limitTime': '10:25',
        'level': 3,
        'bool': false,
        'taskIndex': 0
      },
      {
        'user': 'おさかな',
        'woeker': 'おさかな',
        'task': 'タスク追加機能',
        'day': '10',
        'month': '09',
        'limitDay': '10-09',
        'limitTime': '13:00',
        'level': 3,
        'bool': false,
        'taskIndex': 0
      },
      {
        'user': 'おさかな',
        'woeker': 'おさかな',
        'task': 'ルーム作成機能',
        'day': '10',
        'month': '09',
        'limitDay': '10-09',
        'limitTime': '13:00',
        'level': 3,
        'bool': false,
        'taskIndex': 0
      },
      {
        'user': 'おさかな',
        'woeker': 'おさかな',
        'task': 'ニャリオットにごはんをあげる',
        'day': '10',
        'month': '09',
        'limitDay': '10-09',
        'limitTime': '13:00',
        'level': 3,
        'bool': false,
        'taskIndex': 0
      },
      // room['1111']['tasks'][0],
      // room['1111']['tasks'][1],
      // room['1111']['tasks'][2],
      // room['1111']['tasks'][3],
      // room['1111']['tasks'][4],

      //  誰からか　タスクの内容　残り日数　残り時間　優先度　進捗状況
    ]
  };

  static Map message = {
    'sender': {
      // ここ相手のgoogleアカウントとかにしないと名前変えたとき困るねとおもった
      'せろり': [
        {
          'sendDay': '2023-9-25',
          'sendTime': '12:03',
          'messagebool': true,
          'message': '進捗いかがですか？',
          'stampBool': false,
          'stamp': 0,
          'level': 5,
          'indexBool': true,
          'index': 1,
          'whose': true,
        },
        {
          'sendDay': '2023-9-25',
          'sendTime': '12:03',
          'messagebool': true,
          'message': 'ぜんぜんだめです',
          'stampBool': true,
          'stamp': 0,
          'level': 5,
          'indexBool': true,
          'index': 1,
          'whose': false,
        },
      ],
      'おさかな': [
        {
          'sendDay': '2023-9-25',
          'sendTime': '12:03',
          'messagebool': true,
          'message': 'なうすすんでますか？',
          'stampBool': false,
          'stamp': 0,
          'level': 5,
          'indexBool': false,
          'index': 0,
          'whose': true,
        }
      ]
    }
  };

  // メッセージ
  static Map<String, dynamic> leaderWord = {
    'idWord': [
      {'sender': 'せろり', 'time': '2023-10-02', 'word': '遊んでないで仕事してください！！', 'level': 5, 'index': 0},
    ]
  };

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

  
}
