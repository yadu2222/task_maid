import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../view/pages/page_massages.dart';
import './items.dart';

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

// 辞書に追加するメソッド
void addMessage(
  int msgid,
  String message,
  int status,
  int index,
  int level,
  String chatRoom
) {

  // 辞書に追加
  Map<String,Object> newMessage = {
    'msgid': msgid, 
    'time': DateTime.now(),
    'message': message, 
    'status': status, 
    'index': index, 
    'level':level,
    'sender':items.userInfo['userid'],
    'chatRoom':chatRoom
     
  };
  items.message[chatRoom].add(newMessage);
}

// タスクを辞書に追加するメソッド
void addTask(String user, String worker, String task, DateTime limitTime, String taskRoomIndex) {
  // 辞書に追加
  var newtask = {
    'user': user,
    'worker': worker,
    'task': task,
    'day': limitTime.day,
    'month': limitTime.month,
    'limitDay': limitTime.day,
    'limitTime': '${limitTime.hour}時${limitTime.minute}分',
    'level': 3,
    'bool': false,
    'taskIndex': 0,
    'roomid': taskRoomIndex
  };

  // 事故発生中
  items.room[taskRoomIndex]['tasks'].add(newtask);
  items.taskList.add(newtask);
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
