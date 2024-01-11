import 'dart:convert';
import 'package:task_maid/view/task.dart';

import 'Room.dart';
import 'TaskManager.dart';
import 'package:task_maid/database_helper.dart';

class RoomManager {
  // ルームリスト
  List<Room> _roomList = [Room('0000', 'てすとるーむ',  ['12345'], ['12345'], [], '12345', 0, '0000', ['0000'])];

  // roomManagerのインスタンス
  static final RoomManager _instance = RoomManager._internal();

  // プライベートなコンストラクタ
  RoomManager._internal();

  TaskManager _taskManager = TaskManager();

  // 自分自身を生成
  factory RoomManager() {
    return _instance;
  }

  // 部屋数を取得
  int count() {
    return _roomList.length;
  }

  // 指定したインデックスの部屋を取得
  Room findByindex(int index) {
    return _roomList[index];
  }

  // 部屋を追加する
  void add(Room nowRoom, String roomName, List leaders, List workers, List tasks, int boolSubRoom, [List? sameGroup, String? mainRoomid]) {
    var roomid = count() == 0 ? 1 : int.parse(_roomList.last.roomid) + 1;
    // List<Task> taskDatas = _taskManager.findByRoomid(roomid);

    String mainRoomiii = roomid.toString();
    if (mainRoomid != null) {
      mainRoomiii = mainRoomid;
    }

    List sameGrouppp = [roomid];
    if (sameGroup != null) {
      sameGrouppp = sameGroup;
    }

    // インスタンス生成
    var room = Room(roomid.toString(), roomName, leaders, workers, [], roomid.toString(), boolSubRoom, mainRoomiii, sameGrouppp);
    room.subRoomData = getSameData(room);
    room.taskDatas = _taskManager.findByRoomid(roomid.toString());

    _roomList.add(room);

    // 他の部屋の情報の上書き
    for (Room checkRoom in _roomList) {
      if (nowRoom.mainRoomid == checkRoom.mainRoomid) {
        checkRoom.sameGroup.add(roomid);
        update(checkRoom, checkRoom.leaders, checkRoom.workers, checkRoom.tasks, checkRoom.sameGroup);
      }
    }
    save(room, true);
  }

  // 指定した部屋のsameGroupに格納されたidをRoomオブジェクトと紐づける
  List<Room> getSameData(Room serchRooms) {
    List<Room> result = [];
    for (Room room in _roomList) {
      for (String serchRoom in serchRooms.sameGroup) {
        if (room.roomid == serchRoom) {
          result.add(room);
        }
      }
    }
    return result;
  }

  // 部屋情報の更新
  void update(Room room, List leaders, List workers, List tasks, List sameGroup) {
    room.leaders = leaders;
    room.workers = workers;
    room.tasks = tasks;
    room.sameGroup = sameGroup;
    save(room, false);
  }

  // 部屋情報の削除
  // 退室処理
  void deleat(Room room) {
    // dbから削除
    DatabaseHelper.delete('rooms', 'main_room_id', room.mainRoomid);
    List<Room> deleateRoom = [];
    for (Room check in _roomList) {
      if (room.mainRoomid == check.mainRoomid) {
        deleateRoom.add(check);
      }
    }
    // タスクリストから削除
    _taskManager.deleat(deleateRoom);

    // リストから削除
    _roomList.remove(room);
  }

  // 部屋情報の保存
  void save(Room room, saveType) async {
    Map<String, dynamic> saveRoom = room.toJson();
    // trueでinsert
    // falseでupdate
    saveType ? DatabaseHelper.insert('rooms', saveRoom) : DatabaseHelper.update('rooms', 'room_id', saveRoom, room.roomid);
  }

  // 部屋情報の読み込み
  void load() async {
    List loadList = await DatabaseHelper.queryAllRows('rooms');
    for (Map room in loadList) {
      String roomid = room['room_id'];
      String roomName = room['room_name'];
      List leaders = jsonDecode(room['leaders']);
      List workers = jsonDecode(room['workers']);
      List tasks = jsonDecode(room['tasks']);
      List<Task> taskDates = _taskManager.findByRoomid(roomid);
      String roomNumber = room['room_number'];
      List sameGroup = jsonDecode(room['sub_rooms']);
      int subRoom = room['bool_sub_room'];
      String mainRoomid = room['main_room_id'];

      // リストに追加
      _roomList.add(Room(roomid, roomName, leaders, workers, tasks,roomNumber, subRoom, mainRoomid,sameGroup));
    }
  }
}
