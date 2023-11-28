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

// dialog表示用クラス
class dialog extends StatefulWidget {
  // 箱のサイズ
  double screenSizeWidth;
  double screenSizeHeight;
  // paddingの有無
  bool pabool;

  // 中身のサイズ
  double widthin;
  double heightin;

  Widget widget;
  dialog({Key? key, required this.screenSizeWidth, required this.screenSizeHeight, required this.widget, required this.pabool, required this.widthin, required this.heightin});

  @override
  _dialog createState() => _dialog();
}

class _dialog extends State<dialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 0.0, // ダイアログの影を削除
        backgroundColor: Constant.white.withOpacity(0), // 背景色

        content: Container(
            width: widget.screenSizeWidth * widget.widthin,
            height: widget.screenSizeHeight * widget.heightin,
            decoration: BoxDecoration(color: Constant.glay, borderRadius: BorderRadius.circular(16)),
            padding: widget.pabool
                ? EdgeInsets.only(
                    left: widget.screenSizeWidth * 0.03,
                    right: widget.screenSizeWidth * 0.03,
                    top: widget.screenSizeWidth * 0.05,
                  )
                : EdgeInsets.all(0),
            child: widget.widget));
  }
}

// 辞書に追加するメソッド
void addMessage(String messenger, bool messagebool, String message, bool StampBool, int stamp, int level, bool indexBool, int index, bool whose) {
  // 現在時刻を保存する変数
  DateTime now = DateTime.now();
  String formattedDate = DateFormat('yyyy-MM-dd').format(now);
  String formattedTime = DateFormat.Hm().format(now);

  // 辞書に追加
  var newMessage = {
    'sendDay': formattedDate,
    'sendTime': formattedTime,
    'messagebool': messagebool,
    'message': message,
    'stampBool': StampBool,
    'stamp': stamp,
    'level': level,
    'indexBool': indexBool,
    'index': index,
    'whose': whose,
  };
  items.message[messenger].add(newMessage);
}

// タスクを辞書に追加するメソッド
void addTask(String user, String worker, String task, String limitMonth, String limitDay, String limit, String limitTime, String taskRoomIndex) {
  // 辞書に追加
  var newtask = {
    'user': user,
    'worker': worker,
    'task': task,
    'day': limitMonth,
    'month': limitDay,
    'limitDay': limit,
    'limitTime': limitTime,
    'level': 3,
    'bool': false,
    'taskIndex': 0,
    'roomid': taskRoomIndex
  };
  items.room[taskRoomIndex]['tasks'].add(newtask);
  items.taskList['id'].add(newtask);
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
