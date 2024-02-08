import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // http
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'dart:convert'; // json

import '../controller/msg_manager.dart';
import '../controller/door.dart';
import '../database_helper.dart';
import 'dart:async';

final StreamController<dynamic> _chatMsgController = StreamController<dynamic>.broadcast();

class Url {
  // URLとかポートとかプロトコルとか
  static const String serverIP = "172.22.80.1"; // win + r で gipcしてね♡
  static const String serverPort = "5108";
  static const String protocol = "http";

  // 設定した値から鯖のURLを生成
  static baseUrl() {
    // 鯖のURLを設定
    return protocol + "://" + serverIP + ":" + serverPort;
  }

  // 設定した値から鯖のURLを生成(プロトコルなし)
  static baseUrlWithoutProtcol() {
    // 鯖のURLを設定
    return "://" + serverIP + ":" + serverPort;
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
  late io.Socket socket; // ソケットIOの実体
  static final SocketIO _instance = SocketIO._internal(); // シングルトンインスタンス
  String _connectMsg = "";
  String _testText = "";
  String _serverResMsg = "";
  String _msg_numDataMsg_chat_msg_id = "";
  String _chatMsgWsMsg = "";
  // Map<String, dynamic> _msg_numData = {};
  // Map<String, dynamic> _chatMsgWs = {};

  // methods
  ///ファクトリコンストラクタ(factory Class)
  ///通常のコンストラクタでいう呼び出される処理を担当、通常のコンストラクタと同じく外側から呼び出される。
  ///シングルトンインスタンス(=静的でどこから見ても同一のインスタンス)を呼び出し側に返す。
  factory SocketIO() {
    return _instance; // フィールドのシングルトンインスタンス
  }

  ///コンストラクタ(Class._internal())
  ///通常のコンストラクタでいう実際の初期化処理を担当。
  ///シングルトンクラスの場合、クラスが読み込まれてクラス変数が定義されたときにインスタンスが生成される。
  SocketIO._internal() {
    // 接続を開始
    _connectWS();
  }
  // // プライベートなコンストラクタ
  // SocketIO._internal();
  // initState() {
  //   // 接続を開始
  //   _connectWS();
  // }

  void msgSetter(String connectMsg) {
    this._connectMsg = "connect" + connectMsg;
  }

  /// 接続確立
  Future<void> _connectWS() async {
    // wsの接続先を指定し、ソケットのインスタンスを生成し確立する
    socket = io.io('http://' + Url.serverIP + ":" + Url.serverPort, <String, dynamic>{
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

    ///チャットの連番を受け取る
    socket.on('msg_num', (data) {
      _msg_numDataMsg_chat_msg_id = data['msg_chat_msg_id'];
      print(data["msg_chat_msg_id"]);
    });

    ///チャットを受け取る
    socket.on(
      'chat_msg',
      // ここに受け取ったデータが入る
      (data) {
        debugPrint(data);

        // 受け取ったデータをmapに変換
        Map<String, dynamic> recordMsgMap = jsonDecode(data);

        _chatMsgWsMsg = jsonDecode(data)['msg'];
        // 表示してみる
        recordMsgMap.forEach((key, value) {
          debugPrint("$key: $value");
        });

        // データを処理するメソッドに流す
        MsgManager().sioReceive(recordMsgMap);
      },
    );

    socket.on(
      // かわいそう；；
      'receive__update',
      (data) async {
        // サーバー側で更新があれば｛"tableName":テーブル名,"pKey":主キー,"pKeyValue":主キーの値｝を受信する。
        // http通信でget申請
        http.Response response = await HttpToServer.httpReq("GET", "/get_record", {"tableName": data["tableName"], "pKey": data["pKey"], "pKeyValue": data["pKeyValue"]});

        // 返ってきたデータを読み込むためのインスタンス生成
        Door door = Door();
        print(response.statusCode);
        print(response.body);
        // 返ってきたデータをJSONに変換
        Map<String, dynamic> responseBody = jsonDecode(response.body);
        // dbに追加
        DatabaseHelper.insert(data["tableName"], responseBody);
        // 読み込み
        door.load();
      },
    );

    socket.on(
      '',
      (data) {},
    );

    /// disconnect
    socket.on('disconnect', (data) {});

    /// 接続
    /// connect()で接続、emit(...)でconnectedに"connect?"を送信
    socket.connect().emit('connected', {"mail": "neruko@gmail.com", "time": DateTime.now().toString(), "msg": "connect?"}); // "oauth": {"token": "",,,}

    // socket.onって別のところにかけるのかな～
    //   // チャットを受け取る
    //   socket.on(
    //     'chat_msg',
    //     (data) {
    //       _chatMsgWs = jsonDecode(data); // フィールドに追加
    //     },
    //   );
    // }
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

  ///任意のエンドポイントにメッセージを送る
  void sendMsg(String wsEvent, Map<String, dynamic> wsData) {
    if (wsData.isNotEmpty) {
      socket.emit(wsEvent, wsData);
    }
  }

  // accessor getter setter
  String get connectMsg => _connectMsg;
  String get testText => _testText;
  String get serverResMsg => _serverResMsg;
  String get msg_numDataMsg_chat_msg_id => _msg_numDataMsg_chat_msg_id;
  String get chatMsgWsMsg => _chatMsgWsMsg;
  // Map<String, dynamic> get msg_numData => _msg_numData;
  // Map<String, dynamic> get chatMsgWs => _chatMsgWs;
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

// class SocketIO {
//   // fields
//   late io.Socket socket; // ソケットIOの実体
//   String _connectMsg = "";
//   String _testText = "";
//   String _serverResMsg = "";

//   // methods
//   ///コンストラクタ
//   SocketIO() {
//     // 接続を開始
//     connectWS();
//   }

//   ///accessor
//   void msgSetter(String connectMsg) {
//     this._connectMsg = "connect" + connectMsg;
//   }

//   /// 接続確立
//   Future<void> connectWS() async {
//     // wsの接続先を指定し、ソケットのインスタンスを生成し確立する
//     socket = io.io('http://' + Url.serverIP + ":" + Url.serverPort, <String, dynamic>{
//       'transports': ['websocket'],
//     });

//     // event handlers  ハンドル名connectを明示的に定義すると動かなかった。
//     /// コネクト時のサーバーからのレスポンスを受け取る
//     socket.on('connected_response', (data) {
//       debugPrint("Response from server: " + data);
//       _serverResMsg = data;
//     });

//     /// テスト
//     socket.on('test_msg_res', (data) {
//       debugPrint("Sent back TEST from server: " + data);
//       _testText = data;
//     });

//     socket.on(
//       '',
//       (data) {},
//     );

//     /// disconnect
//     socket.on('disconnect', (data) {});

//     /// 接続
//     /// connect()で接続、emit(...)でconnectedに"connect?"を送信
//     socket.connect().emit('connected', "connect?"); // "time": DateTime.now().toString(),}
//   }

//   /// 切断。ログアウト、アプリケーションのバックグラウンド実行時、または接続が不要になったとき
//   void dispose() {
//     socket.disconnect();
//   }

//   // サーバーに送ったりするメソッドとか
//   /// テストメッセージ
//   void sendTestMsg(String msg) {
//     if (msg.isNotEmpty) {
//       socket.emit('test_msg', msg);
//     }
//   }

//   // accessor getter setter
//   String get connectMsg => _connectMsg;
//   String get testText => _testText;
//   String get serverResMsg => _serverResMsg;
// }

// // WebSocket
// class SocketIO {
//   // fields
//   late io.Socket socket; // ソケットIOの実体
//   static final SocketIO _instance = SocketIO._internal(); // シングルトンインスタンス
//   String _connectMsg = "";
//   String _testText = "";
//   String _serverResMsg = "";

//   // methods
//   ///ファクトリコンストラクタ(factory Class)
//   ///通常のコンストラクタでいう呼び出される処理を担当、通常のコンストラクタと同じく外側から呼び出される。
//   ///シングルトンインスタンス(=静的でどこから見ても同一のインスタンス)を呼び出し側に返す。
//   factory SocketIO() {
//     return _instance; // フィールドのシングルトンインスタンス
//   }

//   ///コンストラクタ(Class._internal())
//   ///通常のコンストラクタでいう実際の初期化処理を担当。
//   ///シングルトンクラスの場合、クラスが読み込まれてクラス変数が定義されたときにインスタンスが生成される。
//   SocketIO._internal() {
//     // 接続を開始
//     _connectWS();
//   }

//   void msgSetter(String connectMsg) {
//     this._connectMsg = "connect" + connectMsg;
//   }

//   /// 接続確立
//   Future<void> _connectWS() async {
//     // wsの接続先を指定し、ソケットのインスタンスを生成し確立する
//     socket = io.io('http://' + Url.serverIP + ":" + Url.serverPort, <String, dynamic>{
//       'transports': ['websocket'],
//     });

//     // event handlers  ハンドル名connectを明示的に定義すると動かなかった。
//     /// コネクト時のサーバーからのレスポンスを受け取る
//     socket.on('connected_response', (data) {
//       debugPrint("Response from server: " + data);
//       _serverResMsg = data;
//     });

//     /// テスト
//     socket.on('test_msg_res', (data) {
//       debugPrint("Sent back TEST from server: " + data);
//       _testText = data;
//     });

//     socket.on(
//       '',
//       (data) {},
//     );

//     /// disconnect
//     socket.on('disconnect', (data) {});

//     /// 接続
//     /// connect()で接続、emit(...)でconnectedに"connect?"を送信
//     socket.connect().emit('connected', "connect?"); // "time": DateTime.now().toString(),}
//   }

//   /// 切断。ログアウト、アプリケーションのバックグラウンド実行時、または接続が不要になったとき
//   void dispose() {
//     socket.disconnect();
//   }

//   // サーバーに送ったりするメソッドとか
//   /// テストメッセージ
//   void sendTestMsg(String msg) {
//     if (msg.isNotEmpty) {
//       socket.emit('test_msg', msg);
//     }
//   }

//   // accessor getter setter
//   String get connectMsg => _connectMsg;
//   String get testText => _testText;
//   String get serverResMsg => _serverResMsg;
// }