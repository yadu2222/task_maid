
// import 'task_class.dart';

// import 'room_class.dart';
// import 'task_manager.dart';
// import 'package:task_maid/data/database_helper.dart';

// class TaskRoomManager {
//   // ルームリスト
//   List<TaskRoom> _roomList = [
//     TaskRoom('0', 'うごかない；；', ['12345'], ['12345'], [], '0', 0, '0', ['0'])
//   ];

//   // roomManagerのインスタンス
//   static final TaskRoomManager _instance = TaskRoomManager._internal();

//   // プライベートなコンストラクタ
//   TaskRoomManager._internal();

//   TaskManager _taskManager = TaskManager();

//   // 自分自身を生成
//   factory TaskRoomManager() {
//     return _instance;
//   }

//   // 部屋数を取得
//   int count() {
//     if (_roomList.isNotEmpty) {
//       return _roomList.length;
//     } else {
//       return 0;
//     }
//   }

//   // 指定したインデックスの部屋を取得
//   TaskRoom findByindex(int index) {
    
//     return _roomList[index];
//   }

//   // 部屋を追加する
//   // 改修
//   void add(TaskRoom nowRoom, String roomName, List leaders, List workers, List tasks, int boolSubRoom, [List? sameGroup, String? mainRoomid]) {
//     var roomid = count() == 0 ? 1 : int.parse(_roomList.last.roomid) + 1;

//     String mainRoomiii = roomid.toString();
//     if (mainRoomid != null) {
//       mainRoomiii = mainRoomid;
//     }

//     List sameGrouppp = [roomid];
//     if (sameGroup != null) {
//       sameGrouppp = sameGroup;
//     }

//     if (boolSubRoom != 0) {
//       for (TaskRoom room in _roomList) {
//         if (room.mainRoomid == mainRoomid) {
//           sameGrouppp.add(room.roomid);
//         }
//       }
//     }

//     // インスタンス生成
//     var room = TaskRoom(
//       roomid.toString(),
//       roomName,
//       leaders,
//       workers,
//       [],
//       roomid.toString(),
//       boolSubRoom,
//       mainRoomiii,
//       sameGrouppp,
//     );
//     // List<Task> taskDatas = _taskManager.findByRoomid(roomid.toString());
//     room.taskDatas = _taskManager.findByRoomid(roomid.toString());
//     room.subRoomData = getSameData(sameGrouppp);

//     _roomList.add(room);

//     // 他の部屋の情報の上書き
//     for (TaskRoom checkRoom in _roomList) {
//       if (nowRoom.mainRoomid == checkRoom.mainRoomid) {
//         checkRoom.sameGroup.add(roomid);
//         update(checkRoom, checkRoom.leaders, checkRoom.workers, checkRoom.tasks, checkRoom.sameGroup);
//       }
//     }
//     save(room, true);
//   }

//   // 指定した部屋のsameGroupに格納されたidをRoomオブジェクトと紐づける
//   List<TaskRoom> getSameData(List sameGroup) {
//     List<TaskRoom> result = [];

//     for (TaskRoom room in _roomList) {
//       print(sameGroup);
//       for (var serchRoomid in sameGroup) {
//         if (room.roomid != null && room.roomid == serchRoomid) {
//           result.add(room);
//         }
//       }
//     }
//     print(result);
//     return result;
//   }

//   // 部屋情報の更新
//   void update(TaskRoom room, List leaders, List workers, List tasks, List sameGroup) {
//     room.leaders = leaders;
//     room.workers = workers;
//     room.tasks = tasks;
//     room.sameGroup = sameGroup;
//     save(room, false);
//   }

//   // 部屋情報の削除
//   // 退室処理
//   void deleat(TaskRoom room) {
//     // dbから削除
//     DatabaseHelper.delete('rooms', 'main_room_id', room.mainRoomid);
//     List<TaskRoom> deleateRoom = [];
//     for (TaskRoom check in _roomList) {
//       if (room.mainRoomid == check.mainRoomid) {
//         deleateRoom.add(check);
//       }
//     }

//     _roomList.removeWhere((value) => value.mainRoomid == room.mainRoomid);
//     // タスクリストから削除
//     _taskManager.deleat(deleateRoom);

//     // リストから削除
//     _roomList.remove(room);
//   }

//   // 部屋情報の保存
//   void save(TaskRoom room, saveType) async {
//     Map<String, dynamic> saveRoom = room.toJson();
//     // trueでinsert
//     // falseでupdate
//     saveType ? DatabaseHelper.insert('rooms', saveRoom) : DatabaseHelper.update('rooms', 'room_id', saveRoom, room.roomid);
//   }

//   // 部屋情報の読み込み
//   void load() async {
//     List loadList = await DatabaseHelper.queryAllRows('rooms');
//     _roomList.clear();
//     for (Map room in loadList) {
//       String roomid = room['room_id'];
//       String roomName = room['room_name'];
//       List leaders = jsonDecode(room['leaders']);
//       List workers = jsonDecode(room['workers']);
//       List tasks = jsonDecode(room['tasks']);
//       List<Task> taskDates = _taskManager.findByRoomid(roomid);
//       String roomNumber = room['room_number'];
//       List sameGroup = jsonDecode(room['sub_rooms']);
//       int subRoom = room['bool_sub_room'];
//       String mainRoomid = room['main_room_id'];

//       // リストに追加
//       Room loadRoom = Room(roomid, roomName, leaders, workers, tasks, roomNumber, subRoom, mainRoomid, sameGroup);
//       loadRoom.subRoomData = getSameData(sameGroup);
//       loadRoom.taskDatas = _taskManager.findByRoomid(roomid);
//       _roomList.add(loadRoom);
//     }
//   }
// }
