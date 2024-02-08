import 'dart:convert';

class Room {
  // 固有値
  String roomid;

  // 部屋の名前
  String roomName;
  // 管理者
  List leaders;
  // 労働者
  List workers;
  // タスクidリスト
  List tasks;
  // 入室申請者リスト
  List applicant;

  // 検索用の値
  String roomNumber;
  // サブルームか否か
  int subRoom;
  // サブルームであった場合参照 メインルームの値
  String mainRoomid;
  //
  List sameGroupId;
  //

  // 上記の情報からリストを作成
  // これをもとに画面を生成する
  // List<Task> taskDatas;

  // List<Room> subRoomData;

  // MsgManager msgManager;

  Room(this.roomid, this.roomName, this.leaders, this.workers, this.tasks, this.roomNumber, this.subRoom, this.mainRoomid, this.sameGroupId,this.applicant);

  // Mapに変換する
  // 保存で使う
  Map<String, dynamic> toJson() {
    return {
      'room_id': roomid,
      'room_name': roomName,
      'leaders': jsonEncode(leaders),
      'workers': jsonEncode(workers),
      'tasks': jsonEncode(tasks),
      'room_number': roomNumber,
      'sub_rooms': jsonEncode(sameGroupId),
      'is_sub_room': subRoom,
      'main_room_id': mainRoomid,
      'applicant':jsonEncode(applicant)
    };
  }
}
