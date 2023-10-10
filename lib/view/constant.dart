import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../view/pages/page_massages.dart';
import './items.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:http/http.dart' as http;  // http
import 'dart:convert';  // json


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

class stampPictures extends StatefulWidget {
  int picture;
  double width;
  double height;
  String messenger;
  var scaffoldKey;
  var scrollController;
  stampPictures(
      {Key? key,
      required this.picture,
      required this.width,
      required this.height,
      required this.messenger,
      required this.scaffoldKey,
      required this.scrollController})
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

            void reloadWidgetTree() {
              widget.scaffoldKey.currentState?.reassemble();
            }

            WidgetsBinding.instance.addPostFrameCallback((_) {
              widget.scrollController.animateTo(
                widget.scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            });
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
  var scaffoldKey;
  var scrollController;
  stampList(
      {Key? key,
      required this.width,
      required this.height,
      required this.messenger,
      required this.scaffoldKey,
      required this.scrollController})
      : super(key: key);

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
                    scaffoldKey: widget.scaffoldKey,
                    scrollController: widget.scrollController,
                    messenger: widget.messenger,
                    picture: 0,
                    width: widget.width,
                    height: widget.height,
                  ),
                  stampPictures(
                    scaffoldKey: widget.scaffoldKey,
                    scrollController: widget.scrollController,
                    messenger: widget.messenger,
                    picture: 1,
                    width: widget.width,
                    height: widget.height,
                  ),
                  stampPictures(
                    scaffoldKey: widget.scaffoldKey,
                    scrollController: widget.scrollController,
                    messenger: widget.messenger,
                    picture: 2,
                    width: widget.width,
                    height: widget.height,
                  ),
                  stampPictures(
                    scaffoldKey: widget.scaffoldKey,
                    scrollController: widget.scrollController,
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
                    scaffoldKey: widget.scaffoldKey,
                    scrollController: widget.scrollController,
                    messenger: widget.messenger,
                    picture: 4,
                    width: widget.width,
                    height: widget.height,
                  ),
                  stampPictures(
                    scaffoldKey: widget.scaffoldKey,
                    scrollController: widget.scrollController,
                    messenger: widget.messenger,
                    picture: 5,
                    width: widget.width,
                    height: widget.height,
                  ),
                  stampPictures(
                    scaffoldKey: widget.scaffoldKey,
                    scrollController: widget.scrollController,
                    messenger: widget.messenger,
                    picture: 6,
                    width: widget.width,
                    height: widget.height,
                  ),
                  stampPictures(
                    scaffoldKey: widget.scaffoldKey,
                    scrollController: widget.scrollController,
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

  // 
  
  items.message['sender'][messenger].add(newMessage);
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
    'limitDay':limit,
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

class Url {
  // URLとかポートとかプロトコルとか
  static const String serverIP = "10.0.2.2";  // "127.0.0.1""10.200.0.82""tidalhip.local""10.200.0.115"10.25.10.10710.200.0.163
  static const String server_port = "5000";
  static const String protocol = "http";
  static baseUrl() {  // 鯖のURLを設定
    return protocol + "://" + serverIP + ":" + server_port;
  }
  static baseUrlWithoutProtcol() {  // 鯖のURLを設定
    return "://" + serverIP + ":" + server_port;
  }

}

// Httpリクエストを投げるクラス
// 
class HttpToServer {  // HttpLib
  // インスタンス変数

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
    var req = http.Request("POST", Uri.parse(Url.baseUrl() + path_para));  // HTTPリクエストメソッドの種類とuriから
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


    // if (response.statusCode == 200) {
    //   // レスポンスが成功した場合
    //   final data = json.decode(response.body);
      
    // } else {
    //   // レスポンスがエラーの場合
     
    // }
  }
}
class WS extends StatefulWidget {
  const WS({super.key});

  @override
  State<WS> createState() => _WSState();
}

class _WSState extends State<WS> {
  // 
  // パッケージからインスタンス
  late io.Socket socket;

  // wsを初期化
  @override
  void initState() {
    super.initState();
    var req = http.Request("POST", Uri.parse("http" + Url.baseUrlWithoutProtcol() + "/post_"));  // HTTPリクエストメソッドの種類とuriから
    try {
    req.body = json.encode({"key": "testhoge"});  // bodyをjson形式に変換
      var res = req.send().then((value) => debugPrint(value.statusCode.toString()));//.timeout(const Duration(seconds: 5));
    } catch (e) {
      
    }

    // 接続先Socket.IOサーバーのURLと通信方式を設定
    socket = io.io("http" + Url.baseUrlWithoutProtcol(), <String, dynamic>{
      'transports': ['websocket'],
    });
    // 接続
    socket.connect();

    // イベント
    socket.on('response', (data) {
      setState(() {
        debugPrint(data);
      });
    });

  }

  void _sendMessage(String msg) {
    String message = msg;
    if (message.isNotEmpty) {  // からでなければ
      socket.emit('message', message);
    }
  }

  // ログアウト、アプリケーションのバックグラウンド実行時、または接続が不要になったとき
  @override
  void dispose() {
    socket.disconnect();
    super.dispose();
  }

/* 
// 反映するとき   
            Container(
              margin:EdgeInsets.all(_screenSizeWidth*0.02),
              height: _screenSizeHeight*0.075,
              alignment: Alignment(0, 0),
              decoration: BoxDecoration(color: Constant.white,borderRadius: BorderRadius.circular(16)),
              child: CustomText(text: testText, fontSize: _screenSizeWidth*0.05, color: Constant.blackGlay),
            )
 */
  
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
