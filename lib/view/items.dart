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

  static List myroom = [
    '1111',
  ];

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
  static List rooms = [];
  static List message = [];
  static List newTask = [];
  // static List subRooms = [];

  static Nums() async {
    taskList = await DatabaseHelper.queryAllRows('tasks');
    // print(taskList);
    message = await DatabaseHelper.queryAllRows('msg_chats');
    // print(msgchats);
    rooms = await DatabaseHelper.queryAllRows('rooms');
    // print(rooms);
    // subRooms = await DatabaseHelper.queryAllRows('sub_rooms');
  }

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
      'assets/images/stamp/taskMaid_stamp04.png',
      'assets/images/stamp/taskMaid_stamp05.png',
      'assets/images/stamp/taskMaid_stamp06.png',
      'assets/images/stamp/taskMaid_stamp07.png',
      'assets/images/stamp/taskMaid_stamp08.png',
    ],
  };
}
