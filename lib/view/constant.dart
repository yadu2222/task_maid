import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import './items.dart';
import 'package:http/http.dart' as http;  // http
import 'dart:convert';  // json




class Constant {
  static const Color main = Color(0xFF00849C);
  static const Color sub1 = Color(0xFFFF9F9F);
  static const Color sub2 = Color.fromARGB(255, 197, 233, 53);
  static const Color sub3 = Color(0xFFFFDC61);
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

class stampPictures extends StatefulWidget {
  int picture;
  double width;
  double height;
  String messenger;
  stampPictures({Key? key, required this.picture, required this.width, required this.height, required this.messenger})
      : super(key: key);

  @override
  _stampPictures createState() => _stampPictures();
}

class _stampPictures extends State<stampPictures> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          items.stampIndex = widget.picture;
          addMessage(widget.messenger, false, '', true, items.stampIndex, 0, false, 0, false);

          setState(() {
            items.stamplist = false;
          });
        },
        child: Container(
          width: widget.width * 0.2,
          height: widget.width * 0.2,
          margin: EdgeInsetsDirectional.all(widget.width * 0.02),
          child: Image.asset(
            items.taskMaid['stamp'][widget.picture],
            fit: BoxFit.contain,
          ),
        ));
  }
}

// スタンプを表示するクラス
class stampList extends StatefulWidget {
  double width;
  double height;
  String messenger;
  stampList({Key? key, required this.width, required this.height, required this.messenger}) : super(key: key);

  @override
  _stampList createState() => _stampList();
}

class _stampList extends State<stampList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      decoration: BoxDecoration(color: Constant.glay),
      
      child: Column(
        children: [
          Container(
              alignment: Alignment(0, 0),
              padding: EdgeInsets.only(left: widget.width * 0.025),
              child: Row(
                children: [
                  stampPictures(
                    messenger: widget.messenger,
                    picture: 0,
                    width: widget.width,
                    height: widget.height,
                  ),
                  stampPictures(
                    messenger: widget.messenger,
                    picture: 1,
                    width: widget.width,
                    height: widget.height,
                  ),
                  stampPictures(
                    messenger: widget.messenger,
                    picture: 2,
                    width: widget.width,
                    height: widget.height,
                  ),
                  stampPictures(
                    messenger: widget.messenger,
                    picture: 3,
                    width: widget.width,
                    height: widget.height,
                  ),
                ],
              )),
          Container(
              alignment: Alignment(0, 0),
              padding: EdgeInsets.only(left: widget.width * 0.025),
              child: Row(
                children: [
                  stampPictures(
                    messenger: widget.messenger,
                    picture: 4,
                    width: widget.width,
                    height: widget.height,
                  ),
                  stampPictures(
                    messenger: widget.messenger,
                    picture: 5,
                    width: widget.width,
                    height: widget.height,
                  ),
                  stampPictures(
                    messenger: widget.messenger,
                    picture: 6,
                    width: widget.width,
                    height: widget.height,
                  ),
                  stampPictures(
                    messenger: widget.messenger,
                    picture: 7,
                    width: widget.width,
                    height: widget.height,
                  ),
                ],
              ))
        ],
      ),
    );
  }
}

// 辞書に追加するメソッド
void addMessage(String messenger, bool messagebool, String message, bool StampBool, int stamp, int level,
    bool indexBool, int index, bool whose) {
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
  items.message['sender'][messenger].add(newMessage);
}


// Httpリクエストを投げるクラス
// 
class HttpToServer {  // HttpLib
  // インスタンス変数
  // URLとかポートとかプロトコルとか
  static const String serverIP = "127.0.0.1";  // "127.0.0.1""10.200.0.82""tidalhip.local""10.200.0.115"10.25.10.10710.200.0.163
  static const String server_port = "5000";
  static const String protocol = "http";
  static baseUrl() {  // 鯖のURLを設定
    return protocol + "://" + serverIP + ":" + server_port;
  }

  // コンストラクタってなに？？
  HttpToServer();

  // "URLパラメータ", "HTTPメソッド", "body"  例えば (/send_userInfo", "POST", items.userInfo)
  // HTTP リクエストを送信する関数 
  static Future<List> httpReq(String path_para, String method, Map<String, dynamic> body) async {

    
    //header
    var headersList = {
      'Accept': '*/*',
      'User-Agent': 'Thunder Client (https://www.thunderclient.com)',
      'Content-Type': 'application/json',
    };
    // "Access-Control-Allow-Origin": "*"

    // リクエスト作成
    var req = http.Request("POST", Uri.parse(baseUrl() + path_para));  // HTTPリクエストメソッドの種類とuriから
      // debugPrint(req.toString());
    req.headers.addAll(headersList);  // header情報を追加
      // debugPrint(req.toString());
    req.body = json.encode(body);  // bodyをjson形式に変換
      // debugPrint(req.toString());

    try {

      // HTTPリクエストを送信。 seconds: 5 で指定した秒数応答がなかったらタイムアウトで例外を発生させる
      var res = await req.send();//.timeout(const Duration(seconds: 5));
      debugPrint(res.toString());
      // レスポンスをストリームから文字列に変換して保存
      final resBody = await res.stream.bytesToString();

      // ステータスコードが正常ならtrueと内容を返す
      if (res.statusCode >= 200 && res.statusCode < 300) {
        debugPrint([true, resBody].toString());
        return [true, resBody];
      } else {
        debugPrint([false, res.statusCode.toString(), resBody].toString());
        return [false, res.statusCode.toString(), resBody];
      }

    } catch (e) {  // タイムアウトしたとき。

      debugPrint("exception error: " + e.toString());
      debugPrint([false, "おうとうないよ；；"].toString());
      return [false, "おうとうないよ；；"];

    }
  }
}