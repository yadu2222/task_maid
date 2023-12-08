import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../view/pages/page_massages.dart';
import './items.dart';
import 'package:task_maid/database_helper.dart';

class Constant {
  static const Color main = Color(0xFF00849C);
  static const Color glay = Color(0xFFD9D9D9);
  static const Color blackGlay = Color.fromARGB(255, 124, 124, 124);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF3E3E3E);
  static const Color red = Color.fromARGB(255, 204, 24, 24);
}

class CustomText extends StatelessWidget {
  String text;
  double fontSize;
  Color color;
  CustomText({
    super.key,
    required this.text,
    required this.fontSize,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.left,
      softWrap: true, // 自動改行
      overflow: TextOverflow.ellipsis, // テキストが領域からはみ出た場合の動作を指定
      maxLines: 5, // 改行後の最大行数
      style: GoogleFonts.kiwiMaru(fontWeight: FontWeight.bold, fontSize: fontSize, color: color, height: 1.2),
    );
  }
}

// メッセージをdbに追加するメソッド
void addMessage(int msgid, String message, int status, int index, int level, String chatRoom) async {
  // 辞書に追加
  // indexじゃなくてtaskidを追加すべきと思ったけどstampとかのこと考えたらそうとも言えないな困ったな
  var newmsg = {
    'msgid': msgid,
    'roomid': chatRoom,
    'time': DateTime.now().toString(),
    'sender': items.userInfo['userid'],
    'level': level,
    'status': status,
    'message': message,
    'quote': index,
  };
  // dbに追加
  DatabaseHelper.insert('msgchats', newmsg);
  Future<List<Map<String, dynamic>>> result = DatabaseHelper.queryAllRows('msgchats');
  print(await result);
}

// タスクをdbに追加するメソッド
void addTask(int taskid, String user, String worker, String contents, DateTime limitTime, String roomid, int status) async {
  // 辞書に追加
  var newtask = {'taskid': taskid, 'limitTime': limitTime.toString(), 'leaders': user, 'worker': worker, 'contents': contents, 'roomid': roomid, 'status': status};

  // 事故発生中
  // items.room[roomid]['tasks'].add(taskid);

  // dbに追加
  DatabaseHelper.insert('tasks', newtask);

  // 例えば tasks テーブルから全ての行を取得
  Future<List<Map<String, dynamic>>> result = DatabaseHelper.queryAllRows('tasks');
  print(await result);
}

// 新しい部屋をdbに追加するメソッド
void dbAddRoom(String roomid, String roomName, List leaders, List workers, List tasks) {
  // Roomをデータベースに追加する際の例
  var newRoom = {
    'roomid': roomid,
    'roomName': roomName,
    'leader': jsonEncode(leaders),
    'workers': jsonEncode(workers),
    'tasks': jsonEncode(tasks),
  };
  DatabaseHelper.insert('rooms', newRoom);
  
}

// 日付を変換して返す
String dateformat(String dateTime, int type) {
  final formatType_1 = DateFormat('yyyy.MM.dd HH:mm');
  final formatType_2 = DateFormat('yyyy/MM/dd');
  final formatType_3 = DateFormat('HH:mm');
  final formatType_4 = DateFormat('MM月dd日HH時mm分');

  List formatType = [formatType_1, formatType_2, formatType_3,formatType_4];
  return formatType[type].format(DateTime.parse(dateTime));
}

// ルームIDチェッカー
bool roomIDcheck(String roomID) {
  for (int i = 0; i < items.room[roomID]['workers'].length; i++) {
    if (items.room[roomID]['workers'][i] == items.userInfo['userid']) {
      return true;
    }
  }
  return false;
}
