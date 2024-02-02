// import 'TaskRoomManager.dart';
// import 'msg_manager.dart';
// import 'MsgRoom.dart';

// class MsgRoomManager {
//   List<MsgRoom> _msgRoom = [];

//   // 自分自身を生成し、インスタンスの単一性を確保
//   static final MsgRoomManager _instance = MsgRoomManager._internal();

//   MsgRoomManager._internal();
//   MsgRoomManager _MsgRoomManager = MsgRoomManager();
//   factory MsgRoomManager() {
//     return _instance;
//   }

//   static final TaskRoomManager _roomManager = TaskRoomManager();

//   MsgRoom findindex(String roomid) {
//     // えらーでちゃうよ～～～；；
//     for (MsgRoom msgRoom in _msgRoom) {
//       if (msgRoom.room.roomid == roomid) {
//         return msgRoom;
//       }
//     }
//     return _msgRoom[0];
//   }

//   // 読み込み
//   void load() async {
//     for (int i = 0; i < _roomManager.count(); i++) {
//       // 初期化
//       _msgRoom.clear();
//       // roomidとmsgListを紐づけてオブジェクト化し、リストに挿入
//       _msgRoom.add(
//         MsgRoom(_roomManager.findByindex(i), MsgManager(_roomManager.findByindex(i).roomid)),
//       );
//     }
//   }
// }
