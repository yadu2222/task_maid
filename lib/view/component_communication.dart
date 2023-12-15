import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../view/pages/page_massages.dart';
import './items.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:http/http.dart' as http; // http
import 'dart:convert'; // json
import 'constant.dart';

class Url {
  // URLとかポートとかプロトコルとか
  static const String serverIP = "unserori.local"; // "127.0.0.1""10.200.0.82""tidalhip.local""10.200.0.115"10.25.10.10710.200.0.16310.0.2.2
  static const String server_port = "8282";
  static const String protocol = "http";

  // 設定した値から鯖のURLを生成
  static baseUrl() {
    // 鯖のURLを設定
    return protocol + "://" + serverIP + ":" + server_port;
  }

  // 設定した値から鯖のURLを生成(プロトコルなし)
  static baseUrlWithoutProtcol() {
    // 鯖のURLを設定
    return "://" + serverIP + ":" + server_port;
  }
}

// Httpリクエストを投げるクラス
class HttpToServer {
  // HttpLib
  // インスタンス変数

  // コンストラクタってなに？？ggrks
  HttpToServer();

  // "URLパラメータ", "HTTPメソッド", "body"  例えば (/send_userInfo", "POST", items.userInfo)
  // HTTP リクエストを送信する関数
  static Future httpReq(String method, String path_para, Map<String, dynamic> body) async {
    //header
    var headersList = {
      'Accept': '*/*',
      'User-Agent': 'Thunder Client (https://www.thunderclient.com)',
      'Content-Type': 'application/json', // ここいる
    };

    // リクエスト作成
    var req = http.Request(method, Uri.parse(Url.baseUrl() + path_para)); // debugPrint(req.toString());  // HTTPリクエストメソッドの種類とuriから
    req.headers.addAll(headersList); // debugPrint(req.toString());  // header情報を追加
    req.body = json.encode(body); // debugPrint(req.toString());  // bodyをjson形式に変換

    try {
      // HTTPリクエストを送信。 seconds: 5 で指定した秒数応答がなかったらタイムアウトで例外を発生させる
      var res = await req.send(); //.timeout(const Duration(seconds: 5));
      debugPrint(res.toString()); // debug
      // レスポンスをストリームから文字列に変換して保存
      final resBody = await res.stream.bytesToString();
      print(res.statusCode);
      print(resBody);
      return res;
      // // ステータスコードが正常ならtrueと内容を返す
      // if (res.statusCode >= 200 && res.statusCode < 300) {
      //   //debugPrint([true, resBody].toString()); // debug
      //   return [res.statusCode.toString(), true, resBody];
      // } else {
      //   //debugPrint([false, res.statusCode.toString(), resBody].toString()); // debug
      //   return [res.statusCode.toString(), false, resBody];
      // }
    } catch (e) {
      // タイムアウトしたとき。
      debugPrint("Exception_error: " + e.toString());
      // debugPrint([false, "おうとうないよ；；"].toString());
      return ["0", "おうとうないよ；；"];
    }
  }
}

// WebSocket
class WS extends StatefulWidget {
  const WS({super.key});

  @override
  State<WS> createState() => WSState();
}

class WSState extends State<WS> {
  //
  // パッケージからインスタンス
  late io.Socket socket;

  // wsを初期化
  @override
  void initState() {
    super.initState();

    var req = http.Request("POST", Uri.parse("http" + Url.baseUrlWithoutProtcol() + "/post_"));
    try {
      req.body = json.encode({"key": "testhoge"}); // bodyをjson形式に変換
      var res = req.send().then((value) => debugPrint(value.statusCode.toString())); //.timeout(const Duration(seconds: 5));
    } catch (e) {}

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
    if (message.isNotEmpty) {
      // からでなければ
      socket.emit('message', message);
    }
  }

  // ログアウト、アプリケーションのバックグラウンド実行時、または接続が不要になったとき
  @override
  void dispose() {
    socket.disconnect();
    super.dispose();
  }

  // 反映するとき
  static Widget testContainer(String testText, BuildContext context) {
    var _screenSizeWidth = MediaQuery.of(context).size.width;
    var _screenSizeHeight = MediaQuery.of(context).size.height;

    return Container(
      margin: EdgeInsets.all(_screenSizeWidth * 0.02),
      height: _screenSizeHeight * 0.075,
      alignment: Alignment(0, 0),
      decoration: BoxDecoration(color: Constant.white, borderRadius: BorderRadius.circular(16)),
      child: CustomText(text: testText, fontSize: _screenSizeWidth * 0.05, color: Constant.blackGlay),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
