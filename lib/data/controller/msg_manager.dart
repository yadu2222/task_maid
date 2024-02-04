import '../database_helper.dart';
import '../models/msg_class.dart';

class MsgManager {
  

  // msg_list
  List<MSG> _msgList = [];

  static final MsgManager _instance = MsgManager._internal();
  MsgManager._internal();
  factory MsgManager() {
    return _instance;
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
  void add(String msg, int statusAddition, int stampid, String quoteid, int level,String roomid) {
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
    List loadList = await DatabaseHelper.serachRows('msg_chats', 0, [], [], 'msg_datetime');

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
      print("msgList{$lordMsg}");
      _msgList.add(lordMsg);
    }
  }
}
