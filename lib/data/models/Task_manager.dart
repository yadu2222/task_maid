import 'package:intl/intl.dart';
import 'Room_manager.dart';
import 'Task.dart';
import 'package:task_maid/data/database_helper.dart';
import 'Room.dart';

class TaskManager {
  // タスクリスト
  List<Task> _taskList = [];

  // taskManagerのインスタンス
  static final TaskManager _instance = TaskManager._internal();
  // final RoomManager _roomManager = RoomManager();

  // プライベートなコンストラクタ
  TaskManager._internal();

  // 自分自身を生成
  factory TaskManager() {
    return _instance;
  }

  // タスクの件数を取得する
  int count() {
    return _taskList.length;
  }

  // 指定したインデックスのタスクを取得する
  Task findByIndex(int index) {
    return _taskList[index];
  }

  // タスクを検索して返却
  Task findByid(String id) {
    Task result = _taskList[0];
    for (Task task in _taskList) {
      if (id == task.taskid) {
        result = task;
      }
    }
    return result;
  }

  // ルームに合わせてタスクリストを生成
  List<Task> findByRoomid(String roomid) {
    List<Task> result = [];
    for (Task task in _taskList) {
      if (roomid == task.roomid) {
        result.add(task);
      }
    }
    return result;
  }

  // 選択した形式で期日を返す
  String getDateTime(Task task, int type) {
    final formatType_1 = DateFormat('yyyy.MM.dd HH:mm');
    final formatType_2 = DateFormat('yyyy/MM/dd');
    final formatType_3 = DateFormat('HH:mm');
    final formatType_4 = DateFormat('MM月dd日HH時mm分');
    final formatType_5 = DateFormat('MM.dd.HH時mm分');

    List formatType = [formatType_1, formatType_2, formatType_3, formatType_4, formatType_5];
    DateTime nn = DateTime.parse(task.taskLimit);
    return formatType[type].format(nn);
  }

  // タスクを追加する
  void add(String title, String contents, String taskLimit, String worker, String roomid) {
    var taskid = count() == 0 ? 1 : int.parse(_taskList.last.taskid) + 1;
    // var dateTime = getDateTime();
    var task = Task(taskid.toString(), title, contents, 0, taskLimit, worker, roomid);
    // リストに追加
    _taskList.add(task);
    save(0, null, task);
  }

  // タスクを更新する
  void update(Task task, String contents, int status, String taskLimit, String worker) {
    task.contents = contents;
    task.status = status;
    task.taskLimit = taskLimit;
    task.worker = worker;
    save(1, null, task);
  }

  // タスクを削除
  // 退室処理
  void deleat(List<Room> deleatRooms) {
    // 引数のリストの部屋を削除
    for (Room deleatRoom in deleatRooms) {
      _taskList.removeWhere((value) => value.roomid == deleatRoom.roomid);
      save(2, deleatRoom);
    }
  }

  // タスクリストをdbに保存する
  void save(
    int saveType, [
    Room? room,
    Task? task,
  ]) async {
    Map<String, dynamic> saveTask = {};
    if (task != null) {
      saveTask = task.toJson();
    }

    // 0でinsert
    // 1でupdate
    // 2でdeleate
    switch (saveType) {
      case 0:
        if (task != null) {
          await DatabaseHelper.insert('tasks', saveTask);
        }
        break;
      case 1:
        if (task != null) {
          await DatabaseHelper.update('tasks', 'task_id', saveTask, task.taskid.toString());
        }
        break;
      case 2:
        if (room != null) {
          await DatabaseHelper.delete('tasks', 'room_id', room.roomid);
        }
        break;
    }

    // _roomManager.load();
  }

  // タスクを読み込む
  void load() async {
    // dbから落とす
    List loadList = await DatabaseHelper.queryAllRows('tasks');
    // _taskList = loadList.forEach((task) => _taskList.add(task.fromJson(task)));

    for (Map task in loadList) {
      String taskid = task['task_id'];
      String title = task['title'];
      String contents = task['contents'];
      int status = task['status_progress'];
      String taskLimit = task['task_limit'];
      String worker = task['worker'];
      String roomid = task['room_id'];

      _taskList.add(Task(taskid, title, contents, status, taskLimit, worker, roomid));
    }
  }
}
