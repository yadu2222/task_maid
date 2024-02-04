import 'dart:convert';

// 各情報のクラス
import 'package:flutter/material.dart';

import '../models/room_class.dart';

// 各情報を操作するクラス
import 'task_manager.dart';

// db操作
import '../database_helper.dart';

class RoomManager extends ChangeNotifier {
  Room dummy = Room('12345', 'てすと', [], [], [], '1234', 0, '1234', []);
  late List<Room> _roomList = [dummy];
  // taskManagerのインスタンス
  static final RoomManager _instance = RoomManager._internal();
  // プライベートなコンストラクタ
  RoomManager._internal();
  // 自分自身を生成
  factory RoomManager() {
    return _instance;
  }

  // 部屋数を取得
  int count() {
    if (_roomList.isNotEmpty) {
      return _roomList.length;
    } else {
      return 0;
    }
  }

  // 指定したインデックスの部屋を取得
  Room findByindex(int index) {
    if (count() != 0) {
      return _roomList[index];
    } else {
      return dummy;
    }
  }

  Room findByroomid(String roomid) {
    for (Room room in _roomList) {
      if (room.roomid == roomid) {
        return room;
      }
    }

    print("ないないある");
    return _roomList[0];
  }

  Room getLastRoom() {
    return _roomList.last;
  }

  // 部屋を追加する
  // 改修
  void add(Room nowRoom, String roomName, List leaders, List workers, List tasks, int boolSubRoom, TaskManager _taskManager, [List? sameGroupId, String? mainRoomid]) {
    var roomid = count() == 0 ? 1 : int.parse(_roomList.last.roomid) + 1;

    // nullチェック
    String mainRoomiii = roomid.toString();
    if (mainRoomid != null) {
      mainRoomiii = mainRoomid;
    }

    List sameGroupIdpp = [roomid];
    if (sameGroupId != null) {
      sameGroupIdpp = sameGroupId;
    }

    if (boolSubRoom != 0) {
      for (Room room in _roomList) {
        if (room.mainRoomid == mainRoomid) {
          sameGroupIdpp.add(room.roomid);
        }
      }
    }

    // MsgManager msgManager = new MsgManager(roomid.toString());
    // List<Room> addRoomData = getSameData(sameGroupIdpp);

    // インスタンス生成
    var room = Room(
      roomid.toString(),
      roomName,
      leaders,
      workers,
      [],
      roomid.toString(),
      boolSubRoom,
      mainRoomiii,
      sameGroupIdpp,
    );

    // List<Task> taskDatas = _taskManager.findByRoomid(roomid.toString());
    // room.taskDatas = _taskManager.findByRoomid(roomid.toString());
    // room.subRoomData = getSameData(sameGroupIdpp);

    _roomList.add(room);

    // 他の部屋の情報の上書き
    for (Room checkRoom in _roomList) {
      if (nowRoom.mainRoomid == checkRoom.mainRoomid) {
        checkRoom.sameGroupId.add(roomid);
        update(checkRoom, checkRoom.leaders, checkRoom.workers, checkRoom.tasks, checkRoom.sameGroupId);
      }
    }
    save(room, true);
    notifyListeners();
  }

  // 指定した部屋のsameGroupIdに格納されたidをRoomオブジェクトと紐づける
  List<Room> getSameData(List sameGroupId) {
    List<Room> result = [];
    for (Room room in _roomList) {
      print(sameGroupId);
      for (var serchRoomid in sameGroupId) {
        if (room.roomid != null && room.roomid == serchRoomid) {
          result.add(room);
        }
      }
    }
    print(result);
    return result;
  }

  // 部屋情報の更新
  void update(Room room, List leaders, List workers, List tasks, List sameGroupId) {
    room.leaders = leaders;
    room.workers = workers;
    room.tasks = tasks;
    room.sameGroupId = sameGroupId;
    save(room, false);
    notifyListeners();
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
    _roomList.removeWhere((value) => value.mainRoomid == room.mainRoomid);
    // リストから削除
    _roomList.remove(room);
    notifyListeners();
  }

  // 部屋情報の保存
  void save(Room room, saveType) async {
    Map<String, dynamic> saveRoom = room.toJson();
    // trueでinsert
    // falseでupdate
    saveType ? DatabaseHelper.insert('rooms', saveRoom) : DatabaseHelper.update('rooms', 'room_id', saveRoom, room.roomid);
    notifyListeners();
  }

  // 部屋情報の読み込み
  void load(TaskManager taskManager) async {
    List loadList = await DatabaseHelper.queryAllRows('rooms');
    _roomList.clear();
    for (Map room in loadList) {
      String roomid = room['room_id'];
      String roomName = room['room_name'];
      List leaders = jsonDecode(room['leaders']);
      List workers = jsonDecode(room['workers']);
      List tasks = jsonDecode(room['tasks']);
      String roomNumber = room['room_number'];
      List sameGroupId = jsonDecode(room['sub_rooms']);
      int subRoom = room['bool_sub_room'];
      String mainRoomid = room['main_room_id'];

      // リストに追加
      // MsgManager msgManager = MsgManager(roomid);
      // List<Task> loadTaskData =   taskManager.findByRoomid(roomid);
      // List<Room> loadSubRoomData =  getSameData(sameGroupId);

      Room loadRoom = Room(roomid, roomName, leaders, workers, tasks, roomNumber, subRoom, mainRoomid, sameGroupId);
     
      _roomList.add(loadRoom);
    }

   

    notifyListeners();
  }
}
