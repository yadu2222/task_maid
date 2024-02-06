import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:math';

// 各情報のクラス
import '../models/room_class.dart';
// 各情報を操作するクラス
import 'task_manager.dart';

// db操作
import '../database_helper.dart';

// 通信
import '../component_communication.dart';
import 'package:http/http.dart' as http; // http

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

  // ここでもサーバーとの通信を行えたほうがいいのかもしれないなと思ったり思わなかったり思ったり
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
  void add(
    Room nowRoom,
    String roomName,
    List leaders,
    List workers,
    List tasks,
    int boolSubRoom,
    TaskManager _taskManager,
  ) {
    Random random = Random();
    String roomNumber = random.nextInt(100000).toString();

    // サーバーから通信でidをもらうので、それまでのだみーー
    String dummyId = "08200000000";
    List sameGroupId = [];
    // mainRoomなら
    // 0:main 1:sub
    if (boolSubRoom == 1) {
      // サブルームであれば
      // サブルームをいきなり追加することはできないであってほしい
      // mainRoomから一部屋ずつ増やす方向で
      roomNumber = findByroomid(nowRoom.mainRoomid).roomNumber + "-" + (findByroomid(nowRoom.mainRoomid).sameGroupId.length).toString();
      // グループリストを今の部屋からもらう
      // グループ内ならどの部屋も同じリストを保持している、、はず、、
      sameGroupId = nowRoom.sameGroupId;
      // sameGroupIdpp.add(dummyId);
      print("通信前sameGroup${sameGroupId}");
    }
    // インスタンス生成
    var room = Room(
      dummyId,
      roomName,
      leaders,
      workers,
      [],
      roomNumber,
      boolSubRoom,
      nowRoom.mainRoomid,
      sameGroupId,
    );
    // 通信 保存
    save(room, 0, "/post_ins_new_record");
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
    save(room, 1, "/post_upd");
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
    // リストから削除
    _roomList.removeWhere((value) => value.mainRoomid == room.mainRoomid);
    _roomList.remove(room);

    save(room, 2, "/post_upd");
    notifyListeners();
  }

  // 部屋情報の保存
  // 追加または更新する部屋のデータ,ins,upd,deleteの選択,エンドポイント
  void save(Room room, int saveType, String httpRoute) async {

    // insとupdでidの扱いが違うのでその対応
    // 不細工だね
    String postType = "uuid-1";
    if (saveType != 0) {
      postType = room.roomid;
    }

    // http通信
    http.Response response = await HttpToServer.httpReq("POST", httpRoute, {
      "tableName": "rooms",
      "pKey": "room_id",
      "pKeyValue": "uuid-1",
      "recordData": {
        "room_id": postType,
        "room_name": room.roomName,
        "applicant": [postType],
        "workers": room.workers,
        "leaders": room.leaders,
        "tasks": room.tasks,
        "room_number": room.roomNumber,
        "is_sub_room": room.subRoom,
        "main_room_id": room.roomid,
        "sub_rooms": room.sameGroupId,
      }
    });
    // レスポンスをStringに変換
    Map resultData = jsonDecode(response.body);
    String result = resultData["server_response_data"].toString();

    // print(room.sameGroupId);

    // print("mainroomid ${result}");
    // print(room.roomid);
    // print(result);

    Map<String, dynamic> saveRoom = room.toJson();
    switch (saveType) {
      // insert
      case 0:
        room.roomid = result; // サーバーからもらった正規のidを格納
        room.sameGroupId.add(result); // 自分自身をsameGroupIdに追加

        // サブルームならば
        if (room.subRoom == 1) {
          // roomListをループ
          for (Room checkRoom in _roomList) {
            // mainRoomidが同じ部屋のsameGroupIdを最新のものに更新
            if (checkRoom.mainRoomid == room.mainRoomid) {
              checkRoom.sameGroupId = room.sameGroupId;
              update(checkRoom, checkRoom.leaders, checkRoom.workers, checkRoom.tasks, checkRoom.sameGroupId);
            }
          }
          // メインルームならば
        } else {
          // mainRoomidを自分のidに変更
          room.mainRoomid = result;
        }
        saveRoom = room.toJson();
        _roomList.add(room);
        DatabaseHelper.insert('rooms', saveRoom);
        break;

      // update
      case 1:
        DatabaseHelper.update('rooms', 'room_id', saveRoom, room.roomid);
        break;
      // delete
      case 2:
        DatabaseHelper.delete('rooms', 'room_id', room.roomid);
        break;
    }

    // 値変更の通知 動いてるのかいまいちわからない
    // load();
    notifyListeners();
  }

  // 部屋情報の読み込み
  void load() async {
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
