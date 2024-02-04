import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // http
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'dart:convert'; // json

class Url {
  // URLとかポートとかプロトコルとか
  static const String serverIP = "10.109.0.41"; // "unserori.local"
  static const String server_port = "5108";
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
class SocketIO {
  // fields
  late io.Socket socket;
  String _connectMsg = "";
  String _testText = "";
  String _serverResMsg = "";

  // methods
  SocketIO() {
    // 接続を開始
    connectWS();
  }

  void msgSetter(String connectMsg) {
    this._connectMsg = "connect" + connectMsg;
  }

  /// 接続確立
  Future<void> connectWS() async {
    // wsの接続先を指定し、ソケットのインスタンスを生成し確立する
    socket = io.io('http://' + Url.serverIP + ":" + Url.server_port, <String, dynamic>{
      'transports': ['websocket'],
    });

    // event handlers  ハンドル名connectを明示的に定義すると動かなかった。
    /// コネクト時のサーバーからのレスポンスを受け取る
    socket.on('connected_response', (data) {
      debugPrint("Response from server: " + data);
      _serverResMsg = data;
    });

    /// テスト
    socket.on('test_msg_res', (data) {
      debugPrint("Sent back TEST from server: " + data);
      _testText = data;
    });

    socket.on(
      '',
      (data) {},
    );

    /// disconnect
    socket.on('disconnect', (data) {});

    /// 接続
    /// connect()で接続、emit(...)でconnectedに"connect?"を送信
    socket.connect().emit('connected', "connect?"); // "time": DateTime.now().toString(),}
  }

  /// 切断。ログアウト、アプリケーションのバックグラウンド実行時、または接続が不要になったとき
  void dispose() {
    socket.disconnect();
  }

  // サーバーに送ったりするメソッドとか
  /// テストメッセージ
  void sendTestMsg(String msg) {
    if (msg.isNotEmpty) {
      socket.emit('test_msg', msg);
    }
  }

  // accessor getter setter
  String get connectMsg => _connectMsg;
  String get testText => _testText;
  String get serverResMsg => _serverResMsg;
}

// class Tryws {
//   late io.Socket sk;
//   Tryws() {
//     debugPrint("インスタンスコネクト");
//     connectsk();
//     debugPrint("インスタンスコネクトkannyrou");
//   }

//   Future<void> connectsk() async {
//     sk = io.io('http://' + Url.serverIP + ":" + Url.server_port, <String, dynamic>{
//       'transports': ['websocket'],
//     });
//     sk.on('socket_connection_response', (data) {
//       debugPrint("socket_connection_response: " + data);
//     });
//     debugPrint("コネクト開始");
//     sk.connect().emit('connect_socket', "connect_socket");
//     debugPrint("コネクト官僚");
//   }
// }
