import 'package:flutter/material.dart';
import 'constant.dart';
import 'package:task_maid/database_helper.dart';

class items {
  static Map<String, dynamic> userInfo = {'name': 'おさかな', 'userid': '12345', 'tasks': taskList, 'rooms': myroom, 'mail': ''};

  static Map<String, dynamic> friend = {
    '12345': {'name': 'おさかな', 'userTask': taskList, 'message': message, 'myroom': '1234', 'bool': false},
    '23456': {'name': 'せろり', 'userTask': taskList, 'message': message, 'myroom': '1234', 'bool': false},
    '67890': {'name': 'ニャリオット', 'userTask': taskList, 'message': message, 'myroom': '2345', 'bool': false}
  };

  static List myroom = ['1111', '1234', '2345'];

  // ルーム
  // でーたべーすから自分が参加してるルームをもらってくる
  static Map room = {
    '1111': {
      'roomName': 'てすとるーむ',
      'leader': '12345',
      'workers': ['12345'],
      'tasks': [],
    },
    '3456': {
      'roomName': '参加できない; ;',
      'leader': '12345',
      'workers': ['12345'],
      'tasks': [],
    },
    '1234': {
      'roomName': 'てくてくてっく',
      'leader': '12345',
      'workers': ['12345', '67890'],
      'tasks': [],
    },
    '2345': {
      'roomName': 'ニャリオットのお世話',
      'leader': '67890',
      'workers': ['67890'],
      'tasks': [],
    }
  };

  // タスクを追加するときに値を保存する変数
  static String worker = '';
  static String newtask = '0000';
  static DateTime limitTime = DateTime.now();

  // db用テーブル名まとめ
  static List table = ['userAccount', 'rooms', 'tasks', 'msgchats'];

  //タスクリスト
  // dbからデータの取得
  static List taskList = [];
  static Map userAccount = {};
  static List rooms = [
    {
      'roomid': '1111',
      'roomName': 'てすとるーむ',
      'leader': '12345',
      'workers': ['12345'],
      'tasks': [],
    }
  ];
  static List message = [];
  static List newTask = [];

  static Nums() async {
    taskList = await DatabaseHelper.queryAllRows('tasks');
    // print(taskList);
    message = await DatabaseHelper.queryAllRows('msgchats');
    // print(msgchats);
    rooms = await DatabaseHelper.queryAllRows('rooms');
  }

  static Future<void> getTask(String key) async {
    newTask = await DatabaseHelper.queryRow(key);
    // newTask が空でない場合のみ処理を行う
    if (newTask.isNotEmpty) {
      taskList.add(newTask[0]);
    }
  }

  static List getList() {
    Nums();
    return taskList;
  }

  static int karioki = 1234565;

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
      'assets/images/stamp/taskMaid_stamp03.png',
      'assets/images/stamp/taskMaid_stamp01.png',
      'assets/images/stamp/taskMaid_stamp01.png',
      'assets/images/stamp/taskMaid_stamp01.png',
      'assets/images/stamp/taskMaid_stamp01.png',
      'assets/images/stamp/taskMaid_stamp01.png',
    ],
  };
}
