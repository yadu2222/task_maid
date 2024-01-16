import 'package:task_maid/view/Room.dart';
import 'Room_manager.dart';
import 'MsgManager.dart';

class ChatRoom {
  Room room;
  MsgManager msgList;
  ChatRoom(this.room, this.msgList);
}

class chatRoomManager {
  List<ChatRoom> _chatRoom = [];

  // 自分自身を生成し、インスタンスの単一性を確保
  static final chatRoomManager _instance = chatRoomManager._internal();
  static final RoomManager _roomManager = RoomManager();
  chatRoomManager._internal();
  chatRoomManager _chatRoomManager = chatRoomManager();
  factory chatRoomManager() {
    return _instance;
  }

  ChatRoom findindex(String roomid) {
    // えらーでちゃうよ～～～；；
    for (ChatRoom chatRoom in _chatRoom) {
      if (chatRoom.room.roomid == roomid) {
        return chatRoom;
      }
    }
    return _chatRoom[0];
  }

  // 読み込み
  void load() async {
    for (int i = 0; i < _roomManager.count(); i++) {
      // 初期化
      _chatRoom.clear();
      // roomidとmsgListを紐づけてオブジェクト化し、リストに挿入
      _chatRoom.add(
        ChatRoom(_roomManager.findByindex(i), MsgManager(_roomManager.findByindex(i).roomid)),
      );
    }
  }
}
