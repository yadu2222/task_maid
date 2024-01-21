import 'dart:convert';

// このクラスを読み込むだけで各操作ができるようにしたい

// 各情報のクラス
import 'room_class.dart';
import 'task_class.dart';
import 'msg_class.dart';

// 各情報を操作するクラス
import 'task_manager.dart';
import 'msg_manager.dart';
import 'room_manager.dart';

// db操作
import '../database_helper.dart';

class Door {
  List<Room> _roomList = [];

  // 自分自身を生成
  static final Door _instance = Door._internal();
  Door._internal();
  // Door _door = Door();

  final TaskManager _taskManager = TaskManager();
  // final MsgManager _msgManager = MsgManager();
  final RoomManager _roomManager = RoomManager();

  TaskManager getTaskManager() {
    return _taskManager;
  }

  RoomManager getRoomManager() {
    return _roomManager;
  }

  factory Door() {
    return _instance;
  }

  ///
  /// 数えて返す
  ///
  int taskCount() {
    return _taskManager.count();
  }

  int roomCount() {
    return _roomManager.count();
  }

  // int msgCount() {
  //   return _msgManager.count();
  // }

  // 指定したインデックスのRoomを返す
  Room getRoom(int index) {
    return _roomManager.findByindex(index);
  }

  // 指定したインデックスのタスクを取得
  Task taskFindbyIndex(int index) {
    return _taskManager.findByIndex(index);
  }

  // 指定したidの部屋を取得
  Room roomFindbyid(String roomid) {
    return _roomManager.findByroomid(roomid);
  }

  Room getLastRoom() {
    return getLastRoom();
  }

  // 部屋を追加する
  void addRoom(Room nowRoom, String roomName, List leaders, List workers, List tasks, int boolSubRoom, [List? sameGroup, String? mainRoomid]) {
    // Room追加処理
    _roomManager.add(nowRoom, roomName, leaders, workers, tasks, boolSubRoom, _taskManager, sameGroup, mainRoomid);
    // 追加した部屋と依存関係にある部屋のデータ更新

    // 追加したroomのtaskData作成処理

    // 追加したroomのmsgリスト作成処理
  }

  // 部屋を削除する
  void deleate(Room room) {
    _taskManager.deleat(room.subRoomData);
    _roomManager.deleat(room);
  }

  // 指定した部屋のタスクリストを生成
  List<Task> findByRoomid(String id) {
    return _taskManager.findByRoomid(id);
  }

  // 読み込み
  void load() async {
    _roomManager.load(_taskManager,);
  }
}
