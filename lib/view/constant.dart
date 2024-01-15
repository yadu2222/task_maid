import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
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
void addMessage(int msgid, String message, int status, int stamp_id, String quote_id, int level, String chatRoom) async {
  // 辞書に追加
  var newmsg = {
    'msg_id': msgid,
    'msg_datetime': DateTime.now().toString(),
    'sender': items.userInfo['userid'],
    'room_id': chatRoom,
    'level': level,
    'status_addition': status,
    'stamp_id': stamp_id,
    'quote_id': quote_id,
    'msg': message,
  };

  // dbに追加
  DatabaseHelper.insert('msg_chats', newmsg);
  Future<List<Map<String, dynamic>>> result = DatabaseHelper.queryAllRows('msg_chats');
  print(await result);
}


// 日付を変換して返す
String dateformat(String dateTime, int type) {
  final formatType_1 = DateFormat('yyyy.MM.dd HH:mm');
  final formatType_2 = DateFormat('yyyy/MM/dd');
  final formatType_3 = DateFormat('HH:mm');
  final formatType_4 = DateFormat('MM月dd日HH時mm分');
  final formatType_5 = DateFormat('MM.dd.HH時mm分');

  print(dateTime);

  List formatType = [formatType_1, formatType_2, formatType_3, formatType_4];
  DateTime nn = DateTime.parse(dateTime);
  return formatType[type].format(nn);
}
