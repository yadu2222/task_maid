import 'dart:convert';
import '../database_helper.dart';

import 'msg_class.dart';
import 'room_class.dart';

class MsgManager {
  String roomid;

  // msg_list
  List<MSG> _msgList = [];

  MsgManager(this.roomid) {
    load();
  }

  // 指定した部屋のメッセージ数を取得
  int count() {
    return _msgList.length;
  }

  // 指定したインデックスのメッセージを取得
  MSG findByindex(int index) {
    return _msgList[index];
  }

  

  // msgを追加する
  void add(String msg, int statusAddition, int stampid, String quoteid, int level) {
    // (int msgid, String message, int status, int stamp_id, String quote_id, int level, String chatRoom
    var msgid = count() == 0 ? 1 : _msgList.last.msgid + 1;
    String senderid = '12345';
    String msgDatetime = DateTime.now().toString();

    // インスタンス生成
    var newMsg = MSG(msgid, msgDatetime, senderid, roomid, level, statusAddition, stampid, quoteid, msg);
    _msgList.add(newMsg);
  }

  // 保存
  void save(MSG msg) async {
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
  

  void load() async {
    // roomidで検索し、dbのメッセージをidごとにリスト化
    List loadList = await DatabaseHelper.serachRows('msg_chats', 1, ['room_id'], [roomid], 'msg_datetime');

    _msgList.clear();
    // リスト化した情報をループしMSGオブジェクトを生成
    for (Map msgRoom in loadList) {
      int msgid = msgRoom['msg_room'];
      String msgDatetime = msgRoom['msg_Datetime'];
      String senderid = msgRoom['sender_id'];
      String roomid = msgRoom['room_id'];
      int level = msgRoom['level'];
      int statusAddition = msgRoom['status_addition'];
      int stampid = msgRoom['stamp_id'];
      String quoteid = msgRoom['quote_id'];
      String msg = msgRoom['msg'];

      MSG lordMsg = MSG(msgid, msgDatetime, senderid, roomid, level, statusAddition, stampid, quoteid, msg);
      _msgList.add(lordMsg);
    }
  }
}
