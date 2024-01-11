import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:http/http.dart' as http; // http
import 'dart:convert'; // json
import 'constant.dart';

class Url {
  // URLとかポートとかプロトコルとか
  static const String serverIP = "unSerori.local"; // "127.0.0.1""10.200.0.82""tidalhip.local""10.200.0.115"10.25.10.10710.200.0.16310.0.2.2
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
  static Future<http.Response> httpReq(String method, String path_para, Map<String, dynamic> body) async {
    //header
    var headersList = {
      'Accept': '*/*',
      'User-Agent': 'Thunder Client (https://www.thunderclient.com)',
      'Content-Type': 'application/json', // ここいる
    };

    // uri
    Uri uri = Uri.parse(Url.baseUrl() + path_para);

    // 返り血を遅延初期化 レスポンスがくるまで値を入れない
    late http.Response response;

    // methodによってリクエスト作成が異なる
    switch (method.toUpperCase()) {
      // 大文字にそろえてから。
      case 'GET':
        try {
          // リクエストの失敗をcatchする
          response = await http.get(
            uri,
            headers: headersList,
          );
        } catch (e) {
          throw Exception('GET request failed: $e');
        }
        break;

      case 'POST':
        try {
          response = await http.post(uri, headers: headersList, body: json.encode(body));
        } catch (e) {
          throw Exception('POST request failed: $e');
        }
        break;

      default:
        throw Exception('Invalid HTTP method: $method');
    }
    return response;
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
