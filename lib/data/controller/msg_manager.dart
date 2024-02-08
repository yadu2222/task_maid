import 'dart:convert';

import 'package:task_maid/data/models/user_class.dart';

import '../database_helper.dart';
import '../models/msg_class.dart';
import '../controller/user_manager.dart';
import '../models/component_communication.dart';

class MsgManager {
  // msg_list
  List<MSG> _msgList = [];

  static final MsgManager _instance = MsgManager._internal();
  MsgManager._internal();
  factory MsgManager() {
    return _instance;
  }

  final SocketIO _socketIO = SocketIO();
  final UserManager _userManager = UserManager();

  // 指定した部屋のメッセージ数を取得
  int count() {
    return _msgList.length;
  }

  // 指定したインデックスのメッセージを取得
  MSG findByindex(int index) {
    return _msgList[index];
  }

  // msgを追加する
  void add(String msg, int statusAddition, int stampid, String quoteid, int level, String roomid) async {
    // (int msgid, String message, int status, int stamp_id, String quote_id, int level, String chatRoom
    var msgid = count() == 0 ? 1 : _msgList.last.msgid + 1;
    String msgDatetime = DateTime.now().toString();
    // 送り先
    List receiverList = await DatabaseHelper.serachRows("msg_chats", 1, ["room_id"], [roomid], "room_id");
    String receiver = jsonDecode(receiverList[0]["leaders"]);
    _socketIO.sendMsg("send_msg_chat", {
      "tableMsg": "msg_chats",
      "recordData": {"msg_datetime": msgDatetime, "receiver": receiver, "room_id": roomid, "level": level, "status": statusAddition, "stamp_id": stampid, "quote_id": quoteid, "msg": msg},
      "token_mail": _userManager.getUser().mail
    });

    // savaしてはいけない
    // インスタンス生成
    // var newMsg = MSG(msgid, msgDatetime, senderid, roomid, level, statusAddition, stampid, quoteid, msg, receiver);
    // save(newMsg);
  }

  void sioReceive(Map<String, dynamic> msgData) async {
    // インスタンス生成
    MSG addMsg = MSG(msgData["msg_id"], msgData["msg_datetime"], msgData["sender"], msgData["room_id"], msgData["level"], msgData["status"], msgData["stamp_id"], msgData["quote_id"], msgData["msg"],
        msgData["receiver"]);
    // 保存処理呼び出す
    save(addMsg);

    // _msgList.add(addMsg);
    // DatabaseHelper.insert('msg_chats', addMsg.toJson());
    // load();
  }

  // 保存
  void save(MSG msg) async {
    _msgList.add(msg);
    Map<String, dynamic> savemsg = msg.toJson();
    DatabaseHelper.insert('msg_chats', savemsg);
  }

  // 指定した部屋のmsgListを生成
  // ルームに合わせてタスクリストを生成
  List<MSG> findByRoomid(String roomid) {
    List<MSG> result = [];
    for (MSG msg in _msgList) {
      if (roomid == msg.roomid) {
        result.add(msg);
      }
    }
    return result;
  }

  // 最新のmsgを返す
  String lastMsg() {
    String result = '';
    if (_msgList.isNotEmpty) {
      result = _msgList.last.msg;
    }
    return result;
  }

  void load() async {
    // roomidで検索し、dbのメッセージをidごとにリスト化
    _msgList.clear();
    List loadList = await DatabaseHelper.serachRows('msg_chats', 0, [], [], 'msg_datetime');
    // リスト化した情報をループしMSGオブジェクトを生成
    for (Map msgRoom in loadList) {
      int msgid = msgRoom['msg_id'];
      String msgDatetime = msgRoom['msg_datetime'];
      String senderid = msgRoom['sender'];
      String roomid = msgRoom['room_id'];
      int level = msgRoom['level'];
      int statusAddition = msgRoom['status_addition'];
      int stampid = msgRoom['stamp_id'];
      String quoteid = msgRoom['quote_id'];
      String msg = msgRoom['msg'];
      String receiver = msgRoom['receiver'];

      MSG lordMsg = MSG(msgid, msgDatetime, senderid, roomid, level, statusAddition, stampid, quoteid, msg, receiver);
      _msgList.add(lordMsg);
    }
  }
}
