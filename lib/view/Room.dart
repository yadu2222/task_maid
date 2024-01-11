import 'dart:convert';
import 'task.dart';
import 'TaskManager.dart';

class Room {
  // 固有値
  String roomid;

  // 部屋の名前
  String roomName;
  // 管理者
  List leaders;
  // 労働者
  List workers;
  // タスクリスト
  List tasks;
  //
  List<Task> taskDatas = [];
  // 検索用の値
  String roomNumber;
  // サブルームか否か
  int subRoom;
  // サブルームであった場合参照 メインルームの値
  String mainRoomid;
  //
  List sameGroup;
  //
  List<Room> subRoomData = [];

  Room(this.roomid, this.roomName, this.leaders, this.workers, this.tasks, this.roomNumber, this.subRoom, this.mainRoomid, this.sameGroup);

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
      'sub_rooms': jsonEncode(sameGroup),
      'bool_sub_room': subRoom,
      'main_room_id': mainRoomid
    };
  }
}
